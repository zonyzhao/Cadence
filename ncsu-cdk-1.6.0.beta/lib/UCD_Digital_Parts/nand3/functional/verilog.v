// Verilog HDL for gates, nand3 _functional

module nand3 (Y, A, B, C);
    output Y;
    input A;
    input B;
    input C;

nand (Y, A, B, C);

endmodule
