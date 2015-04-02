// Verilog HDL for basic_gates, xnor6 _functional

module xnor6 (Y, A, B, C, D, E, F);
    output Y;
    input A;
    input B;
    input C;
    input D;
    input E;
    input F;

xnor (Y, A, B, C, D, E, F);

endmodule
