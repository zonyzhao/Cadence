// Verilog HDL for SAND_Standard_Parts, flipflop_D _functional

/* Module *****************************************************************
*
* NAME : DFF
* 
* DESCRIPTION : positive edge-triggered (master-slave) D flipflop
*               without preset or clear        
*
* NOTES :
*
*
* REVISION HISTORY :
*	 Date	Programmer  	Description
*	 ----	----------  	-----------
*	2/27/95	Toby Schaffer	Created					
*   3/2/95  Toby Schaffer   Structural
*
*M*/

/*==== Context =========================================================*/

//`include "/afs/eos/info/ece691f_info/toplevel/defines_h.v"

/*==== Declarations =====================================================*/

module  DFF 
		(
        Q,
        D,
		Clk,
		_Clk
		);

/*---- Inputs -----------------------------------------------------------*/

input   D, Clk, _Clk;

/*---- Outputs ----------------------------------------------------------*/

output 	Q;


/*---- Register ---------------------------------------------------------*/

// reg Q;

/*==== Operation ========================================================*/


// always @ ( posedge Clk )
//  Q = D;	
		
    cmos( MasterIn, D, _Clk, Clk );
    not( MasterMid, MasterIn );
    not( MasterOut, MasterMid );
    cmos( MasterIn, MasterOut, Clk, _Clk );

    cmos( SlaveIn, MasterOut, Clk, _Clk );
    not( SlaveMid, SlaveIn );
    not( Q, SlaveMid );
    cmos( SlaveIn, Q, _Clk, Clk );

endmodule //---- DFF ------------------------------------------------------
