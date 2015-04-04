;==========================================================================
;
; $Id: setPIPOform.il,v 1.1.1.1 2006/02/10 16:33:46 slipa Exp $
; 
;--------------------------------------------------------------------------

/*
 * autoset the CIF and GDSII PIPO form to use a layer map file
 */
procedure( setPIPOForm( form )
    /*
     * make sure context is loaded so PIPO forms are defined
     */
    unless( isContextLoaded( "transUI" )
        loadContext( prependInstallPath( "etc/context/transUI.cxt" ) )
    )

    /*
     * avoid problem when trying to stream a file into library with a
     * read-only technology file
     */
    cifInSetup->pipoSkipUndefinedLPP->value = t
    streamInSetup->pipoSkipUndefinedLPP->value = t

    case( form
        ( "CIFin"
            cifInUserDefine->pipoLayerTable->value = NCSU_cifInLayermapFile
            pipoDisplay( transCifInForm )
        )
        ( "CIFout"
            cifOutUserDefine->pipoLayerTable->value = NCSU_cifOutLayermapFile
            pipoDisplay( transCifOutForm )
        )
        ( "StreamIn"
            streamInUserDefine->pipoLayerTable->value = NCSU_streamInLayermapFile
            pipoDisplay( transStreamInForm )
        )
        ( "StreamOut"
            ; stream-out layer numbers are defined in layerRules.tf
            streamOutUserDefine->pipoLayerTable->value = "" 
            pipoDisplay( transStreamOutForm )
        )
    )
)
