// Verilog HDL for basic_gates, trinv1 _functional

module trinv1 (Y, A, EN);
    output Y;
    input A;
    input EN;

notif1 (Y, A, EN);

endmodule
