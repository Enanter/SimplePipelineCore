//?should PC be at least 23+1(1mb+sign bit) bits to support that jump can be +-1mb?

/*0.1: just load instructions from RAM
order of steps:	
^Fetch=	MAR<=PC				CIR<=MDR^=>Decode
^DRAM=		MDR<=Inst[MAR][31:0]^
^accumulator				CDR<=MDR^
*/
//Program Counter override for B,J types.

//0.x: load instructions to L1i from RAM if L1i is empty, cache miss-> update L1i.
//0.x': multiple instructions fetching.

module Fetch (PC,clk,rst,inst,DONE_Fetch);
	input [31:0]PC;
	input clk;
	input rst;		//positive reset
	input [31:0] inst;
	output reg [31:0]Req_Addr;
	output reg DONE_Fetch;
	output reg [31:0] CIR;	//Current Instruction Register in a buffer
	output reg [31:0] CDR;	//Current Data Register in


	reg [31:0] MAR; 	//Memory Address Register
	reg [31:0] MDR; 	//Memory Data Register

	
	always_comb  begin
		DONE_Fetch = 0;
		if(!rst) begin
			MAR = PC;	//in
			MDR = Inst;
			if(MDR[5:0] == 5'b11111) CDR = MDR;	//let's say data in RAM starts with 5'b11111
			else CIR = MDR;
			DONE_Fetch=1;
		end
		else begin
			MAR <=0;
			MDR <=0;
			Req_Addr <=0;
			DONE_Fetch <=1;
		end
	end
endmodule


module Fetch_tb();

	input [31:0]PC;
	input clk;
	input rst;		//positive reset
	input [31:0] inst;
	output reg [31:0]Req_Addr;
	output reg DONE_Fetch;
	output reg [31:0] CIR;	//Current Instruction Register
	output reg [31:0] CDR;	//Current Data Register