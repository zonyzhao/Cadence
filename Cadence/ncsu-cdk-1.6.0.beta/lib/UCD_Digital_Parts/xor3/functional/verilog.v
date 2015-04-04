// Verilog HDL for basic_gates, xor3 _functional

module xor3 (Y, A, B, C);
    output Y;
    input A;
    input B;
    input C;

xor (Y, A, B, C);

endmodule
