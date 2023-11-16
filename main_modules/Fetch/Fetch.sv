

module Fetch (Sig_NextInst,rst,MAR);
	//input MBR; //memory buffer register. From Memory to decode.
	input Sig_NextInst; // AND gate[every stage finished](when every stage is finished) => signal 1 to proceed to the next PC or address.
	input rst; //positive reset
	output reg [31:0] MAR; //Memory Address Register. From Fetch to Memory. MAR <= PC
	//output Sig_FetchDone;

	reg [31:0] PC = 32'h0;

	assign MAR = PC;
	always @(posedge rst, posedge Sig_NextInst) begin
		if(rst)	begin
			PC=0;	//reset the instruction request in 0.
		end
		else begin
			if(Sig_NextInst) begin
				PC = PC+4;
			end
		end
	end
endmodule

module Fetch_tb();

	logic Sig_nextInst; // AND gate[every stage finished](when every stage is finished) => signal 1 to proceed to the next PC or address.
	logic rst; //positive reset
	logic [31:0] MAR; //Memorry Address Register. From Fetch to Memory. MAR <= PC


	Fetch DUT (Sig_nextInst,rst,MAR);

	initial begin
	   #20;
		Sig_nextInst =1;#10;
		Sig_nextInst =0;#10;	
		Sig_nextInst =1;#10;
		Sig_nextInst =0;#10;	
		Sig_nextInst =1;#10;
		Sig_nextInst =0;#10;
		rst = 0; #10;
		Sig_nextInst =1;#10;
		Sig_nextInst =0;#10;	
		Sig_nextInst =1;#10;
		Sig_nextInst =0;#10;
		rst = 1; #10;
		Sig_nextInst =1;#10;
		Sig_nextInst =0;#10;	
		Sig_nextInst =1;#10;
		Sig_nextInst =0;#10;
		rst = 0; #10;
		Sig_nextInst =1;#10;
		Sig_nextInst =0;#10;	
		Sig_nextInst =1;#10;
		Sig_nextInst =0;#10;
		rst =1; Sig_nextInst =1;#10;  //race condition check.
		Sig_nextInst =0;#10;
		Sig_nextInst =1;#10;
		Sig_nextInst =0;#10;	
		Sig_nextInst =1;#10;
		Sig_nextInst =0;#10;
	end
endmodule