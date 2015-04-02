;==========================================================================
;
; $Id: fet_cdf.il,v 1.1.1.1 2006/02/10 16:33:45 slipa Exp $
;
; Callbacks for the following CDFs:
; 
; NCSU_Digital_Parts  	library cdf, pfet, nfet
; NCSU_Analog_Parts 	pmos, pmos4, pmos_elec, pmos4_elec
;						nmos, nmos4, nmos_elec, nmos4_elec 
;
; Revision History
;
; $Log: fet_cdf.il,v $
; Revision 1.1.1.1  2006/02/10 16:33:45  slipa
; starting CDK v1.5.0rc1 source file
;
; Revision 1.10  2000/11/27 20:57:23  semick
; added check for lxUseCell property in procedure CheckDLECellName()
; also added assignment of TechLib and Cell to cdfgData->lxUseCell->value
; in procedure SetDLECellName()
; These edits should allow the Virtuoso XL layout generation from schematic
; to continue to work in version 4.4.5 of the tools while maintaining
; functionality with 4.4.2
;
; Revision 1.9  1999/02/02 00:37:33  jtschaff
; whoops - fixed bug so gates don't try to set minL for hvfets
;
; Revision 1.8  1999/01/29 22:43:45  jtschaff
; added stuff to set minL for hvfets to be 1.5*minL for normal fets
;
; Revision 1.7  1998/03/18 21:35:33  jtschaff
; minor cleanup
;
; Revision 1.6  1998/02/02 20:24:51  astanas
; 	Changed CheckMicronSizeCB and setFetArea to accept variable names
; 	in place of fixed numeric values for the properties they check.
;
; Revision 1.5  1998/01/29 19:50:42  astanas
; 	Changed SetFetDefaultsCB for digital gates to look for any
; 	of the needed lib properties when attached to cdsDefTechLib.
; 	Having any of the lib props set indicates spice simulations
; 	may be possible.
;
; 	Changed SetDLECellName to use the library name containing the
; 	cell when attached to cdsDefTechLib.
;
; Revision 1.4  1998/01/22 23:52:41  astanas
; 	Fixed a typo.
;
; Revision 1.3  1998/01/15 16:28:32  astanas
; 	Changed init procedure and SetDleCellNameCB to use the
; 	new global database.
;
; 	Changed SetDleCellName to look for the library property
; 	techFileName as the technology library.
;
; Revision 1.2  1998/01/09 22:36:25  astanas
; 	Fully incorporated gate parameter passing to the Digital Parts fets
; 	through the library CDF in NCSU_Digital_Parts and the n/p fet cell CDFs.
;
; 	Generalized the initialization procedure to handle both individual
; 	transistors and gate instances.
;
; 	Rewrote the "Check Grid/Micron Length/Width CB" to a more flexible
; 	form as "Check Grid/Micron Size CB" which takes a parameter
; 	to indicate which field to check.
;
; Revision 1.1  1997/12/18 16:20:23  astanas
; 	Initial revision
;
;
;--------------------------------------------------------------------------


;==== PropDisplayOffCB ====================================================
; 
; This procedure turns off the display of the gate properties.
;--------------------------------------------------------------------------

procedure( PropDisplayOffCB( props )
	props->DisplayGateProps->value = nil
)



;==== SetFetDefaultsCB ====================================================
; 
; This procedure sets the default mosfet transistor parameters. It is
; called by the formInitProc of the CDF, and activated whenever a new
; component is selected or the device properties are edited. 
;
; The procedure should only be run when a new component is placed. It is
; designed to inititalize the property list with the system default values.
; It has the following actions. The Model Type is set to its default 
; value, "system", and CheckFetModelCB is called to set the model name. 
; Then SetDLECellName puts the appropriate layout cell name for the 
; dleCellName property. Finally, The device lengths and widths are set to
; their minimum values.
;--------------------------------------------------------------------------

procedure( SetFetDefaultsCB( props )
let(  (MinLength MinWidth GridResolution) 

;--------------------------------------------------------------------------
; The "when" checks to see if the component has already been initialized.
; Without this line the formInitProc would be called every time the 
; transistor's properties were edited, which would reset everything.
;
; The "if" part checks for a gate instance WITHOUT technology data, such 
; as one that would be used for Verilog simulations only. A library without
; technology data is attached to the cdsDefTechLib, and has none of the
; needed parameters set as library properties. In this case there is no way
; to initialize the properties since the data is not available. Setting 
; DisplayGateProps to nil turns off the display of the properties.
;--------------------------------------------------------------------------

when( props->MinL->value == props->MinL->defValue    ;---- Unset ----

	if( props->DisplayGateProps->defValue == t && 
		GetEditTechLib()->name == "cdsDefTechLib" &&
		!exists( Prop 
			LookupLibProp( "model" "minLength" "minWidth" "gridResolution" nil )
			( Prop != nil ) 
		)
	then 
			props->DisplayGateProps->value = nil
	else
		
	;----------------------------------------------------------------------
	; Lookup the library properties used in the cdf. These will 
	; determine the minimum values of the device length and width.
	;----------------------------------------------------------------------
	
	MinLength = LookupLibProp( "minLength" )			;-- microns --
	
	if( MinLength == nil then 
		SetMosfetPropForm( "minLength" )
		MinLength = LookupLibProp( "minLength" nil )
	)

	
	MinWidth = LookupLibProp( "minWidth" )				;-- microns --
	
	if( MinWidth == nil then
		SetMosfetPropForm( "minWidth" )
		MinWidth = LookupLibProp( "minWidth" nil )
	)

	
	GridResolution = LookupLibProp( "gridResolution" )	;-- microns --
	
	if( GridResolution == nil then 
		SetMosfetPropForm( "gridResolution" )
		GridResolution = LookupLibProp( "gridResolution" )
	)
	
	
	if( MinLength == nil || MinWidth == nil || GridResolution == nil 
	then
			printf("SetFetDefaultsCB: Could not obtain one or more of the required parameters.\n")

	else	
		;------------------------------------------------------------------
		; Set the model and DLE layout cell to the system default.
		;------------------------------------------------------------------

		props->ModelType->value = props->ModelType->defValue
		CheckFetModelCB()  

		SetDLECellName()

		;------------------------------------------------------------------
		; Set the device length and width minimums. These are common for 
		; both individual transistors and gates.
        ;
        ; High-voltage FETs have min length = 3 lambda, not 2 (SCMOS
        ; 24.5), ie, 1.5 times the value for a normal FET.. For these
        ; devices, scale MinLength up to fit. This doesn't apply to
        ; gates, just individual transistors.
		;
        ; All of the size info is generated from the library properties.
        ;------------------------------------------------------------------

		unless( (props->DisplayGateProps->defValue == t)
            if( substring( props->model->value -2 ) == "hv" then
                MinLength = MinLength * 1.5
            )
        )

		props->MinL->value = sprintf( nil "%g" MinLength * 1e-6 )
		props->MinW->value = sprintf( nil "%g" MinWidth * 1e-6 )

	
		if( props->DisplayGateProps->defValue == t then

			;--------------------------------------------------------------
			; Gate instance.
			; Set the length and width to minimums for all gate transistors.
			;--------------------------------------------------------------

			props->lp_grid->value 	= round( MinLength/GridResolution )
			props->ln_grid->value 	= props->lp_grid->value

			props->lp->value 		= props->MinL->value
			props->ln->value 		= props->MinL->value

			props->wp_grid->value 	= round( MinWidth/GridResolution )
			props->wn_grid->value 	= props->wp_grid->value
			
			props->wp->value   		= props->MinW->value
			props->wn->value 		= props->MinW->value
			
			;--------------------------------------------------------------
			; The micron length & width and S/D area and perimeter are set
			; by passing parameters from the lib CDF to the fet cell CDF.
			;--------------------------------------------------------------

		else
			;--------------------------------------------------------------
			; Single transistor instance.
			; Set the length and width to minimums.
			;--------------------------------------------------------------
			props->l_grid->value 	= round( MinLength/GridResolution )
			props->l->value 		= props->MinL->value

			props->w_grid->value 	= round( MinWidth/GridResolution )
			props->w->value    		= props->MinW->value


    		;--------------------------------------------------------------
			; Set length & width in terms of microns for pcells .
			;--------------------------------------------------------------
    		props->l_microns->value = sprintf( nil "%g" MinLength )
    		props->w_microns->value = sprintf( nil "%g" MinWidth )


			;--------------------------------------------------------------
			; Estimate the device source and drain areas and perimeters.
			;--------------------------------------------------------------
    		setFetArea()
		)
	);---- End if MinLength != nil ... ----
	)
);---- End When ----

));---- End Procedure SetFetDefaultsCB ----



;==== CheckFetModelCB =====================================================
; 
; This procedure checks the ModelType parameter and resets the model 
; whenever the "default" value is selected.
;--------------------------------------------------------------------------

procedure( CheckFetModelCB()
prog( (ModelPrefix ModelSuffix pModelSuffix nModelSuffix) 
        
	when( cdfgData->ModelType->value == cdfgData->ModelType->defValue
	  
		;------------------------------------------------------------------
		; Make the model assignment based on the "model" library property
		; and the component's model default value. The standard naming
		; convention used is:
		;
		; ModelPrefix ComponentName 
		; ("model" library property)(component model default value)
		;
		; If the ModelPrefix is blank then only the ComponentName is used.
		;
		; The ComponentName suffix is generated from the default value of
		; the model parameter which is used to index the NCSU_modelSuffix
		; table in the global data. This allows the suffix to be changed
		; from one location.
        ;
        ; The model naming code is also present (not verbatim, but the
        ; idea is the same) in divaExt.rul, so Diva can assign the
        ; correct model name when it extracts from a layout.
        ;------------------------------------------------------------------
		
		ModelPrefix = LookupLibProp( "model" )
		
		;---- If the "model" library property *does not exist* ask about it --
		
		if( ModelPrefix == nil then
			SetMosfetPropForm( "model" )
			ModelPrefix = LookupLibProp( "model" nil )
		)

		if( cdfgData->DisplayGateProps->defValue == t 
		then
			;---- Gate instance -------------------------------------------
			
			pModelSuffix = NCSU_modelSuffix[ cdfgData->pModel->defValue ]
			nModelSuffix = NCSU_modelSuffix[ cdfgData->nModel->defValue ]
			
			if( ModelPrefix == nil || ModelPrefix == "" then				
				cdfgData->pModel->value = pModelSuffix
				cdfgData->nModel->value = nModelSuffix
			else
				cdfgData->pModel->value = strcat( ModelPrefix  pModelSuffix )
				cdfgData->nModel->value = strcat( ModelPrefix  nModelSuffix )
			)		
		
		else
			;---- Transistor instance -------------------------------------
			
			ModelSuffix = NCSU_modelSuffix[ cdfgData->model->defValue ]
			
			if( ModelPrefix == nil || ModelPrefix == "" then
				cdfgData->model->value = ModelSuffix
			else
				cdfgData->model->value = strcat( ModelPrefix  ModelSuffix )
			)
		);---- End if cdfgData ... ----

	);---- End When ----

));---- End Procedure CheckFetModelCB ----



;==== CheckGridSizeCB =====================================================
; 
; This procedure checks the transistor size (grid value) against
; the minimum size whenever it is changed. It then sets the micron size
; to the appropriate value.
;--------------------------------------------------------------------------

procedure( CheckGridSizeCB( Property )
let( (GridResolution PropertyName GridSize MinSizeString MinSize MinGridSize 
		Size MicronSize) 
	
	;---------------------------------------------------------------------
	; Gather the grid resolution which is stored as a library property. If 
	; it is not set call the SetMosfetPropForm to set it.
	;---------------------------------------------------------------------

	GridResolution = LookupLibProp( "gridResolution" )		;-- microns --
	
	if( GridResolution == nil then 
		SetMosfetPropForm( "gridResolution" )
		GridResolution = LookupLibProp( "gridResolution" )
	)

	;---------------------------------------------------------------------
	; Get the appropriate size and minimum size parameter values from the 
	; component's property list. The name and string values will be used 
	; in the prompts later.
	;---------------------------------------------------------------------

	case( Property
	
		( "l" 
		PropertyName  = "Length"          
		GridSize	  = cdfgData->l_grid->value
		MinSizeString = cdfgData->MinL->value
		)
		
		( "w" 	            
		PropertyName  = "Width"          
		GridSize	  = cdfgData->w_grid->value
		MinSizeString = cdfgData->MinW->value
		)
		
		( "lp" 	            
		PropertyName  = "Length P"          
		GridSize	  = cdfgData->lp_grid->value
		MinSizeString = cdfgData->MinL->value
		)
		
		( "wp" 	            
		PropertyName  = "Width P"          
		GridSize	  = cdfgData->wp_grid->value
		MinSizeString = cdfgData->MinW->value
		)
		
		( "ln"	            
		PropertyName  = "Length N"          
		GridSize      = cdfgData->ln_grid->value
		MinSizeString = cdfgData->MinL->value
		)
		
		( "wn" 	            
		PropertyName  = "Width N"          
		GridSize      = cdfgData->wn_grid->value
		MinSizeString = cdfgData->MinW->value
		)
		
		( t
			printf("CheckGridSizeCB: Unknown property \"%s\".\n" Property )
		)
	);---- End Case Property ----

	
	;---------------------------------------------------------------------
	; If there were no errors in obtaining the data then proceed. Otherwise
	; print the error message and drop through.
	;---------------------------------------------------------------------

	if( GridResolution == nil || GridSize == nil || MinSizeString == nil  
	then
		printf("CheckGridSizeCB: Could not obtain one or more of the required parameters.\n")

	else
		;------------------------------------------------------------------
		; Convert all the properties to the same units.
		;------------------------------------------------------------------
		
		GridResolution = GridResolution * 1e-6 			  		;-- meters --
		MinSize		   = cdfParseFloatString( MinSizeString )	;-- meters --
		MinGridSize    = round( MinSize/GridResolution )		;-- int --

		;------------------------------------------------------------------
		; Check the new grid value against the minimum grid size.
		;-------------------------------------------------------------------

		if( GridSize < MinGridSize	  
		then ;---- reset to the minimum ------------------------------------

        	hiGetAttention()
			printf("Warning: Cannot set the transistor width below %d grid units. "
					MinGridSize)
        	printf("Resetting ...\n")

			GridSize 	= MinGridSize
			Size 	 	= MinSizeString
			MicronSize  = sprintf( nil "%g" MinGridSize * GridResolution * 1e6 )
			
		else ;---- Set the correct micron value ---------------------------	

			Size = GridSize * GridResolution
			
			;--------------------------------------------------------------
			; Convert to strings. Note: pcells need the size in microns.
			;--------------------------------------------------------------

			MicronSize = sprintf( nil "%g" Size * 1e6 )
			Size 	   = sprintf( nil "%g" Size ) 
		)

		;------------------------------------------------------------------
		; Write the correct values back to the appropriate property in
		; property list.
		;------------------------------------------------------------------

		case( Property

			( "l" 
			cdfgData->l_grid->value  	= GridSize
			cdfgData->l->value  	 	= Size
    	    cdfgData->l_microns->value  = MicronSize 	
			)

			( "w" 	            
			cdfgData->w_grid->value     = GridSize
			cdfgData->w->value  	    = Size
    	    cdfgData->w_microns->value  = MicronSize 	
			setFetArea()
			)

			( "lp" 	            
			cdfgData->lp_grid->value = GridSize
			cdfgData->lp->value  	 = Size
			)

			( "wp" 	            
			cdfgData->wp_grid->value = GridSize
			cdfgData->wp->value  	 = Size
			)

			( "ln"	            
			cdfgData->ln_grid->value = GridSize
			cdfgData->ln->value  	 = Size
			)

			( "wn" 	            
			cdfgData->wn_grid->value = GridSize
			cdfgData->wn->value  	 = Size
			)

			( t
				printf("CheckGridSizeCB: Unknown property \"%s\".\n" Property )
			)
		);---- End Case Property ----		
		
	);---- End if GridResolution == nil ... ----
));---- End Procedure CheckGridSizeCB ----



;==== CheckMicronSizeCB ===================================================
; 
; This procedure checks the transistor size (micron value) against
; the minimum size whenever it is changed. It also checks to make sure 
; the value is on the grid, then sets the grid size to the appropriate 
; value.
;--------------------------------------------------------------------------

procedure( CheckMicronSizeCB( Property )
let( (GridResolution PropertyName SizeString MinSizeString Size MinSize 
		GridSize MicronSize) 
	
	;---------------------------------------------------------------------
	; Gather the grid resolution stored as a library property. If this
	; is not set call the SetMosfetPropForm to set it.
	;---------------------------------------------------------------------

	GridResolution = LookupLibProp( "gridResolution" )		;-- microns --
	
	if( GridResolution == nil then 
		SetMosfetPropForm( "gridResolution" )
		GridResolution = LookupLibProp( "gridResolution" )
	)

	;---------------------------------------------------------------------
	; Get the appropriate size and minimum size parameter values from the 
	; component's property list. The name and string values will be used 
	; in the prompts later.
	;---------------------------------------------------------------------

	case( Property
	
		( "l" 
		PropertyName  = "Length"          
		SizeString    = cdfgData->l->value
		MinSizeString = cdfgData->MinL->value
		)
		
		( "w" 	            
		PropertyName  = "Width"          
		SizeString    = cdfgData->w->value
		MinSizeString = cdfgData->MinW->value
		)
		
		( "lp" 	            
		PropertyName = "Length P"          
		SizeString    = cdfgData->lp->value
		MinSizeString = cdfgData->MinL->value
		)
		
		( "wp" 	            
		PropertyName = "Width P"          
		SizeString    = cdfgData->wp->value
		MinSizeString = cdfgData->MinW->value
		)
		
		( "ln"	            
		PropertyName = "Length N"          
		SizeString    = cdfgData->ln->value
		MinSizeString = cdfgData->MinL->value
		)
		
		( "wn" 	            
		PropertyName = "Width N"          
		SizeString    = cdfgData->wn->value
		MinSizeString = cdfgData->MinW->value
		)
		
		( t
			printf("CheckMicronSizeCB: Unknown property \"%s\".\n" Property )
		)
	);---- End Case Property ----

	
	;---------------------------------------------------------------------
	; If there were no errors in obtaining the data then proceed. Otherwise
	; print the error message and drop through.
	;---------------------------------------------------------------------

	if( GridResolution == nil || SizeString == nil || MinSizeString == nil  
	then
		printf("CheckMicronSizeCB: Could not obtain one or more of the required parameters.\n")

	else
		;------------------------------------------------------------------
		; Convert all the properties to the same units.
		;------------------------------------------------------------------
		
		GridResolution = GridResolution * 1e-6 			  		;-- meters --
		Size    	   = cdfParseFloatString( SizeString )		;-- meters --
		MinSize		   = cdfParseFloatString( MinSizeString )	;-- meters --


		cond( 
		
		( !floatp(Size)
		
			;--------------------------------------------------------------
			; If something other than a number was entered, 
			; treat it as a variable.
			;--------------------------------------------------------------
			
			printf("CheckMicronSizeCB: %s is not a number. Use the variable %L to set this property\n"
					PropertyName Size )
			GridSize = 0
			MicronSize = strcat( Size " * 1e6")
		)
		
		( Size < MinSize 
				
        	hiGetAttention()
			printf( "Error: Cannot set transistor %s below %s. Resetting ...\n"
					PropertyName MinSizeString )

			Size 	   = MinSizeString						;-- String value --
			MicronSize = sprintf( nil "%g" MinSize * 1e6 )
			GridSize   = round( MinSize/GridResolution )	
		)
		
		( t
			;--------------------------------------------------------------
			; Set the size in grid units.
			;--------------------------------------------------------------

			GridSize = round( Size/GridResolution )


			;--------------------------------------------------------------
			; Check to see if the micron value is on the grid.
			;--------------------------------------------------------------

			when( abs(Size/GridResolution - GridSize) > 0.0001

            	hiGetAttention()
				printf( "Warning: Transistor %s %s not on the grid. "
						PropertyName SizeString )
            	printf( "Resetting to closest value.\n" )

				Size = GridSize * GridResolution	
			)
			
			;--------------------------------------------------------------
			; Convert to strings. Note: pcells need the size in microns.
			;--------------------------------------------------------------

			MicronSize = sprintf( nil "%g" Size * 1e6 )
			Size 	   = sprintf( nil "%g" Size ) 
						
		)
		) ;-- End cond ----
		
		
		;------------------------------------------------------------------
		; Write the correct values back to the appropriate property in
		; property list.
		;------------------------------------------------------------------

		case( Property

			( "l" 
			cdfgData->l_grid->value  	= GridSize
			cdfgData->l->value  	 	= Size
    	    cdfgData->l_microns->value  = MicronSize 	
			)

			( "w" 	            
			cdfgData->w_grid->value     = GridSize
			cdfgData->w->value  	    = Size
    	    cdfgData->w_microns->value  = MicronSize 	
			setFetArea()
			)

			( "lp" 	            
			cdfgData->lp_grid->value = GridSize
			cdfgData->lp->value  	 = Size
			)

			( "wp" 	            
			cdfgData->wp_grid->value = GridSize
			cdfgData->wp->value  	 = Size
			)

			( "ln"	            
			cdfgData->ln_grid->value = GridSize
			cdfgData->ln->value  	 = Size
			)

			( "wn" 	            
			cdfgData->wn_grid->value = GridSize
			cdfgData->wn->value  	 = Size
			)

			( t
				printf("CheckMicronSizeCB: Unknown property \"%s\".\n" Property )
			)
		);---- End Case Property ----		
		
	);---- End if GridResolution == nil ... ----
	
));---- End Procedure CheckMicronSizeCB ----



;==== ChangeMultiplierCB  =================================================
;
; Called when "m" (multiplier) changes; making sure that fingers can't
; be edited while m > 1 is taken care of by the "editable" cdf
; parameter.
;--------------------------------------------------------------------------

procedure( ChangeMultiplierCB()

if( cdfgData->m->value < 1 then
	hiGetAttention()
    warn( "\"Multiplier\" must be an integer >= 1, setting to 1..." )
    cdfgData->m->value = 1
)

; something in DLE is changing m to a float! so, put this in to
; convert it back to an integer...

cdfgData->m->value = floor( cdfgData->m->value )

) ;---- End procedure ChangeMultiplierCB  ----



;==== ChangeFingersCB =====================================================
;
; Called when "fingers" changes; making sure that multiplier can't be
; edited while fingers > 1 is taken care of by the "editable" cdf
; parameter
;--------------------------------------------------------------------------

procedure( ChangeFingersCB()

if( cdfgData->fingers->value < 1 then
	hiGetAttention()
    warn( "\"Fingers\" must be an integer >= 1, setting to 1..." )
    cdfgData->fingers->value = 1
)

) ;---- End procedure ChangeFingersCB ----



;==== setFetArea ==========================================================
;
; Estimate drain/source area/perimeter based on minLength & width. For the
; contact spacing on the diffusion we assume a source/drain rectangle
; which is 2.5 "minLength" on top/bottom and "width" size on left and right.
;--------------------------------------------------------------------------

procedure( setFetArea()
let( (MinLength Width)
	
		Width = cdfParseFloatString(cdfgData->w->value) 		;-- meters --
		MinLength = cdfParseFloatString(cdfgData->MinL->value)	;-- meters --

	cond( 
	
	( Width == nil || MinLength == nil
	 
		warn("setFetArea: Could not obtain one or more of the required parameters.\n")
	)
	
	( !floatp(Width)
		
		;------------------------------------------------------------------
		; Width was entered as a variable instead of a fixed value.
		;------------------------------------------------------------------
		
		cdfgData->as->value = strcat( Width " * 2.5 * iPar(\"MinL\")" )
    	cdfgData->ps->value = strcat( "(2 * " Width ") + (5 * iPar(\"MinL\"))" )
    	cdfgData->ad->value = cdfgData->as->value
    	cdfgData->pd->value = cdfgData->ps->value
	)
	
	( t
    	cdfgData->as->value = sprintf( nil "%g" (Width * 2.5 * MinLength) )
    	cdfgData->ps->value = sprintf( nil "%g" (2 * Width) + (5 * MinLength) )
    	cdfgData->ad->value = cdfgData->as->value
    	cdfgData->pd->value = cdfgData->ps->value
	)
	)
)) ;---- End procedure setFetArea ----



;==== CheckDLECellName ====================================================
;
; This function is the callback for the dleUseCell property on the cdf. It
; allows the system value for the dle layout cell to be generated whenever
; "reset" is used as the value.
;--------------------------------------------------------------------------

procedure( CheckDLECellName()

if( cdfgData->dleUseCell->value == "reset" || 
    cdfgData->lxUseCell->value == "reset" || 
	  cdfgData->pDLEcell->value == "reset" ||
	  cdfgData->nDLEcell->value == "reset"
then
	SetDLECellName()
)

;---- Could also check to see if the library is in the path ----

);---- End procedure CheckDLECellName ----



;==== SetDLECellName ======================================================
;
; This function generates the system value for the dle layout cell. It uses
; the technology library from the library property techLibName and cell
; name from the global data using the model default value as the key.
;--------------------------------------------------------------------------

procedure( SetDLECellName()
let( (Libid Bag PropId TechLib Cell pCell nCell)
	
	;----------------------------------------------------------------------
	; Not needed when in the layout editor. Use the P-Cells directly.
	;----------------------------------------------------------------------

	when( hiGetCurrentWindow()->cellView->cellViewType != "maskLayout"
	
	
    	;------------------------------------------------------------------ 
    	; Get the technology library name. If attached to cdsDefTechLib use
		; the library name that contains the cell.
    	;------------------------------------------------------------------ 

		TechLib = GetEditTechLib("IgnoreCdsDefTechLib")->name
		
		unless( TechLib == nil

			;--------------------------------------------------------------
			; Set the cell name property with the string "TechLib Cell".
			;--------------------------------------------------------------

			if( cdfgData->DisplayGateProps->defValue == t 
			then
				;---- Gate instance ---------------------------------------
				pCell = NCSU_dleCellName[ cdfgData->pModel->defValue ]
				nCell = NCSU_dleCellName[ cdfgData->nModel->defValue ]
				cdfgData->pDLEcell->value = strcat( TechLib " " pCell )
				cdfgData->nDLEcell->value = strcat( TechLib " " nCell )
			else
				;---- Transistor instance ---------------------------------
				Cell = NCSU_dleCellName[ cdfgData->model->defValue ]
				;cdfgData->dleUseCell->value = strcat( TechLib " " Cell )
				;cdfgData->lxUseCell->value = strcat( TechLib " " Cell )
			)

		);---- End unless TechLib == nil ----
		
	);---- End when hiGetCurrentWindow ... ----
	
));---- End procedure SetDLECellName ----



;==== OldCBs ==============================================================
; 
; These procedures are included for backward compatability.
;--------------------------------------------------------------------------

procedure( CheckGridLengthCB() 
	CheckGridSizeCB( "l" )
)

procedure( CheckGridWidthCB()
	CheckGridSizeCB( "w" )
)

procedure( CheckMicronLengthCB()
	CheckMicronSizeCB( "l" )
)

procedure( CheckMicronWidthCB()
	CheckMicronSizeCB( "w" )
)

procedure( DigitalGateInitCB( props )
	SetFetDefaultsCB( props )
)
