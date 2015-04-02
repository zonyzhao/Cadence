// Verilog HDL for gates, nor3 _functional

module nor3 (Y, A, B, C);
    output Y;
    input A;
    input B;
    input C;

nor (Y, A, B, C);

endmodule
