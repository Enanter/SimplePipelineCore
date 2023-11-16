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
module Decoder(clk,inst,rst,nxt,oper,rdAddr,rs1Addr,rs2Addr,imm,DONE_Decoder,LS);
	//input clk;
	input [31:0]inst;	//instruction from Fetch
	input rst;		//positive reset
	input nxt;		//next instruction

	output reg [6:0]oper;	//internal operation designation
	output reg [4:0]rdAddr;		//register destination
	output reg [4:0]rs1Addr,rs2Addr;	//register sources
	output reg [11:0]imm;	//immediate value
	output reg DONE_Decoder;
	output reg [1:0] SL;	//store load = SL={Store,Load}

	logic en;		//enable to hold output

	parameter ALU=5'b0_1100,ALUImm=5'b0_0100,Load=5'b0_0000,Store=5'b0_1000,Jalr=5'b1_1001,Jal=5'b1_1011,AUIPC=5'b0_0101,LUI=5'b0_1101,FENCE=5'b0_0011,CSRECB='b1_1100,Branch=7'b1_1000;	//opcode-inst[6:2] opcode types

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

	always @(rst or inst or en) begin	//latch; hold outputs when en is 1.
		DONE_Decoder= 0; //&& DONE_StageCheck; to hold decoder for the other 
		//RV32I instruction
		if(rst) begin		//positive reset
			oper <= 0;	
			rd <= 0;	
			rs1Addr <=0;
			rs2Addr <=0;	
			imm <=0;	
			SL<=0;
			DONE<=0;
		end
		else begin			//! positive reset == no reset
			if(en) begin		//enable is high, output changes
				case(inst[6:2])		//types of operations

					ALU: begin	//R-type ALU operations
						//same type shares the same instruction structure. set registers as soon as possible, so the register file unit does not need to wait.
						rdAddr <= inst[11:7];		
						rs1Addr <= inst[19:15];
						rs2Addr <= inst[24:20];

						case({inst[14:13],inst[31:25]})	//operations
							{3'b000,7'b000_0000}:	oper <= 7'd1;	//{add|sub, first selection}=add
							{3'b000,7'b010_0000}:	oper <= 7'd2;	//{add|sub, second selection}=sub
							{3'b001,7'b000_0000}:	oper <= 7'd3;	//{SLL, 0}= Shift Left Logical (multiply)
							{3'b010,7'b000_0000}:	oper <= 7'd4;	//{SLT, 0}= signed number comparison
							{3'b011,7'b000_0000}:	oper <= 7'd5;	//{SLTU, 0}= unsigned number comparison
							{3'b100,7'b000_0000}:	oper <= 7'd6;	//{XOR, 0}= XOR
							{3'b101,7'b000_0000}:	oper <= 7'd7;	//{SRL, first selection}= Shift Right Logical(divide)
							{3'b101,7'b010_0000}:	oper <= 7'd8;	//{SRL, second selection}= Shift Right Arithmetic(divide)
							{3'b110,7'b000_0000}:	oper <= 7'd9;	//{OR, 0}= OR
							{3'b111,7'b000_0000}:	oper <= 7'd10;	//{AND, 0}= AND
							default: oper <= 7'd0;
						endcase
					end
	
					ALUImm:	begin	//I-type ALU operations
						rdAddr <= inst[11:7];
						rs1Addr <= inst[19:15];
						immAddr <= inst[31:20];
						//SL <=2'b01;
					
						case(inst[14:12])
							3'b000:	oper <= 7'd11;	//add immediate,, MV rd rs1 = ADDI rd rs1 0,, NOP = ADDI x0,x0,0
							3'b010: oper <= 7'd12;	//set less than immediate signed
							3'b011: oper <= 7'd13;	//set less than immediate unsigned,,SLTIU rd, rs1, 1 sets rd to 1 if rs1 equals zero, otherwise sets rd to 0 (assembler pseudo-op SEQZ rd, rs).
							3'b100: oper <= 7'd14;	//XOR immediate,, xori rd, rs1, -1 = NOT rd, rs = logical inversion of register rs1
							3'b110: oper <= 7'd15;	//OR immediate
							3'b111: oper <= 7'd16;	//AND immediate
							//imm[4:0] = shamt, imm[11:5] = funct 7
							3'b001:	oper <= 7'd17;	//shift left logical immediate
							3'b101: oper <= 7'd18;	//shift right logical immediate
							3'b101: oper <= 7'd19;	//shift right arithmetic immediate
							default: oper <= 7'd0;
						endcase
					end

					Load:	begin	//I-type Load operations
						rdAdder <= inst[11:7];	//destination
						rs1Adder <= inst[19:15];	//base
						//rs2 <= 5'b0;		//does not use
						imm <= inst[31:20];	//offset
						case(inst[14:12])
							3'b000:	begin	//LB-load 8bit from L1d
							end
							3'b001:	begin	//LH-load 16bit from L1d and sign-extends to 32 bits before storing in register destination
							     rdAdder <= L1dload(Regi(rs1Adder)+imm)&&32'h0000ffff
							end
							3'b010:	begin	//LW-load 32bit from L1d into register destination
							     rdAdder <= L1dload(Regi(rs1Adder)+imm)
							end
							3'b100:	begin	//LBU-load 8bit unsigned
							end
							3'b101:	begin	//LHU-load 16bit from L1d and zero-extends to 32 bits before storing in register destination
							     rdAdder <= (L1dload(Regi(rs1Adder)+imm)&&32'h0000ffff) ||32'h11110000
							end
							default: oper=7'd0;
						endcase
					end
	
					Store:	begin	//I-type Store operations
						//rd <= 5'b0;			
						rs1 <= inst[19:15];		//base
						rs2 <= inst[24:20];		//source
						imm <= {inst[31:25],inst[11:7]};	//offset
				
						case(inst[14:12])
							3'b000: SL = 2'b10;	//SB= store LSB 8bits from rs2 to L1d[rs1]
							3'b001:	SL = 2'b10;	//SH= store LSB 16bits from rs2 to L1d[rs1]
							3'b010:	SL = 2'b10;	//SW= store LSB 32bits from rs2 to L1d[rs1]
						endcase
					end	
	
					Jal:	begin	//Jump and link
					//push and return address onto a Return-Address Stack only when rd = x1/x5
						rd = inst[11:7];	
						rs1 = 5'bx;
						rs2 = 5'bx;
				        imm		//extend immediate
				
					end

					Jalr: begin	//Jump and link
					/*link is true when the register is either x1 or x5->>
					rd=!link,rs1=!link =>RAS action: none
					rd=!link,rs1=link =>RAS action: pop
					rd=link,rs1=!link =>RAS action: push
					rd=link,rs1=link,rs1!=rd =>RAS action: push and pop
					rd=link,rs=link,rs1=rd =>RAS action: push
					*/
						rd = inst[11:7];	
						rs1 = inst[19:15];
						imm= inst[31:20];			
					end
					Branch:	begin	//B-type: branch operations
						rd = 5'bx;
						rs1 = inst[19:15];
						rs2 = inst[24:20];
						imm={inst[31],inst[7],inst[30:25],inst[11:8]}
						case(inst[14:12])
							3'b000:		//BEQ
							3'b001:		//BNE
							3'b100:		//BLT
							3'b101:		//BGE
							3'b110:		//BLTU
							3'b111:		//BGEU
							default: oper = 7'd0;
						endcase
					LUI:	begin	//load upper immediate
				*	// needs extended imm-inst[31:12]
					end
					AUIPC:	begin	//add upper immiate to pc
				*	// needs extended imm-inst[31:12]
					end
					FENCE:	begin	//memory model
				
						case(inst[14:12]) begin
							3'b000: begin	//FENCE
								rd <= inst[11:7];
								rs1<= inst[19:15];
								rs2<=5'bx;
							end
							3'b001:		//FENCE.I
								rd <= 5'b0;
								rs1 <= 5'b0;
								rs2 <= 5'b0;
								imm <=12'b0;
						
							default: oper = 7'b0;
						endcase				
					end
					CSRECB:	begin	//Control and Status Register Instructions & Environment Call and Breakpoints
					default: begin	
						oper <= 0;
						rd <= 0;
						rs1 <=0;
						rs2 <=0;
						imm <=0;
						SL <=0;
						DONE_Decoder<=0;

					end
	
				endcase
			end
		end
	end
endmodule