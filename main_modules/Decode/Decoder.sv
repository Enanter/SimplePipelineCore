/*
Oct 5,2023
Archtecture_Diagram0.1
	-no Reorder buffer, no out-of-order.




*/

/*
logical shift - add 0 to do the shift
arithmetic shift- move the original sign bit into the vacated bits to do the shift
zero-extend-
sign-extend-
*/


//idea: there can be relationship between instructions. if 2 or more instructions are related, and frequently used 
//?between instructions, should I reset registers in Decode?
module Decoder(inst,rst,nxt,oper,rdAddr,rs1Addr,rs2Addr,imm,DONE_Decode,SL);
	//input clk;
	input [31:0]inst;	//instruction from Fetch
	input rst;		//positive reset
	input nxt;		//next instruction signal from other modules, it will drive en.

	output [5:0]oper;	//internal operation designation
	output [4:0]rdAddr;		//register destination
	output [4:0]rs1Addr,rs2Addr;	//register sources
	output [11:0]imm;	//immediate value
	output DONE_Decode;
	output [1:0] SL;	//store load = SL={Store,Load}
  
	parameter ALU=5'b0_1100,ALUImm=5'b0_0100,Load=5'b0_0000,Store=5'b0_1000,Jalr=5'b1_1001,Jal=5'b1_1011,AUIPC=5'b0_0101,LUI=5'b0_1101,FENCE=5'b0_0011,CSRECB='b1_1100,Branch=7'b1_1000;	//opcode-inst[6:2] opcode types

    logic en;		//enable to hold output
    
    reg [5:0] operReg = 6'b00_0000;
    reg [4:0]rdAddrReg =5'b0_0000;
    reg [4:0]rs1AddrReg =5'b0_0000;
    reg [4:0]rs2AddrReg =5'b0_0000;
    reg [11:0]immReg=12'h000;
    reg DONE_DecodeReg = 1'b0;
    reg [1:0] SLReg =2'b0;
    
    assign en = !nxt;
    assign oper=operReg;
    assign rdAddr = rdAddrReg;
    assign rs1Addr = rs1AddrReg;
    assign rs2Addr = rs2AddrReg;
    assign imm = immReg;
    assign DONE_Decode = DONE_DecodeReg;
    assign SL = SLReg;
/*
	always @(rst or nxt or DONE) begin
		if(rst) begin
			en <=0;
			DONE_Decoder <=0;
		end
		else begin
			if(nxt) begin
				DONE_Decoder<= 0;
				en<=0;
			end
			else	begin
				if(!DONE) begin
				en <=1;
				end
			end
		end
	end
*/
	always @(rst or inst or en) begin	
	//Decode doesnt have send the mircrocode at the end of always blocks.
	//latch; hold outputs when en is 1. en is the signal from ALU or later modules, to prevent those modules are overpopulated.
		DONE_DecodeReg= 0; //&& DONE_StageCheck; to hold decoder for the other 
		//RV32I instruction
		if(rst) begin		//positive reset
			operReg = 0;	
			rdAddrReg = 0;	
			rs1AddrReg =0;
			rs2AddrReg =0;	
			immReg =0;	
			SLReg = 0;
		end
		else begin			//! positive reset == no reset
			if(en) begin		//enable is high, output changes
				case(inst[6:2])		//types of operations

					ALU: begin	//R-type ALU operations
						rdAddrReg = inst[11:7];		
						rs1AddrReg = inst[19:15];
						rs2AddrReg = inst[24:20];

						case({inst[14:13],inst[31:25]})	//operations
							{3'b000,7'b000_0000}:	operReg = 6'd1;	//{add|sub, first selection}=add
							{3'b000,7'b010_0000}:	operReg = 6'd2;	//{add|sub, second selection}=sub
							{3'b001,7'b000_0000}:	operReg = 6'd3;	//{SLL, 0}= Shift Left Logical (multiply)
							{3'b010,7'b000_0000}:	operReg = 6'd4;	//{SLT, 0}= signed number comparison
							{3'b011,7'b000_0000}:	operReg = 6'd5;	//{SLTU, 0}= unsigned number comparison
							{3'b100,7'b000_0000}:	operReg = 6'd6;	//{XOR, 0}= XOR
							{3'b101,7'b000_0000}:	operReg = 6'd7;	//{SRL, first selection}= Shift Right Logical(divide)
							{3'b101,7'b010_0000}:	operReg = 6'd8;	//{SRL, second selection}= Shift Right Arithmetic(divide)
							{3'b110,7'b000_0000}:	operReg = 6'd9;	//{OR, 0}= OR
							{3'b111,7'b000_0000}:	operReg = 6'd10;	//{AND, 0}= AND
							default: operReg = 7'd0;
						endcase
					end
	
					ALUImm:	begin	//I-type ALU operations
						rdAddrReg = inst[11:7];
						rs1AddrReg = inst[19:15];
						immReg = inst[31:20];
					
						case(inst[14:12])
							3'b000:	operReg = 7'd11;	//add immediate,, MV rd rs1 = ADDI rd rs1 0,, NOP = ADDI x0,x0,0
							3'b010: operReg = 7'd12;	//set less than immediate signed
							3'b011: operReg = 7'd13;	//set less than immediate unsigned,,SLTIU rd, rs1, 1 sets rd to 1 if rs1 equals zero, otherwise sets rd to 0 (assembler pseudo-op SEQZ rd, rs).
							3'b100: operReg = 7'd14;	//XOR immediate,, xori rd, rs1, -1 = NOT rd, rs = logical inversion of register rs1
							3'b110: operReg = 7'd15;	//OR immediate
							3'b111: operReg = 7'd16;	//AND immediate
							//imm[4:0] = shamt, imm[11:5] = funct 7
							3'b001:	operReg = 7'd17;	//shift left logical immediate
							3'b101: operReg = 7'd18;	//shift right logical immediate
							3'b101: operReg = 7'd19;	//shift right arithmetic immediate
							default: operReg = 7'd0;
						endcase
					end
/*
					Load:	begin	//I-type Load operations
						rdAddr = inst[11:7];	//destination
						rs1Addr = inst[19:15];	//base
						//rs2 <= 5'b0;		//does not use
						imm <= inst[31:20];	//offset
						case(inst[14:12])
							3'b000:	begin	//LB-load 8bit from L1d
							end
							3'b001:	begin	//LH-load 16bit from L1d and sign-extends to 32 bits before storing in register destination
							     rdAddr <= L1dload(Regi(rs1Addr)+imm)&&32'h0000ffff;
							end
							3'b010:	begin	//LW-load 32bit from L1d into register destination
							     rdAddr <= L1dload(Regi(rs1Addr)+imm);
							end
							3'b100:	begin	//LBU-load 8bit unsigned
							end
							3'b101:	begin	//LHU-load 16bit from L1d and zero-extends to 32 bits before storing in register destination
							     rdAddr <= (L1dload(Regi(rs1Addr)+imm)&&32'h0000ffff) ||32'h11110000;
							end
							default: oper=7'd0;
						endcase
					end
	
					Store:	begin	//I-type Store operations
						//rd <= 5'b0;			
						rs1 = inst[19:15];		//base
						rs2 = inst[24:20];		//source
						imm = {inst[31:25],inst[11:7]};	//offset
				
						case(inst[14:12])
							3'b000: SL = 2'b10;	//SB= store LSB 8bits from rs2 to L1d[rs1]
							3'b001:	SL = 2'b10;	//SH= store LSB 16bits from rs2 to L1d[rs1]
							3'b010:	SL = 2'b10;	//SW= store LSB 32bits from rs2 to L1d[rs1]
						endcase
					end	
	*/
					
	
				endcase
			end
		end
	end
endmodule

module Decoder_tb();
    logic [31:0]inst;	//instruction from Fetch
	logic rst;		//positive reset
	logic nxt;		//next instruction

	logic [5:0]oper;	//internal operation designation
	logic [4:0]rdAddr;		//register destination
	logic [4:0]rs1Addr,rs2Addr;	//register sources
	logic [11:0]imm;	//immediate value
	logic DONE_Decoder;
	logic [1:0] SL;	//store load = SL={Store,Load}

    Decoder DUT (inst,rst,nxt,oper,rdAddr,rs1Addr,rs2Addr,imm,DONE_Decoder,SL);
 
    initial begin
    
    #20;
    nxt = 0;
    inst = 32'h002081b3;#10;
    inst = 32'h003091b3;#20;
    #20;
    rst = 1'b1;#20;
    inst = 32'h002081b3;#10;
    rst = 1'b0;#20;
    inst = 32'h002081b3;#10;
    inst = 32'h3e808193;#10;
    end
endmodule