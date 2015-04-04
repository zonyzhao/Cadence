// Verilog HDL for SAND_Standard_Parts, mux_2to1_1bit _functional

/* Module *****************************************************************
*
* NAME : mux_2to1_1bit
* 
* DESCRIPTION : 1 Bit, 2 to 1 mux
*
*
* NOTES :
*
*
* REVISION HISTORY :
*	 Date	Programmer  	Description
*	 ----	----------  	-----------
*	2/27/95	Toby Schaffer   Created					
*	2/28/95	Toby Schaffer   Changed input names
*
*M*/

/*==== Context =========================================================*/

//`include "/afs/eos/info/ece691f_info/toplevel/defines_h.v"


/*==== Declarations =====================================================*/

module  mux_2to1_1bit
		(In0,
		In1,
		Select,
		_Select,
		Out
		);

/*---- Inputs -----------------------------------------------------------*/

input 	In0,
		In1;
				
input	Select,
		_Select;


/*---- Outputs ----------------------------------------------------------*/

output 	Out;



/*---- Register ---------------------------------------------------------*/

reg 	Out;


/*==== Operation ========================================================*/

always @ (In0 or In1 or Select or _Select)
	case ({Select, _Select})
		2'b00: Out = 1'bx;
		2'b01: Out = In0;
		2'b10: Out = In1;
		2'b11: Out = 1'bx;		
		default: Out = 1'bx;
	endcase

endmodule //---- mux_2to1_1bit ------------------------------------------------
