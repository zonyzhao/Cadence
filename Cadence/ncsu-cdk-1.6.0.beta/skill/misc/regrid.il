/* Procedure to move layout db from one grid to another. Only changes
 * bBoxes, so probably will screw up paths or anything that's not a
 * rect. Also doesn't rescale pcells or (probably) symContacts
 */

procedure( regrid( newgrid )

let( ( urx ury llx lly cell )

    cell = getEditRep()
    foreach( sh cell->shapes
        urx = xCoord( upperRight( sh->bBox))
        ury = yCoord( upperRight( sh->bBox))
        llx = xCoord( lowerLeft( sh->bBox))
        lly = yCoord( lowerLeft( sh->bBox))

        ; now convert to new grid
        urx = urx - float( mod( fix( urx*100 ) fix( newgrid * 100 ) ) ) / 100
        ury = ury - float( mod( fix( ury*100 ) fix( newgrid * 100 ) ) ) / 100
        llx = llx - float( mod( fix( llx*100 ) fix( newgrid * 100 ) ) ) / 100
        lly = lly - float( mod( fix( lly*100 ) fix( newgrid * 100 ) ) ) / 100

        sh->bBox = list( llx:lly urx:ury )
    )
))

    
