//Verilog HDL for "16nm", "inv_1xT" "functional"


module inv_1x( Y, A );

  output Y;
  input A;
	not(Y,A);
endmodule
