;==========================================================================
;
; $Id: align.il,v 1.1.1.1 2006/02/10 16:33:45 slipa Exp $
; 
; Revision History
;
;--------------------------------------------------------------------------

/* "internal globals" */

NCSU_alignObjs = list()

procedure( alignObjectsCB()
prog( (leftEdge rightEdge topEdge bottomEdge edge w h offset
      x y llX llY urX urY left right top bottom delta pts refObj)

    ; make sure editing is enabled
    if( geGetEditCellView()~>mode == "r" then
        hiDisplayAppDBox(
            ?name 'readOnlyErr
            ?dboxBanner "Error"
            ?dboxText "Layout must be opened with write permission"
            ?dialogType hicErrorDialog
            ?buttonLayout 'Close
        )
        return( nil )
    )

    if( NCSU_alignObjForm->useRefObjBB->value == t then
        if( length( geGetSelectedSet() ) != 1 then
            hiGetAttention()
            error( "Exactly one reference object must be selected" )
        )
        refObj = car( geGetSelectedSet() )

        ; go through NCSU_alignObjs and remove any references to objects that
        ; don't exist anymore
        let( (l)
            l = list()
            foreach( s NCSU_alignObjs
                unless( s~>cellView == nil
                    l = append( l list( s ) )
                )
            )
            NCSU_alignObjs = l
        )
    else
    ; previously-selected "NCSU_alignObjs" are ignored if we're not using a
    ; reference object
        NCSU_alignObjs = geGetSelectedSet()
    ) 

    case( NCSU_alignObjForm->alignobjRadioField->value
        ("Left"
            ; get leftmost edge
            if( NCSU_alignObjForm->useRefObjBB->value == nil then
                leftEdge = 999999
                foreach( s NCSU_alignObjs
                    edge = nth( 0 lowerLeft( s~>bBox ) )
                    leftEdge = min( edge leftEdge )
                )
            else
                leftEdge = nth( 0 lowerLeft( refObj~>bBox ) )
            )
            ; move everything over to match leftEdge
            foreach( s NCSU_alignObjs
                w = nth(0 upperRight(s~>bBox)) - nth(0 lowerLeft(s~>bBox))
                case( s~>objType 
                    ("inst"
                        offset = nth( 0 lowerLeft( s~>bBox ) ) - nth( 0 s~>xy )
                        x = leftEdge - offset
                        y = nth( 1 s~>xy )
                        s~>xy = list( x y )
                    )
                    ("rect"
                        llX = leftEdge
                        llY = nth( 1 lowerLeft( s~>bBox ) )
                        urX = leftEdge + w
                        urY = nth( 1 upperRight( s~>bBox ) )
                        s~>bBox = list( list( llX llY ) list( urX urY ))
                    )
                    ( "polygon"
                        left = 999999
                        foreach( p s~>points
                            left = min( left nth( 0 p ) )
                        )
                        delta = left - leftEdge
                        pts = list()
                        foreach( p s~>points
                            x = nth( 0 p ) - delta
                            y = nth( 1 p )
                            pts = append( pts list(list( x y )) )
                        )
                        s~>points = pts
                    )
                )
            )
        )

        ("Right"
            ; get rightmost edge
            if( NCSU_alignObjForm->useRefObjBB->value == nil then
                rightEdge = -999999
                foreach( s NCSU_alignObjs
                    edge = nth( 0 upperRight( s~>bBox ) )
                    rightEdge = max( edge rightEdge )
                )
            else
                rightEdge = nth( 0 upperRight( refObj~>bBox ) )
            )
            ; move everything over to match rightEdge
            foreach( s NCSU_alignObjs
                w = nth(0 upperRight(s~>bBox)) - nth(0 lowerLeft(s~>bBox))
                case( s~>objType 
                    ("inst"
                        offset = nth( 0 lowerLeft( s~>bBox ) ) - nth( 0 s~>xy )
                        x = rightEdge - w - offset
                        y = nth( 1 s~>xy )
                        s~>xy = list( x y )
                    )
                    ("rect"
                        llX = rightEdge - w
                        llY = nth( 1 lowerLeft( s~>bBox ) )
                        urX = rightEdge
                        urY = nth( 1 upperRight( s~>bBox ) )
                        s~>bBox = list( list( llX llY ) list( urX urY ))
                    )
                    ( "polygon"
                        right = -999999
                        foreach( p s~>points
                            right = max( right nth( 0 p ) )
                        )
                        delta = rightEdge - right
                        pts = list()
                        foreach( p s~>points
                            x = nth( 0 p ) + delta
                            y = nth( 1 p )
                            pts = append( pts list(list( x y )) )
                        )
                        s~>points = pts
                    )
                )
            )
        )

        ("Top"
            ; get topmost edge
            if( NCSU_alignObjForm->useRefObjBB->value == nil then
                topEdge = -999999
                foreach( s NCSU_alignObjs
                    edge = nth( 1 upperRight( s~>bBox ) )
                    topEdge = max( edge topEdge )
                )
            else
                topEdge = nth( 1 upperRight( refObj~>bBox ) )
            )
            ; move everything over to match topEdge
            foreach( s NCSU_alignObjs
                h = nth(1 upperRight(s~>bBox)) - nth(1 lowerLeft(s~>bBox))
                case( s~>objType 
                    ("inst"
                        x = nth( 0 s~>xy )
                        offset = nth( 1 lowerLeft( s~>bBox ) ) - nth( 1 s~>xy )
                        y = topEdge - h - offset
                        s~>xy = list( x y )
                    )
                    ("rect"
                        llX = nth( 0 lowerLeft( s~>bBox ) )
                        llY = topEdge - h
                        urX = nth( 0 upperRight( s~>bBox ) )
                        urY = topEdge
                        s~>bBox = list( list( llX llY ) list( urX urY ))
                    )
                    ( "polygon"
                        top = -999999
                        foreach( p s~>points
                            top = max( top nth( 1 p ) )
                        )
                        delta = topEdge - top
                        pts = list()
                        foreach( p s~>points
                            x = nth( 0 p )
                            y = nth( 1 p ) + delta
                            pts = append( pts list(list( x y )) )
                        )
                        s~>points = pts
                    )
                )
            )
        )

        ("Bottom"
            ; get bottommost edge
            if( NCSU_alignObjForm->useRefObjBB->value == nil then
                bottomEdge = 999999
                foreach( s NCSU_alignObjs
                    edge = nth( 1 lowerLeft( s~>bBox ) )
                    bottomEdge = min( edge bottomEdge )
                )
            else
                bottomEdge = nth( 1 lowerLeft( refObj~>bBox ) )
            )
            ; move everything over to match bottomEdge
            foreach( s NCSU_alignObjs
                h = nth(1 upperRight(s~>bBox)) - nth(1 lowerLeft(s~>bBox))
                case( s~>objType 
                    ("inst"
                        x = nth( 0 s~>xy )
                        offset = nth( 1 lowerLeft( s~>bBox ) ) - nth( 1 s~>xy )
                        y = bottomEdge - offset
                        s~>xy = list( x y )
                    )
                    ("rect"
                        llX = nth( 0 lowerLeft( s~>bBox ) )
                        llY = bottomEdge
                        urX = nth( 0 upperRight( s~>bBox ) )
                        urY = bottomEdge + h
                        s~>bBox = list( list( llX llY ) list( urX urY ))
                    )
                    ( "polygon"
                        bottom = 999999
                        foreach( p s~>points
                            bottom = min( bottom nth( 1 p ) )
                        )
                        delta = bottom - bottomEdge
                        pts = list()
                        foreach( p s~>points
                            x = nth( 0 p )
                            y = nth( 1 p ) - delta
                            pts = append( pts list(list( x y )) )
                        )
                        s~>points = pts
                    )
                )
            )
        )
    )

    ; reset
    NCSU_alignObjs = list()
)
)


procedure( handleAlignButtons()
    if( NCSU_alignObjForm->useRefObjBB->value == t then
        hiAddField( NCSU_alignObjForm
                    list( hiCreateButton(
                            ?name 'getGroupButton
                            ?callback "NCSU_alignObjs = geGetSelectedSet()"
                            ?buttonText "Click here after group selection" )
                            105:100 200:30 ) )
    else
        hiDeleteField( NCSU_alignObjForm 'getGroupButton )
    )
)


hiCreateAppForm(
                ?name 'NCSU_alignObjForm
                ?formTitle "Align Objects"
                ?buttonLayout 'ApplyCancelDef
                ?callback "alignObjectsCB()"
                ?fields list( 
                        list(
                            hiCreateRadioField(
                                ?name 'alignobjRadioField
                                ?prompt "Alignment edge:"
                                ?choices list( "Left" "Right" "Top" "Bottom" )
                                ?itemsPerRow 4
                            ) 10:10 200:40 150) 
                        list(
                            hiCreateBooleanButton(
                                ?name 'useRefObjBB
                                ?buttonText "Align to reference object"
                                ?callback "handleAlignButtons()"
                                ?value nil
                            ) 10:50 260:40 150 )
                )
                ?help "ncsuHelp"
                )

; vim:ts=4
