;==========================================================================
;
; $Id: triggers.il,v 1.1.1.1 2006/02/10 16:33:45 slipa Exp $
; 
;--------------------------------------------------------------------------

procedure( NCSU_MenuTrigger( args )
let( ( menuList userMenu )

    menuList = makeNCSUMenu( args ) 
    makeUserMenu( args menuList )
))

procedure( NCSU_LayoutPITrigger( args )

    if( NCSU_newLayoutMenuLabels == t then
        ; modify "Create->Label..." to bring up our form
        hiSetMenuItemCallback( leCreateMenu 
                               'LabelItem
                               "doCreateLabels()" )

        ; modify "Verify->LVS..." to bring up our form
        hiSetMenuItemCallback( leVerifyMenu
                               'LVSItem
                               "setLVSForm()" )

        ; modify "Verify->Extract..." so we can set default behavior
        hiSetMenuItemCallback( leVerifyMenu
                               'ExtractItem
                               "setExtForm()" )

        ; modify "Verify->DRC..." so we can set default behavior
        hiSetMenuItemCallback( leVerifyMenu
                               'DRCItem
                               "setDRCForm()" )
    else
        ; modify "Create->Label..." to bring up our form
        hiSetMenuItemCallback( leCreateMenu 
                               'leCreateLabelItem
                               "doCreateLabels()" )

        ; modify "Verify->LVS..." to bring up our form
        hiSetMenuItemCallback( leVerifyMenu
                               'leVerifyLVSItem
                               "setLVSForm()" )

        ; modify "Verify->Extract..." so we can set default behavior
        hiSetMenuItemCallback( leVerifyMenu
                               'leVerifyExtractItem
                               "setExtForm()" )

        ; modify "Verify->DRC..." so we can set default behavior
        hiSetMenuItemCallback( leVerifyMenu
                               'leVerifyDRCItem
                               "setDRCForm()" )
    )
)

procedure( NCSU_LayoutAppTrigger( args )
    /*
     * look for the library property "gridResolution" first; if we can't
     * find that, then check for "lambda" (need to make sure the lib
     * prop bag exists first, tho...)
     */
    let( (gridRes l)
        if( (not (boundp 'bag)) then
            printf("Getting layout propert bag")
            GetPropBag()
        )
        if( PropBagExists( nil ) then
            gridRes = LookupLibProp( "gridResolution" nil )
            if( gridRes != nil then
                args->window->xSnapSpacing = gridRes 
                args->window->ySnapSpacing = gridRes
            else
                l = LookupLibProp( "lambda" nil )
                if( l != nil then
                    args->window->xSnapSpacing = l * 0.5
                    args->window->ySnapSpacing = l * 0.5
                )
            )
        )
    )
)

procedure( NCSU_SchematicAppTrigger( args )
    if( (not (boundp 'bag)) then
        printf("Getting schematic propert bag")
        GetPropBag()
    )
)


/*******************************************************/

deRegUserTriggers( "maskLayout" 'NCSU_LayoutAppTrigger
                                'NCSU_MenuTrigger 
                                'NCSU_LayoutPITrigger )


deRegUserTriggers( "schematic"  'NCSU_SchematicAppTrigger
                                'NCSU_MenuTrigger )
