;==========================================================================
;
; $Id: attachTech.il,v 1.1.1.1 2006/02/10 16:33:46 slipa Exp $
; 
; Replaces standard "Technology File->Attach To..." in ciw
;
;--------------------------------------------------------------------------

procedure( getDesignLibList( writeableOnly )
let( (libList)
    libList = list()
    foreach( lib ddGetLibList()
        libList = cons( lib~>name libList )
    )

    if( writeableOnly then
        foreach( lib ddGetLibList()
            if( lib~>isWritable == nil  
               libList = remd( lib~>name libList )
            )
        )
    )

    libList
))


procedure( cellEditableCB()
    if( NCSU_attachTechLibForm->attachToggle->cell->value == nil then
        NCSU_attachTechLibForm->cellname->editable = nil
        NCSU_attachTechLibForm->viewname->editable = nil
        NCSU_attachTechLibForm->attachToggle->view->value = nil
    else
        NCSU_attachTechLibForm->cellname->editable = t
    )
)


procedure( viewEditableCB()
    if( NCSU_attachTechLibForm->attachToggle->view->value == t then
        NCSU_attachTechLibForm->viewname->editable = t
        NCSU_attachTechLibForm->cellname->editable = t
        NCSU_attachTechLibForm->attachToggle->cell->value = t
    else
        NCSU_attachTechLibForm->viewname->editable = nil
    )
)


procedure( getAttachLibName( libName )
prog( (ret inList cdsLibPort attachLibName)
   /*
    * if we are attaching an ncsu library we need to make sure
    * it's in the liblist before we do the bind. look for it in
    * list & if it's not there, add a DEFINE entry for it in the
    * current dir's cds.lib
    *
    * SIDE EFFECTS: modifies/creates ./cds.lib file
    */

    foreach( key NCSU_techData
        if( libName == NCSU_techData[key]->description then
            libName = key
        )
    )

    attachLibName = NCSU_techData[libName]->techLib

    if( attachLibName != nil then
        /*
         * NCSU library...
         */
        foreach( lib ddGetLibList() 
            if( lib~>name == attachLibName
                inList = t
            )
        )
        if( inList == nil then
            cdsLibPort = outfile( "./cds.lib" "a" )
            if( cdsLibPort == nil 
                cdsLibPort = outfile( strcat( "~/cds.lib" ) "a" )
                if( cdsLibPort == nil then
                    warn( "Can't update cds.lib file!" )
                )
            )

            if( cdsLibPort != nil then
                fprintf( cdsLibPort "DEFINE %s %s/lib/%s\n" 
                                        attachLibName
                                        getShellEnvVar( "CDS_SITE" )
                                        attachLibName )
                close( cdsLibPort )
                ddUpdateLibList()
                printf( "Updated cds.lib file and library path...\n" )
            )
        )
        return( attachLibName )
    else
        /*
         * non-NCSU library...
         */
        return( libName )
    )
))


procedure( attachTechOK()
prog( (ret objID libName cellName viewName attachLib)

    libName = NCSU_attachTechLibForm->designLib->value
    if( NCSU_attachTechLibForm->attachToggle->cell->value == t then
        cellName = NCSU_attachTechLibForm->cellname->value
    else
        cellName = nil
    )
    if( NCSU_attachTechLibForm->attachToggle->view->value == t then
        viewName = NCSU_attachTechLibForm->viewname->value
    else
        viewName = nil
    )

    objID = ddGetObj( libName cellName viewName )
    if( objID == nil then
        warn( "Can't find specified library/cell/view!" )
        ddsEndSyncWithForm()
        return( nil )
    )

    attachLib = getAttachLibName( NCSU_attachTechLibForm->techLib->value )

    ; refresh since liblist might have just been changed
    objID = ddGetObj( libName cellName viewName )

    ret = techBindTechFile( objID attachLib "techfile.cds" t )
    if( ret == t then
        printf( "Attach successfully completed\n" )
    else
        warn( "Attach failed!" )
    )

    ddsEndSyncWithForm()

    return( ret )
))


procedure( attachCFCB()
let( (techLibList)

    if( NCSU_attachTechLibForm->techLib->value == "other..." then
        techLibList = append( getTechLibList( t ) 
                              list( "back to NCSU tech libs" ) )
        NCSU_attachTechLibForm->techLib->choices = techLibList
    )
    
    if( NCSU_attachTechLibForm->techLib->value == "back to NCSU tech libs" then
        NCSU_attachTechLibForm->techLib->choices = NCSU_techList   
    )
))

    
hiCreateAppForm(
    ?name 'NCSU_attachTechLibForm
    ?formTitle "Attach Design Library to Tech File "
    ?buttonLayout 'OKCancelApply
    ?unmapAfterCB t
    ?callback list( "attachTechOK()" "ddsEndSyncWithForm()" )
    ?fields list( 
                 list( hiCreateCyclicField(
                    ?name 'designLib
                    ?prompt "Design library: "
                    ?choices list( "dummy" )
                    ?value "dummy"
                 ) 20:20 175:30 100 )
                 list( hiCreateButton(
                    ?name 'browse
                    ?buttonText "Browse..."
                    ?callback "ddsSyncWithForm( NCSU_attachTechLibForm
                                                'browse 
                                                'designLib 
                                                'cellname 
                                                'viewname )" )
                   340:57 75:30 )
                list( hiCreateToggleField(
                    ?name 'attachToggle
                    ?choices list( list('cell "Cell") list('view "View") )
                    ?itemsPerRow 1
                    ?callback list( "cellEditableCB()" "viewEditableCB()" )
                ) 20:55 50:50 )
                list( hiCreateStringField( 
                    ?name 'cellname
                    ?editable nil
                ) 120:45 200:20 50) 
                list( hiCreateStringField( 
                    ?name 'viewname
                    ?editable nil
                ) 120:75 200:20 50) 
                list( hiCreateSeparatorField(
                    ?name 'sep
                ) 0:110 hicFormWidth:0 )
                list( hiCreateCyclicField(
                    ?name 'techLib
                    ?prompt "Technology library: "
                    ?choices list( "dummy" )
                    ?value "dummy"
                    ?callback "attachCFCB()"
                ) 20:120 175:30 130 )
          )
    ?help "ncsuHelp"
    )


/*
 * this function is called from the "Technology File -> Attach To..."
 * menu entry
 */
procedure( NCSU_attachTechForm( @optional ( obj "" )( lib "" )( cell "")
                                          ( view "" )( file "" )( cat "" ) )
let( (designLibList techLibList)
   
    designLibList = getDesignLibList( t )
    NCSU_attachTechLibForm->designLib->choices = designLibList
    if( lib != "" then
        NCSU_attachTechLibForm->designLib->value = lib
    else
        ; called from CIW, reset all the fields
        NCSU_attachTechLibForm->designLib->value = car( designLibList )
        NCSU_attachTechLibForm->cellname->value = ""
        NCSU_attachTechLibForm->cellname->editable = nil
        NCSU_attachTechLibForm->attachToggle->cell->value = nil
        NCSU_attachTechLibForm->viewname->value = ""
        NCSU_attachTechLibForm->viewname->editable = nil
        NCSU_attachTechLibForm->attachToggle->view->value = nil
    )
    if( cell != "" then
        NCSU_attachTechLibForm->cellname->value = cell
        NCSU_attachTechLibForm->cellname->editable = t
        NCSU_attachTechLibForm->attachToggle->cell->value = t
    )
    if( view != "" then
        NCSU_attachTechLibForm->viewname->value = view
        NCSU_attachTechLibForm->viewname->editable = t
        NCSU_attachTechLibForm->attachToggle->view->value = t
    )

    techLibList = NCSU_techList
    NCSU_attachTechLibForm->techLib->choices = techLibList
    NCSU_attachTechLibForm->techLib->value = car( techLibList )

    hiDisplayForm( NCSU_attachTechLibForm )
))
