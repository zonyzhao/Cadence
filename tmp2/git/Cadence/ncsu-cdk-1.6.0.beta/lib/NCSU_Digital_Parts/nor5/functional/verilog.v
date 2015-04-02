// Verilog HDL for gates, nor5 _functional

module nor5 (Y, A, B, C, D, E);
    output Y;
    input A;
    input B;
    input C;
    input D;
    input E;

nor (Y, A, B, C, D, E);

endmodule
