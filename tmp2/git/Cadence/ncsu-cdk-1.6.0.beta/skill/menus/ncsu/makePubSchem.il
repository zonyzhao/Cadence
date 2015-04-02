;==========================================================================
;
; $Id: makePubSchem.il,v 1.1.1.1 2006/02/10 16:33:46 slipa Exp $
; 
;--------------------------------------------------------------------------

procedure( NCSU_showPubSchematicForm()
let( ( editCV )


    ; Set up the form using the info from the current edit cell
    editCV = geGetEditCellView()
    if( editCV then
        NCSU_pubSchForm->sourceLib->value = editCV->libName
        NCSU_pubSchForm->sourceCell->value = editCV->cellName
        NCSU_pubSchForm->sourceView->value = editCV->viewName

        NCSU_pubSchForm->destLib->value = editCV->libName
        NCSU_pubSchForm->destCell->value = editCV->cellName
        NCSU_pubSchForm->destView->value = strcat( editCV->viewName ".publication" )
    else
        NCSU_pubSchForm->sourceView->value = "schematic"
        NCSU_pubSchForm->destView->value = "schematic.publication"
    )


    ; Now that the symbol map's done, display the form
    hiDisplayForm( NCSU_pubSchForm )
))


procedure( NCSU_makePublicationSchematic()
let( ( sourceCV cv inst newMaster sourceLib sourceCell sourceView
       destLib destCell destView forceWrite showParameters showInstNames
       instName instProp mosW mosWu mosL mosLu labelText labelOrigin
       labelJust lObj urx ury llx lly multiplier)

    ; Get relevant data from the form
    sourceLib = NCSU_pubSchForm->sourceLib->value
    sourceCell = NCSU_pubSchForm->sourceCell->value
    sourceView = NCSU_pubSchForm->sourceView->value

    destLib = NCSU_pubSchForm->destLib->value
    destCell = NCSU_pubSchForm->destCell->value
    destView = NCSU_pubSchForm->destView->value

    forceWrite = NCSU_pubSchForm->forceOverwrite->value
    showParameters = NCSU_pubSchForm->showParameters->value
    showInstNames = NCSU_pubSchForm->showInstNames->value

    ; Do an open for read on the dest cellview, to see if it's there
    cv = ddGetObj( destLib destCell destView nil nil "r" )

    ; If force overwrite is on, or if the destination cell doesn't
    ; exist, we can proceed. Otherwise, print a message.
    if( forceWrite || ( cv == nil ) then 

        ; Copy the source cellview to the new cellview and close it
        sourceCV = dbOpenCellViewByType( sourceLib sourceCell sourceView )

        dbCopyCellView( sourceCV destLib destCell destView "" nil forceWrite )
        dbClose( sourceCV )

        ; Open the new cellview for editing, and change all instances that
        ; appear in the symbol map list
        cv = dbOpenCellViewByType( destLib destCell destView "schematic" "a" )
        foreach( inst cv~>instances
            
            ; Check the local lib for a cellview with same cellname and
            ; viewname "symbol.publication", and use it if you find it.

            if( ddGetObj( sourceLib inst->cellName 
                          "symbol.publication" nil nil "r" ) then

                newMaster = dbOpenCellViewByType( sourceLib
                                                  inst->cellName 
                                                  "symbol.publication" 
                                                  "" "r" )
                inst->master = newMaster
                dbClose( newMaster )

            ; Next, check in the instance's source library for a
            ; cellview with same cellname and viewname
            ; "symbol.publication", and use it if you find it.

            else 
                if( ddGetObj( inst->libName inst->cellName 
                              "symbol.publication" nil nil "r" ) then

                    newMaster = dbOpenCellViewByType( inst->libName
                                                      inst->cellName 
                                                      "symbol.publication" 
                                                      "" "r" )
                    inst->master = newMaster
                    dbClose( newMaster )

                )
            )
        )
        ; If the user wants instance names, run through each instance
        ; in the new cell, and try to put a label with the instance
        ; name next to it
        when( showInstNames == t
            foreach( inst cv~>instances

                ;set label text
                labelText = inst->name

                ; If we actually generated some label text, try to place
                ; it in the cellview at the right spot.
                unless( labelText == nil
                    
                    ; Get the bounding box coordinates of the instance
                    llx = xCoord( nth( 0 inst->bBox ) )
                    lly = yCoord( nth( 0 inst->bBox ) )
                    urx = xCoord( nth( 1 inst->bBox ) )
                    ury = yCoord( nth( 1 inst->bBox ) )

                    ; Set up label origin based on instance orientation.
                    ; This is set up with FETs in mind, but it should be
                    ; OK for everything else too.
                    cond( 
                        ( index( inst->orient "R90" )
                            labelOrigin = list( urx 
                                                lly )
                            labelJust = "lowerLeft"
                        )
                        ( index( inst->orient "R180" )
                            labelOrigin = list( ( llx - 0.02 )
                                                ury )
                            labelJust = "centerRight"
                        )
                        ( index( inst->orient "R270" )
                            labelOrigin = list( llx 
                                                ury )
                            labelJust = "upperRight"
                        )
                        ( t
                            labelOrigin = list( ( urx + 0.02 )
                                                ury )
                            labelJust = "centerLeft"
                        )
                    )
                            
                    ; Create the label on the "text" layer
                    lObj = dbCreateLabel( cv "text" labelOrigin labelText
                                              labelJust "R0" "stick" 0.05 )
                    
                    ; Add the "\Omega" if it was a resistor (it's a
                    ; different font, so we can't do it all in one go)
                )
            )
        )


        ; If the user wants instance labels, run through each instance
        ; in the new cell, and try to put a label with the instance
        ; parameters next to it
        when( showParameters == t
            foreach( inst cv~>instances

                ;reset label text
                labelText = nil

                ; see if the instance is a MOSFET. If it is, use a generic
                ; identifier, since the properties are the same for all of
                ; them.
                if( rexMatchp( "mos" inst->cellName ) then
                    instName = "mos"
                else
                    instName = inst->cellName
                )

                ; Generate the label text based on what the instance is
                case( instName
                    ( "mos"
                        unless( inst~>prop == nil
                            foreach( instProp inst~>prop
                                ; need to figure out if we want to use
                                ; w (symbolic width/length - eg WN, LN) 
                                ; or w_microns (numeric width/length -
                                ; eg 0.45)
                                case( instProp->name
                                    ( "w"
                                        mosW = instProp->value
                                    )
                                    ( "l"
                                        mosL = instProp->value
                                    )
                                    ( "w_microns"
                                        mosWu = instProp->value
                                    )
                                    ( "l_microns"
                                        mosLu = instProp->value
                                    )
                                    ( "m"
                                        multiplier = instProp->value
                                    )
                                )
                            )
                            ; If there are alphabetics in mosW (other
                            ; than the SI abbrs for powers of ten), it's
                            ; probably a symbolic width, so we want to
                            ; use it for the label. Otherwise, use the
                            ; numeric value in mosWu.
                            unless( rexMatchp( "[A-LN-Za-jlo-tv-z]" mosW )
                                mosW = mosWu
                            )
                            ; Similar thing for length
                            unless( rexMatchp( "[A-LN-Za-jlo-tv-z]" mosL )
                                mosL = mosLu
                            )
                            labelText = strcat( mosW "/" mosL )
                            ; If there was a multiplier, add it to the
                            ; label text
                            when( multiplier
                                multiplier = sprintf( nil "%d" multiplier )
                                labelText = strcat( labelText " (x"
                                                    multiplier ")" )
                                multiplier = nil
                            )
                        )
                    )
                    ( "res"
                        if( inst~>prop == nil then
                            labelText = "1k"
                        else
                            foreach( instProp inst~>prop
                                if( instProp->name == "r" then
                                    labelText = instProp->value
                                )
                            )
                        )
                    )
                    ( "ind"
                        if( inst~>prop == nil then
                            labelText = "1n"
                        else
                            foreach( instProp inst~>prop
                                if( instProp->name == "l" then
                                    labelText = instProp->value
                                )
                            )
                        )
                        labelText = strcat( labelText "H" )
                    )
                    ( "cap"
                        if( inst~>prop == nil then
                            labelText = "1p"
                        else
                            foreach( instProp inst~>prop
                                if( instProp->name == "c" then
                                    labelText = instProp->value
                                )
                            )
                        )
                        labelText = strcat( labelText "F" )
                    )
                    ( "vdc"
                        unless( inst~>prop == nil
                            foreach( instProp inst~>prop
                                if( instProp->name == "vdc" then
                                    labelText = instProp->value
                                )
                            )
                            labelText = strcat( labelText "V" )
                        )
                    )
                )

                ; If we actually generated some label text, try to place
                ; it in the cellview at the right spot.
                unless( labelText == nil
                    
                    ; Get the bounding box coordinates of the instance
                    llx = xCoord( nth( 0 inst->bBox ) )
                    lly = yCoord( nth( 0 inst->bBox ) )
                    urx = xCoord( nth( 1 inst->bBox ) )
                    ury = yCoord( nth( 1 inst->bBox ) )

                    ; Set up label origin based on instance orientation.
                    ; This is set up with FETs in mind, but it should be
                    ; OK for everything else too.
                    cond( 
                        ( index( inst->orient "R90" )
                            labelOrigin = list( ( 0.5 * ( llx + urx ) ) 
                                                ( ury + 0.02 ) )
                            labelJust = "lowerCenter"
                        )
                        ( index( inst->orient "R180" )
                            labelOrigin = list( ( llx - 0.02 )
                                                ( 0.5 * ( lly + ury ) ) )
                            labelJust = "centerRight"
                        )
                        ( index( inst->orient "R270" )
                            labelOrigin = list( ( 0.5 * ( llx + urx ) ) 
                                                ( lly - 0.02 ) )
                            labelJust = "upperCenter"
                        )
                        ( t
                            labelOrigin = list( ( urx + 0.02 )
                                                ( 0.5 * ( lly + ury ) ) )
                            labelJust = "centerLeft"
                        )
                    )
                            
                    ; Create the label on the "text" layer
                    lObj = dbCreateLabel( cv "text" labelOrigin labelText
                                              labelJust "R0" "stick" 0.05 )
                    
                    ; Add the "\Omega" if it was a resistor (it's a
                    ; different font, so we can't do it all in one go)
                    when( instName == "res"

                        ; If it was a horizontal inst, shift label to the
                        ; left to account for the width of the \Omega
                        ; (so the label as a whole is still centered)
                        when( labelJust == "lowerCenter"
                            lObj->xy = list( xCoord( lObj->xy ) - 0.028125
                                             yCoord( lObj->xy ) ) 
                        )

                        ; Now add the \Omega so that it's just to the
                        ; right of the existing label text
                        ury = yCoord( nth( 1 lObj->bBox ) )
                        urx = xCoord( nth( 1 lObj->bBox ) )
                        dbCreateLabel( cv "text" urx:ury ":" "upperLeft"
                                       "R0" "math" 0.05 )
                    
                    )
                )
            )
        )
        
        ; Save the edits to the new cellview, and we're done
        dbSave( cv )
        dbClose( cv )

    else

        hiGetAttention()
        warn( "The destination cell exists and overwrite is disabled." )
    
    )

))

hiCreateAppForm(
    ?name 'NCSU_pubSchForm
    ?formTitle "Make Publication Schematic"
    ?callback list( "NCSU_makePublicationSchematic()" )
    ?unmapAfterCB t
    ?buttonLayout 'OKCancelApply
    ?help "ncsuHelp"
    ?fields list(
                list( hiCreateFrameField(
                        ?name 'source
                      ) 10:10 310:110 
                )
                list( hiCreateLabel(
                        ?name 'sourceBoxLabel
                        ?labelText "From"
                      ) 20:0 50:25
                )
                list( hiCreateStringField(
                        ?name 'sourceLib
                        ?editable t
                      ) 75:25 235:30 70
                )
                list( hiCreateLabel(
                        ?name 'sourceLibLabel
                        ?labelText "Library"
                        ?justification 'right
                      ) 10:25 60:30
                )
                list( hiCreateStringField(
                        ?name 'sourceCell
                        ?editable t
                      ) 75:55 235:30 70
                )
                list( hiCreateLabel(
                        ?name 'sourceCellLabel
                        ?labelText "Cell"
                        ?justification 'right
                      ) 10:55 60:30
                )
                list( hiCreateStringField(
                        ?name 'sourceView
                        ?editable t
                      ) 75:85 235:30 70
                )
                list( hiCreateLabel(
                        ?name 'sourceViewLabel
                        ?labelText "View"
                        ?justification 'right
                      ) 10:85 60:30
                )
                list( hiCreateFrameField(
                        ?name 'dest
                      ) 10:135 310:110 
                )
                list( hiCreateLabel(
                        ?name 'destBoxLabel
                        ?labelText "To"
                      ) 20:125 50:25
                )
                list( hiCreateStringField(
                        ?name 'destLib
                        ?editable t
                      ) 75:150 235:30 70
                )
                list( hiCreateLabel(
                        ?name 'destLibLabel
                        ?labelText "Library"
                        ?justification 'right
                      ) 10:150 60:30
                )
                list( hiCreateStringField(
                        ?name 'destCell
                        ?editable t
                      ) 75:180 235:30 70
                )
                list( hiCreateLabel(
                        ?name 'destCellLabel
                        ?labelText "Cell"
                        ?justification 'right
                      ) 10:180 60:30
                )
                list( hiCreateStringField(
                        ?name 'destView
                        ?editable t
                      ) 75:210 235:30 70
                )
                list( hiCreateLabel(
                        ?name 'destViewLabel
                        ?labelText "View"
                        ?justification 'right
                      ) 10:210 60:30
                )
                list( hiCreateFrameField(
                        ?name 'options
                      ) 10:260 310:90 
                )
                list( hiCreateLabel(
                        ?name 'optionsBoxLabel
                        ?labelText "Options"
                      ) 20:250 50:25
                )
                list( hiCreateBooleanButton(
                        ?name 'forceOverwrite
                        ?value t
                        ?buttonText " "
                      ) 10:270 10:30 5
                )
                list( hiCreateLabel(
                        ?name 'overwriteLabel
                        ?labelText "Overwrite existing destination cell"
                      ) 38:270 200:30
                )
                list( hiCreateBooleanButton(
                        ?name 'showInstNames
                        ?value t
                        ?buttonText " "
                      ) 10:295 10:30 5
                )
                list( hiCreateLabel(
                        ?name 'instNamesLabel
                        ?labelText "Include instance names"
                      ) 38:295 200:30
                )
                list( hiCreateBooleanButton(
                        ?name 'showParameters
                        ?value t
                        ?buttonText " "
                      ) 10:320 10:30 5
                )
                list( hiCreateLabel(
                        ?name 'parametersLabel
                        ?labelText "Include instance parameters"
                      ) 38:320 200:30
                )
                ; separator to enforce form width
                list( hiCreateSeparatorField(
                        ?name 'sep1
                      ) 0:355 325:0
                )
            )
)

; vim:ts=4:
