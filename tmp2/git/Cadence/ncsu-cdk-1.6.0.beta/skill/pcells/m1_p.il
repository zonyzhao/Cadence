;==========================================================================
;
; m1_p.il - parameterized cell for a metal1-pdiffusion contact
;
; $Id: m1_p.il,v 1.1.1.1 2006/02/10 16:33:46 slipa Exp $
;
;--------------------------------------------------------------------------

procedure( createM1_Ppcell( libName )
    pcDefinePCell(
    ;     library ID           cellname  viewname
    list( ddGetObj( libName )  "m1_p"    "layout" )

    ; input parameters with default values
    (   (_rows    1)
        (_columns 1)
    )

    let( (cv tf quantum bag prop
          contactSpacing polyContactEnc m1ContactEnc contactSize
          hOffset vOffset left right lower upper step h w selectExtent)

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
        contactSpacing = techGetSpacingRule( tf "minSpacing" "cc" )
        /* m1 enclosure of contact */
        m1ContactEnc = techGetOrderedSpacingRule( tf "minEnclosure" "metal1" "cc" )
        /* active enclosure of contact */
        activeContactEnc = techGetOrderedSpacingRule( tf "minEnclosure" "active" "cc" )
        /* select enclosure of active */
        selectActiveEnc = techGetOrderedSpacingRule( tf "minEnclosure" "pselect" "active" )

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
        ; active
        ;
        left = -activeContactEnc
        lower = -activeContactEnc
        w = _columns*contactSize + (_columns-1)*contactSpacing + 2*activeContactEnc
        h = _rows*contactSize + (_rows-1)*contactSpacing + 2*activeContactEnc
        dbCreateRect( cv "pactive" list( left:lower left+w:lower+h ) )

        ;
        ; metal
        ;
        left = -m1ContactEnc
        lower = -m1ContactEnc
        w = _columns*contactSize + (_columns-1)*contactSpacing + 2*m1ContactEnc
        h = _rows*contactSize + (_rows-1)*contactSpacing + 2*m1ContactEnc
        dbCreateRect( cv "metal1" list( left:lower left+w:lower+h ) )

        ;
        ; select
        ;
        selectExtent = activeContactEnc + selectActiveEnc
        left = -selectExtent
        lower = -selectExtent
        w = _columns*contactSize + (_columns-1)*contactSpacing + 2*selectExtent
        h = _rows*contactSize + (_rows-1)*contactSpacing + 2*selectExtent
        dbCreateRect( cv "pselect" list( left:lower left+w:lower+h ) )

        dbReplaceProp( cv "viewSubType" "string" "maskLayoutParamCell" )
        dbReplaceProp( cv "function" "string" "contact" )
        
    )

    t
    ) ; end pcDefinePCell
) ; end createM1_Ppcell

/* vim:set ts=4: */
