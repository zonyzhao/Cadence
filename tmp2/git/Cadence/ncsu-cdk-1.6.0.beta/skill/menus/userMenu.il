;==========================================================================
;
; $Id: userMenu.il,v 1.1.1.1 2006/02/10 16:33:45 slipa Exp $
; 
;--------------------------------------------------------------------------

/* The user menu file has the following format:

    menu <menu_name> <view_type> <title text> [library1 library2...]
    item <item_name> <parent_menu_name> <item text> <callback>
    sliderItem <item_name> <parent_menu_name> <item text>

    parent menu is either a "menu" or a "sliderItem" name

example:
    menu menu1 maskLayout "1st menu"
    menu menu2 maskLayout "2nd menu"
    menu menu3 maskLayout "Cu DRC" copperlo
    item menuItem1 menu1 "menu item 1" callback1()
    item menuItem2 menu1 "menu item 2" callback2()
    item menuItem3 menu2 "menu item 1" callback1()
    item menuItem4 menu2 "menu item 2" callback2()
    sliderItem slider1 menu2 "choices"
    item menuItem6 slider1 "submenu item 1" callback1()
    item menuItem7 slider1 "submenu item 2" callback2()
*/

defstruct( menuStruct name view text libs )

procedure( makeUserMenu( args ncsuMenuList )
prog( ( menuFileList siteMenuFile userMenuFile menuFile line menuName itemName
        itemCB m menuItems userMenu menuList menus lineType libList lineCtr )
    
    menuFileList = list()
    
    ; check for sitewide file
    if( (isFile( NCSU_siteMenuFile ) && isReadable( NCSU_siteMenuFile )) then
        menuFileList = append( menuFileList list( NCSU_siteMenuFile ) )
    )

    ; check for user file in current directory then home directory
    cond( (
            isFile( "./.cdkusermenu" ) && isReadable( "./.cdkusermenu" )
            menuFileList = append( menuFileList list( "./.cdkusermenu" ) )
          )
          (
            isFile( "~/.cdkusermenu") && isReadable( "~/.cdkusermenu" )
            menuFileList = append( menuFileList list( "~/.cdkusermenu" ) )
          )
          ( t
            ; neither was found, return if there's no sitewide file
            if( menuFileList == nil then
                return( ncsuMenuList )
            )
          )
    )

    menuItems = makeTable( "Menu Items" nil )
    menus = makeTable( "Menu list" nil )

    rexCompile( "^[ \t]+" )

    foreach( currentFile menuFileList

        menuFile = infile( currentFile )

        lineCtr = 0

        ; read lines until EOF
        while( gets( line menuFile ) != nil

            lineCtr = lineCtr + 1

            ; strip out leading whitespace
            line = rexReplace( line "" 1 )

            ; ignore a line if the first char is # or if the line is empty
            unless( strncmp( line "#" 1 ) == 0 ||
                    strncmp( line ";" 1 ) == 0 ||
                    parseString( line " \n" ) == nil
            
                ; get rid of the trailing \n

                line = car( parseString( line "\n" ) )

                ; break the line at whitespace chars and look at the first word
                ; of the line to see what to do
                lineType = lowerCase( car( parseString( line ) ) )
                cond( (
                        strcmp( lineType "menu" ) == 0
                        
                        ; construct the list of valid libs first, if there
                        ; is one: first, get everything following the menu
                        ; text as a string, then parse that into a list of
                        ; strings
                        libList = nth( 2 parseString( line "\"" ) )
                        unless( libList == nil
                            libList = parseString( libList )
                        )
                            
                        ; add this menu to the menu list
                        m = make_menuStruct( 
                                ?name nth( 1 parseString( line ) )
                                ?view nth( 2 parseString( line ) )
                                ?text nth( 1 parseString( line "\"" ) )
                                ?libs libList
                        )

                        if( menus[ m->name ] != nil then
                            hiGetAttention()
                            printf( "Duplicate menu \"%s\" at line %d, file \"%s\". Skipping...\n"
                                    m->name lineCtr currentFile )
                        else
                            menus[ m->name ] = m
                        )
                      )
                      (
                        strcmp( lineType "item" ) == 0
                        ; get item name
                        itemName = nth( 1 parseString( line ) )

                        ; get menu name
                        menuName = nth( 2 parseString( line ) )

                        ; get everything after the 2nd quote mark; that's
                        ; the item callback
                        itemCB = substring( line nindex( line "\"")+1 strlen( line ) )
                        itemCB = substring( itemCB nindex( itemCB "\"")+1 strlen( itemCB ) )
                        
                        ; create a menu item and add it to the assoc table,
                        ; keyed by menu name
                        m = hiCreateMenuItem(
                                ?name       stringToSymbol( itemName )
                                ?itemText   nth( 1 parseString( line "\"" ) )
                                ?callback   itemCB
                        )

                        menuItems[ menuName ] = append( menuItems[ menuName ] list( m ) )
                      )
                      (
                        strcmp( lineType "slideritem" ) == 0

                        ; since this is effectively a menu, use the menu
                        ; defstruct to hold this guy
                        m = make_menuStruct(
                                ?name nth( 1 parseString( line ) )
                                ?view nil
                                ?text nth( 1 parseString( line "\"" ) )
                                ?libs nil
                        )

                        ; get this guy's parent menu, and add it to the list
                        ; of stuff in that menu. add a marker to the list as
                        ; well, so we can do some post-processing
                        
                        menuName = nth( 2 parseString( line ) )

                        menuItems[ menuName ] = append( menuItems[ menuName ] list( "slider" m ) )

                      )
                )
            )
        )

        close( menuFile )
    )

    ; now we need to fix up the sliding menus; right now, there are just
    ; "placeholders" in the menu items for them. however, since sliders
    ; can contain other sliders, we'll go off and do this recursively.
    foreach( menuName menuItems
        if( member( "slider" menuItems[ menuName ] ) != nil then
            menuItems = fixupSliders( menuItems menuName )
        )
    )

    ; each entry in menuItems should now be a list of menu items that
    ; can be plugged-in to each hiCreatePulldownMenu() call directly. so
    ; now we traverse the menu list, looking at the viewType to see if
    ; it matches. if it does, create a menu for that entry and add it to
    ; the final menu list
    menuList = ncsuMenuList
    foreach( m menus
        if( strcmp( menus[ m ]->view args->viewType ) == 0 then
            if( menus[ m ]->libs == nil || member( args->libName menus[ m ]->libs ) then
                unless( menuItems[ menus[ m ]->name ] == nil
                    userMenu = hiCreatePulldownMenu( 
                                    stringToSymbol( menus[ m ]->name )
                                    menus[ m ]->text
                                    menuItems[ menus[ m ]->name ] )
                    menuList = append( menuList list( userMenu ) )
                )
            )
        )
    )

    ; now return the menu list
    return( menuList )
))

procedure( fixupSliders( mItems mName )
let( ( nextSlider sItem sliderMenu pulldownMenu )

    ; go thru each "slider" item in the menu item
    nextSlider = member( "slider" mItems[ mName ] )
    while( nextSlider != nil
        sItem = nth( 1 nextSlider )

        ; if this slider menu contains other sliders, go take care of
        ; them first
        if( member( "slider" mItems[ sItem->name ] ) != nil then
            mItems = fixupSliders( mItems sItem->name )
        )

        ; and put it there. otherwise, use it from the table
        pulldownMenu = hiCreatePulldownMenu(
                                stringToSymbol( sItem->name )
                                ""
                                mItems[ sItem->name ] )

        ; create the slider menu
        sliderMenu = hiCreateSliderMenuItem( 
                            ?name       stringToSymbol( sItem->name)
                            ?itemText   sItem->text
                            ?subMenu    pulldownMenu )

        ; replace the placeholder defstruct with the "real" slider menu
        mItems[ mName ] = subst( sliderMenu sItem mItems[ mName ] )
        
        ; now get the next slider item, if there is one
        nextSlider = member( "slider" cdr( nextSlider ) )
    )

    ; remove the "slider" markers from the menu item
    mItems[ mName ] = remove( "slider" mItems[ mName ] )

    ; return the whole table
    mItems

))
        

; vim:ts=4
