;==========================================================================
;
; m2_m1.il - parameterized cell for a metal1-metal2 contact (via)
;
; $Id: m2_m1.il,v 1.1.1.1 2006/02/10 16:33:46 slipa Exp $
; 
; Revision History
;
; $Log: m2_m1.il,v $
; Revision 1.1.1.1  2006/02/10 16:33:46  slipa
; starting CDK v1.5.0rc1 source file
;
; Revision 1.4  2003/05/29 18:53:40  gma2
; Add deep variable line 34, added line 49-56 because via size
; will be different for DEEP and SUB
;
; Revision 1.3  1998/07/28 23:10:27  jtschaff
; inlined getQuantum() to avoid PIPO choke
;
; Revision 1.2  1998/03/19 16:04:04  jtschaff
; changed to _rows and _columns
;
; Revision 1.1  1998/03/12 06:17:45  jtschaff
; Initial revision
;
;
;--------------------------------------------------------------------------

procedure( createM2_M1pcell( libName )
    pcDefinePCell(
    ;     library ID           cellname  viewname
    list( ddGetObj( libName )  "m2_m1"   "layout" )

    ; input parameters with default values
    (   (_rows    1)
        (_columns 1)
    )

    let( (cv tf quantum bag prop
          viaSpacing m1ViaEnc m2ViaEnc viaSize
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
        

        /* via-via spacing */
        viaSpacing = techGetSpacingRule( tf "minSpacing" "via" )
        /* m1 enclosure of via */
        m1ViaEnc = techGetOrderedSpacingRule( tf "minEnclosure" "metal1" "via" )
        /* m2 enclosure of via */
        m2ViaEnc = techGetOrderedSpacingRule( tf "minEnclosure" "metal2" "via" )

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
                dbCreateRect( cv list( "via" "drawing" ) list( left:lower right:upper ) )
                vOffset = vOffset + step
            )
            hOffset = hOffset + step
        )

        ;
        ; metal 1
        ;
        left = -m1ViaEnc
        lower = -m1ViaEnc
        w = _columns*viaSize + (_columns-1)*viaSpacing + 2*m1ViaEnc
        h = _rows*viaSize + (_rows-1)*viaSpacing + 2*m1ViaEnc
        dbCreateRect( cv "metal1" list( left:lower left+w:lower+h ) )

        ;
        ; metal 2
        ;
        left = -m2ViaEnc
        lower = -m2ViaEnc
        w = _columns*viaSize + (_columns-1)*viaSpacing + 2*m2ViaEnc
        h = _rows*viaSize + (_rows-1)*viaSpacing + 2*m2ViaEnc
        dbCreateRect( cv "metal2" list( left:lower left+w:lower+h ) )

        dbReplaceProp( cv "viewSubType" "string" "maskLayoutParamCell" )
        dbReplaceProp( cv "function" "string" "contact" )
    )

    t
    ) ; end pcDefinePCell
) ; end createM2_M1pcell

/* vim:set ts=4: */
