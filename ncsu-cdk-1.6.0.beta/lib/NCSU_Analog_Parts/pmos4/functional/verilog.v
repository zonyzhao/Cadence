// Verilog HDL for "NCSU_Analog_Parts", "pmos4" "functional"

module pmos4 (B, D, G, S);
    inout B;
    inout D;
    inout G;
    inout S;

    tranif0 (D, S, G);

endmodule
