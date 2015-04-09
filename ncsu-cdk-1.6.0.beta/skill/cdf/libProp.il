;==========================================================================
;
; $Id: libProp.il,v 1.1.1.1 2006/02/10 16:33:45 slipa Exp $
; 
; Revision History
;
; $Log: libProp.il,v $
; Revision 1.1.1.1  2006/02/10 16:33:45  slipa
; starting CDK v1.5.0rc1 source file
;
; Revision 1.7  2000/04/26 16:32:13  awglaser
; Added PropBagExists() function to check if prop bag is readable
; for current edit library (allows for graceful failure of certain
; functions for libs not created using the CDKK tech files)
;
; Revision 1.6  1999/07/14 21:55:14  awglaser
; Changed dmFindLib() (deprecated) to ddGetObj()
;
; Revision 1.5  1999/07/05 20:41:37  jtschaff
; changed "getEditRep()" to "geGetEditCellView()" based
; on skill lint report from John Gianni (john@cadence.com)
;
; Revision 1.4  1998/03/23 22:16:06  astanas
; Comment additions for clarification.
;
; Revision 1.3  1998/01/27 19:31:56  astanas
; 	Added the optional parameter Mode to GetEditTechLib to allow
; 	it to return the design library id instead of cdsDefTechLib.
; 	This was the original functionality before rev 1.2.
;
; Revision 1.2  1998/01/15 16:30:52  astanas
; Separated the technology library lookup from GetPropBag into its
; own procedure GetEditTechLib.
;
; Changed the prog statements to let and cleaned up the code.
;
; Added the capability to allow SetLibProp to run silently.
;
; Revision 1.1  1997/12/18 16:24:30  astanas
; Initial revision
;
;--------------------------------------------------------------------------



;==== GetEditTechLib ======================================================
;
; Returns the library id of the technology library for the edit cellview.
;
; The optional argument "Mode", when set to "IgnoreCdsDefTechLib", tells
; the function to return the library id of the design library instead of
; the tech lib "cdsDefTechLib" if attached to cdsDefTechLib.
; 
; Usage: GetEditTechLib() or GetEditTechLib( "IgnoreCdsDefTechLib" )
; 
;--------------------------------------------------------------------------

procedure( GetEditTechLib( @optional Mode )
let( (Libid Cell CellView TechLib)

	;----------------------------------------------------------------------
	; Get the CellView, Cell, and Library IDs.
	;
    ; When the Component Browser is used in the add component command
    ; the browser window becomes the current window and
    ; "geGetEditCellView" no longer works. The needed variables must be
    ; found on the create instance form.
	;
    ;----------------------------------------------------------------------

    if( hiGetWindowName( hiGetCurrentWindow() ) == "Component Browser"  then
    
       	Cell = schCreateInstForm->cellViewId->cell
		CellView = schCreateInstForm->cellViewId->cellView	
        Libid = schCreateInstForm->cellViewId->lib

	else
		Cell = geGetEditCellView()~>cell
		CellView = geGetEditCellView()~>cellView
		Libid = geGetEditCellView()~>lib
	)
		

	;----------------------------------------------------------------------
	; The technology used by a cellview may come from a technology file
	; compiled into the library, or one attached to either the cellview, 
	; the cell, or the library. This conditional looks for an attached
	; technology library.
	;----------------------------------------------------------------------	

    cond(
    
    ( TechLib = dbSearchPropByName( CellView "techLibName") TechLib )
    
    ( TechLib = dbSearchPropByName( Cell "techLibName") TechLib )
    
    ( TechLib = dbSearchPropByName( Libid "techLibName") TechLib )

    ( t  TechLib = nil )
    
    ) ;---- End Cond ----
	

	;----------------------------------------------------------------------
	; The design library id is returned when there is no technology library
	; attached or when the attached lib is the default tech lib with the 
	; Mode set to ignore that library. Otherwise, the tech lib id is returned.
	;----------------------------------------------------------------------	

	cond(
	
	( !TechLib Libid )
	
	( TechLib->value == "cdsDefTechLib" && Mode == "IgnoreCdsDefTechLib"  Libid )
	
	( t  Libid = ddGetObj( TechLib->value ) )
	
	) ;---- End Cond ----


));---- End procedure GetEditTechLib ----



;==== GetPropBag ===========================================================
;
; Open the library property bag in the mode specified as an argument. 
;
; Mode:	"r" 		= read [default]
;		"a" or "w" 	= append
;
;
; Returns a list with the property bag id and the library id.
; 
; Usage: GetPropBag( t_mode<r/a/w> )
;
;--------------------------------------------------------------------------

procedure( GetPropBag( @optional ( Mode "r" ) )
let( (Libid bag)

	;----------------------------------------------------------------------	
	; Check the function arguments.
	;----------------------------------------------------------------------	

	case( Mode
	
	( ("r" "a" "w") )	;-- Are all ok --
	
	( t  Mode = "r"	)	;-- Otherwise default to read --
	
	)

	;----------------------------------------------------------------------	
	; Get the library id.
	;----------------------------------------------------------------------	

    Libid = GetEditTechLib( "IgnoreCdsDefTechLib" )

    if( Libid != nil && Libid->name != "cdsDefTechLib"	then

		;------------------------------------------------------------------	
		; Open the property bag.
		;------------------------------------------------------------------	

    	bag = dbOpenBag( Libid Mode )
    	if( bag == nil then
        	warn( "GetPropBag: Can't open property bag for library \"%s\"!" 
                	Libid->name )
    	else
    		list(bag Libid)
		)
		
	else
		warn( "GetPropBag: Bad Library ID.\n" )
	
	);---- End if Libid ... ----
	
));---- End procedure GetPropBag ----



;==== PropBagExists =======================================================
;
; Check for a property bag on the edit lib. 
;
; Optional t/nil arg specifies verbose output.
;
; Returns "t" if prop bag is present, "nil" if not.
; 
; Usage: PropBagExists() or PropBagExists( [t|nil] )
;
;--------------------------------------------------------------------------

procedure( PropBagExists( @optional ( Verbose t ) )
let( (Libid bagExists)

	; Get the library id.

    Libid = GetEditTechLib( "IgnoreCdsDefTechLib" )

    if( Libid != nil && Libid->name != "cdsDefTechLib"	then

		; Check to see if the prop bag is readable

    	bagExists = dbIsBagReadable( Libid )
    	if( bagExists == nil && Verbose then
        	warn( "PropBagExists: Property bag unreadable for library \"%s\"!" 
                	Libid->name )
		)

        ; return result

        bagExists
		
	else
        if( Verbose then
            warn( "PropBagExists: Bad Library ID.\n" )
        )
        
        nil
	
	);---- End if Libid ... ----
	
));---- End procedure PropBagExists ----



;==== LookupLibProp ========================================================
;
; Lookup the library property specified as a string argument. If there
; are multiple properties the function returns a list of the results. The
; last argument (if nil) can be used to turn off the error message regarding
; the absence of the property.
;
; Usage: LookupLibProp( t_prop1 [t_prop2 ...] [nil | t] )
;
;--------------------------------------------------------------------------

procedure( LookupLibProp( @rest args )
let( (i NumArgs Verbose BagData bag LibId PropId PropValue PropList (Error nil) )

	;----------------------------------------------------------------------	
	; Check the function arguments.
	;----------------------------------------------------------------------	
	
    if( args == nil then
		printf( "*Error* LookupLibProp: At least one agrument needed.\n" )
		Error = t
    else
    	Verbose = car( last(args) )
    	if( Verbose == nil || Verbose == t then
    		NumArgs = length( args ) - 1
			
    		if( NumArgs == 0 then
				printf( "*Error* LookupLibProp: No property given.\n")
				Error = t
			)
    	else
    	    Verbose = t
    	    NumArgs = length( args )
    	)    
    		
		for(i 1 NumArgs
    		if( !stringp( nthelem(i args) ) then 
		 		warn( "LookupLibProp: Property %L must be given as a string." 
		 				nthelem(i args) )
				Error = t
			)
    	)
		
    );---- End if args == nil ----
	
	unless( Error 
	
		;------------------------------------------------------------------	
		; Open the property bag.
		;------------------------------------------------------------------	
		
		BagData = GetPropBag( "r" )

		if( BagData != nil then 

			bag 	= car(BagData)
			Libid 	= cadr(BagData)

			;--------------------------------------------------------------	
			; Get the first property.
			;--------------------------------------------------------------	
    		PropId 	= dbFindProp( bag car(args) )  
    		if( PropId == nil && Verbose then
        		warn( "LookupLibProp: Library \"%s\" has no \"%s\" property!" 
                		Libid~>name car(args) )
    		)

			;--------------------------------------------------------------	
			; If there is only one property return its value.
			;--------------------------------------------------------------	
    		if( NumArgs == 1 then
    			PropValue = PropId->value
    			dbCloseBag( bag )
				PropValue

			else
				;----------------------------------------------------------	
				; There is more than one property. Start a list of the 
				; property values using the tconc structure. This allows
				; the property values to be added to the end of the list.
				;----------------------------------------------------------	
				
    			PropList = tconc( nil PropId->value )

    			for( i 2 NumArgs
    				PropId 	= dbFindProp( bag nthelem(i args) )
    				if( PropId == nil && Verbose then
        				warn( "LookupLibProp: Library \"%s\" has no \"%s\" property!" 
                				Libid~>name nthelem(i args) )
            		)
            		tconc( PropList PropId->value )
    			)
				
				;----------------------------------------------------------
				; Return the property list.
				;----------------------------------------------------------
    			dbCloseBag( bag )
				car(PropList)
				
    		);---- End if NumArgs == 1 ----
			
		);---- End if BagData != nil ----
		
	);---- End unless Error ----
	      
));---- End Procedure LookupLibProp ----



;==== SetLibProp ==========================================================
;
; Sets the library property (specified as a string argument) to the type
; and value given. 
;
; Usage: SetLibProp( t_prop t_type<int/float/string> g_value [nil | t] )
; 
;--------------------------------------------------------------------------

procedure( SetLibProp( Property Type Value @optional (Verbose t) )
let( (BagData bag Libid PropId Status (Error nil) )

	;----------------------------------------------------------------------
	; Check the argument types and values.
	;----------------------------------------------------------------------
	
	if( !stringp( Property ) then 
		 warn( "SetLibProp: Property must be given as a string." )
		 Error = t 
	)

	
	case( Type
	
	( "int" 
		if( !fixp( Value ) then
			warn( "SetLibProp: Bad Value for Type int." )
			Error = t
	))

	( "float" 
		if( !numberp( Value ) then
			warn( "SetLibProp: Bad Value for Type float." )
			Error = t
	))
	
	( "string"
		if( !stringp( Value ) then
			warn( "SetLibProp: Bad Value for Type string." )
			Error = t
	))

	( t 
		warn( "SetLibProp: Unknown Type." )
		Error = t
	)
	);---- End case Type ----
	
	
	case( Verbose
	
	( (t nil) )	;-- Are ok --
	
	( t  Verbose = t	)	;-- Otherwise default to true --
	
	)
	

	unless( Error

		;----------------------------------------------------------------------
		; Open the property bag and set the property.
		;----------------------------------------------------------------------

		BagData = GetPropBag( "a" ) 
		if( BagData != nil then 

			bag   = car(BagData)
			Libid = cadr(BagData)

    		PropId = dbFindProp( bag Property )  ;-- Does it already exist? --
    		if( PropId == nil then
    			Status = dbCreateProp( bag Property Type Value )
    		else
    			Status = dbReplaceProp( bag Property Type Value )
    		)

    		dbSaveBag( bag )
    		dbCloseBag( bag )

    		if( Status == nil then
				warn("SetLibProp: Unable to set property \"%s\" in library\"%s\".\n"
						Property Libid~>name )
    		else
				if( Verbose then
    				printf("Property \"%s\" set to %L in library \"%s\".\n"
    							Property Value Libid~>name )
				else
					t   ;-- return value --
				)
    		)
			
		);---- End if BagData != nil -----
		
	);---- End unless Error ----
	  
));---- End Procedure SetLibProp ----
