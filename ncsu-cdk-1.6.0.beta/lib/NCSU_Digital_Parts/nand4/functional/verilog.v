// Verilog HDL for gates, nand4 _functional

module nand4 (Y, A, B, C, D);
    output Y;
    input A;
    input B;
    input C;
    input D;

nand (Y, A, B, C, D);

endmodule
