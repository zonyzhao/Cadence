// Verilog HDL for SAND_Standard_Parts, mux_2to1_32bit _behavioral

/* Module *****************************************************************
*
* NAME : mux_2to1_32bit
* 
* DESCRIPTION : 32 Bit, 2 to 1 mux
*
*
* NOTES :
*
*
* REVISION HISTORY :
*	 Date	Programmer  	Description
*	 ----	----------  	-----------
*	1/17/95	Andy Stanaski	Created					
*	2/28/95	Toby Schaffer   Changed input names
*
*M*/

/*==== Context =========================================================*/

//`include "/afs/eos/info/ece691f_info/toplevel/defines_h.v"


/*==== Declarations =====================================================*/

module  mux_2to1_32bit 
		(In0,
		In1,
		Select,
		Out
		);

/*---- Inputs -----------------------------------------------------------*/

input 	[31:0]	In0,
				In1;
				
input			Select;


/*---- Outputs ----------------------------------------------------------*/

output 	[31:0]	Out;



/*---- Register ---------------------------------------------------------*/

reg 	[31:0] 	Out;



/*==== Operation ========================================================*/


always @ (In0 or In1 or Select)
	case (Select)
		0:Out = In0;
		1:Out = In1;
		default:Out = 32'bx;
	endcase
		


endmodule //---- mux_2to1_32bit ------------------------------------------------
