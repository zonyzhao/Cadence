// Verilog HDL for gates, nor6 _functional

module nor6 (Y, A, B, C, D, E, F);
    output Y;
    input A;
    input B;
    input C;
    input D;
    input E;
    input F;

nor (Y, A, B, C, D, E, F);

endmodule
