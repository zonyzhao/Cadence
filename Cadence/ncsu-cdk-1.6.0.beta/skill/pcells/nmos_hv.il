;==========================================================================
;
; nmos_hv.il - parameterized pcell for a high-voltage NMOS
;
; $Id: nmos_hv.il,v 1.1.1.1 2006/02/10 16:33:46 slipa Exp $
; 
;--------------------------------------------------------------------------

procedure( createNMOS_HVpcell( libName )
    pcDefinePCell(
    ;     library ID           cellname  viewname
    list( ddGetObj( libName )  "nmos_hv"    "layout" )

    ; input parameters (default values are ignored; use the CDF instead)
    (   (fingers   1)   ; number of gates in series 
        (m         1)   ; number of gates in parallel
        (w_microns 1.0)   ; width in microns
        (l_microns 1.0)   ; length in microns
    )

    let( (cv tf f quantum polyPitch serial bag prop xCorrection yCorrection
          contactSpacing polySpacing activeContactEnc polyContactSpacing
          selectActiveEnc tactiveActiveEnc m1ContactEnc contactSize deep )

        /* convenience abbreviations */
        cv = pcCellView
        tf = techGetTechFile( cv )

        /* "m" is the multiplier in the SPICE sense (devices in parallel) */
        serial = (m == 1)

        /* get the number of poly gates we need - only one of fingers
         * and m can be > 1 */
        f = max( fingers m )

        /* the only reason i avoid the usual name "lambda" in favor of
         * "quantum" is that "lambda" is a reserved skill keyword that vim
         * highlights, and i don't want to see it highlighted everywhere...
         * */
        bag = dbOpenBag( ddGetObj( tf~>libName ) "r" )
        prop = dbFindProp( bag "minLength" )
        quantum = prop->value / 2
        dbCloseBag( bag )

        contactSize = 2 * quantum

        /*
         * repair problem when specifying odd number of grid
         * units/microns - since everything is drawn from the center,
         * when using a width/length that is not an even multiple of
         * half-lambda it caused all the horizontal/vertical lines to be
         * off the half-lambda grid
         */
        if( modulo( round( l_microns/(quantum/2.0) ) 2 ) == 1 then
            xCorrection = quantum/4.0
        else
            xCorrection = 0
        )
        if( modulo( round( w_microns/(quantum/2.0) ) 2 ) == 1 then
            yCorrection = quantum/4.0
        else
            yCorrection = 0
        )

        /* contact-contact spacing */
        contactSpacing = techGetSpacingRule( tf "minSpacing" "cc" )
        /* poly-poly spacing */
        polySpacing = techGetSpacingRule( tf "minSpacing" "poly" )
        /* poly-contact spacing */
        polyContactSpacing = techGetSpacingRule( tf "minSpacing" "poly" "cc" )
        /* active enclosure of contact */
        activeContactEnc = techGetOrderedSpacingRule( tf "minEnclosure" "active" "cc" )
        /* select enclosure of active */
        selectActiveEnc = techGetOrderedSpacingRule( tf "minEnclosure" "nselect" "active" )
        /* thick active enclosure of active */
        tactiveActiveEnc = techGetOrderedSpacingRule( tf "minEnclosure" "tactive" "active" )
        /* m1 enclosure of contact */
        m1ContactEnc = techGetOrderedSpacingRule( tf "minEnclosure" "metal1" "cc" )
        /* since we only have Nwell processes (for now), don't worry about pwell */

        /* poly gate pitch (center-center) */
        if( serial == t then
            polyPitch = l_microns + polySpacing
        else
            polyPitch = l_microns + 2*(polyContactSpacing + quantum)
        )
        
        deep = rindex( techGetParam( tf "technology" ) "DEEP" )
	;
        ; create gate(s)
        ;
        let( (halfW halfL left right upper lower offset
              netName idx fig net pin)
            
	    if( deep == "DEEP"
	    then 
	    halfW = (w_microns + 5*quantum) * 0.5 ; gate extension past active = 2.5*quantum
	    else
	    halfW = (w_microns + 4*quantum) * 0.5 ; gate extension past active = 2*quantum 
	      )  
	    
            halfL = l_microns * 0.5
            offset = 0
            netName = "G"
            idx = 2
            for( g 1 f
                left  = -halfL + offset + xCorrection
                right =  halfL + offset + xCorrection
                lower = -halfW + yCorrection
                upper =  halfW + yCorrection

                ; the actual gate
                dbCreateRect( cv "poly" list( left:lower right:upper ) )

                ; create a pin for DLE/routing tools
                fig = dbCreateRect( cv list( "poly" "pin" ) list( left:lower right:upper ) )
                net = dbCreateNet( cv netName )
                dbCreateTerm( net netName "input" )
                pin = dbCreatePin( net fig netName )
                pin~>accessDir = list( "top" "bottom" )
                netName = strcat( "G" sprintf( nil "%d" idx++ ) )

                offset = offset + polyPitch
            )
        )

        ;
        ; create da rest
        ;
        let( (polyEdgeActiveEdge w h hOffset hOffsetStep
              actLeft actRight actUpper actLower
              tactLeft tactRight tactUpper tactLower
              selLeft selRight selUpper selLower
              numContacts conLeft conRight conUpper conLower
              netName idx minWidth rightContactOffset leftContactOffset
              actChunkWidth )
            ;
            ; active
            ;
            polyEdgeActiveEdge = polyContactSpacing + contactSize + activeContactEnc
            ; width (of whole thing, *not* transistor width) & height
            w = 2*polyEdgeActiveEdge + (f-1)*polyPitch + l_microns
            h = w_microns

            ; is transistor width too small for a single contact?
            minWidth = (w_microns < 2*activeContactEnc + contactSize)

            if( mod( f 2 ) == 1 then
                offset = polyPitch*(f/2)
            else
                offset = polyPitch*((f-1)/2) + polyPitch*0.5
            )
            
            actLeft  = -(w*0.5) + offset + xCorrection
            actRight =  (w*0.5) + offset + xCorrection
            actLower = -(h*0.5) + yCorrection
            actUpper =  (h*0.5) + yCorrection

            dbCreateRect( cv "nactive" list( actLeft:actLower actRight:actUpper ) )

            ; correct actUpper if we have minWidth
            if( minWidth then
                actUpper = actLower + 4*quantum
            )
            
            ;
            ; thick active
            ;
            
            tactLeft  = actLeft - tactiveActiveEnc
            tactRight = actRight + tactiveActiveEnc
            tactLower = actLower - tactiveActiveEnc
            tactUpper = actUpper + tactiveActiveEnc

            dbCreateRect( cv "tactive" list( tactLeft:tactLower tactRight:tactUpper ) )

            ;
            ; select
            ;
            
            selLeft  = actLeft - selectActiveEnc 
            selRight = actRight + selectActiveEnc 
            
	    if( deep == "DEEP"
	    then 
	       selLower = actLower - selectActiveEnc - 0.5*quantum
	       selUpper = actUpper + selectActiveEnc + 0.5*quantum
	    else
	       selLower = actLower - selectActiveEnc
	       selUpper = actUpper + selectActiveEnc
	      )  

            dbCreateRect( cv "nselect" list( selLeft:selLower selRight:selUpper ) )

            ;
            ; contacts
            ;

            ; find number of contacts we have room for
            /* w_microns >= 2*activeContactEnc + n*contactSize + (n-1)contactSpacing */
            if( minWidth then
                numContacts = 1
                actChunkWidth = 2*activeContactEnc + contactSize
            else
                numContacts = floor( (w_microns - 2*activeContactEnc + contactSpacing) / 
                                     (contactSize + contactSpacing) )
            )

            if( serial == t then
                leftContactOffset = actLeft + activeContactEnc
                rightContactOffset = leftContactOffset+2*(quantum+polyContactSpacing)+f*l_microns+(f-1)*polySpacing

                ; create source contact column

                let( (vOffset vOffsetStep lower conRight conLower conUpper
                      halfW mid m1Left m1Right m1Lower m1Upper
                      fig net pin)

                    /* contacts */
                    vOffset = 0
                    vOffsetStep = contactSize + contactSpacing
                    conRight = leftContactOffset + contactSize
                    lower = actLower + activeContactEnc
                    for( c 1 numContacts
                        conLower = lower + vOffset
                        conUpper = conLower + contactSize
                        dbCreateRect( cv "cc" list( leftContactOffset:conLower conRight:conUpper ) )
                        vOffset = vOffset + vOffsetStep
                    )

                    /* metal */
                    halfW = quantum + m1ContactEnc
                    mid = leftContactOffset + quantum
                    m1Left =  mid - halfW
                    m1Right = mid + halfW
                    m1Lower = actLower
                    m1Upper = actUpper
                    dbCreateRect( cv "metal1" list( m1Left:m1Lower m1Right:m1Upper ) )

                    /* pin */
                    fig = dbCreateRect( cv list( "metal1" "pin" ) list( m1Left:m1Lower
                                                                        m1Right:m1Upper ) )
                    net = dbCreateNet( cv "S" )
                    dbCreateTerm( net "S" "inputOutput" )
                    pin = dbCreatePin( net fig "S" )
                    pin~>accessDir = list( "top" "bottom" )
                )

                ; create drain contact column

                let( (vOffset vOffsetStep lower conRight conLower conUpper
                      halfW mid m1Left m1Right m1Lower m1Upper
                      fig net pin)

                    /* contacts */
                    vOffset = 0
                    vOffsetStep = contactSize + contactSpacing
                    conRight = rightContactOffset + contactSize
                    lower = actLower + activeContactEnc
                    for( c 1 numContacts
                        conLower = lower + vOffset
                        conUpper = conLower + contactSize
                        dbCreateRect( cv "cc" list( rightContactOffset:conLower conRight:conUpper ) )
                        vOffset = vOffset + vOffsetStep
                    )

                    /* metal */
                    halfW = quantum + m1ContactEnc
                    mid = rightContactOffset + quantum
                    m1Left =  mid - halfW
                    m1Right = mid + halfW
                    m1Lower = actLower
                    m1Upper = actUpper
                    dbCreateRect( cv "metal1" list( m1Left:m1Lower m1Right:m1Upper ) )

                    /* pin */
                    fig = dbCreateRect( cv list( "metal1" "pin" ) list( m1Left:m1Lower
                                                                        m1Right:m1Upper ) )
                    net = dbCreateNet( cv "D" )
                    dbCreateTerm( net "D" "inputOutput" )
                    pin = dbCreatePin( net fig "D" )
                    pin~>accessDir = list( "top" "bottom" )
                )

                if( minWidth then
                    dbCreateRect( cv "nactive" list( actLeft:actLower 
                                                     actLeft+actChunkWidth:actUpper ) )
                    dbCreateRect( cv "nactive" list(
                                rightContactOffset-activeContactEnc:actLower
                                rightContactOffset-activeContactEnc+actChunkWidth:actUpper ) )
                )
            else
                hOffset = actLeft + activeContactEnc    ; where to start placing contacts
                hOffsetStep = 2*(quantum + polyContactSpacing) + l_microns
                netName = "S"
                idx = 2
                for( groups 1 f
                    ; create (multiple) source contact columns

                    let( (vOffset vOffsetStep lower conRight conLower conUpper
                          halfW mid m1Left m1Right m1Lower m1Upper
                          fig net pin)

                        /* contacts */
                        vOffset = 0
                        vOffsetStep = contactSize + contactSpacing
                        conRight = hOffset + contactSize
                        lower = actLower + activeContactEnc
                        for( c 1 numContacts
                            conLower = lower + vOffset
                            conUpper = conLower + contactSize
                            dbCreateRect( cv "cc" list( hOffset:conLower conRight:conUpper ) )
                            vOffset = vOffset + vOffsetStep
                        )

                        /* metal */
                        halfW = quantum + m1ContactEnc
                        mid = hOffset + quantum
                        m1Left =  mid - halfW
                        m1Right = mid + halfW
                        m1Lower = actLower
                        m1Upper = actUpper
                        dbCreateRect( cv "metal1" list( m1Left:m1Lower m1Right:m1Upper ) )

                        /* pin */
                        fig = dbCreateRect( cv list( "metal1" "pin" ) list( m1Left:m1Lower
                                                                            m1Right:m1Upper ) )
                        net = dbCreateNet( cv netName )
                        dbCreateTerm( net netName "inputOutput" )
                        pin = dbCreatePin( net fig netName )
                        pin~>accessDir = list( "top" "bottom" )
                    )

                    if( minWidth then
                        dbCreateRect( cv "nactive" list( hOffset-activeContactEnc:actLower
                                                         hOffset-activeContactEnc+actChunkWidth:actUpper) )
                    )
                    hOffset = hOffset + hOffsetStep
                    netName = strcat( "S" sprintf( nil "%d" idx++ ) )
                )

                ; create "drain" contact column

                let( (vOffset vOffsetStep lower conRight conLower conUpper
                      halfW mid m1Left m1Right m1Lower m1Upper
                      fig net pin)

                    /* contacts */
                    vOffset = 0
                    vOffsetStep = contactSize + contactSpacing
                    conRight = hOffset + contactSize
                    lower = actLower + activeContactEnc
                    for( c 1 numContacts
                        conLower = lower + vOffset
                        conUpper = conLower + contactSize
                        dbCreateRect( cv "cc" list( hOffset:conLower conRight:conUpper ) )
                        vOffset = vOffset + vOffsetStep
                    )

                    /* metal */
                    halfW = quantum + m1ContactEnc
                    mid = hOffset + quantum
                    m1Left =  mid - halfW
                    m1Right = mid + halfW
                    m1Lower = actLower
                    m1Upper = actUpper
                    dbCreateRect( cv "metal1" list( m1Left:m1Lower m1Right:m1Upper ) )

                    /* pin */
                    fig = dbCreateRect( cv list( "metal1" "pin" ) list( m1Left:m1Lower
                                                                        m1Right:m1Upper ) )
                    net = dbCreateNet( cv "D" )
                    dbCreateTerm( net "D" "inputOutput" )
                    pin = dbCreatePin( net fig "D" )
                    pin~>accessDir = list( "top" "bottom" )
                )

                if( minWidth then
                    dbCreateRect( cv "nactive" list( hOffset-activeContactEnc:actLower
                                                     hOffset-activeContactEnc+actChunkWidth:actUpper) )
                )
            )
        )

        dbReplaceProp( cv "viewSubType" "string" "maskLayoutParamCell" )
        dbReplaceProp( cv "function" "string" "transistor" )
        )

        t
    )   ; end pcDefinePCell
) ; end createNMOS_HVpcell

/* vim:set ts=4: */
