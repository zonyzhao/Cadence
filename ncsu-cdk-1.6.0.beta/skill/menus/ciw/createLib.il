;==========================================================================
;
; $Id: createLib.il,v 1.3 2006/11/04 11:49:52 wdavis Exp $
; 
;--------------------------------------------------------------------------

procedure( handleSymbolics( libID )
let( (syms symContactList symPinList catID cv)
    symContactList = list( "M1_N" "M1_P" "M1_POLY" "M2_M1" "M3_M2" "NTAP"
                           "PTAP" "M1_ELEC" "M1_CAP" "M1_COLLECTOR" "M1_EMITTER" 
                           "M1_BASE" "M1_POLYCAP" "M4_M3" "M5_M4" "M6_M5" )
    symPinList = list( "pwell" "nwell" "cwell" "nactive" "pactive" "cactive"
                       "tactive" "active" "poly" "elec" "polycap"
                       "metal1" "metal2" "metal3" "metal4" "metal5" "metal6" )

    ; categorize symbolic contacts
    syms = list()
    foreach( sym symContactList
        cv = dbFindOpenCellView( libID sym "symbolic" )
        if( cv != nil then
           dbSave( cv )
           syms = cons( sym syms )
        )
    )
    if( length( syms ) != 0 then
        catID = ddCatOpen( libID "sym_contacts" "w" )
        if( catID then
            foreach( sym syms 
                ddCatAddItem( catID sym "cell" )
            )
            ddCatSave( catID )
            ddCatClose( catID )
        else
            warn( "Couldn't create \"sym_contacts\" category!" )
        )
    )

    ; categorize symbolic pins
    syms = list()
    foreach( sym symPinList
        cv = dbFindOpenCellView( libID sym "symbolic" )
        if( cv != nil then
           dbSave( cv )
           syms = cons( sym syms )
        )
    )
    if( length( syms ) != 0 then
        catID = ddCatOpen( libID "sym_pins" "w" )
        if( catID then
            foreach( sym syms 
                ddCatAddItem( catID sym "cell" )
            )
            ddCatSave( catID )
            ddCatClose( catID )
        else
            warn( "Couldn't create \"sym_pins\" category!" )
        )
    )
))


procedure( createLibCB( createLibForm )
prog( (libID libName path bag tech techFileName techFileID customTechFile
       ret prop attachLibID inList cdsLibPort)

    /*
     * be careful here - the 2nd argument to ddCreateLib() is not the directory
     * where the library is to be stored, rather, it is the name by which the
     * library will be referenced in the cds.lib file. so, to make things intuitive
     * to the user, cat the lib name to the path and use that as the "path"
     */
    libName = createLibForm->libName->value
    path = car( parseString( createLibForm->libPath->value ) )
    if( path != nil then    
        /*
         * make sure path is valid directory
         */
        if( isDir( path ) == nil then
            hiGetAttention()
            error( "The directory \"%s\" does not exist!" path )
        )
        path = strcat( strcat( path "/" ) libName )
    else
        path = ""
    )

    /*
     * check to see if library already exists
     */
    if( ddGetObj( libName ) != nil then
        hiGetAttention()
        error( "A library named \"%s\" already exists!" libName )
    )

    /*
     * actually create the library
     */
    libID = ddCreateLib( libName path )
    if( libID == nil then
        hiGetAttention()
        error( "Creation of library \"%s\" failed!" libName )
    )

    /*
     * call post-create hook if it's defined
     */
    if( getd( 'NCSU_libCreateUserFunc ) then
        NCSU_libCreateUserFunc( libID )
    )

    /*
     * If no tech file is needed, we're done
     */
    if( createLibForm->tfRadioField->value == "No tech library needed" then
        printf( "Library creation successfully completed.\n" )
        return( t )
    )

    /*
     * If we are attaching to a tech library, after we do the attach we need to
     * copy the PadType, lambda, and technology properties from the tech lib if
     * they are present (these properties are used by Diva for DRC and
     * extraction).
     */
    if( createLibForm->tfRadioField->value == "Attach to existing tech library" then 

        attachLibName = getAttachLibName( createLibForm->cyclicField->value )

        ; refresh libID variable since lib list might have changed
        libID = ddGetObj( libName )

        ret = techBindTechFile( libID attachLibName "techfile.cds" t )
        if( ret != nil then
            printf( "Library creation successfully completed.\n" )
        else
            error( "Technology file attach failed!" )
        )

        return( t )
    )

    /*
     * From here to the end of the function, we are compiling a new tech file
     * from scratch.
     */
    if( createLibForm->cyclicField->value == "other..." then
        ; we are loading a non-NCSU tech file
        customTechFile = t
        techFileName = car( parseString( NCSU_customTechFileForm->ctfName->value ) )
    else
        ; we are loading an NCSU tech file
        customTechFile = nil
        tech = createLibForm->cyclicField->value
        foreach( key NCSU_techData
            if( tech == NCSU_techData[key]->description then
                tech = key
            )
        )
        techFileName = strcat( prependNCSUCDKInstallPath( "techfile/" )
                               NCSU_techData[tech]->techFile)

        ; set lambda & technology properties so Diva rules can access them later on
        bag = dbOpenBag( libID "w" )
        if( bag == nil then
            error( "Can't open library property bag! Aborting..." )
        )
        dbCreateProp( bag "PadType" "string" createLibForm->padType->value )
        dbCreateProp( bag "technology" "string" tech )
        dbCreateProp( bag "model" "string" NCSU_techData[tech]->fetModelPrefix )
        dbCreateProp( bag "gridResolution" "float" NCSU_techData[tech]->gridRes )
        dbCreateProp( bag "minLength" "float" NCSU_techData[tech]->minL )
        dbCreateProp( bag "minWidth" "float" NCSU_techData[tech]->minW )
        dbSaveBag( bag )
        dbCloseBag( bag )
    )

    ; make your own tech library
    printf( "Loading technology files...\n" )
    techFileID = techOpenTechFile( libName "techfile.cds" "w" )
    if( customTechFile then
        ret = tcLoadTechFile( techFileID techFileName "w" )
    else
        ret = loadTechFiles( techFileID techFileName )
    )
    if( ret == t then
        techSaveTechFile( techFileID )
    else
        error( "Aborting tech file compilation..." )
    )
    
    unless( customTechFile
        let( (cwd techfileDir)
        ; put symbolics in their own category to prevent visual clutter
        printf( "Categorizing symbolic cells...\n" )
        handleSymbolics( libID )

        ; create pcells
        createPcells( libName )

        ; create links to Diva files
        printf( "Creating links to Diva verification rules files...\n" )
        cwd = getWorkingDir()
        changeWorkingDir( ddGetObjWritePath( libID ) )
        techfileDir = prependNCSUCDKInstallPath( "/techfile/" )
        system( strcat( "ln -s " techfileDir "divaDRC.rul divaDRC.rul" ) )
        system( strcat( "ln -s " techfileDir "divaEXT.rul divaEXT.rul" ) )
        system( strcat( "ln -s " techfileDir "divaLVS.rul divaLVS.rul" ) )
        changeWorkingDir( cwd )
        )
    )

    /*
     * call post-compile hook if it's defined
     */
    if( getd( 'NCSU_libCompileUserFunc ) then
        NCSU_libCompileUserFunc( libID techFileID )
    )

    printf( "Library creation successfully completed.\n" )
    return( t )
    )
)


/*
 * Load all the NCSU tech files
 */
procedure( loadTechFiles( tfID controls )
let( (layerDefs layerRules devs elecRules physRules pdRules prRules)

    layerDefs  = prependNCSUCDKInstallPath( "techfile/layerDefinitions.tf" )
    devs       = prependNCSUCDKInstallPath( "techfile/devices.tf" )
    layerRules = prependNCSUCDKInstallPath( "techfile/layerRules.tf" )
    elecRules  = prependNCSUCDKInstallPath( "techfile/electricalRules.tf" )
    physRules  = prependNCSUCDKInstallPath( "techfile/physicalRules.tf" )
    pdRules    = prependNCSUCDKInstallPath( "techfile/physicalDesignAppRules.tf")
    prRules  = prependNCSUCDKInstallPath( "techfile/prRules.tf" )

    ; set this global variable so the tech files can access the correct techfile ID
    NCSU_techFileID = tfID

    cond(
          (tcLoadTechFile( tfID controls "w" ) == nil
           warn( "Controls: Technology file compilation failed!" )
          )

          (tcLoadTechFile( tfID layerDefs "a" ) == nil
           warn( "Layer Definitions: Technology file compilation failed!" )
          )

          (tcLoadTechFile( tfID devs "a" ) == nil
           warn( "Devices: Technology file compilation failed!" )
          )

          (tcLoadTechFile( tfID layerRules "a" ) == nil
           warn( "Layer Rules: Technology file compilation failed!" )
          )

          (tcLoadTechFile( tfID elecRules "a" ) == nil
           warn( "Electrical Rules: Technology file compilation failed!" )
          )

          (tcLoadTechFile( tfID physRules "a" ) == nil
           warn( "Physical Rules: Technology file compilation failed!" )
          )

          (tcLoadTechFile( tfID pdRules "a" ) == nil
           warn( "PDA Rules: Technology file compilation failed!" )
          )

          (tcLoadTechFile( tfID prRules "a" ) == nil
           warn( "Place and Route Rules: Technology file compilation failed!" )
          )

          (t t)
    )
))


/*
 * Create list of all technology libraries available in search path.
 * Optionally remove the NCSU ones, which appear in their own menu.
 */
procedure( getTechLibList( removeNCSULibs ) 
let( (tf tl techLibList)

    ; a technology library is one with the file "techfile.cds"
    ; don't bother with the Cadence "cdsDefTechLib"
    techLibList = list()
    foreach( lib ddGetLibList()
        unless( lib~>name == "cdsDefTechLib" 
            foreach( file lib~>files
                if( file~>name == "techfile.cds" then
                    techLibList = cons( lib~>name techLibList )
                )
            )
        )
    )

    if( removeNCSULibs == t
        foreach( lib techLibList
            foreach( td NCSU_techData 
                tf = NCSU_techData[td]->techFile
                tl = NCSU_techData[td]->techLib
                if( (strncmp( lib tf strlen( lib ) ) == 0) ||
                    (strcmp(  lib tl               ) == 0)
                    ; remd does not modify the original list if you tell
                    ; it to remove the first element - this seems to be
                    ; a skill bug!
                    techLibList = remd( lib techLibList )
                )
            )
        )
    )

    techLibList
))


procedure( cyclicFieldCB()
prog( (rfValue techLibList)

    if( NCSU_createLibForm->cyclicField->value == "other..." then
        rfValue = NCSU_createLibForm->tfRadioField->value
        cond(
            (rfValue == "Compile tech library"
             hiDisplayForm( NCSU_customTechFileForm )
            )
            (rfValue == "Attach to existing tech library"
             techLibList = append( getTechLibList( t ) 
                                   list( "back to NCSU tech libraries" ) )
             NCSU_createLibForm->cyclicField->choices = techLibList
            )
        )         
    
        return( t )
    )

    if( hiIsFormDisplayed( NCSU_customTechFileForm ) == t
        hiFormCancel( NCSU_customTechFileForm )
    )

    if( NCSU_createLibForm->cyclicField->value == "back to NCSU tech libraries" then
        NCSU_createLibForm->cyclicField->choices = NCSU_techList   
    )
))


procedure( tfOptionCB()
let( (techLibList)

    if( NCSU_createLibForm->tfRadioField->value == "No tech library needed" then
        hiDeleteField( NCSU_createLibForm 'cyclicField )
    )

    if( NCSU_createLibForm->tfRadioField->value == "Attach to existing tech library" then

        if( NCSU_createLibForm->cyclicField != nil then
            NCSU_createLibForm->cyclicField->choices = NCSU_techList
            hiMoveField( NCSU_createLibForm 'cyclicField 250:243 )
        else
            hiAddField( NCSU_createLibForm
                        list( hiCreateCyclicField( 
                                ?name 'cyclicField
                                ?prompt "-->"
                                ?choices NCSU_techList
                                ?value car( NCSU_techList )
                                ?callback "cyclicFieldCB()"
                              )
                              250:243 120:30 50 )
            )
        )
    )

    if( NCSU_createLibForm->tfRadioField->value == "Compile tech library" then
        if( NCSU_createLibForm->cyclicField != nil then
            NCSU_createLibForm->cyclicField->choices = NCSU_techList
            hiMoveField( NCSU_createLibForm 'cyclicField 250:268 )
        else
            hiAddField( NCSU_createLibForm
                        list( hiCreateCyclicField( 
                                ?name 'cyclicField
                                ?prompt "-->"
                                ?choices NCSU_techList
                                ?value car( NCSU_techList )
                                ?callback "cyclicFieldCB()"
                              )
                              250:268 120:30 50 )
            )
        )
    )

    unless( (NCSU_createLibForm->tfRadioField->value == "Compile tech library")
        if( hiIsFormDisplayed( NCSU_customTechFileForm ) 
            hiFormCancel( NCSU_customTechFileForm )
        )
    )
))


let( (tfExplanationMessage1 tfExplanationMessage2 tfExplanationMessage3)

; text for labels explaining what's going on
tfExplanationMessage1 = "If this library will not contain physical design (i.e., layout) data you do not need a tech library."
tfExplanationMessage2 = "Otherwise, you must either attach to an existing tech library or compile one."
tfExplanationMessage3 = "Choose option:"

/*
 * Main form, displayed by "File->New->Library..."
 */
hiCreateAppForm(
              ?name 'NCSU_createLibForm
              ?formTitle "Create Library"
              ?callback 'createLibCB
              ?buttonLayout 'OKCancelApply
              ?unmapAfterCB t
              ?fields list(
                        list( hiCreateFrameField(
                                ?name 'frame1
                                ?labelText "Library "
                              ) 5:5 610:115 25 )
                        list( hiCreateStringField( 
                                ?name 'libName
                                ?prompt "Name: " 
                              ) 15:40 555:40 50 )
                        list( hiCreateStringField( 
                                ?name 'libPath
                                ?prompt "Path: " 
                              ) 15:80 555:40 50 )

                        list( hiCreateFrameField(
                                ?name 'frame2
                                ?labelText "Technology Library "
                              ) 5:130 610:170 25 )
                        list( hiCreateLabel(
                                ?name 'tfExplanation1 ?labelText tfExplanationMessage1
                              ) 15:160 600:20 )
                        list( hiCreateLabel(
                                ?name 'tfExplanation2 ?labelText tfExplanationMessage2
                              ) 15:180 600:20 )
                        list( hiCreateLabel(
                                ?name 'tfExplanation3 ?labelText tfExplanationMessage3
                              ) 15:200 600:20 )
                        list( hiCreateRadioField( 
                                ?name 'tfRadioField
                                ?choices list( "No tech library needed" 
                                               "Attach to existing tech library" 
                                               "Compile tech library" )
                                ?itemsPerRow 1
                                ?callback list( "tfOptionCB()" )
                              ) 45:225 150:75 100 )

                        list( hiCreateFrameField(
                                ?name 'frame3
                                ?labelText "Misc. "
                              ) 5:310 610:60 25 )
                        list( hiCreateRadioField( 
                                ?name 'padType
                                ?choices list( "Perimeter" "Area array" )
                                ?prompt "I/O Pad Type:" 
                              ) 60:345 600:20 100 )
                      )
              ?help "ncsuHelp"
            )
)


/*
 * form for entering custom tech file to compile
 */
hiCreateAppForm(
    ?name 'NCSU_customTechFileForm
    ?formTitle "Custom Tech File"
    ?buttonLayout 'OKCancel
    ?unmapAfterCB t
    ?fields list( hiCreateStringField( 
                    ?name 'ctfName
                    ?prompt "Tech file: " 
                ) 
          )
    ?help ""
    )

/*
 * procedure for user to register function to be called after library is
 * created but before techfile is compiled
 */
procedure( NCSU_registerLibCreateHook( functionSym "s" )
    putd( 'NCSU_libCreateUserFunc getd( functionSym ) )
)
 
/*
 * procedure for user to register function to be called after techfile
 * is (successfully) compiled
 */
procedure( NCSU_registerLibCompileHook( functionSym "s" )
    putd( 'NCSU_libCompileUserFunc getd( functionSym ) )
)

procedure( NCSU_unregisterLibCreateHook()
    putd( 'NCSU_libCreateUserFunc  nil )
)

procedure( NCSU_unregisterLibCompileHook()
    putd( 'NCSU_libCompileUserFunc nil )
)

; compileTechLibrary() is a version of createLib() that runs in batch mode.
; It was created to provide an easy way to re-compile a technology library
; from a SKILL script.
; Suggested Usage: compileTechLibrary( ?tech "techname" )
;     Where "techname" indexes the NCSU_techData structure
procedure( compileTechLibrary( @key (libName nil) 
            (path nil) (tech "TSMC_CMOS020") )
  prog( (libID bag techFileName techFileID customTechFile
       ret prop attachLibID inList cdsLibPort cdb retval cwd techFileDir)

    ; The following was copied from creatLibCB() 
    ; in skill/menus/ciw/createLib.il

    /*
     * be careful here - the 2nd argument to ddCreateLib() is not the directory
     * where the library is to be stored, rather, it is the name by which the
     * library will be referenced in the cds.lib file. so, to make things intuitive
     * to the user, cat the lib name to the path and use that as the "path"
     */

    /*
     * check to see if library already exists
     */
    ; we are loading an NCSU tech file
    foreach( key NCSU_techData
        if( tech == NCSU_techData[key]->description then
            tech = key
        ) ;if
    ) ;foreach
    printf("tech = %L techFileName = %L" tech NCSU_techData[tech]->techFile)
    techFileName = strcat( prependNCSUCDKInstallPath( "techfile/" )
                           NCSU_techData[tech]->techFile)
    if( !libName then
      libName = NCSU_techData[tech]->techLib
    ) ;if
    libID = ddGetObj( libName )
    if( libID then
        ddDeleteObj(libID)
    ) ;if

    printf("path = %L" path)
    if( path != nil then    
        /*
         * make sure path is valid directory
         */
        if( isDir( path ) == nil then
            printf("ERROR: The directory %L does not exist!" path )
            return( nil )
        ) ;if
        path = strcat( strcat( path "/" ) libName )
    else
        path = ""
    ) ;if

    /*
     * actually create the library
     */
    libID = ddCreateLib( libName path )
    if( libID == nil then
        hiGetAttention()
        printf( "ERROR: Creation of library \"%s\" failed!" libName )
        return( nil )
    ) ;if

    /*
     * call post-create hook if it's defined
     */
    if( getd( 'NCSU_libCreateUserFunc ) then
        NCSU_libCreateUserFunc( libID )
    ) ;if

    ; set lambda & technology properties so Diva rules can access them later on
    bag = dbOpenBag( libID "w" )
    if( bag == nil then
        printf( "ERROR: Can't open library property bag! Aborting..." )
        return( nil )
    ) ;if
    dbCreateProp( bag "PadType" "string" "Perimeter")
    dbCreateProp( bag "technology" "string" tech )
    dbCreateProp( bag "model" "string" NCSU_techData[tech]->fetModelPrefix )
    dbCreateProp( bag "gridResolution" "float" NCSU_techData[tech]->gridRes )
    dbCreateProp( bag "minLength" "float" NCSU_techData[tech]->minL )
    dbCreateProp( bag "minWidth" "float" NCSU_techData[tech]->minW )
    dbSaveBag( bag )
    dbCloseBag( bag )

    ; make your own tech library
    techFileID = techOpenTechFile( libName "techfile.cds" "w" )
    ret = loadTechFiles( techFileID techFileName )
    if( ret == t then
        techSaveTechFile( techFileID )
    else
        printf("ERROR: Aborting tech file compilation..." )
        return( nil )
    ) ;if
    
    ; put symbolics in their own category to prevent visual clutter
    printf("Categorizing symbolic cells..." )
    handleSymbolics( libID )

    ; create pcells
    createPcells( libName )

    ; create links to Diva files
    printf("Creating links to Diva verification rules files..." )
    cwd = getWorkingDir()
    changeWorkingDir( ddGetObjWritePath( libID ) )
    techfileDir = prependNCSUCDKInstallPath( "/techfile/" )
    system( strcat( "ln -s " techfileDir "divaDRC.rul divaDRC.rul" ) )
    system( strcat( "ln -s " techfileDir "divaEXT.rul divaEXT.rul" ) )
    system( strcat( "ln -s " techfileDir "divaLVS.rul divaLVS.rul" ) )
    changeWorkingDir( cwd )

    /*
     * call post-compile hook if it's defined
     */
    if( getd( 'NCSU_libCompileUserFunc ) then
        NCSU_libCompileUserFunc( libID techFileID )
    ) ;if

    printf("Library creation successfully completed." )
   
  ) ;prog
) ;procedure compileTechLibrary

; createRuleViaLib() compiles a temporary tech-library, dumps a LEF file,
; and reads the LEF file into the temporary tech-library for the purposes of
; creating the ruleVia cell.  This has a tendency to corrupt the tech-
; library, which is why the "sacrificial" tech-library is created.
; A new tech-library is then compiled, and the ruleVia cell is then copied 
; into the new tech-library.  This is the only known way to create a tech-
; library that contains the ruleVia cell, which is needed to import DEF files.
; This procedure is intended to replace the compileTechLibrary() procedure.
; Suggested Usage: createRuleViaLib( ?tech "techname" )
;     Where "techname" indexes the NCSU_techData structure
procedure( createRuleViaLib( @key (tech "TSMC_CMOS020") (path nil) )
  prog( (cdb retval file key)

    foreach( key NCSU_techData
        if( tech == NCSU_techData[key]->description then
            tech = key
        ) ;if
    ) ;foreach

    compileTechLibrary( ?tech tech ?libName "templib")

    ; Generate a bogus lefout.list file so that the LEF-OUT program
    ; Doesn't generate an error
    file=outfile("./lefout.list" "w")
    fprintf( file "templib M2_M1 symbolic\n" )
    close(file)

    retval=ldtrLefWrite("temp.lef" "templib" t "lefout.list" nil)
    printf("ldtrLefWrite returned with value %L" retval)

    retval=ldtrLefRead("temp.lef" "templib")
    printf("ldtrLefRead returned with value %L" retval)

    compileTechLibrary( ?tech tech ?path path
                        ?libName NCSU_techData[tech]->techLib)
    cdb=dbOpenCellViewByType("templib" "ruleVia" "symbolic" nil "r")
    if( !cdb then
      printf("ERROR: Could not open (templib ruleVia symbolic) for reading")
      return( nil )
    ) ;if
    retval=dbCopyCellView(cdb NCSU_techData[tech]->techLib "ruleVia" "symbolic"
                          nil nil t )
    if( !retval then
      printf("ERROR: Could not copy ruleVia to library %L" NCSU_techData[tech]->techLib )
      return( nil )
    ) ;if
    dbSave(retval)
    dbClose(retval)
    dbClose(cdb)
    
    return( t )
  ) ;prog
) ;procedure createRuleViaLib

; compileAllTechLibs() compiles all technologies and puts them in the
; directory specified by the ?path argument.  If ?path 'install is used,
; then the CDK install path is used. 
procedure( compileAllTechLibs( @key (path nil) )
  prog( (lib)
    if( path=='install then
      path = prependNCSUCDKInstallPath( "lib" )
    ) ;if
    if( path != nil then    
        /*
         * make sure path is valid directory
         */
        if( isDir( path ) == nil then
            printf("ERROR: The directory %L does not exist!" path )
            return( nil )
        ) ;if
    ) ;if
    printf("Compiling all TechLibs to path %L\n" path)

    techs=list("AMI_C5N" "AMI_ABN" "HP_AMOS14TB" 
               "TSMC_CMOS020" "TSMC_CMOS018_DEEP" 
               "TSMC_CMOS025" "TSMC_CMOS025_DEEP"
               "TSMC_CMOS035_4M2P" )

    foreach( key techs
      printf("Compiling %L\n" NCSU_techData[key]->techLib)
      ;createRuleViaLib( ?tech key ?path path )
      compileTechLibrary( ?tech key ?path path )
      ;lib=ddGetObj("templib")
      ;ddDeleteObj(lib)
    ) ;foreach

  return( t )
  ) ;prog
) ;procedure compileAllTechLibs

; vim:ts=4:columns=90

