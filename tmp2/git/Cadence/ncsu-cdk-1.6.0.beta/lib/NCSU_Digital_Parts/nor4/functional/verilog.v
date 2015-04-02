// Verilog HDL for gates, nor4 _functional

module nor4 (Y, A, B, C, D);
    output Y;
    input A;
    input B;
    input C;
    input D;

nor (Y, A, B, C, D);

endmodule
