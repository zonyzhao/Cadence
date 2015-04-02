// Verilog HDL for gates, nand6 _functional

module nand6 (Y, A, B, C, D, E, F);
    output Y;
    input A;
    input B;
    input C;
    input D;
    input E;
    input F;

nand (Y, A, B, C, D, E, F);

endmodule
