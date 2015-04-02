// Verilog HDL for gates, nor2 _functional

module nor2 (Y, A, B);
    output Y;
    input A;
    input B;

nor (Y, A, B);

endmodule
