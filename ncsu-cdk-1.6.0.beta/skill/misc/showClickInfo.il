;==========================================================================
;
; $Id: showClickInfo.il,v 1.1.1.1 2006/02/10 16:33:46 slipa Exp $
;
; Print information about the clicked-on item in the CIW.
; For extracted layouts, clicking on an item highlights its
; entire net.
; 
;--------------------------------------------------------------------------

procedure( hiliteShapes( obj win )
    if( NCSU_DontUseProbeHighlighting == t then
        foreach( fig obj~>net~>figs
            unless( NCSU_hiliteExcludeList[ fig~>layerName ] == t
                geSelectFig( fig )
            )
        )
    else
        geAddNetProbe( win list( "hilite" "drawing" ) obj~>net~>name )
        NCSU_oldProbe = obj~>net~>name
    )
)

if( boundp( 'NCSU_DontUseProbeHighlighting ) == nil then
    NCSU_DontUseProbeHighlighting = nil
)

NCSU_lastWin = nil
NCSU_oldProbe = ""

procedure( showClickInfo()
let( (viewName win s net)
    win = hiGetCurrentWindow()
    viewName = win->cellView~>viewName 

    ; deselect the current selection
    if( NCSU_DontUseProbeHighlighting then
        geDeselectAllFig()
    else
        geSetCrossProbeValue( "none" )  ; thanks to Andrew Beckett at Cadence!
        unless( NCSU_oldProbe == "" || windowp( NCSU_lastWin ) == nil
            geDeleteNetProbe( NCSU_lastWin NCSU_oldProbe )
            NCSU_oldProbe = ""
        )
    )
    ; check for infix mode
    if( (hiSysProps->hiSetMouseStyle->value == t) then
        mouseSingleSelectPt()
    else
        geSingleSelectPoint( win win->partialSelect hiGetPoint( win ) )
    )

    s = car( geGetSelSet() )
    if( (s~>net~>name != nil) then
        sprintf( net " net: \"%s\"" s~>net~>name )
    else
        net = "" 
    )

    case( s~>objType
        (("label")
            printf("\n%s label: \"%s\"\n" s~>layerName s~>theLabel )
        )
        (("inst")
            printf("\n%s (instance \"%s\", library \"%s\")\n" s~>cellName
                                                      s~>name s~>libName )
        )
        (("rect") let( (fig figlist)
            printf("\n%s %s ->%s height: %.2f  width: %.2f\n"
                s~>layerName nth(1 s~>lpp) net
                nth(1 nth(1 s~>bBox)) - nth(1 nth(0 s~>bBox))
                nth(0 nth(1 s~>bBox)) - nth(0 nth(0 s~>bBox)) ) 
            if( viewName == "extracted" then
                hiliteShapes( s win )
            )
        ))
        (("polygon" "line") let( (fig figlist)
            printf("\n%s %s ->%s bounding box: (%.2f,%.2f) (%.2f,%.2f)\n" 
                s~>layerName nth(1 s~>lpp) net
                nth(0 nth(0 s~>bBox)) nth(1 nth(0 s~>bBox))
                nth(0 nth(1 s~>bBox)) nth(1 nth(1 s~>bBox)) )
            if( viewName == "extracted" then
                hiliteShapes( s win )
            )
        ))
        (("path") let( (fig figlist)
            printf("\n%s %s ->%s width: %.2f  bounding box: (%.2f,%.2f) (%.2f,%.2f)\n" 
                s~>layerName nth(1 s~>lpp) net
                s~>width
                nth(0 nth(0 s~>bBox)) nth(1 nth(0 s~>bBox))
                nth(0 nth(1 s~>bBox)) nth(1 nth(1 s~>bBox)) )
            if( viewName == "extracted" then
                hiliteShapes( s win )
            )
        ))
        (("ellipse") let( (lx ly rx ry majrad minrad rad fig figList)
                lx = nth(0 nth(1 s~>bBox))
                ly = nth(1 nth(1 s~>bBox))
                rx = nth(0 nth(0 s~>bBox))
                ry = nth(1 nth(0 s~>bBox))
                majrad = max(abs(rx - lx), abs(ry - ly)) / 2.0
                minrad = min(abs(rx - lx), abs(ry - ly)) / 2.0
                if( (majrad == minrad) then
                    sprintf( rad "radius: %.2f" majrad )
                else
                    sprintf( rad "MajRad: %.2f  MinRad: %.2f" majrad minrad )
                )
                printf("\n%s %s ->%s center: (%.2f,%.2f) %s\n"
                    s~>layerName nth(1 s~>lpp) net
                    lx+(rx-lx)/2.0 ly+(ry-ly)/2.0
                    rad )
                if( viewName == "extracted" then
                    hiliteShapes( s win )
                )
        ))
        (("donut") let( (fig figlist)
            printf("\n%s %s ->%s center: (%.2f,%.2f)  Rin: %.2f Rout: %.2f\n"
                s~>layerName nth(1 s~>lpp) net
                nth(0 s~>xy) nth(1 s~>xy)
                s~>innerRadius s~>outerRadius)
            if( viewName == "extracted" then
                hiliteShapes( s win )
            )
        ))
    )

    NCSU_lastWin = win
))

hiSetBindKey( "Layout" "<Btn1Down>" "showClickInfo()" )
hiSetBindKey( "Schematics" "<Btn1Down>" "showClickInfo()" )
