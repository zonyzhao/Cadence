;==========================================================================
;
; m4_m3.il - parameterized cell for a metal3-metal4 contact (via3)
;
; $Id: m4_m3.il,v 1.1.1.1 2006/02/10 16:33:46 slipa Exp $
; 
; Revision History
;
; $Log: m4_m3.il,v $
; Revision 1.1.1.1  2006/02/10 16:33:46  slipa
; starting CDK v1.5.0rc1 source file
;
; Revision 1.4  2003/05/29 19:03:30  gma2
; Add " deep"  variable line 34, added line 49-56 because via size
; will be different for DEEP and SUB
;
; Revision 1.3  1998/07/28 23:10:27  jtschaff
; inlined getQuantum() to avoid PIPO choke
;
; Revision 1.2  1998/03/19 16:04:04  jtschaff
; changed to _rows and _columns
;
; Revision 1.1  1998/03/12 06:18:05  jtschaff
; Initial revision
;
;
;--------------------------------------------------------------------------

procedure( createM4_M3pcell( libName )
    pcDefinePCell(
    ;     library ID           cellname  viewname
    list( ddGetObj( libName )  "m4_m3"   "layout" )

    ; input parameters with default values
    (   (_rows    1)
        (_columns 1)
    )

    let( (cv tf quantum bag prop
          viaSpacing m3ViaEnc m4ViaEnc viaSize
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

        /* via3-via3 spacing */
        viaSpacing = techGetSpacingRule( tf "minSpacing" "via3" )
        /* m3 enclosure of via3 */
        m3ViaEnc = techGetOrderedSpacingRule( tf "minEnclosure" "metal3" "via3" )
        /* m4 enclosure of via3 */
        m4ViaEnc = techGetOrderedSpacingRule( tf "minEnclosure" "metal4" "via3" )

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
                dbCreateRect( cv list( "via3" "drawing" ) list( left:lower right:upper ) )
                vOffset = vOffset + step
            )
            hOffset = hOffset + step
        )

        ;
        ; metal 3
        ;
        left = -m3ViaEnc
        lower = -m3ViaEnc
        w = _columns*viaSize + (_columns-1)*viaSpacing + 2*m3ViaEnc
        h = _rows*viaSize + (_rows-1)*viaSpacing + 2*m3ViaEnc
        dbCreateRect( cv "metal3" list( left:lower left+w:lower+h ) )

        ;
        ; metal 4
        ;
        left = -m4ViaEnc
        lower = -m4ViaEnc
        w = _columns*viaSize + (_columns-1)*viaSpacing + 2*m4ViaEnc
        h = _rows*viaSize + (_rows-1)*viaSpacing + 2*m4ViaEnc
        dbCreateRect( cv "metal4" list( left:lower left+w:lower+h ) )

        dbReplaceProp( cv "viewSubType" "string" "maskLayoutParamCell" )
        dbReplaceProp( cv "function" "string" "contact" )
    )

    t
    ) ; end pcDefinePCell
) ; end createM4_M3pcell

/* vim:set ts=4: */
