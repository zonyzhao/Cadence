// Verilog HDL for SAND_Standard_Parts, flipflop_D _functional

/* Module *****************************************************************
*
* NAME : DFF_Clr
* 
* DESCRIPTION : positive edge-triggered (master-slave) D flipflop
*               with synchronous clear        
*
* NOTES :
*
*
* REVISION HISTORY :
*	 Date	Programmer  	Description
*	 ----	----------  	-----------
*   3/2/95  Toby Schaffer   Created
*
*M*/

/*==== Context =========================================================*/

//`include "/afs/eos/info/ece691f_info/toplevel/defines_h.v"

/*==== Declarations =====================================================*/

module  DFF_Clr
		(D,
		Clk,
		_Clk,
        _Clr,
		Q
		);

/*---- Inputs -----------------------------------------------------------*/

input   D, Clk, _Clk, _Clr;

/*---- Outputs ----------------------------------------------------------*/

output 	Q;

/*---- Register ---------------------------------------------------------*/

// reg Q;

/*==== Operation ========================================================*/

// always @ ( posedge Clk )
//  Q = _Clr == 1'b1 ? D : 0;	
		
    not( Clr, _Clr );
    cmos( FFin, D, _Clr, Clr );
    pulldown( GND );
    nmos( FFin, GND, _Clr );

    cmos( MasterIn, D, _Clk, Clk );
    not( MasterMid, MasterIn );
    not( MasterOut, MasterMid );
    cmos( MasterIn, MasterOut, Clk, _Clk );

    cmos( SlaveIn, MasterOut, Clk, _Clk );
    not( SlaveMid, SlaveIn );
    not( Q, SlaveMid );
    cmos( SlaveIn, Q, _Clk, Clk );

endmodule //---- DFF_Clr ------------------------------------------------------
