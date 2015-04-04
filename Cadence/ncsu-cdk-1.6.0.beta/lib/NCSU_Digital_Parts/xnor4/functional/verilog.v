// Verilog HDL for basic_gates, xnor4 _functional

module xnor4 (Y, A, B, C, D);
    output Y;
    input A;
    input B;
    input C;
    input D;

xnor (Y, A, B, C, D);

endmodule
