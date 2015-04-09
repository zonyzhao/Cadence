// Verilog HDL for SAND_Standard_Parts, mux_4to1_20bit _behavioral

/* Module *****************************************************************
*
* NAME : mux_4to1_20bit
* 
* DESCRIPTION : 20 Bit, 4 to 1 mux
*
*
* NOTES :
*
*
* REVISION HISTORY :
*	 Date	Programmer  	Description
*	 ----	----------  	-----------
*	4/21/95 Toby Schaffer   created
*
*
*M*/

/*==== Context =========================================================*/

//`include "/afs/eos/info/ece691f_info/toplevel/defines_h.v"


/*==== Declarations =====================================================*/

module  mux_4to1_20bit 
		(In0,
		In1,
		In2,
		In3,
		Select,
		Out
		);

/*---- Inputs -----------------------------------------------------------*/

input 	[19:0]	In0,
				In1,
				In2,
				In3;
				
input	[1:0]	Select;


/*---- Outputs ----------------------------------------------------------*/

output 	[19:0]	Out;



/*---- Register ---------------------------------------------------------*/

reg 	[19:0] 	Out;



/*==== Operation ========================================================*/


always @ (In0 or In1 or In2 or In3 or Select)
	casez (Select)
		2'b00:  Out = In0;
		2'b01:  Out = In1;
		2'b10:  Out = In2;
		2'b11:  Out = In3;
		default:Out = 20'bx;
	endcase
		


endmodule //---- mux_4to1_20bit ------------------------------------------------
