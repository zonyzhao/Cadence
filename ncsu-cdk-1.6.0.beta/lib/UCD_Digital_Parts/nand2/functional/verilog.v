// Verilog HDL for gates, nand2 _functional

module nand2 (Y, A, B);
    output Y;
    input A;
    input B;

nand ( Y, A, B );

endmodule
