// Verilog HDL for basic_gates, xor4 _functional

module xor4 (Y, A, B, C, D);
    output Y;
    input A;
    input B;
    input C;
    input D;

xor (Y, A, B, C, D);

endmodule
