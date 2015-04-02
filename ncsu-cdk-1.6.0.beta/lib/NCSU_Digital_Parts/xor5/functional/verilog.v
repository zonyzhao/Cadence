// Verilog HDL for basic_gates, xor5 _functional

module xor5 (Y, A, B, C, D, E);
    output Y;
    input A;
    input B;
    input C;
    input D;
    input E;

xor (Y, A, B, C, D, E);

endmodule
