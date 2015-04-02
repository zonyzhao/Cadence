// Verilog HDL for basic_gates, xnor3 _functional

module xnor3 (Y, A, B, C);
    output Y;
    input A;
    input B;
    input C;

xnor (Y, A, B, C);

endmodule
