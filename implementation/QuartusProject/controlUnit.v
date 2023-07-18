	//This control unit is not built for RISC-V
//you will need to make substantial edits for it to work 

module controlUnit (immShift,
							op,
							cmpRst,
							ALUOp,
							writeEnable,
							numBits,
							memAddrSel,
							ALUSrcA,
							ALUSrcB,
							memEnableRead,
							memEnableWrite,
							PCWriteEnable,
							PCSource,
							memToReg,
							DOrS,
							IRWrite,
							regDataWrite,
							memAddrSet,
							  
						  
						   //instruction,
						   CLK,
						   Reset
						   );
//
//		input [3:0] op;
//		input [1:0] cmpRst;
//		input CLK;
//		input Reset;
		output reg [1:0] immShift;
		output reg [2:0] ALUOp;
		output reg writeEnable;
		output reg [1:0] numBits;
		output reg memAddrSel;
		output reg ALUSrcA;
		output reg ALUSrcB;
		output reg memEnableRead;
		output reg memEnableWrite;
		output reg PCWriteEnable;
		output reg PCSource;
		output reg memToReg;
		output reg DOrS;
		output reg IRWrite;
		output reg [2:0] regDataWrite;
		output reg memAddrSet;
	

   //-- You can add these state registers to the IO pins in the module
   //-- declaration and uncomment the output statements here if you want, but
   //-- Quartus won't identify this as a State Machine with the state
   //-- registers as inputs or outputs.

   input wire CLK;
   input wire Reset;
	input wire [3:0] op;
	input wire [1:0] cmpRst;
	//input wire [15:0] instruction;

	
	
	
	
//   reg [1:0]    ALUOp;
//   reg [1:0]    PCSource;
//   reg [1:0]    ALUSrcB;
//   reg          ALUSrcA;
//   reg          MemtoReg;
//   reg          RegDst;
//   reg          RegWrite;
//   reg          MemRead;
//   reg          MemWrite;
//   reg          IorD;
//   reg          IRWrite;
//   reg          PCWrite;
//   reg          PCWriteCond;
//	reg [1:0] immShift;
//	reg [2:0] ALUOp;
//	reg writeEnable;
//	reg [1:0] numBits;
//	reg memAddrSel;
//	reg [1:0] ALUSrcA;
//	reg [1:0] ALUSrcB;
//	reg memEnableRead;
//	reg memEnableWrite;
//	reg PCWriteEnable;
//	reg PCSource;
//	reg memToReg;
//	reg DOrS;
//	reg IRWrite;
//	reg regDataWrite;
//	reg memAddrSet;

   //state flip-flops
   reg [4:0]    current_state;
   reg [4:0]    next_state;
	
	//keep track of inst
	reg [31:0] numInsts;

   //state definitions
	parameter FETCH = 0;
	parameter DECODE = 1;
	parameter LUI = 2;
	parameter RALU = 3;
	parameter ALUWrite = 4;
	parameter ISelect = 5;
	parameter IALU = 6;
	parameter TST = 7;
	parameter BPause = 8;
	parameter BWrite = 9;
	parameter MemBase = 10;
	parameter LWRead = 11;
	parameter LWWrite = 12;
	parameter SW = 13;
	parameter JALR = 14;
	parameter TSTWait = 15;
	parameter ALUWriteTwo = 16;
	parameter LUI2 = 17;
	parameter LUIDUMMY = 18;
	parameter FETCHWait = 19;
	parameter TSTWait2 = 20;
	parameter JALR2 = 21;
	parameter LW3 = 22;
	parameter resetState = 23;
	
	
	reg [1:0] cmpRstReg;
	
	initial begin
	
	immShift = 0;
	ALUOp = 0;
	writeEnable = 0;
	numBits = 0;
	memAddrSel = 0;
	ALUSrcA = 0;
	ALUSrcB = 0;
	memEnableRead = 0;
	memEnableWrite = 0;
	PCWriteEnable = 0;
	PCSource = 0;
	memToReg = 0;
	DOrS = 0;
	IRWrite = 0;
	regDataWrite = 0;
	memAddrSet = 0;
	//force fetch as first op
	current_state = TSTWait;
	next_state = TSTWait;
	
	end

   //register calculation
   always @ (posedge CLK, posedge Reset)
     begin
        if (Reset)begin 
				numInsts = 0;
            current_state = resetState;
//
				//force fetch as first op
				//current_state = TSTWait;
				//next_state = TSTWait;
        end else begin
          current_state = next_state;
			end
     end


   //OUTPUT signals for each state (depends on current state)
   always @ (current_state)
		
     begin
//			$display("current state: %d",current_state);
        //Reset all signals that cannot be don't cares
			immShift = 0;
			writeEnable = 0;
			numBits = 0;
			memEnableRead = 0;
			memEnableWrite = 0;
			PCWriteEnable = 0;
			PCSource = 0;
			memToReg = 0;
        
        case (current_state)
		  
				resetState:
					begin
						immShift = 0;
						ALUOp = 0;
						writeEnable = 0;
						numBits = 0;
						memAddrSel = 0;
						ALUSrcA = 0;
						ALUSrcB = 0;
						memEnableRead = 0;
						memEnableWrite = 0;
						PCWriteEnable = 0;
						PCSource = 0;
						memToReg = 0;
						DOrS = 0;
						IRWrite = 0;
						regDataWrite = 0;
						memAddrSet = 0;
					end
				FETCH:
					begin
						numInsts = numInsts + 1;
						//$display("%d",numInsts);
//						$display("cmprstreg : %b",cmpRstReg);
						memAddrSel = 0;
						memEnableRead = 1;
						IRWrite = 1;
						PCWriteEnable = 0;
						memEnableWrite = 0;
						writeEnable = 0;
					end
				FETCHWait:
					begin
						IRWrite = 0;
					end
				DECODE:
					begin
						immShift = 'b01;
						ALUOp = 'b000;
						ALUSrcA = 0;
						ALUSrcB = 1;
						numBits = 'b11;
						PCWriteEnable = 1;
						PCSource = 0;
						IRWrite = 0;
						memEnableRead = 0;
					end
					
				LUI:
					begin
						immShift = 'b10;
						numBits = 'b10;
						PCWriteEnable = 0;
						ALUSrcA = 1;
						DOrS = 0;
					end
				LUI2:
					begin
						regDataWrite = 'b011;
						writeEnable = 1;
					end
				RALU:
					begin
						regDataWrite = 'b000;
						case(op)
								'b0000://add
									begin
										ALUOp = 0;
									end
								'b0001://sub
									begin
										ALUOp = 1;
									end//xor
								'b0010:
									begin
										ALUOp = 4;
									end
								'b0011://or
									begin
										ALUOp = 3;
									end
								'b0100://and
									begin
										ALUOp = 2;
									end
								'b1101://srli
									begin
										ALUOp = 6;
									end
								'b1110://slli
									begin
										ALUOp = 5;
									end
								'b0100://addi
									begin
										ALUOp = 0;
									end
						endcase
						ALUSrcA = 1;
						ALUSrcB = 0;
						PCWriteEnable = 0;
						DOrS = 0;
					end
					
				ALUWrite:
					begin
						writeEnable = 1;
					end
					
				ALUWriteTwo:
					begin
//						regDataWrite = 'b011;
//						writeEnable = 1;
					end
				
				ISelect:
					begin
						DOrS = 1;
						PCWriteEnable = 0;
						immShift = 'b00;
						regDataWrite = 'b000;
						case(op)
								'b0000://add
									begin
										ALUOp = 0;
									end
								'b0001://sub
									begin
										ALUOp = 1;
									end//xor
								'b0010:
									begin
										ALUOp = 4;
									end
								'b0011://or
									begin
										ALUOp = 3;
									end
								'b0100://and
									begin
										ALUOp = 2;
									end
								'b1101://srli
									begin
										ALUOp = 6;
									end
								'b1110://slli
									begin
										ALUOp = 5;
									end
								'b0100://addi
									begin
										ALUOp = 0;
									end
						endcase
						numBits = 'b10;
						ALUSrcA = 1;
					end
					
				TST:
					begin
						regDataWrite = 'b100;
						PCWriteEnable = 0;
						DOrS = 0;
						ALUSrcA = 1;
						ALUSrcB = 0;
					end
				TSTWait2:
					begin
						writeEnable = 1;
						cmpRstReg = cmpRst;
//						$display("cmprst : %b",cmpRst);
					end
				TSTWait:
					begin
						memAddrSel = 0;
						PCWriteEnable = 0;
						//keeps all same signals as tst so no change
					end
					
				BPause:
					begin
						PCWriteEnable = 0;
					end
					
				BWrite:
					begin
						PCWriteEnable = 1;
						PCSource = 1;
					end
					
				MemBase:
					begin
						immShift = 'b00;
						ALUOp = 'b000;
						ALUSrcA = 1;
						ALUSrcB = 1;
						numBits = 'b01;
						PCWriteEnable = 0;
						regDataWrite = 'b010;
					end	
				SW:
					begin
						memAddrSel = 1;
						memEnableWrite = 1;
						memEnableRead = 0;
					end
					
				JALR:
					begin
						writeEnable = 1;
						DOrS = 0;
					end
				JALR2:
					begin
						writeEnable = 0;
						PCSource = 1;
						PCWriteEnable = 1;
					end
					
				LWWrite:
					begin
						regDataWrite = 'b001;
						memEnableRead = 1;
						memAddrSel = 1;
					end
					
				LWRead:
					begin
						memAddrSel = 1;
					end
				LW3:
					begin
						memEnableRead = 0;
						memAddrSel = 0;
						memEnableRead = 1;
					end
        
          default:
            begin 
//					$display ("not implemented"); 
				end
          
        endcase
     end
	  
	  
	  
	  
	  

	 always @ (current_state, next_state, op, cmpRst)
		begin
//			$display("The current state is %d", current_state);
			
			
				case (current_state)
				
					resetState:
						begin
						next_state = TSTWait;
						end
					FETCH:
						begin
							next_state = FETCHWait;
						end
					FETCHWait:
						begin
							next_state = DECODE;
						end
					DECODE:
						begin
//							$display("here op: %d",op);
							case (op)
								'b1111: //lui
									begin
										next_state = LUI;
									end
								'b0000,
								'b0001,
								'b0010,
								'b0011,
								'b0100: //r type
									begin
										next_state = RALU;
									end
								'b1100,
								'b1101,
								'b1110: //slli, srli, addi
									begin
										next_state = ISelect;
									end
								'b0101: //TST
									begin
										next_state = TST;
									end
								'b1000,
								'b1010,
								'b1001: //branches (wait a cycle)
									begin
										case(op)
											'b1000: //beq
												begin
													if(cmpRstReg == 'b00)begin
														next_state = BWrite;
													end else begin
														next_state = TSTWait;
													end
												end
											'b1001: //bge
												begin
													if(cmpRstReg == 'b00 || cmpRstReg == 'b01)begin
														next_state = BWrite;
													end else begin
														next_state = TSTWait;
													end
												end
											'b1010: //blt
												begin
													if(cmpRstReg == 'b10)begin
														next_state = BWrite;
													end else begin
														next_state = TSTWait;
													end
												end
											
										endcase										
									end
								'b0110,
								'b0111,
								'b1011: //lw/sw/jalr
									begin
										next_state = MemBase;
									end
								
							endcase
						end
						
					LUI:
						begin
							next_state = LUIDUMMY;
						end
					LUIDUMMY:
						begin
							next_state = LUI2;
						end
					LUI2:
						begin
							next_state = TSTWait;
						end
						
					RALU:
						begin
							next_state = ALUWriteTwo;
						end
						
					ALUWrite:
						begin
							next_state = FETCH;
						end
					ALUWriteTwo:
						begin
							next_state = ALUWrite;
						end
					
					ISelect:
						begin
							next_state = ALUWriteTwo;
						end
						
					TST:
						begin
							next_state = TSTWait2;
						end
					TSTWait:
						begin
							next_state = FETCH;
						end
					TSTWait2:
						begin
							next_state = FETCH;
						end
						
					BPause:
						begin
//							//TODO: PUT cmpRstReg logic with opcodes here
//							case(op)
//								'b1000: //beq
//									begin
//										if(cmpRstReg == 'b00)begin
//											next_state = BWrite;
//										end else begin
//											next_state = FETCH;
//										end
//									end
//								'b1001: //bge
//									begin
//										if(cmpRstReg == 'b00 || cmpRstReg == 'b01)begin
//											next_state = BWrite;
//										end else begin
//											next_state = FETCH;
//										end
//									end
//								'b1010: //blt
//									begin
//										if(cmpRstReg == 'b10)begin
//											next_state = BWrite;
//										end else begin
//											next_state = FETCH;
//										end
//									end
//								
//							endcase
							next_state = TSTWait;
						end
						
					BWrite:
						begin
							
							next_state = BPause;
						end
						
					MemBase:
						begin
							case (op)
								'b0110: //lw
									begin
										next_state = LWRead;
									end
								'b0111: //sw
									begin
										next_state = SW;
									end
								'b1011: //jalr
									begin
										next_state = JALR;
									end
							endcase
						end
					SW:
						begin
							next_state = BPause;
						end

					JALR:
						begin
							next_state = JALR2;
						end
					JALR2:
						begin
							next_state = TSTWait;
						end
					
					LWWrite:
						begin
							next_state = LW3;
						end
					LW3:
						begin
							next_state = ALUWrite;
						end
					LWRead:
						begin
							next_state = LWWrite;
						end
					default:
						begin
							next_state = FETCH;
						end
				
				endcase
//			$display("After the tests, the next_state is %d", next_state);
		end
endmodule