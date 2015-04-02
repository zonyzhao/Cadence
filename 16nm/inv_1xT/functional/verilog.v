//Verilog HDL for "16nm", "inv_1xT" "functional"


module inv_1xT ( Y, A );

  output Y;
  input A;
	not(Y,A);
endmodule
