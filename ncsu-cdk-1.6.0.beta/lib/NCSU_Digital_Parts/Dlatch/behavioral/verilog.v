// Verilog HDL for SAND_Standard_Parts, Dlatch _behavioral

primitive Dlatch(Q, D, Clk, _Clk);
output Q; reg Q;
input D, Clk, _Clk;

    table
    //  D  Clk _Clk  "Q"    Q+
        ?  0   1    : ? :   -   ;
        1  1   0    : ? :   1   ;
        0  1   0    : ? :   0   ;
        ?  1   1    : ? :   -   ;   // intermediate clock state
        ?  0   0    : ? :   -   ;   // intermediate clock state
    endtable
    
endprimitive
