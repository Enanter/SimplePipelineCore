module CellRegi32(d,clk,rst,en,Q) begin
	input [31:0] d; //32bit data
	input clk;
	input rst;	//pos reset
	input en;
	output reg [31:0] Q;

	reg [31:0] register;

	always_ff @(posedge clk) begin
		if(!rst) begin
			if(en) Q = d;
		end
		else if(rst) begin
			Q = 32'b0;
		end
	end
endmodule