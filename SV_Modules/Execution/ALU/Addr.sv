Module Addr(en,s1,s2,res_add);
	input en;	//enable
	input [31:0]s1,s2;
	output res_add;

	assign res_add = en? s1+s2: 32'h0000;
endmodule