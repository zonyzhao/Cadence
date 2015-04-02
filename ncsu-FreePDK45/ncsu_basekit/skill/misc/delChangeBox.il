; Quick-n-dirty hack to remove the doggone change box from the cell so
; doing an "f" actually shows you the cell extents, not the extra space
; you used when you moved stuff around. AWG

procedure( NCSU_delChangeBox()
let( ( cv delShapes shape )

    ; First set changed layer valid

    leSetLayerValid( list( "changedLayer" "tool0" ) t )

    ; Get the dbID of the current cellview

    cv = geGetEditCellView();

    ; now search the current cellview for rectangles on the changed layer

    delShapes = leSearchHierarchy( cv cv->bBox 0 "rectangle" list( list( "layer" "==" list( "changedLayer" "tool0" ))))

    ; delete any rectangles you find

    foreach( shape delShapes
        dbDeleteObject( shape )
    )

    ; and set the layer invalid again

    leSetLayerValid( list( "changedLayer" "tool0" ) nil )
))
