// Verilog HDL for SAND_Standard_Parts, mux_8to1_1bit _functional

/* Module *****************************************************************
*
* NAME : mux_8to1_1bit
* 
* DESCRIPTION : 1 Bit, 8 to 1 mux
*
*
* NOTES :
*
*
* REVISION HISTORY :
*	 Date	Programmer  	Description
*	 ----	----------  	-----------
*	4/19/95	Toby Schaffer	Created					
*
*M*/

/*==== Context =========================================================*/

//`include "/afs/eos/info/ece691f_info/toplevel/defines_h.v"


/*==== Declarations =====================================================*/

module  mux_8to1_1bit 
		(In0, In1, In2, In3, In4, In5, In6, In7,
         Select, _Select,
		 Out
		);

/*---- Inputs -----------------------------------------------------------*/

input 	In0, In1, In2, In3, In4, In5, In6, In7;
				
input	[2:0]	 Select,
                _Select;

/*---- Outputs ----------------------------------------------------------*/

output 	Out;

/*---- Register ---------------------------------------------------------*/

reg 	Out;

/*==== Operation ========================================================*/

always @ (In0 or In1 or In2 or In3 or In4 or In5 or In6 or In7 or
          Select or _Select)
	casez ({Select[2],_Select[2],Select[1],_Select[1],Select[0],_Select[0]})
		6'b010101:  Out = In0;
		6'b010110:  Out = In1;
		6'b011001:  Out = In2;
		6'b011010:  Out = In3;
		6'b100101:  Out = In4;
		6'b100110:  Out = In5;
		6'b101001:  Out = In6;
		6'b101010:  Out = In7;
		
		default:    Out = 1'bx;
	endcase

endmodule //---- mux_8to1_1bit ------------------------------------------------
