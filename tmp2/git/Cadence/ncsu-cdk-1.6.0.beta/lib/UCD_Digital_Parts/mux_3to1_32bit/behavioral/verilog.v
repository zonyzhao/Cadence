// Verilog HDL for SAND_Standard_Parts, mux_3to1_32bit _behavioral

/* Module *****************************************************************
*
* NAME : mux_3to1_32bit
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
*	2/28/95	Toby Schaffer	Changed input names
*
*M*/

/*==== Context =========================================================*/

//`include "/afs/eos/info/ece691f_info/toplevel/defines_h.v"


/*==== Declarations =====================================================*/

module  mux_3to1_32bit 
		(In0,
		In1,
		In2,
		Select,
		Out
		);

/*---- Inputs -----------------------------------------------------------*/

input 	[31:0]	In0,
				In1,
				In2;
				
input	[1:0]	Select;


/*---- Outputs ----------------------------------------------------------*/

output 	[31:0]	Out;



/*---- Register ---------------------------------------------------------*/

reg 	[31:0] 	Out;



/*==== Operation ========================================================*/


always @ (In0 or In1 or In2 or Select)
	casez (Select)
		2'b00:  Out = In0;
		2'b01:  Out = In1;
		2'b1?:  Out = In2;
		default:Out = 32'bx;
	endcase
		


endmodule //---- mux_3to1_32bit ------------------------------------------------
