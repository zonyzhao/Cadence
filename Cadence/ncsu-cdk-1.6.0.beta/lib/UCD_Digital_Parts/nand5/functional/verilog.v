// Verilog HDL for gates, nand5 _functional

module nand5 (Y, A, B, C, D, E);
    output Y;
    input A;
    input B;
    input C;
    input D;
    input E;

nand (Y, A, B, C, D, E);

endmodule
