;==========================================================================
;
; $Id: createLabel.il,v 1.1.1.1 2006/02/10 16:33:45 slipa Exp $
; 
; Revision History
;
; $Log: createLabel.il,v $
; Revision 1.1.1.1  2006/02/10 16:33:45  slipa
; starting CDK v1.5.0rc1 source file
;
; Revision 1.6  1999/10/13 19:47:40  jtschaff
; use NCSU_createDrawingLayerCyclic()
;
; Revision 1.5  1999/07/05 20:40:13  jtschaff
; changed "getEditRep()" to "geGetEditCellView()" based
; on skill lint report from John Gianni (john@cadence.com)
;
; Revision 1.4  1998/09/02 04:33:41  jtschaff
; added overbar
;
; Revision 1.3  1998/03/06 00:32:37  jtschaff
; added help field
;
; Revision 1.2  1998/01/16 22:12:19  jtschaff
; added layer field to select label layer
; deglobalfied somethings, added NCSU_defLabelLayer to global list
;
; Revision 1.1  1997/12/18 19:10:08  astanas
; Initial revision
;
;
;--------------------------------------------------------------------------

procedure( expandBounds( lb rb s )
let( (ret leftBound rightBound step)

    ret = list()
    leftBound  = evalstring( lb )
    rightBound = evalstring( rb )
    step = evalstring( s )

    cond(
        (   (leftBound > rightBound)        ; eg <7:0>
            while( (leftBound >= rightBound)
                ret = cons( leftBound ret )
                leftBound = leftBound - step
            )
        )
        (   (leftBound < rightBound)        ; eg <0:7>
            while( (leftBound <= rightBound)
                ret = cons( leftBound ret )
                leftBound = leftBound + step
            )
        )
        (   (leftBound == rightBound)
            ret = list( leftBound )
        )
    )

    reverse( ret )
))


procedure( isVector( token )
let( (isVec step)
    /*
     * find tokens that match xxx<#:#:#> or xxx[#:#:#]
     */
    isVec = rexMatchp(
        "\\([a-zA-Z0-9_]+\\)[[<]\\([0-9]+\\):\\([0-9]+\\):\\([0-9]+\\)[]>]" 
        token )
    if( isVec then
        step = rexSubstitute( "\\4" )
    else
        /*
         * find tokens that match xxx<#:#> or xxx[#:#]
         */
        isVec = rexMatchp(
                    "\\([a-zA-Z0-9_]+\\)[[<]\\([0-9]+\\):\\([0-9]+\\)[]>]" 
                    token )
        if( isVec step = "1")
    )

    if( isVec then
        list( rexSubstitute( "\\1" )    ; vector name
              rexSubstitute( "\\2" )    ; left bound
              rexSubstitute( "\\3" )    ; right bound
              step )                    ; step amount
    else
        nil
    )
))


procedure( getFirstToken()
    car( parseString( NCSU_createLabelForm->labelString->value, ",; " ) )
)


procedure( createVirtuosoLabels()
prog( (needPoint point firstToken vector saveFirstToken vecName labelArray
       idxList idx idxIsInBounds labelText removeTokenFromForm spacing
       form)

    /*
     * make sure editing is enabled...
     */
    if( geGetEditCellView()~>mode == "r" then
        hiDisplayAppDBox( 
            ?name 'readOnlyErr
            ?dboxBanner "Create Label Error"
            ?dboxText "Layout must be opened with write permission"
            ?dialogType hicErrorDialog
            ?buttonLayout 'Close
        )
        return( nil )
    )
    
    form = NCSU_createLabelForm     ; this is just to make less typing...

    hiDisplayForm( form )

    needPoint = t

LOOP_BEGIN
    while( t
        /*
         * return if the form is unmapped and the label field blank,
         * because they've hit the OK button and finished placing
         * everything
         */
        if( hiIsFormDisplayed( form ) == nil &&
            form->labelString->value == "" then
            hiFormDone( form )
            return( t )
        )

        if( needPoint then
            point = enterPoint( ?prompts list( "Select label origin" ) 
                                ?noInfix t )
        )
        if( point == nil then
            hiFormDone( form )
            return( t )
        )

        labelArray = form->array->value

        firstToken = getFirstToken()
        if( firstToken == nil then
            hiGetAttention()
            warn( "No label text!" )
            go( LOOP_BEGIN ) ; continue
        )

        vector = isVector( firstToken )
        if( vector != nil then
            /*
             * it's a vector
             */

            /*
             * save first token for comparisons later
             */
            saveFirstToken = firstToken

            /*
             * get vector name & list of indices needed
             */
            vecName = nth( 0 vector )
            idxList = expandBounds( nth( 1 vector )
                                    nth( 2 vector )
                                    nth( 3 vector ) )

            idx = 0
            idxIsInBounds = t
            /*
             * only continue as long as current first token hasn't
             * changed and we still have more to go
             */
            while( idxIsInBounds && saveFirstToken == getFirstToken() 
                sprintf( labelText "%s%d" vecName nth( idx idxList ) )
                if( createLabel( point labelText ) == nil then
                    hiGetAttention()
                    warn( "Couldn't create label \"%s\"!" labelText )
                )

                /*
                 * check to see if we have any more; if not, stop loop
                 */
                if( ++idx < length( idxList ) then
                    if( labelArray == nil    
                        point = enterPoint( ?prompts list("Select label origin")
                                            ?noInfix t )
                        if( point == nil then
                            hiFormDone( form )
                            return( t )
                        )
                    )
                else     
                    idxIsInBounds = nil
                )

                /*
                 * we need to do this even if we are done with current
                 * vector, because there might be more labels after
                 * this one
                 */
                if( labelArray then
                    spacing = form->spacing->value
                    point = list( xCoord( point ) + xCoord( spacing )
                                  yCoord( point ) + yCoord( spacing ) )
                )
            )

            /*
             * check to see if the first token has been changed in the
             * time we were placing the components of the vector - if
             * it has, we keep the point chosen above and don't change
             * the label field in the form, if it hasn't, things
             * progress as normal (ie, we remove first token from the
             * form and get a new point at top of the loop)
             */
            if( saveFirstToken == getFirstToken() then 
                removeTokenFromForm = t
                if( labelArray then
                    needPoint = nil
                else
                    needPoint = t
                )
            else
                removeTokenFromForm = nil
                needPoint = nil
            )
        else
            /*
             * it's a scalar
             */

            if( createLabel( point firstToken ) == nil then
                hiGetAttention()
                warn( "Couldn't create label \"%s\"!" firstToken )
            )

            removeTokenFromForm = t

            if( labelArray then
                needPoint = nil
                spacing = form->spacing->value
                point = list( xCoord( point ) + xCoord( spacing )
                              yCoord( point ) + yCoord( spacing ) )
            else 
                needPoint = t
            )
        )

        if( removeTokenFromForm then
            form->labelString->value = 
                    buildString( cdr( parseString(
                    form->labelString->value, ",; " ) ) ) )

        /*
         * if doing labelArray and we have just placed last one, we need
         * to get a point
         */
        if( labelArray && getFirstToken() == nil then
            needPoint = t
        )

    ) ; end while
)     ; end prog
)     ; end procedure
    

procedure( createLabel( point labelText )
let( (form lab labelTransforms layer)

    /*
     * list of legal label transformation strings
     */
    labelTransforms = makeTable( "NCSU_labelTransforms" nil )
    labelTransforms["None"] = "R0"
    labelTransforms["Rotate 90"] = "R90"
    labelTransforms["Rotate 180"] = "R180"
    labelTransforms["Rotate 270"] = "R270"
    labelTransforms["Reflect X axis"] = "MX"
    labelTransforms["Reflect X axis/Rotate 90"] = "MXR90"
    labelTransforms["Reflect Y axis"] = "MY"
    labelTransforms["Reflect Y axis/Rotate 90"] = "MYR90"

    form = NCSU_createLabelForm
    layer = car( parseString( nth( 3
                                   NCSU_createLabelForm->hiLayerField->value ) ) )

    lab = dbCreateLabel( hiGetCurrentWindow()->cellView
                         layer
                         point
                         labelText
                         form->justification->value
                         labelTransforms[form->transformation->value]
                         form->fontName->value
                         form->height->value )
    if( lab != nil then
        lab~>isDrafted = nil
        lab~>isOverbar = form->overbar->value
    )

    lab
))


hiCreateAppForm(
    ?name 'NCSU_createLabelForm
    ?help "ncsuHelp"
    ?formTitle "Create Labels"
    ?buttonLayout 'OKCancelDef
    ?unmapAfterCB nil
    ?dontBlock t
    ?callback list( "hiFormUnmap( NCSU_createLabelForm )"       ; OK
                    "cancelEnterFun( NCSU_createLabelForm )" )  ; Cancel
    ; x:y  width:height  promptTextBoxWidth
    ?fields list(
        list( hiCreateStringField( 
              ?name 'labelString
              ?prompt "Label(s):   " 
              ) 10:5 400:40 60 )
        list( hiCreateFloatField( 
              ?name 'height
              ?prompt "Height: " 
              ?acceptNil nil
              ?value 1.0
              ?defValue 1.0
              ) 450:5 100:40 50 )
        list( hiCreateCyclicField(
                ?name 'fontName
                ?prompt "Font:   "
                ?choices list( "euroStyle" "gothic" "math" "roman"
                               "script" "stick" "swedish" )
                ?value "stick"
                ?defValue "stick"
              ) 10:60 115:40 35 )
        list( hiCreateCyclicField(
                ?name 'justification
                ?prompt "Justification:   "
                ?choices list( "lowerLeft" "centerLeft" "upperLeft"
                               "lowerCenter" "centerCenter" "upperCenter"
                               "lowerRight" "centerRight" "upperRight" )
                ?value "centerCenter"
                ?defValue "centerCenter"
              ) 145:60 125:40 80 )
        list( hiCreateCyclicField(
                ?name 'transformation
                ?prompt "Transformation:   "
                ?choices list( "None" "Rotate 90" "Rotate 180" "Rotate 270"
                               "Reflect X axis" "Reflect X axis/Rotate 90"
                               "Reflect Y axis" "Reflect Y axis/Rotate 90" )
                ?value "None"
                ?defValue "None"
              ) 335:60 175:40 100 )
        list( hiCreateBooleanButton(
                ?name 'array
                ?buttonText "Create label array  "
                ?value nil
                ?defValue nil
                ?callback "NCSU_createLabelForm->spacing->editable =
                           NCSU_createLabelForm->array->value"
              ) 10:110 125:40 110 )
        list( hiCreatePointField( 
                ?name 'spacing
                ?prompt "Spacing (X:Y)  " 
                ?value 5:0
                ?defValue 5:0
                ?editable nil
              ) 150:110 140:40 85 )
        list( hiCreateBooleanButton(
                ?name 'overbar
                ?buttonText "Overbar  "
                ?value t
                ?defValue t
              ) 310:110 100:40 55 )
    )
) ; hiCreateAppForm


/*
 * called by menu entry "Create->Label..."
 */
procedure( doCreateLabels()
    NCSU_createDrawingLayerCyclic( NCSU_createLabelForm 
                                   list( "text" "drawing" ) 
                                   410 110 100 40 50 )
    createVirtuosoLabels()
)
