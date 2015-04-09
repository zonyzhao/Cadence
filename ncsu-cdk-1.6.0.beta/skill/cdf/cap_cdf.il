/*
 * CDF for capacitors. It expects the CDF to contain:
 *
 *      c                   the capacitance value, in Farads
 *      w                   width of capacitor in meters
 *      h                   height of capacitor in meters
 *      w_microns           width of capacitor in microns
 *      h_microns           height of capacitor in microns
 *      capPerSquareMicron  capacitance in F/um^2
 *      caRows              rows of active contacts
 *      cpRows              rows of poly contacts
 *      redoWhich           which of height and width to resize in response
 *                          to the user typing in a capacitance value directly
 */

procedure( modifyCapValue()
let( (w h capPerArea gridRes)

    ; w & h are the width/height of the actual overlap area (in
    ; meters), not the cell itself
    ; capPerArea is cap/square meter
    w = cdfParseFloatString( cdfgData->width->value )
    h = cdfParseFloatString( cdfgData->height->value )
    capPerArea = cdfParseFloatString(cdfgData->capPerSquareMicron->value)*1e12

    ; fit h & w to grid if we have valid grid resolution
    gridRes = getGridRes()
    if( gridRes != nil then
        gridRes = gridRes * 1e-6  ; convert to meters

        if( abs( h/gridRes - round(h/gridRes) ) > 0.0001 then
            h = round(h/gridRes) * gridRes
            cdfgData->height->value = sprintf( nil "%g" h )
        )
        if( abs( w/gridRes - round(w/gridRes) ) > 0.0001 then
            w = round(w/gridRes) * gridRes
            cdfgData->width->value = sprintf( nil "%g" w )
        )
    )

    cdfgData->c->value = sprintf( nil "%g" w * h * capPerArea )

    ; change these so the cell will resize itself
    cdfgData->w_microns->value = w*1e6
    cdfgData->h_microns->value = h*1e6
))

procedure( resizeCapHeight()
let( (w c h capPerArea gridRes)

    gridRes = getGridRes()
    w = cdfParseFloatString( cdfgData->width->value )
    c = cdfParseFloatString( cdfgData->c->value )
    capPerArea = cdfParseFloatString(cdfgData->capPerSquareMicron->value)*1e12

    h = c/(capPerArea * w)

    ; fit to grid if we have valid grid resolution
    if( gridRes != nil then
        gridRes = gridRes * 1e-6  ; convert to meters
        if( abs( h/gridRes - round(h/gridRes) ) > 0.0001
            h = round(h/gridRes) * gridRes
        )
    )

    ; make sure we're above the minimum before we commit the change
    if( h < 2.85e-6 then   
        hiGetAttention()
        ; for some reason warn() doesn't work here
        printf( "WARNING: Value would cause a minimum height violation!\n" )
    else
        cdfgData->height->value = sprintf( nil "%g" h )
    )
))

procedure( resizeCapWidth()
let( (h c w capPerArea gridRes)

    gridRes = getGridRes()
    h = cdfParseFloatString( cdfgData->height->value )
    c = cdfParseFloatString( cdfgData->c->value )
    capPerArea = cdfParseFloatString(cdfgData->capPerSquareMicron->value)*1e12

    w = c/(capPerArea * h)

    ; fit to grid if we have valid grid resolution
    if( gridRes != nil then
        gridRes = gridRes * 1e-6  ; convert to meters
        if( abs( w/gridRes - round(w/gridRes) ) > 0.0001
            w = round(w/gridRes) * gridRes
        )
    )

    ; make sure we're above the minimum before we commit the change
    if( w < 1.80e-6 then   
        hiGetAttention()
        ; for some reason warn() doesn't work here
        printf( "WARNING: Value would cause a minimum width violation!\n" )
    else
        cdfgData->width->value = sprintf( nil "%g" w )
    )
))

procedure( getGridRes()
prog( (gridRes)
    gridRes = LookupLibProp( "gridResolution" )
    if( gridRes == nil then
        SetMosfetPropForm( "gridResolution" )
        gridRes = LookupLibProp( "gridResolution" )
    )
    return( gridRes )
))

procedure( capChange()

    if( cdfgData->redoWhich->value == "width"
    then
        resizeCapWidth()
    else
        resizeCapHeight()
    )

    ; since the width/height for the cap the user wants might not be
    ; on the grid, the resize() function above could have changed w/h.
    ; so, we call modifyCapValue() again to account for this possible
    ; change.

    modifyCapValue()
)


procedure( pcRowsCB()
    if( cdfgData->pcRows->value < 1 then   
        hiGetAttention()
        warn( "Number of poly contact rows must be >=1" )
        cdfgData->pcRows->value = 1
    )
)

procedure( caRowsCB()
    if( cdfgData->caRows->value < 1 then   
        hiGetAttention()
        warn( "Number of active contact rows must be >=1" )
        cdfgData->caRows->value = 1
    )
)
