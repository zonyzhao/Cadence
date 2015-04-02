;==========================================================================
;
; $Id: cdsLibMgr.il,v 1.1.1.1 2006/02/10 16:32:38 slipa Exp $
; 
; Library Manager customizations (need DFII 4.4.2.100.22 or later)
;--------------------------------------------------------------------------

/* 
 * set this variable to nil if you are running DFII 4.4.2.100.21 or
 * earlier
 */
NCSU_modifyLibMgrMenus = t

if( NCSU_modifyLibMgrMenus then
    lmgrDisplayMessage( "Loading NCSU Library Manager customizations..." nil )

    /*
     * make "File->New->Library..." use CDK routine
     */
    lmgrCreateMenuItem( "cdkCreateNewLib"
                        "simple" 
                        list( list("label" "Library...")
                              list("callback" list( "libManCreateLib" "refreshIf" ) ) )
                      )
    lmgrManageMenuItems( list( "FileNewLibButton" ) 
                         nil
                       )
    lmgrInsertMenuItems( "FileNewLibButton" 
                         ""
                         list( "cdkCreateNewLib" )
                       )

    /*
     * add "Attach tech library..." entry to Edit menu and library, cell and
     * cellview popup menus
     */
    lmgrCreateMenuItem( "cdkAttachTechLib"
                        "simple" 
                        list( list("label" "Attach tech library...")
                              list("callback" list( "libManAttachTechLib" "noOpts" ) ) )
                      )
    lmgrAddMenuItems( "editCascade" 
                      "LCV"
                      list( "cdkAttachTechLib" )
                    )

    lmgrDisplayMessage( "done.\n" nil )
)
