// Verilog HDL for SAND_Standard_Parts, flipflop_D _functional

/* Module *****************************************************************
*
* NAME : DFF_Pre
* 
* DESCRIPTION : positive edge-triggered (master-slave) D flipflop
*               with syncrhonous preset
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

module  DFF_Pre 
		(D,
		Clk,
		_Clk,
        _Preset,
		Q
		);

/*---- Inputs -----------------------------------------------------------*/

input   D, Clk, _Clk, _Preset;

/*---- Outputs ----------------------------------------------------------*/

output 	Q;

/*---- Register ---------------------------------------------------------*/

// reg Q;

/*==== Operation ========================================================*/


// always @ ( posedge Clk )
//  Q = (_Pr == 1'b1 ? D : 1'b1);

    not( Preset, _Preset );
    cmos( FFin, D, _Preset, Preset );
    pullup( Vdd );
    pmos( FFin, Vdd, _Preset );

    cmos( MasterIn, D, _Clk, Clk );
    not( MasterIn, MasterMid );
    not( MasterMid, MasterOut );
    cmos( MasterIn, MasterOut, Clk, _Clk );

    cmos( SlaveIn, MasterOut, Clk, _Clk );
    not( SlaveIn, SlaveMid );
    not( SlaveMid, Q );
    cmos( SlaveIn, Q, _Clk, Clk );

endmodule //---- DFF ------------------------------------------------------
