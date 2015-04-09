/*
 * NCSU CDK version string
 */

NCSU_CDK_version = "NCSU_CDK.1.5.1"

/*
 * Create global to hold model suffixes for CDFs and extract rules
 */

NCSU_modelSuffix = makeTable( "fetModelSuffix" "" )

NCSU_modelSuffix[ "nmos" ] =    "N"
NCSU_modelSuffix[ "pmos" ] =    "P"
NCSU_modelSuffix[ "nmos_hv" ] = "Nhv"   ; high-voltage device
NCSU_modelSuffix[ "pmos_hv" ] = "Phv"   ; high-voltage device
NCSU_modelSuffix[ "nelec" ] =   "NE"    ; poly2 gate device
NCSU_modelSuffix[ "pelec" ] =   "PE"    ; poly2 gate device
NCSU_modelSuffix[ "npdiode" ] = "NP"    ; N+-p[well|sub] diode
NCSU_modelSuffix[ "pndiode" ] = "PN"    ; P+-n[well|sub] diode
NCSU_modelSuffix[ "nwpdiode" ] = "NwP"  ; nwell-psub diode


/*
 * tell DLE (Device Level Editor) to use our pCells
 */

NCSU_dleCellName = makeTable( "dleCellName" "" )

NCSU_dleCellName[ "nmos" ] =    "nmos"
NCSU_dleCellName[ "pmos" ] =    "pmos"
NCSU_dleCellName[ "nmos_hv" ] = "nmos_hv"
NCSU_dleCellName[ "pmos_hv" ] = "pmos_hv"
NCSU_dleCellName[ "nelec" ] =   "nmos_elec"
NCSU_dleCellName[ "pelec" ] =   "pmos_elec"

/*
 * Point to the sitewide "user menu" file. See
 * local/skill/menus/ncsu/userMenu.il for more detail.
 */

NCSU_siteMenuFile = prependNCSUCDKInstallPath( "cdssetup/cdksitemenu" )


/*
 * Create "NCSU_techData", a global data structure that will hold all
 * the info we need at various parts of the program. Associates
 * technology parameters with a process.
 * 
 * Note that NCSU_techData is an association table (see SKILL Language
 * User Guide, pp. 36-42); each element of NCSU_techData is a defstruct
 * (SKILL Language User Gude, pp. 27-33) with name globalEntry. The
 * function make_globalEntry is automatically created by the defstruct
 * call (see SKILL Language User Guide, p. 28).
 *
 * The fields are:
 *
 *  description     description of technology, appears in "Create Library"
 *                  dialog box; the convention is: 
 *
 *      manufacturer  feature_size  process_name  (process options)
 *
 *                  See local/doc/layerInfo.html for a brief explanation
 *                  of the currently supported process options.
 *
 *  techFile        the name of the file containing the controls class
 *                  for the technology library; see
 *                  local/doc/cdsmgr/technology_files.html for naming
 *                  conventions
 *  techLib         the Cadence technology library
 *  mosisCode       MOSIS technology code. See 
 *                  www.mosis.org/Technical/Techcodes/menu-techcodes.html
 *                  for the allowable codes.
 *  lambda          value of lambda in microns (string)
 *  minL            minimum transistor length _in microns_
 *  minW            minimum transistor width _in microns_
 *  gridRes         grid resolution in microns for layout. For SCMOS rules,
 *                  this value is lambda/2. 
 *  submicronRules  the process uses the MOSIS SUBM (submicron) rules
 *  deepRules       the process uses the MOSIS DEEP (deep submicron) rules
 *  fetModelPrefix  text string prepended to transistor instance names
 *  stackedVias     t if stacked vias are allowed (ie, there are no placement
 *                  restrictions on vias). see the process web page.
 *  active          t if process is currently supported by MOSIS.
 *                  inactive processes do not show up in process menu in
 *                  the "create new library" form.
 */

/*
 * The following are the process ID's used to key into the
 * NCSU_techData table:
 *
 * format: MANUFACTURER_PROCESSNAME
 *
 *     AMI_ABN              AMI 1.6um (formerly 1.2um)
 *     AMI_C5N              AMI 0.5um (0.6um drawn)
 *     HP_AMOS14TB          HP 0.5um (0.6um drawn)
 *     TSMC_CMOS035_4M2P    TSMC 0.35um (0.4um drawn) (4M/2P option)
 *     TSMC_CMOS035_4M      TSMC 0.35um (0.4um drawn) (4M/sblock option)
 *     TSMC_CMOS025         TSMC 0.25um (0.3um drawn)
 *     TSMC_CMOS020         TSMC 0.18um (0.2um drawn)
 *
 *** The following processes are inactive but are retained for backward compatibility  
 *
 *     HP_GMOS10QA          HP 0.35um (0.4um drawn)
 *     TSMC_CMOS035_3M2P    TSMC 0.35um (0.4um drawn) (3M/2P option, superseded by TSMC_CMOS035_4M2P)
 *     AMI_ABN_12           AMI 1.2um (superseded by AMI_ABN)
 *     AMI_CWL              AMI 0.8um 
 *     HP_CMOS26G           HP 0.8um 
 *     ORBIT_SCNA2          Supertex (formerly Orbit) 2.0um 
 * 
 * These strings are used in at least diva(EXT|DRC).rul and
 * layerDefinitions.tf to identify the current process. If any of these
 * strings are changed (which they probably shouldn't be), the same
 * change must be made in the above listed places as well.
 */

defstruct( globalEntry description techFile techLib mosisCode 
           lambda minL minW gridRes deepRules submicronRules
           fetModelPrefix stackedVias active )

NCSU_techData = makeTable( "globalTechData" nil )

/*
 ***********************************************
 *
 * Active processes
 *
 ***********************************************
 */

; http://www.mosis.org/Technical/Processes/proc-ami-abn.html
NCSU_techData[ "AMI_ABN" ] =
        make_globalEntry(
            ?description        "AMI 1.6u ABN (2P, NPN)"
            ?techFile           "ami_16.tf"
            ?techLib            "NCSU_TechLib_ami16"
            ?mosisCode          "SCNA"
            ?lambda             "0.8"
            ?minL               1.6
            ?minW               4.0 ; note 5 lambda min width (see the Web page)
            ?gridRes            0.4
            ?submicronRules     nil
            ?fetModelPrefix     "ami16"
            ?stackedVias        nil
            ?active             t
        )

; http://www.mosis.org/Technical/Processes/proc-ami-c5n.html
NCSU_techData[ "AMI_C5N" ] = 
        make_globalEntry(
            ?description        "AMI 0.60u C5N (3M, 2P, high-res)"
            ?techFile           "ami_06.tf"
            ?techLib            "NCSU_TechLib_ami06"
            ?mosisCode          "SCN3ME_SUBM"
            ?lambda             "0.3"
            ?minL               0.6
            ?minW               1.5 ; note 5 lambda min width (see the Web page)
            ?gridRes            0.15
            ?submicronRules     t
            ?fetModelPrefix     "ami06"
            ?stackedVias        t
            ?active             t
        )

; http://www.mosis.org/Technical/Processes/proc-hp-amos14tb.html
NCSU_techData[ "HP_AMOS14TB" ] =
        make_globalEntry(
            ?description        "HP 0.60u AMOS14TB (3M, sblock, thin-ox cap)"
            ?techFile           "hp_06.tf"
            ?techLib            "NCSU_TechLib_hp06"
            ?mosisCode          "SCN3MLC_SUBM"
            ?lambda             "0.3"
            ?minL               0.6
            ?minW               0.9
            ?gridRes            0.15
            ?submicronRules     t
            ?fetModelPrefix     "hp14tb"
            ?stackedVias        t
            ?active             t
        )

; http://www.mosis.org/Technical/Processes/proc-tsmc-cmos035.html
NCSU_techData[ "TSMC_CMOS035_4M2P" ] = 
        make_globalEntry(
            ?description        "TSMC 0.40u CMOS035 (4M, 2P, HV FET)" 
            ?techFile           "tsmc_04_4m2p.tf"
            ?techLib            "NCSU_TechLib_tsmc04_4M2P"
            ?mosisCode          "SCN4ME_SUBM"
            ?lambda             "0.2"
            ?minL               0.4
            ?minW               0.6
            ?gridRes            0.1
            ?submicronRules     t
            ?fetModelPrefix     "tsmc35"
            ?stackedVias        t
            ?active             t
        )


; http://www.mosis.org/Technical/Processes/proc-tsmc-cmos035.html
NCSU_techData[ "TSMC_CMOS035_4M" ] = 
        make_globalEntry(
            ?description        "TSMC 0.40u CMOS035 (4M, sblock, HV FET)"
            ?techFile           "tsmc_04_4m.tf"
            ?techLib            "NCSU_TechLib_tsmc04_4M"
            ?mosisCode          "SCN4M_SUBM"
            ?lambda             "0.2"
            ?minL               0.4
            ?minW               0.6
            ?gridRes            0.1
            ?submicronRules     t
            ?fetModelPrefix     "tsmc35"
            ?stackedVias        t
            ?active             t
        )

; http://www.mosis.org/Technical/Processes/proc-tsmc-cmos025.html
NCSU_techData[ "TSMC_CMOS025" ] = 
        make_globalEntry(
            ?description        "TSMC 0.30u CMOS025 (5M, HV FET)" 
            ?techFile           "tsmc_03.tf"
            ?techLib            "NCSU_TechLib_tsmc03"
            ?mosisCode          "SCN5M_SUBM"
            ?lambda             "0.15"
            ?minL               0.30
            ?minW               0.45
            ?gridRes            0.075
            ?submicronRules     t
            ?fetModelPrefix     "tsmc25"
            ?stackedVias        t
            ?active             t
        )


; http://www.mosis.org/Technical/Processes/proc-tsmc-cmos025.html new DEEP item
NCSU_techData[ "TSMC_CMOS025_DEEP" ] = 
        make_globalEntry(
            ?description        "TSMC 0.24u CMOS025/DEEP (5M, HV FET)" 
            ?techFile           "tsmc_03d.tf"
            ?techLib            "NCSU_TechLib_tsmc03d"
            ?mosisCode          "SCN5M_DEEP"
            ?lambda             "0.12"
            ?minL               0.24
            ?minW               0.36
            ?gridRes            0.06
            ?submicronRules     nil
            ?deepRules          t
            ?fetModelPrefix     "tsmc25d"
            ?stackedVias        t
            ?active             t
        )



; http://www.mosis.org/Technical/Processes/proc-tsmc-cmos018.html
NCSU_techData[ "TSMC_CMOS020" ] = 
        make_globalEntry(
            ?description        "TSMC 0.20u CMOS018 (6M, HV FET, sblock)" 
            ?techFile           "tsmc_02.tf"
            ?techLib            "NCSU_TechLib_tsmc02"
            ?mosisCode          "SCN6M_SUBM"
            ?lambda             "0.10"
            ?minL               0.20
            ?minW               0.30
            ?gridRes            0.05
            ?submicronRules     t
            ?fetModelPrefix     "tsmc20"
            ?stackedVias        t
            ?active             t
        )


; http://www.mosis.org/Technical/Processes/proc-tsmc-cmos018.html new DEEP item
NCSU_techData[ "TSMC_CMOS018_DEEP" ] = 
        make_globalEntry(
            ?description        "TSMC 0.18u CMOS018/DEEP (6M, HV FET, sblock)" 
            ?techFile           "tsmc_02d.tf"
            ?techLib            "NCSU_TechLib_tsmc02d"
            ?mosisCode          "SCN6M_DEEP"
            ?lambda             "0.09"
            ?minL               0.18
            ?minW               0.27
            ?gridRes            0.045
            ?submicronRules     nil
            ?deepRules          t
            ?fetModelPrefix     "tsmc18d"
            ?stackedVias        t
            ?active             t
        )


; global settings for designing in NCSU_TechLib_EGRC
; NOTE: ?mosisCode is completely fictitious since this process is only
; supported at NCSU -- the name was chosen so that the 3rd char will
; have an no effect when $cdk/local/techfile/devices.tf is compiled
; for this techlib
NCSU_techData[ "NCSU_EGRC" ] = 
        make_globalEntry(
            ?description        "NCSU EGRC CMOS/MEMS Fabrication 3.0u" 
            ?techFile           "ncsu_egrc.tf"
            ?techLib            "NCSU_TechLib_EGRC"
            ?mosisCode          "NCSU_EGRC"
            ?lambda             "1.5"
            ?minL               1.5
            ?minW               1.5
            ?gridRes            1.5
            ?submicronRules     nil
            ?fetModelPrefix     "egrc"
            ?stackedVias        t
            ?active             nil
        )



/*
 ***********************************************
 *
 * Inactive processes
 *
 ***********************************************
 */

; http://www.mosis.org/Technical/Processes/proc-tsmc-cmos035.html
NCSU_techData[ "TSMC_CMOS035_3M2P" ] = 
        make_globalEntry(
            ?description        "TSMC 0.40u CMOS035 (3M, 2P, HV FET)" 
            ?techFile           "tsmc_04_3m2p.tf"
            ?techLib            "NCSU_TechLib_tsmc04_3M2P"
            ?mosisCode          "SCN3ME_SUBM"
            ?lambda             "0.2"
            ?minL               0.4
            ?minW               0.6
            ?gridRes            0.1
            ?submicronRules     t
            ?fetModelPrefix     "tsmc35"
            ?stackedVias        t
            ?active             nil
        )

; http://www.mosis.org/Technical/Processes/proc-hp-gmos10qa.html
NCSU_techData[ "HP_GMOS10QA" ] = 
        make_globalEntry(
            ?description        "HP 0.40u GMOS10QA (4M)" 
            ?techFile           "hp_04.tf"
            ?techLib            "NCSU_TechLib_hp04"
            ?mosisCode          "SCN4M_SUBM"
            ?lambda             "0.2"
            ?minL               0.4
            ?minW               0.6
            ?gridRes            0.1
            ?submicronRules     t
            ?fetModelPrefix     "hp10"
            ?stackedVias        t
            ?active             nil
        )

; http://www.mosis.org/Technical/Processes/proc-orb-scna20.html
NCSU_techData[ "ORBIT_SCNA2" ] =
        make_globalEntry(
            ?description        "Orbit 2.0u (2 poly, NPN, CCD, MEMS)"
            ?techFile           "orbit_scna20.tf"
            ?techLib            "orb20_TechLib"
            ?mosisCode          "SCNA_MEMS"
            ?lambda             "1.0"
            ?minL               2.0
            ?minW               3.0
            ?gridRes            0.5
            ?submicronRules     nil
            ?fetModelPrefix     "orb20"
            ?stackedVias        nil
            ?active             nil
        )

; http://www.mosis.org/Technical/Processes/proc-ami-cwl.html
NCSU_techData[ "AMI_CWL" ] =
        make_globalEntry(
            ?description        "AMI 0.80u CWL (poly capacitors)"
            ?techFile           "ami_cwl.tf"
            ?techLib            "ami08_TechLib"
            ?mosisCode          "SCNPC"
            ?lambda             "0.5"
            ?minL               1.0
            ?minW               1.5
            ?gridRes            0.25
            ?submicronRules     nil
            ?fetModelPrefix     "ami08"
            ?stackedVias        nil
            ?active             nil
        )

; http://www.mosis.org/Technical/Processes/proc-hp-cmos26g.html
NCSU_techData[ "HP_CMOS26G" ] =
        make_globalEntry(
            ?description        "HP 0.80u CMOS26G (3 metal)"
            ?techFile           "hp_26g.tf"
            ?techLib            "hp26_TechLib"
            ?mosisCode          "SCN3M_SUBM"
            ?lambda             "0.4"
            ?minL               0.8
            ?minW               1.2
            ?gridRes            0.2
            ?submicronRules     t
            ?fetModelPrefix     "hp26g"
            ?stackedVias        nil
            ?active             nil
        )

; http://www.mosis.org/Technical/Processes/proc-ami-abn.html
NCSU_techData[ "AMI_ABN_12" ] =
        make_globalEntry(
            ?description        "AMI 1.2u ABN (2P, NPN)"
            ?techFile           "ami_12.tf"
            ?techLib            "ami12_TechLib"
            ?mosisCode          "SCNA"
            ?lambda             "0.6"
            ?minL               1.2
            ?minW               1.8
            ?gridRes            0.3
            ?submicronRules     nil
            ?fetModelPrefix     "ami12"
            ?stackedVias        nil
            ?active             nil
        )

/*
 * Default layer for creating labels in Virtuoso
 * (see <cds_dir>/local/skill/menus/virtuoso/createLabel.il)
 */

NCSU_defLabelLayer = list( "text" "drawing" )

/*
 * Threshold below which extracted parasitic caps are ignored
 * (see <cds_dir>/local/techfile/divaEXT.rul)
 */

NCSU_parasiticCapIgnoreThreshold = 2.0e-17

/*
 * amount by which resistor/capacitor values can differ in layout and
 * schematic and still pass LVS
 */

NCSU_LVSResSlack = 0.1  ; 10%
NCSU_LVSCapSlack = 0.1  ; 10%

/*
 * default names for the CIF/GDSII layer map files
 */

NCSU_cifInLayermapFile = prependNCSUCDKInstallPath( "pipo/cifInLayermap" )
NCSU_cifOutLayermapFile = prependNCSUCDKInstallPath( "pipo/cifOutLayermap" )
NCSU_streamInLayermapFile = prependNCSUCDKInstallPath( "pipo/streamInLayermap" )

/*
 * Limit the shapes which are highlighted when you click on a net in an
 * extracted view - ie, don't show contacts. This speeds things up
 * quite a bit on large nets. 
 *
 * update: highlighting nets now uses the probe functions, so
 * NCSU_hiliteExcludeList is used only if the variable
 * NCSU_DontUseProbeHighlighting is set to t
 */

NCSU_hiliteExcludeList = makeTable( "hiliteExcludeLayers" "" )
NCSU_hiliteExcludeList[ "cp" ]   = t
NCSU_hiliteExcludeList[ "ce" ]   = t
NCSU_hiliteExcludeList[ "cc" ]   = t
NCSU_hiliteExcludeList[ "ca" ]   = t
NCSU_hiliteExcludeList[ "via" ]  = t
NCSU_hiliteExcludeList[ "via2" ] = t
NCSU_hiliteExcludeList[ "via3" ] = t
NCSU_hiliteExcludeList[ "via4" ] = t
NCSU_hiliteExcludeList[ "via5" ] = t


;==== CompareFeatureSize ==================================================
;
; This function compares two strings. It was designed to parse the technology
; strings of the form "Vendor FeatureSize ..." If there are two or more words
; in the string it compares the second word (FeatureSize). It returns t if the 
; first FeatureSize is smaller than the second or nil if the other way 
; around. If the FeatureSize is the same then the strings are sorted 
; alphabetically on the first word (Vendor).
;--------------------------------------------------------------------------

procedure( NCSU_CompareFeatureSize( Technology1 Technology2 )
let( (TechDesc1 TechDesc2 TechList1 TechList2 Size1 Size2 Result 
      Vendor1 Vendor2)

    TechDesc1 = Technology1
    TechDesc2 = Technology2

	if( stringp( TechDesc1 ) && stringp( TechDesc2 ) then 
	
		TechList1 = parseString( TechDesc1 ) 
		TechList2 = parseString( TechDesc2 ) 
		
		if( length( TechList1 ) > 1 && length( TechList2 ) > 1 then
			Size1 = nthelem( 2 TechList1 )
			Size2 = nthelem( 2 TechList2 )
		else
			Size1 = car( TechList1 )
			Size2 = car( TechList2 )		
		)
		
		case( alphaNumCmp( Size1 Size2 )
			(  1 Result = t )
			( -1 Result = nil )
			(  0
				Vendor1 = car( TechList1 )
				Vendor2 = car( TechList2 )
				if( strcmp( Vendor1 Vendor2 ) == -1 then Result = t
				else Result = nil 
				)
			)
			( t Result = t println("fall"))
		)
	else 
		Result = t 
	)

));---- End procedure NCSU_CompareFeatureSize ----


procedure( NCSU_createDrawingLayerCyclic( form
                                          defaultLayer
                                          xpos ypos
                                          width height promptWidth 
                                          @optional ( callback "" ) )

let( ( techLibName tfID l layers defaultIsPresent cycField )

    /* Get techfile for the current edit window */
    techLibName = techGetTechLibName( hiGetCurrentWindow()->cellView~>lib )
    tfID = techOpenTechFile( techLibName "techfile.cds" "r")

    if( tfID then

        defaultIsPresent = nil

        /* get the layer list for this techfile */
        layers = leGetValidLayerList( tfID )

        /* prune out any layer that doesn't have the purpose "drawing",
         * and figure out if the desired default layer is present */
        foreach( l layers
            if( nth( 1 l ) != "drawing" then
                layers = remd( l layers )
            else
                if( nth( 0 l ) == nth( 0 defaultLayer ) then
                    defaultIsPresent = t
                )
            )
        )

        /* if the form already has a layer cyclic field, delete it,
         * since only one is allowed per form */
        if( form->hiLayerField != nil then
            hiDeleteField( form `hiLayerField )
        )

        /* create the cyclic field and add it to the form */
        cycField = hiCreateLayerCyclicField( tfID "Layer" callback layers )

        hiAddField( form list( cycField xpos:ypos width:height promptWidth ) )

        /* if the default layer is available, set the layer cyclic to
         * display it */
        if( defaultIsPresent then
            hiSetLayerCyclicValue( tfID defaultLayer form ) 
        )
        
    else
        hiGetAttention()
        error( "Can't get techfile ID!" )
    )
));---- End procedure NCSU_createDrawingLayerCyclic ----


/*
 * Predefined technology choices used in 
 * <cds_dir>/local/skill/menus/ciw/createLib.il and attachTech.il
 * This probably shouldn't be changed.
 */

NCSU_techList = nil

foreach( tech NCSU_techData
    if( NCSU_techData[tech]->active  == t then
        NCSU_techList = cons( NCSU_techData[tech]->description NCSU_techList )
    )
)

NCSU_techList = sort( NCSU_techList 'NCSU_CompareFeatureSize )
NCSU_techList = append( NCSU_techList list( "other..." ) )
