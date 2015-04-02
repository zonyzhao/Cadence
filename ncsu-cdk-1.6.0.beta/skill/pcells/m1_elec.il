;==========================================================================
;
; m1_elec.il - parameterized cell for a elec contact
;
; $Id: m1_elec.il,v 1.1.1.1 2006/02/10 16:33:46 slipa Exp $
; 
;--------------------------------------------------------------------------

procedure( createM1_ELECpcell( libName )
    pcDefinePCell(
    ;     library ID           cellname   viewname
    list( ddGetObj( libName )  "m1_elec"  "layout" )

    ; input parameters with default values
    (   (_rows    1)
        (_columns 1)
    )

    let( (cv tf quantum bag prop
          contactSpacing elecContactEnc m1ContactEnc contactSize
          hOffset vOffset left right lower upper step h w)

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
 
        contactSize = 2 * quantum

        /* contact-contact spacing */
        contactSpacing = techGetSpacingRule( tf "minSpacing" "ce" )
        /* m1 enclosure of contact */
        m1ContactEnc = techGetOrderedSpacingRule( tf "minEnclosure" "metal1" "cc" )
        /* elec enclosure of contact */
        elecContactEnc = techGetOrderedSpacingRule( tf "minEnclosure" "elec" "cc" )

        ;
        ; contacts
        ;
        step = contactSize + contactSpacing
        hOffset = 0
        for( c 1 _columns
            left = hOffset
            right = left + contactSize
            vOffset = 0
            for( r 1 _rows 
                lower = vOffset
                upper = lower + contactSize
                dbCreateRect( cv list( "cc" "drawing" ) list( left:lower right:upper ) )
                vOffset = vOffset + step
            )
            hOffset = hOffset + step
        )

        ;
        ; elec
        ;
        left = -elecContactEnc
        lower = -elecContactEnc
        w = _columns*contactSize + (_columns-1)*contactSpacing + 2*elecContactEnc
        h = _rows*contactSize + (_rows-1)*contactSpacing + 2*elecContactEnc
        dbCreateRect( cv "elec" list( left:lower left+w:lower+h ) )

        ;
        ; metal
        ;
        left = -m1ContactEnc
        lower = -m1ContactEnc
        w = _columns*contactSize + (_columns-1)*contactSpacing + 2*m1ContactEnc
        h = _rows*contactSize + (_rows-1)*contactSpacing + 2*m1ContactEnc
        dbCreateRect( cv "metal1" list( left:lower left+w:lower+h ) )

        dbReplaceProp( cv "viewSubType" "string" "maskLayoutParamCell" )
        dbReplaceProp( cv "function" "string" "contact" )
        
    )

    t
    ) ; end pcDefinePCell
) ; end createM1_ELECpcell

/* vim:set ts=4: */
