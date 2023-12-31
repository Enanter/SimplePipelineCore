module RF(rdAddr,rs1Addr,rs2Addr,Length,LS,rd,rs1,rs2,);
	input [4:0] rdAddr;	//register destination address
	input [4:0] rs1Addr;	//register source 1 address
	input [4:0] rs2Addr;	//register source 2 address
	input  Load;		//RF load operation. Load = LS[0];
	input [31:0] rd;	//register destination	data
	input clk;

	output reg [31:0] rs1;		//register source 1 data
	output reg [31:0] rs2;		//register source 2 data

	reg [31:0][31:0] regi;		//32 entries for 32bit register.

	
	assign regi[0] =32'b0;		//x0 = zero register.
	
	always @* begin
		if(Load) begin
			regi[rdAddr] = rd;
		end
		else begin
			rs1 = regi[rs1Addr];
			rs2 = regi[rs2Addr];
		end
	end

endmodule

module RF_TB();
	logic [4:0] rdAddr;	//register destination address
	logic [4:0] rs1Addr;	//register source 1 address
	logic [4:0] rs2Addr;	//register source 2 address
	logic [2:0] Length;	//Length for data of the Load and Store operation.
	logic [1:0] LS;		//RF access operation. 0= no access, 2'b01= load, 2'b10=store, 2'b11 unused.
	logic [31:0] rd;	//register destination	data
	logic Next_INST;		//Program Counter number to save current PC.
	logic DONE_ALU;
	
	logic rs1;		//register source 1 data
	logic rs2;		//register source 2 data
	logic DONE_RF;		//Register file done
	


    RF DUT (rdAddr,rs1Addr,rs2Addr,Length,LS,rd,Next_INST,DONE_ALU,rs1,rs2,DONE_RF);
	initial begin
		#10; DONE_ALU= 0; LS = 0;#10;rs1Addr = 10;rs2Addr=20; rdAddr = 30; Next_INST = 0; rd = 1000; #100;DONE_ALU= 1; Next_INST = 1;#100; Next_INST =0;
		#10; LS = 0;#10;rs1Addr = 11;rs2Addr=21; rdAddr = 31; Next_INST = 0; #1000;rd = 1000; DONE_ALU= 1;#10;
		
	end
endmodule