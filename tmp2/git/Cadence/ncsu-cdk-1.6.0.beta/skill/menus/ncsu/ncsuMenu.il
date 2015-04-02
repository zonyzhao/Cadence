;==========================================================================
;
; $Id: ncsuMenu.il,v 1.2 2006/02/10 23:50:58 slipa Exp $
; 
; NCSU menu for local routines.
;
;--------------------------------------------------------------------------

procedure( makeNCSUMenu( args )
    let( (m1 m2 m3 m4 m5 ncsuMenu menuList)
        m1 = hiCreateMenuItem( 
                 ?name 'hiliteObj
                 ?itemText "Hilite Object..."
                 ?callback "hiDisplayForm( hiliteObjForm )" )
        m2 = hiCreateMenuItem( 
                 ?name 'lvsRules
                 ?itemText "Modify LVS Rules..."
                 ?callback "showLVSRulesForm()" )

        menuList = list( m1 m2 )

        if( args->viewType == "schematic" then
            m3 = hiCreateMenuItem( 
                     ?name 'createPubSchem
                     ?itemText "Create publication schematic..."
                     ?callback "NCSU_showPubSchematicForm()" )
            menuList = append( menuList list( m3 ) );
        )
            
        if( args->viewType == "maskLayout" &&
            args->viewName != "extracted" then
            m4 = hiCreateMenuItem( 
                     ?name 'alignObj
                     ?itemText "Align Objects..."
                     ?callback "hiDisplayForm( NCSU_alignObjForm )" )
            ;m5 = hiCreateMenuItem( 
            ;         ?name 'p2m
            ;         ?itemText "Import JPEG picture..."
            ;         ?callback "P2MstartWindow()" )
            ;m6 = hiCreateMenuItem( 
            ;         ?name 't2m
            ;         ?itemText "Import text..."
            ;         ?callback "T2MimportText()" )

            ;menuList = append( menuList list( m4 m5 m6 ) )
            menuList = append( menuList list( m4 ) )
        )

        ncsuMenu = hiCreatePulldownMenu( 'NCSU_Menu "NCSU" menuList )
        unless( (ncsuMenu == nil)
            list( ncsuMenu )
        )
    )
)

; vim:ts=4
