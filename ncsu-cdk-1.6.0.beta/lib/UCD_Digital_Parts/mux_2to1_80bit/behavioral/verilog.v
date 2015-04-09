// Verilog HDL for SAND_Standard_Parts, mux_2to1_80bit _behavioral

/* Module *****************************************************************
*
* NAME : mux_2to1_80bit
* 
* DESCRIPTION : 80 Bit, 2 to 1 mux
*
*
* NOTES :
*
*
* REVISION HISTORY :
*	 Date	Programmer  	Description
*	 ----	----------  	-----------
*	4/16/95	Toby Schaffer   created
*
*M*/

/*==== Context =========================================================*/

//`include "/afs/eos/info/ece691f_info/toplevel/defines_h.v"


/*==== Declarations =====================================================*/

module  mux_2to1_80bit 
		(In0,
		In1,
		Select,
		Out
		);

/*---- Inputs -----------------------------------------------------------*/

input 	[79:0]	In0,
				In1;
				
input			Select;


/*---- Outputs ----------------------------------------------------------*/

output 	[79:0]	Out;



/*---- Register ---------------------------------------------------------*/

reg 	[79:0] 	Out;



/*==== Operation ========================================================*/


always @ (In0 or In1 or Select)
	case (Select)
		0:Out = In0;
		1:Out = In1;
		default:Out = 80'bx;
	endcase
		


endmodule //---- mux_2to1_80bit ------------------------------------------------
