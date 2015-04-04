;==========================================================================
;
; $Id: setMosfetPropForm.il,v 1.1.1.1 2006/02/10 16:33:45 slipa Exp $
; 
; Revision History
;
; $Log: setMosfetPropForm.il,v $
; Revision 1.1.1.1  2006/02/10 16:33:45  slipa
; starting CDK v1.5.0rc1 source file
;
; Revision 1.1  1997/12/18 16:24:30  astanas
; Initial revision
;
;
;--------------------------------------------------------------------------


;==== SetMosfetPropForm ===================================================
;
; This procedure creates and displays a form to enter missing MOSFET 
; parameters stored as library properties. 
;
; Usage: SetMosfetPropForm( t_MissingProperty )
;--------------------------------------------------------------------------

procedure( SetMosfetPropForm( MissingProp )
let( (Title1 Title2 Choices MinLength GridResolution MinWidth Model Form Properties)

;--------------------------------------------------------------------------
; Create all the fields for the form.
;--------------------------------------------------------------------------

Title1 = hiCreateLabel(
	?name 		'Title1
	?labelText 	strcat("Oops! The library property \"" MissingProp "\" was not found.")
	?justification 'center 
)
 
Title2 = hiCreateLabel(
	?name 		'Title2
	?labelText 	"Please do one of the following:"
	?justification 'center 
) 

Choices = hiCreateRadioField( 
	?name 		'Choice
	?choices 	list(	"Compile a new technology file"
						"Attach to a technology library"
						"Use the following" )
	?prompt  	" "
	?value		"Use the following"
	?defValue  	"Use the following"
	?itemsPerRow 1 
	?callback 	list( "ncsuUpdateChoicesCB()" )
) 

Model = hiCreateStringField( 
	?name 		'Model 
	?prompt 	"Model Name Prefix" 
	?value 		"" 
	?defValue	""
;	?callback 	t_callback
	?format 	"%s" 
	?editable 	t
) 

GridResolution = hiCreateFloatField( 
	?name 		'GridResolution
;	?value 		0.0
	?defValue	0.0
	?acceptNil 	t
	?prompt 	"Grid Resolution (um)"
	?callback   "ncsuCheckGridCB()"
	?range 		list(0 "infinity")
	?format 	"%.2f" 
	?editable 	t 
) 

MinLength = hiCreateFloatField( 
	?name 		'MinLength
;	?value 		0.0 
	?defValue	0.0
	?acceptNil 	t
	?prompt 	"Minimum Length (um)"
	?callback   "ncsuCheckLengthCB()"
	?range 		list(0 "infinity")
	?format 	"%.2f"
	?editable 	t 
) 

MinWidth = hiCreateFloatField( 
	?name 		'MinWidth
;	?value 		0.0
	?defValue	0.0
	?acceptNil 	t
	?prompt 	"Minimum Width (um)"
	?callback   "ncsuCheckWidthCB()"
	?range 		list(0 "infinity")
	?format 	"%.2f" 
	?editable 	t 
) 


;--------------------------------------------------------------------------
; Create the form.
;--------------------------------------------------------------------------

Form = hiCreateAppForm( 
	?name 		'ncsuSetMosfetPropForm 
	?fields list(				  ; x:y		  w:h	prompt_w
				list(Title1 		0:10  	400:18)
				list(Title2		 	0:28  	400:18)
				list(Choices 		0:60  	400:70 	120)
				list(Model			0:130 	250:20 	150)
				list(GridResolution 0:160 	210:20 	150)
				list(MinLength		0:190 	210:20 	150)
				list(MinWidth		0:220 	210:20 	150)
			)
 	?formTitle 	"Set Mosfet Properties" 
	?callback 	list("ncsuMosfetPropOkCB()" "ncsuMosfetPropCancelCB()")
 	?unmapAfterCB t 
 	?buttonLayout 'OKCancel
 	?help		"ncsuHelp"
) 


;--------------------------------------------------------------------------
; Collect any parameters which may already be set then display the form.
;--------------------------------------------------------------------------

Properties = LookupLibProp( "model" "gridResolution" "minLength" "minWidth" nil )

;---- The string field Model cannot accept nil ---
if( car(Properties) != nil then Form->Model->value = car(Properties) )

Form->GridResolution->value = cadr( Properties )
Form->MinLength->value 		= caddr( Properties )
Form->MinWidth->value 		= cadddr( Properties )


hiDisplayForm( Form )


));---- End procedure SetMosfetPropForm ----



;==========================================================================
; Callbacks for checking the field entries.
;==========================================================================


;==== ncsuUpdateChoicesCB =================================================
;
; This procedure makes the entry fields editable when the choice 
; is "Use the following"
;--------------------------------------------------------------------------

procedure( ncsuUpdateChoicesCB()

case(ncsuSetMosfetPropForm->Choice->value

	("Use the following"
		 ncsuSetMosfetPropForm->Model->editable = t
		 ncsuSetMosfetPropForm->GridResolution->editable = t
		 ncsuSetMosfetPropForm->MinLength->editable = t
		 ncsuSetMosfetPropForm->MinWidth->editable = t
	)
	( t
		 ncsuSetMosfetPropForm->Model->editable = nil
		 ncsuSetMosfetPropForm->GridResolution->editable = nil
		 ncsuSetMosfetPropForm->MinLength->editable = nil
		 ncsuSetMosfetPropForm->MinWidth->editable = nil
	)
));---- End Procedure ncsuUpdateChoicesCB ----



;==== ncsuCheckGridCB =====================================================
; 
; Whenever the grid resolution changes both min length and min width must
; be checked.
;--------------------------------------------------------------------------

procedure( ncsuCheckGridCB()
let( (GridResolution)

GridResolution = ncsuSetMosfetPropForm->GridResolution->value

if( GridResolution != nil then

	if( GridResolution > 0 then

		;---- Turn off any error highlight and check length & width ----
		
		hiHighlightField(ncsuSetMosfetPropForm 'GridResolution 'background)
		ncsuCheckLengthCB()
		ncsuCheckWidthCB()
		
	else
		hiGetAttention()
		warn("Grid Resolution must be greater than zero")
		hiHighlightField(ncsuSetMosfetPropForm 'GridResolution 'error)
		ncsuSetMosfetPropForm->GridResolution->value = nil
	)

);---- End if GridResolution ----

));---- End Procedure ncsuCheckGridCB ----



;==== ncsuCheckLengthCB ===================================================
; 
; When minLength changes (1) make sure it is on the grid, and 
; (2) make sure the min width is >= length.
;--------------------------------------------------------------------------

procedure( ncsuCheckLengthCB()
prog( (GridResolution MinLength GridLength MinWidth)

GridResolution 	= ncsuSetMosfetPropForm->GridResolution->value
MinLength 		= ncsuSetMosfetPropForm->MinLength->value
MinWidth		= ncsuSetMosfetPropForm->MinWidth->value

if( MinLength != nil then
	if(MinLength > 0 then

		;------------------------------------------------------------------
		; Turn off any error highlighting then check if length is on grid.
		;------------------------------------------------------------------
		
		hiHighlightField(ncsuSetMosfetPropForm 'MinLength 'background)
	
		when( GridResolution != nil
			GridLength = round( MinLength/GridResolution ) 
			when( abs(MinLength/GridResolution - GridLength) > 0.0001

        		hiGetAttention()
				printf( "*WARNING* Transistor length %.2f not on the grid. "
						 MinLength )
        		printf( "Resetting to closest value...\n" )

				ncsuSetMosfetPropForm->MinLength->value = GridLength * GridResolution
				return()
		))	

			
		;------------------------------------------------------------------
		; Make sure the min width is >= length.
		;------------------------------------------------------------------

		when( MinWidth != nil
			if( MinWidth < MinLength then
			    hiGetAttention()
				printf( "*WARNING* Transistor width %.2f smaller than length %.2f. "
						 MinWidth MinLength)
            	printf( "Resetting width to equal length...\n" )

				ncsuSetMosfetPropForm->MinWidth->value = MinLength
		))

	else ;-- MinLength =< 0 --
	
		hiGetAttention()
		warn("Minimum length must be greater than zero")		
		hiHighlightField(ncsuSetMosfetPropForm 'MinLength 'error)
		ncsuSetMosfetPropForm->MinLength->value = nil
	)
	
);---- End if MinLength ----
	
));---- End Procedure ncsuCheckLengthCB ----



;==== ncsuCheckWidthCB ====================================================
; 
; When the min width changes (1) first make sure min width is >= length, 
; then (2) check if it is on the grid.
;--------------------------------------------------------------------------

procedure( ncsuCheckWidthCB()
prog( (GridResolution MinWidth GridWidth MinLength)

GridResolution 	= ncsuSetMosfetPropForm->GridResolution->value
MinWidth		= ncsuSetMosfetPropForm->MinWidth->value
MinLength 		= ncsuSetMosfetPropForm->MinLength->value

if( MinWidth != nil then
	if( MinWidth > 0 then
	
		;------------------------------------------------------------------
		; Turn off any error highlighting then make sure the min width 
		; is >= length.
		;------------------------------------------------------------------

		hiHighlightField(ncsuSetMosfetPropForm 'MinWidth 'background)
		
		when( MinLength != nil
			if( MinWidth < MinLength then
			    hiGetAttention()
				printf( "*WARNING* Transistor width %.2f smaller than length %.2f. "
						 MinWidth MinLength)
            	printf( "Resetting width to equal length...\n" )

				ncsuSetMosfetPropForm->MinWidth->value = MinLength
				return()
		))
		
		;------------------------------------------------------------------
		; Check if min width is on the grid.
		;------------------------------------------------------------------
		
		when( GridResolution != nil	
			GridWidth = round( MinWidth/GridResolution ) 
			when( abs(MinWidth/GridResolution - GridWidth) > 0.0001

            	hiGetAttention()
				printf( "*WARNING* Transistor width %.2f not on the grid. "
						 MinWidth )
            	printf( "Resetting to closest value...\n" )

				ncsuSetMosfetPropForm->MinWidth->value = GridWidth * GridResolution
		))
		
	else ;-- Min width =< 0 --
	
		hiGetAttention()
		warn("Minimun width must be greater than zero")
		hiHighlightField(ncsuSetMosfetPropForm 'MinWidth 'error)
		ncsuSetMosfetPropForm->MinWidth->value = nil
	)
	
);---- End if MinWidth ----

));---- End Procedure ncsuCheckWidthCB ----




;==========================================================================
; Callbacks for the button actions of the form.
;==========================================================================


;==== ncsuMosfetPropOkCB ==================================================
; 
; The "OK" button. The action taken depends on the choice made. In any case
; the SetMosfetPropForm is only released when the action is actually done. 
;--------------------------------------------------------------------------

procedure( ncsuMosfetPropOkCB()
let( (Result Model GridResolution MinWidth MinLength)

case( ncsuSetMosfetPropForm->Choice->value

	;----------------------------------------------------------------------
	; When compiling or attaching a technology, call the appropriate form 
	; for that action. Look at the return status of these forms to see if 
	; the action was performed. The status determines the effect of 
	; hiSetCallbackStatus. A nil status keeps the SetMosfetPropForm
	; up for further input.	
	;----------------------------------------------------------------------

	("Compile a new technology file"
	
		Result = tcDisplayNewTechForm() 
		hiSetCallbackStatus(ncsuSetMosfetPropForm Result)
	)
	
	("Attach to a technology library" 
	
		Result = NCSU_attachTechForm()	
		hiSetCallbackStatus(ncsuSetMosfetPropForm Result)
	)

	
	;----------------------------------------------------------------------
	; Check to see that values were actually entered for the numeric data.
	; Do not release the form without valid data.
	;----------------------------------------------------------------------

	("Use the following"
	
		Model		 	= ncsuSetMosfetPropForm->Model->value
		GridResolution 	= ncsuSetMosfetPropForm->GridResolution->value
		MinWidth		= ncsuSetMosfetPropForm->MinWidth->value
		MinLength  		= ncsuSetMosfetPropForm->MinLength->value
		Result 			= t
		
		if( GridResolution == nil || !( GridResolution > 0 ) then 
			Result = nil
			warn("Grid Resolution must be set")
			hiHighlightField(ncsuSetMosfetPropForm 'GridResolution 'error) 
		)
		
		if( MinLength == nil || !(MinLength > 0) then 
			Result = nil
			warn("Minimum Length must be set") 
			hiHighlightField(ncsuSetMosfetPropForm 'MinLength 'error) 
		)
		
		if( MinWidth == nil || !(MinWidth > 0) then 
			Result = nil
			warn("Minimum Width must be set") 
			hiHighlightField(ncsuSetMosfetPropForm 'MinWidth 'error) 
		)


		if(	Result == nil then
			hiGetAttention()
			hiSetCallbackStatus(ncsuSetMosfetPropForm nil)
		else
			SetLibProp( "model" 		 "string" 	Model )
			SetLibProp( "gridResolution" "float" 	GridResolution )
			SetLibProp( "minLength" 	 "float" 	MinLength )
			SetLibProp( "minWidth" 		 "float" 	MinWidth )
			hiSetCallbackStatus(ncsuSetMosfetPropForm t)
		)	
	)
	
	( t 
	error("ncsuMosfetPropOkCB: Invalid choice")
	)
)

));---- End procedure ncsuMosfetPropOkCB ----



;==== ncsuMosfetPropCancelCB ==============================================
; 
; The "Cancel" button.
;--------------------------------------------------------------------------

procedure( ncsuMosfetPropCancelCB()

hiGetAttention()
warn("Continuing without MOSFET model parameters.")

);---- End procedure ncsuMosfetPropCancelCB ----
