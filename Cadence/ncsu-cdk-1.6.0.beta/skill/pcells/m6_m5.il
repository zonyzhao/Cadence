;==========================================================================
;
; m6_m5.il - parameterized cell for a metal6-metal5 contact (via5)
;
; $Id: m6_m5.il,v 1.1.1.1 2006/02/10 16:33:46 slipa Exp $
; 
;--------------------------------------------------------------------------

procedure( createM6_M5pcell( libName )
    pcDefinePCell(
    ;     library ID           cellname  viewname
    list( ddGetObj( libName )  "m6_m5"   "layout" )

    ; input parameters with default values
    (   (_rows    1)
        (_columns 1)
    )

    let( (cv tf quantum bag prop
          viaSpacing m6ViaEnc m5ViaEnc viaSize
          hOffset vOffset left right lower upper step h w deep)

        /* convenience abbreviations */
        cv = pcCellView
        tf = techGetTechFile( cv )
        
        /* the only reason i avoid the usual name "lambda" in favor of
         * "quantum" is that "lambda" is a reserved skill keyword that vim
         * highlights, and i don't want to see it highlighted everywhere...
         * */
        bag = dbOpenBag( ddGetObj( tf~>libName ) "r" )
        prop = dbFindProp( bag "minLength" )
        quantum = prop->value / 2
        dbCloseBag( bag )

        deep = rindex( techGetParam( tf "technology" ) "DEEP" )
	
	if( deep == "DEEP"
	    then 
	      viaSize = 4 * quantum 
	    else
	      viaSize = 3 * quantum
	  )  

        /* via5-via5 spacing */
        viaSpacing = techGetSpacingRule( tf "minSpacing" "via5" )
        /* m5 enclosure of via5 */
        m5ViaEnc = techGetOrderedSpacingRule( tf "minEnclosure" "metal5" "via5" )
        /* m6 enclosure of via5 */
        m6ViaEnc = techGetOrderedSpacingRule( tf "minEnclosure" "metal6" "via5" )

        ;
        ; vias
        ;
        step = viaSize + viaSpacing
        hOffset = 0
        for( c 1 _columns
            left = hOffset
            right = left + viaSize
            vOffset = 0
            for( r 1 _rows 
                lower = vOffset
                upper = lower + viaSize
                dbCreateRect( cv list( "via5" "drawing" ) list( left:lower right:upper ) )
                vOffset = vOffset + step
            )
            hOffset = hOffset + step
        )

        ;
        ; metal 5
        ;
        left = -m5ViaEnc
        lower = -m5ViaEnc
        w = _columns*viaSize + (_columns-1)*viaSpacing + 2*m5ViaEnc
        h = _rows*viaSize + (_rows-1)*viaSpacing + 2*m5ViaEnc
        dbCreateRect( cv "metal5" list( left:lower left+w:lower+h ) )

        ;
        ; metal 6
        ;
        left = -m6ViaEnc
        lower = -m6ViaEnc
        w = _columns*viaSize + (_columns-1)*viaSpacing + 2*m6ViaEnc
        h = _rows*viaSize + (_rows-1)*viaSpacing + 2*m6ViaEnc
        dbCreateRect( cv "metal6" list( left:lower left+w:lower+h ) )

        dbReplaceProp( cv "viewSubType" "string" "maskLayoutParamCell" )
        dbReplaceProp( cv "function" "string" "contact" )
    )

    t
    ) ; end pcDefinePCell
) ; end createM6_M5pcell

/* vim:set ts=4: */
