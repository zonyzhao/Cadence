// Verilog HDL for basic_gates, xnor5 _functional

module xnor5 (Y, A, B, C, D, E);
    output Y;
    input A;
    input B;
    input C;
    input D;
    input E;

xnor (Y, A, B, C, D, E);

endmodule
