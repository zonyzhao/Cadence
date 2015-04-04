;==========================================================================
;
; m3_m2.il - parameterized cell for a metal2-metal3 contact (via2)
;
; $Id: m3_m2.il,v 1.1.1.1 2006/02/10 16:33:46 slipa Exp $
; 
; Revision History
;
; $Log: m3_m2.il,v $
; Revision 1.1.1.1  2006/02/10 16:33:46  slipa
; starting CDK v1.5.0rc1 source file
;
; Revision 1.4  2003/05/29 19:00:53  gma2
; Add deep variable line 34, added line 49-56 because via size
; will be different for DEEP and SUB
;
; Revision 1.3  1998/07/28 23:10:27  jtschaff
; inlined getQuantum() to avoid PIPO choke
;
; Revision 1.2  1998/03/19 16:04:04  jtschaff
; changed to _rows and _columns
;
; Revision 1.1  1998/03/12 06:17:57  jtschaff
; Initial revision
;
;
;--------------------------------------------------------------------------

procedure( createM3_M2pcell( libName )
    pcDefinePCell(
    ;     library ID           cellname  viewname
    list( ddGetObj( libName )  "m3_m2"   "layout" )

    ; input parameters with default values
    (   (_rows    1)
        (_columns 1)
    )

    let( (cv tf quantum bag prop
          viaSpacing m2ViaEnc m3ViaEnc viaSize
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

        /* via2-via2 spacing */
        viaSpacing = techGetSpacingRule( tf "minSpacing" "via2" )
        /* m2 enclosure of via2 */
        m2ViaEnc = techGetOrderedSpacingRule( tf "minEnclosure" "metal2" "via2" )
        /* m3 enclosure of via2 */
        m3ViaEnc = techGetOrderedSpacingRule( tf "minEnclosure" "metal3" "via2" )

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
                dbCreateRect( cv list( "via2" "drawing" ) list( left:lower right:upper ) )
                vOffset = vOffset + step
            )
            hOffset = hOffset + step
        )

        ;
        ; metal 2
        ;
        left = -m2ViaEnc
        lower = -m2ViaEnc
        w = _columns*viaSize + (_columns-1)*viaSpacing + 2*m2ViaEnc
        h = _rows*viaSize + (_rows-1)*viaSpacing + 2*m2ViaEnc
        dbCreateRect( cv "metal2" list( left:lower left+w:lower+h ) )

        ;
        ; metal 3
        ;
        left = -m3ViaEnc
        lower = -m3ViaEnc
        w = _columns*viaSize + (_columns-1)*viaSpacing + 2*m3ViaEnc
        h = _rows*viaSize + (_rows-1)*viaSpacing + 2*m3ViaEnc
        dbCreateRect( cv "metal3" list( left:lower left+w:lower+h ) )

        dbReplaceProp( cv "viewSubType" "string" "maskLayoutParamCell" )
        dbReplaceProp( cv "function" "string" "contact" )
    )

    t
    ) ; end pcDefinePCell
) ; end createM3_M2pcell

/* vim:set ts=4: */
