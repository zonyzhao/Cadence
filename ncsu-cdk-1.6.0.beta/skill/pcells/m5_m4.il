;==========================================================================
;
; m5_m4.il - parameterized cell for a metal4-metal5 contact (via4)
;
; $Id: m5_m4.il,v 1.1.1.1 2006/02/10 16:33:46 slipa Exp $
; 
;--------------------------------------------------------------------------

procedure( createM5_M4pcell( libName )
    pcDefinePCell(
    ;     library ID           cellname  viewname
    list( ddGetObj( libName )  "m5_m4"   "layout" )

    ; input parameters with default values
    (   (_rows    1)
        (_columns 1)
    )

    let( (cv tf quantum bag prop
          viaSpacing m4ViaEnc m5ViaEnc viaSize
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
	      viaSize = 3 * quantum 
	    else
	      viaSize = 2 * quantum
	  )  

        /* via4-via4 spacing */
        viaSpacing = techGetSpacingRule( tf "minSpacing" "via4" )
        /* m4 enclosure of via4 */
        m4ViaEnc = techGetOrderedSpacingRule( tf "minEnclosure" "metal4" "via4" )
        /* m5 enclosure of via4 */
        m5ViaEnc = techGetOrderedSpacingRule( tf "minEnclosure" "metal5" "via4" )

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
                dbCreateRect( cv list( "via4" "drawing" ) list( left:lower right:upper ) )
                vOffset = vOffset + step
            )
            hOffset = hOffset + step
        )

        ;
        ; metal 4
        ;
        left = -m4ViaEnc
        lower = -m4ViaEnc
        w = _columns*viaSize + (_columns-1)*viaSpacing + 2*m4ViaEnc
        h = _rows*viaSize + (_rows-1)*viaSpacing + 2*m4ViaEnc
        dbCreateRect( cv "metal4" list( left:lower left+w:lower+h ) )

        ;
        ; metal 5
        ;
        left = -m5ViaEnc
        lower = -m5ViaEnc
        w = _columns*viaSize + (_columns-1)*viaSpacing + 2*m5ViaEnc
        h = _rows*viaSize + (_rows-1)*viaSpacing + 2*m5ViaEnc
        dbCreateRect( cv "metal5" list( left:lower left+w:lower+h ) )

        dbReplaceProp( cv "viewSubType" "string" "maskLayoutParamCell" )
        dbReplaceProp( cv "function" "string" "contact" )
    )

    t
    ) ; end pcDefinePCell
) ; end createM5_M4pcell

/* vim:set ts=4: */
