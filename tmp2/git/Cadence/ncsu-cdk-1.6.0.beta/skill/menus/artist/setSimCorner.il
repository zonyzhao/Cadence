;==========================================================================
;
; $Id: setSimCorner.il,v 1.1.1.1 2006/02/10 16:33:45 slipa Exp $
; 
;--------------------------------------------------------------------------

procedure( setSimCornerCB( form )
let( (session sim corner cornerTable path)

    session = asiGetCurrentSession()
    sim = sprintf( nil "%s" session->name )
    corner = form->modelRadioField->value
    cornerTable = makeTable( "corner" "" )
    cornerTable["Nominal"] = "nom";
    cornerTable["Fast"] = "fast";
    cornerTable["Slow"] = "slow";
    cornerTable["Slow N / Fast P"] = "snfp";
    cornerTable["Fast N / Slow P"] = "fnsp";
    
    sim = cond( 
                (strncmp( sim "spectre" 7 ) == 0 "spectre" )
                (strncmp( sim "hspice" 6 ) == 0 "hspice" )
                (t hiGetAttention() warn( "Unknown simulator" ) nil )
    )

    unless( (sim == nil)
        ; always add a default user-accessible directory to the path
        path = strcat( "~/cadence/models/" sim "/" )
        ; append the model corner as well
        path = strcat( path " " prependNCSUCDKInstallPath( strcat( "models/" sim "/"
                                                                cornerTable[corner] ) ) )
        ; always include nominal case as a fallback, since we don't
        ; have corners for most of the processes
        unless( corner == "Nominal"
            path = strcat( path " " prependNCSUCDKInstallPath( strcat( "models/" sim "/" 
                                                                cornerTable["Nominal"] ) ) )
        )
        asiSetEnvOptionVal( session 'modelPath path )
    )
) )

hiCreateAppForm(
    ?name 'NCSU_setModelPathForm
    ?callback 'setSimCornerCB
    ?help nil
    ?formTitle "Set Model Corner"
    ?buttonLayout 'OKCancelDef

    ?fields list(
      hiCreateRadioField( ?name 'modelRadioField
                          ?itemsPerRow 1
                          ?choices list( "Nominal" "Fast" "Slow"
                                         "Fast N / Slow P" "Slow N / Fast P" )
      )
    )
)

; vim:ts=4:columns=95
