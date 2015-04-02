;==========================================================================
;
; $Id: selobj.il,v 1.1.1.1 2006/02/10 16:33:45 slipa Exp $
;
; For extracted layouts & schematics, highlight a net by name.
;
; Revision History
;
; $Log: selobj.il,v $
; Revision 1.1.1.1  2006/02/10 16:33:45  slipa
; starting CDK v1.5.0rc1 source file
;
; Revision 1.4  1999/01/26 17:09:38  jtschaff
; cancel any ongoing enter functions before starting
;
; Revision 1.3  1998/08/29 01:46:39  jtschaff
; made toggle button prompts wider
;
; Revision 1.2  1998/08/28 18:50:57  jtschaff
; fixed zoomin typo bug
;
; Revision 1.1  1997/12/18 19:27:17  astanas
; Initial revision
;
;
; 950914 JTS File created
; 960314 JTS Changed to use menu & form, can select multiple net names
; 960430 JTS Added ";" to parseString() delimiters.
; 960607 AS  Removed menu portion to ncsuMenu.il, which then loads this
;            file.
; 960806 JTS Made currentCellID local and call hiGetCurrentWindow()
;            here instead of in ncsuMenu.il, changed prompt text
;
;--------------------------------------------------------------------------

/*
 *  Globals:
 *      NCSU_zoomList
 */

procedure( sortLabelsCmpFunc( l1 l2 )
    let( (searchList len1 len2)
        searchList = reverse(parseString(hiliteObjForm->objName->value " ,;"))
        len1 = length( member( l1~>theLabel searchList ) )
        len2 = length( member( l2~>theLabel searchList ) )

        len1 < len2
    )
)

procedure( hiliteObjects( form )
prog( (searchList flag currentCellID foundNet foundInst)

        currentCellID = hiGetCurrentWindow()->editCellView
        if( currentCellID == nil  return( nil ) )

        unless( form->sticky->value == t
            geDeselectAllFig( currentCellID )
        )

        /* if user was in "delete mode", hitting apply in this form
         * sometimes deleted labels. so, cancel any pending enter
         * functions here */
        cancelEnterFun();

        ; use reverse() here so we can go down list and add to it
        ; using cons() and have the resulting list be in the order the
        ; user typed it in
        searchList = reverse( parseString( form->objName->value " ,;") )
        flag = nil

        if( form->zoom->value == t then
            NCSU_zoomList = list()
        )

        cond(
            (
            form->selobjRadioField->value == "Net"

            foreach( netName searchList
                foundNet = dbFindNetByName( currentCellID netName )
                if( foundNet != nil then
                    foreach( fig foundNet~>figs 
                        geSelectFig( fig )
                        if( form->zoom->value == t then
                            NCSU_zoomList = cons( fig NCSU_zoomList )
                        )
                    )
                    flag = t
                ) 
            ))

            (
            form->selobjRadioField->value == "Instance"

            foreach( instName searchList
                foundInst = dbFindAnyInstByName( currentCellID instName )
                if( foundInst != nil then
                    geSelectFig( foundInst )
                    if( form->zoom->value == t then
                        NCSU_zoomList = cons( foundInst NCSU_zoomList )
                    )
                    flag = t
                ) 
            ))

            (
            form->selobjRadioField->value == "Label"

            foreach( obj currentCellID~>shapes
                if( (obj~>objType == "label") &&
                    (member( obj~>theLabel searchList ) != nil) then
                    geSelectFig( obj )
                    if( form->zoom->value == t then
                        NCSU_zoomList = cons( obj NCSU_zoomList )
                    )
                    flag = t
                ) 
            )
            
            ; sort so we zoom in in the right order
            if( flag == t && form->zoom->value == t then
                NCSU_zoomList = sort( NCSU_zoomList 'sortLabelsCmpFunc )
            ))
        )

        if( flag == nil then
            hiGetAttention()
            printf( "%s(s) specified do not exist\n"
                    hiliteObjForm->selobjRadioField->value )
            if( form->nextZoom
                hiDeleteField( form 'nextZoom )
            )
            return( nil )
        )

        if( form->zoom->value == t then
            hiZoomIn( hiGetCurrentWindow() car( NCSU_zoomList )~>bBox )
            NCSU_zoomList = cdr( NCSU_zoomList )
        
            unless( form->nextZoom
                hiAddField( form
                            list( hiCreateButton(
                                ?name 'nextZoom
                                ?buttonText "Zoom to next"
                                ?callback "{
                                    if( length(NCSU_zoomList) > 0 then
                                        hiZoomIn( hiGetCurrentWindow() 
                                                  car( NCSU_zoomList )~>bBox )
                                        NCSU_zoomList = cdr( NCSU_zoomList )
                                    )
                                    }"
                            ) 175:110 100:40 115 )
                )
            )
        else
            if( form->nextZoom
                hiDeleteField( form 'nextZoom )
            )
        )

        return( t )
    )
)

hiCreateAppForm(
                ?name 'hiliteObjForm
                ?formTitle "Hilite Objects"
                ?buttonLayout 'ApplyCancelDef
                ?callback list(
                        "hiliteObjects( hiliteObjForm )"    ; apply
                        "{
                        if( hiliteObjForm->nextZoom != nil
                            hiDeleteField( hiliteObjForm 'nextZoom )
                        )
                        NCSU_zoomList = list()
                        }" ; cancel
                        )
                ?fields list(
                            list( hiCreateStringField( 
                                ?name 'objName
                                ?prompt "Object name(s): " )
                                5:10 500:20 100 )
                            list( hiCreateRadioField(
                                ?name 'selobjRadioField
                                ?prompt "Object Type:"
                                ?choices list( "Net" "Instance" "Label")
                                ?defValue "Net"
                                ?itemsPerRow 3 )
                                5:30 150:65 100 )
                            list( hiCreateBooleanButton(
                                ?name 'sticky
                                ?buttonText "Keep current hilite"
                                ?defValue nil )
                                5:75 170:45 135 )
                            list( hiCreateBooleanButton(
                                ?name 'zoom
                                ?buttonText "Zoom to found objects"
                                ?defValue nil )
                                5:110 170:40 135 )
                        )
                ?help ""
                )
