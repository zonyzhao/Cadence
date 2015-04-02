// Verilog HDL for "NCSU_Analog_Parts", "nmos4" "functional"

module nmos4 (B, D, G, S);
    inout B;
    inout D;
    inout G;
    inout S;

    tranif1 (D, S, G);

endmodule
