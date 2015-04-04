// Verilog HDL for gates, pfet _functional 

module pfet (D, S, G);
    inout D;
    inout S;
    input G;

    pmos (D, S, G);

endmodule
