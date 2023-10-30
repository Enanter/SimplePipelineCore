//set x0 as Zero register x1 for sp x2 for?
//needs to implement a length limiter.
//Yet, very Basic RF. It does not follow MicroArch 0.1.2.

//should I make SL signal to lock for write?(latch)
//is this need done signal?
//does alu operation needs permission to write??
module RF32x32(rd,clk,rst,LoadRF,rdAddr,rs1Addr,rs2Addr,rs1,rs2) begin
	input [31:0] rd;
	input clk;
	input rst;	//positive reset
	input LoadRF;	//load operation. LoadRF = LS[0]
	input [4:0]rdAddr;	//
	input [4:0]rs1Addr;
	input [4:0]rs2Addr;
	output [31:0]rs1;
	output [31:0]rs2;

	logic [31:0] entrySelection;

	wire [31:0][31:0] outputConnection;	//[entry number][data bits] data

	CellRegi32 regi(32'b0,clk,0,0,32'b0);

	genvar i;	// i = 32 general registers except register 0.
	generate
		for(i=1; i<31; i++) begin

			if(LoadRF == i) begin		// 5bits to single bits decoder
				assign entrySelection[i] = 1;
			end
			else begin
				assign entrySelection[i] = 0;
			end

			CellRegi32 regi(rd,clk,rst,entrySeletion[i]&&LoadRF,outputConnection[i]);
			
		end
	endgeneration

	assign rs1 = outputConnection[rs1Addr];
	assign rs2 = outputConnection[rs2Addr];

endmodule


module RF32x32_tb();
	input [31:0] rd;
	input clk;
	input rst;	//positive reset
	input LoadRF;	//load operation. LoadRF = LS[0]
	input [4:0]rdAddr;	//
	input [4:0]rs1Addr;
	input [4:0]rs2Addr;
	output [31:0]rs1;
	output [31:0]rs2;


	RF32x32 DUT(rd,clk,rst,LoadRF,rdAddr,rs1Addr,rs2Addr,rs1,rs2);

	always @* begin
		clk = 0; #10;
		clk = 1; #10;
	end

	inital begin
		rst=1;#25;rst=0;#20;	//prep
		rd= 32'h9; LoadRF = 0; rdAddr = 5'h10; rs1Addr = 5'h10; rs2Addr = 5'h11;#20;	//no saving but rd exist.
		rd= 32'hA; LoadRF = 1; rdAddr = 5'h10; rs1Addr = 5'h10; rs2Addr = 5'h11;#20;	//saving rd to the address. read rd
				

	end
endmodule
