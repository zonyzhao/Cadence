
/*************************************************************************/
 LIBRARY = "NCSU_Digital_Parts"
 CELLS   = '( 	"DFF" "DFF_Clr" "DFF_Pre" "Dlatch" "trinv0" "trinv1"
				"mux_2to1_32bit" "mux_2to1_80bit" "mux_3to1_32bit"
				"mux_4to1_20bit" "mux_4to1_24bit" "mux_4to1_32bit"
				"mux_4to1_80bit" "mux_8to1_32bit" 
				"pcapacitor" "xnor2" "xnor3" "xnor4" "xnor5" "xnor6"
				"xor2" "xor3" "xor4" "xor5" "xor6"  
			)
/*************************************************************************/

let( ( Cell libId cellId cdfId )
	foreach( Cell CELLS
    	unless( cellId = ddGetObj( LIBRARY Cell )
        	error( "Could not get cell %s." Cell )
    	)
    	when( cdfId = cdfGetBaseCellCDF( cellId )
        	cdfDeleteCDF( cdfId )
    	)
    	cdfId  = cdfCreateBaseCellCDF( cellId )

    	;;; Simulator Information
    	cdfId->simInfo = list( nil )
    	cdfId->simInfo->auCdl = '( nil )
    	cdfId->simInfo->auLvs = '( nil )
    	cdfId->simInfo->cdsSpice = '( nil )
    	cdfId->simInfo->hpmns = '( nil )
    	cdfId->simInfo->hspiceS = '( nil )
    	cdfId->simInfo->libra = '( nil )
    	cdfId->simInfo->mharm = '( nil )
    	cdfId->simInfo->spectre = '( nil )
    	cdfId->simInfo->spectreS = '( nil )
    	cdfId->simInfo->switcap = '( nil )
    	cdfId->simInfo->watscad = '( nil )

    	;;; Properties
    	cdfId->formInitProc            = "PropDisplayOffCB"
    	cdfId->doneProc                = ""
    	cdfId->buttonFieldWidth        = 340
    	cdfId->fieldHeight             = 35
    	cdfId->fieldWidth              = 350
    	cdfId->promptWidth             = 175
    	cdfSaveCDF( cdfId )

	);---- End foreach ----
)
