// Verilog HDL for SAND_Standard_Parts, mux_3to1_1bit _functional

/* Module *****************************************************************
*
* NAME : mux_3to1_1bit
* 
* DESCRIPTION : 1 Bit, 3 to 1 mux
*
*
* NOTES :
*
*
* REVISION HISTORY :
*	 Date	Programmer  	Description
*	 ----	----------  	-----------
*	2/27/95	Toby Schaffer	Created					
*	2/28/95	Toby Schaffer	Changed input names
*   3/14/95 Andy Stanaski   Removed Inverters, added _Select and updated
*                           functionality. 
*
*M*/

/*==== Context =========================================================*/

//`include "/afs/eos/info/ece691f_info/toplevel/defines_h.v"


/*==== Declarations =====================================================*/

module  mux_3to1_1bit 
		(In0,
		In1,
		In2,
		Select,
		_Select,
		Out
		);

/*---- Inputs -----------------------------------------------------------*/

input 	In0,
		In1,
		In2;
				
input	[1:0]	 Select,
				_Select;


/*---- Outputs ----------------------------------------------------------*/

output 	Out;


/*---- Register ---------------------------------------------------------*/

reg 	Out;



/*==== Operation ========================================================*/


always @ (In0 or In1 or In2 or Select or _Select)
	casez ({Select[1], _Select[1], Select[0], _Select[0]})
		4'b0101:  Out = In0;
		4'b0110:  Out = In1;
		4'b10??:  Out = In2;
		4'b00??:  Out = 1'bx;
		4'b11??:  Out = 1'bx;
		4'b0111:  Out = 1'bx;
		4'b0100:  Out = 1'bx;		
		default:  Out = 1'bx;
	endcase

endmodule //---- mux_3to1_1bit ------------------------------------------------
