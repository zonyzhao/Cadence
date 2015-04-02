module BUFFX1(A,Y);
	input	A;
	output	Y;
	buf(Y,A);
endmodule

module BUFFX4(A,Y);
	input	A;
	output	Y;
	buf(Y,A);
endmodule

module DFF(CLK,DIN,DOUT);
	input	CLK,DIN;
	output	DOUT;
	not(_n3,DIN);
	not(_n1,DOUT);
	mux(_n2,CLK,_n2,_n3);
	imux(DOUT,CLK,_n2,_n1);
endmodule

module INVX1(A,Y);
	input	A;
	output	Y;
	not(Y,A);
endmodule

module INVX2(A,Y);
	input	A;
	output	Y;
	not(Y,A);
endmodule

module INVX4(A,Y);
	input	A;
	output	Y;
	not(Y,A);
endmodule

module LATCH(CLK,DIN,DOUT);
	input	CLK,DIN;
	output	DOUT;
	mux(DOUT,CLK,DIN,DOUT);
endmodule

module NAND2X1(A,B,Y);
	input	A,B;
	output	Y;
	nand(Y,A,B);
endmodule

module NOR2X1(A,B,Y);
	input	A,B;
	output	Y;
	nor(Y,A,B);
endmodule

module TRIGATEX4(A,EN,Y);
	input	A,EN;
	output	Y;
	bufif1(Y,A,EN);
endmodule

primitive mux(Y,S,A,B);
	output	Y;
	input	S,A,B;
	table	1 1 ? : 1;
		1 0 ? : 0;
		0 ? 1 : 1;
		0 ? 0 : 0;
		? 1 1 : 1;
		? 0 0 : 0;
	endtable
endprimitive

primitive imux(Y,S,A,B);
	output	Y;
	input	S,A,B;
	table	1 1 ? : 0;
		1 0 ? : 1;
		0 ? 1 : 0;
		0 ? 0 : 1;
		? 1 1 : 0;
		? 0 0 : 1;
	endtable
endprimitive

