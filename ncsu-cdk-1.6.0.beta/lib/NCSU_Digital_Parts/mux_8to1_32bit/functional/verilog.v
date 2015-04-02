// Verilog HDL for SAND_Standard_Parts, mux_8to1_32bit _behavioral

/* Module *****************************************************************
*
* NAME : mux_8to1_32bit
* 
* DESCRIPTION : 32 Bit, 8 to 1 mux
*
*
* NOTES :
*
*
* REVISION HISTORY :
*	 Date	Programmer  	Description
*	 ----	----------  	-----------
*	4/19/95	Toby Schaffer   Created
*
*
*M*/

/*==== Context =========================================================*/

//`include "/afs/eos/info/ece691f_info/toplevel/defines_h.v"

/*==== Declarations =====================================================*/

module  mux_8to1_32bit 
		(In0, In1, In2, In3, In4, In5, In6, In7,
		Select,
		Out
		);

/*---- Inputs -----------------------------------------------------------*/

input 	[31:0]	In0, In1, In2, In3, In4, In5, In6, In7;
				
input	[2:0]	Select;

/*---- Outputs ----------------------------------------------------------*/

output 	[31:0]	Out;

/*---- Register ---------------------------------------------------------*/

reg 	[31:0] 	Out;

/*==== Operation ========================================================*/

always @ (In0 or In1 or In2 or In3 or In4 or In5 or In6 or In7 or Select)
	casez (Select)
		3'b000:  Out = In0;
		3'b001:  Out = In1;
		3'b010:  Out = In2;
		3'b011:  Out = In3;
		3'b100:  Out = In4;
		3'b101:  Out = In5;
		3'b110:  Out = In6;
		3'b111:  Out = In7;

		default: Out = 32'bx;
	endcase

endmodule //---- mux_8to1_32bit ------------------------------------------------
