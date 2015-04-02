// Verilog HDL for basic_gates, xor6 _functional

module xor6 (Y, A, B, C, D, E, F);
    output Y;
    input A;
    input B;
    input C;
    input D;
    input E;
    input F;

xor (Y, A, B, C, D, E, F);

endmodule
