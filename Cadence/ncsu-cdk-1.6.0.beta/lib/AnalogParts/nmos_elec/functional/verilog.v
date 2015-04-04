// Verilog HDL for gates, nfet _functional 

module nfet (D, S, G);
    inout D;
    inout S;
    input G;

    nmos (D, S, G);

endmodule
