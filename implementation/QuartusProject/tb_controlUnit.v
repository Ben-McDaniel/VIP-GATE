module tb_controlUnit();

reg [3:0] input_opcode;
reg [1:0] input_cmpRst;
reg clockReg;
reg resetReg;


wire [1:0] out_immShift;
wire [2:0] out_ALUOp;
wire out_writeEnable;
wire [1:0] out_numBits;
wire out_memAddrSel;
wire [1:0] out_ALUSrcA;
wire [1:0] out_ALUSrcB;
wire out_memEnableRead;
wire out_memEnableWrite;
wire out_PCWriteEnable;
wire out_PCSource;
wire out_memToReg;
wire out_DOrS;
wire out_IRWrite;
wire [2:0] out_regDataWrite;
wire out_memAddrSet;

controlUnit UTT(
						.immShift(out_immShift),
						.op(input_opcode),
						.cmpRst(input_cmpRst),
						.ALUOp(out_ALUOp),
						.writeEnable(out_writeEnable),
						.numBits(out_numBits),
						.memAddrSel(out_memAddrSel),
						.ALUSrcA(out_ALUSrcA),
						.ALUSrcB(out_ALUSrcB),
						.memEnableRead(out_memEnableRead),
						.memEnableWrite(out_memEnableWrite),
						.PCWriteEnable(out_PCWriteEnable),
						.PCSource(out_PCSource),
						.memToReg(out_memToReg),
						.DOrS(out_DOrS),
						.IRWrite(out_IRWrite),
						.regDataWrite(out_regDataWrite),
						.memAddrSet(out_memAddrSet),
						
						.CLK(clockReg),
						.Reset(resetReg)
					);



parameter HALF_PERIOD = 50;

integer failures = 0;

initial begin
    clockReg = 0;
    forever begin
        #(HALF_PERIOD);
        clockReg = ~clockReg;
    end
end



//tests
initial begin
	#(2*HALF_PERIOD);
	resetReg = 1;
	#(2*HALF_PERIOD);
	resetReg = 0;
	//#(2*HALF_PERIOD);
	
	//Test: slli
	#(2*HALF_PERIOD);
	resetReg = 1;
	#(2*HALF_PERIOD);
	resetReg = 0;
	
	input_opcode = 'b1110;
	input_cmpRst = 0;
	#(2*HALF_PERIOD);
	$display("Fetch SLLI");
	#(2*HALF_PERIOD);
	$display("Decode SLLI");
	#(2*HALF_PERIOD);
	$display("ISelect SLLI");
	if(out_PCWriteEnable != 0 || out_immShift != 0 || out_ALUOp != 'b101 || out_numBits != 'b10 || out_ALUSrcA != 1)
	begin
		failures = failures + 1;
		$display("ISelect didn't give the right output :(");
	end
	#(2*HALF_PERIOD);
	#(2*HALF_PERIOD);
	$display("ALUWrite SLLI");
	if(out_regDataWrite != 'b000 || out_writeEnable != 'b1)
	begin
		failures = failures + 1;
		$display("ALUWrite didn't give the right output :(");
	end
	//Test: srli
	#(2*HALF_PERIOD);
	resetReg = 1;
	#(2*HALF_PERIOD);
	resetReg = 0;	
	
	input_opcode = 'b1101;
	input_cmpRst = 0;
	#(2*HALF_PERIOD);
	$display("Fetch SRLI");
	#(2*HALF_PERIOD);
	$display("Decode SRLI");
	#(2*HALF_PERIOD);
	$display("ISelect SRLI");
	if(out_PCWriteEnable != 0 || out_immShift != 0 || out_ALUOp != 'b110 || out_numBits != 'b10 || out_ALUSrcA != 1)
	begin
		failures = failures + 1;
		$display("ISelect didn't give the right output :(");
	end
	#(2*HALF_PERIOD);
	#(2*HALF_PERIOD);
	$display("ALUWrite SRLI");
	if(out_regDataWrite != 'b000 || out_writeEnable != 'b1)
	begin
		failures = failures + 1;
		$display("ALUWrite didn't give the right output :(");
	end
	//Test: addi
	#(2*HALF_PERIOD);
	resetReg = 1;
	#(2*HALF_PERIOD);
	resetReg = 0;

	input_opcode = 'b1100;
	input_cmpRst = 0;
	#(2*HALF_PERIOD);
	$display("Fetch ADDI");
	#(2*HALF_PERIOD);
	$display("Decode ADDI");
	#(2*HALF_PERIOD);
	$display("ISelect ADDI");
	if(out_PCWriteEnable != 0 || out_immShift != 0 || out_ALUOp != 'b000 || out_numBits != 'b10 || out_ALUSrcA != 1)
	begin
		failures = failures + 1;
		$display("ISelect didn't give the right output :(");
	end
	#(2*HALF_PERIOD);
	#(2*HALF_PERIOD);
	$display("ALUWrite ADDI");
	if(out_regDataWrite != 'b000 || out_writeEnable != 'b1)
	begin
		failures = failures + 1;
		$display("ALUWrite didn't give the right output :(");
	end	
	//Test: lui
	#(2*HALF_PERIOD);
	resetReg = 1;
	#(2*HALF_PERIOD);
	resetReg = 0;

	input_opcode = 'b1111;
	input_cmpRst = 0;
	#(2*HALF_PERIOD);
	$display("Fetch LUI");
	#(2*HALF_PERIOD);
	$display("Decode LUI");
	#(2*HALF_PERIOD);
	$display("LUI LUI");
	if(out_regDataWrite != 'b011 || out_writeEnable != 1 || out_PCWriteEnable != 0 || out_immShift != 'b10 || out_numBits != 'b10 || out_ALUSrcA != 'b1)
	begin
		failures = failures + 1;
		$display("LUI didn't give the right output :(");
	end
	//Test: lw
	#(2*HALF_PERIOD);
	resetReg = 1;
	#(2*HALF_PERIOD);
	resetReg = 0;	

	input_opcode = 'b0110;
	input_cmpRst = 0;
	#(2*HALF_PERIOD);
	$display("Fetch LW");
	#(2*HALF_PERIOD);
	$display("Decode LW");
	#(2*HALF_PERIOD);
	$display("MemBase LW");
	if(out_PCWriteEnable != 0 || out_immShift != 0 || out_ALUOp != 'b000 || out_numBits != 'b01 || out_ALUSrcA != 1 || out_ALUSrcB != 1)
	begin
		failures = failures + 1;
		$display("MemBase didn't give the right output :(");
	end
	#(2*HALF_PERIOD);
	$display("LWRead LW");
	if(out_memEnableRead != 'b1 || out_memAddrSel != 'b1)
	begin
		failures = failures + 1;
		$display("LWRead didn't give the right output :(");
	end
	#(2*HALF_PERIOD);
	$display("LWWrite LW");
	if(out_regDataWrite != 'b001 || out_writeEnable != 'b1 || out_memEnableRead != 0)
	begin
		failures = failures + 1;
		$display("LWWrite didn't give the right output :(");
	end
	//Test: sw
	#(2*HALF_PERIOD);
	resetReg = 1;
	#(2*HALF_PERIOD);
	resetReg = 0;
	input_opcode = 'b0111;
	input_cmpRst = 0;	
	#(2*HALF_PERIOD);
	$display("Fetch SW");
	#(2*HALF_PERIOD);
	$display("Decode SW");
	#(2*HALF_PERIOD);
	$display("MemBase SW");
	if(out_PCWriteEnable != 0 || out_immShift != 0 || out_ALUOp != 'b000 || out_numBits != 'b01 || out_ALUSrcA != 1 || out_ALUSrcB != 1)
	begin
		failures = failures + 1;
		$display("MemBase didn't give the right output :(");
	end
	#(2*HALF_PERIOD);
	$display("SW SW");
	if(out_memEnableRead != 'b0 || out_memEnableWrite != 'b1 || out_memAddrSel != 'b1)
	begin
		failures = failures + 1;
		$display("SW didn't give the right output :(");
	end
	//Test: beq
	#(2*HALF_PERIOD);
	resetReg = 1;
	#(2*HALF_PERIOD);
	resetReg = 0;
	input_opcode = 'b1000;
	input_cmpRst = 0;	
	#(2*HALF_PERIOD);
	$display("Fetch BEQ");
	#(2*HALF_PERIOD);
	$display("Decode BEQ");
	#(2*HALF_PERIOD);
	$display("BPause BEQ");
	if(out_PCWriteEnable != 0)
	begin
		failures = failures + 1;
		$display("BPause didn't give the right output :(");
	end
	#(2*HALF_PERIOD);
	$display("BWrite BEQ");
	if(out_PCWriteEnable != 'b1 || out_PCSource != 'b1)
	begin
		failures = failures + 1;
		$display("BWrite didn't give the right output :(");
	end	
	#(2*HALF_PERIOD);
	
	#(2*HALF_PERIOD);
	resetReg = 1;
	#(2*HALF_PERIOD);
	resetReg = 0;
	input_opcode = 'b1000;
	input_cmpRst = 2;	
	#(2*HALF_PERIOD);
	$display("Fetch BEQ");
	#(2*HALF_PERIOD);
	$display("Decode BEQ");
	#(2*HALF_PERIOD);
	$display("BPause BEQ");
	if(out_PCWriteEnable != 0)
	begin
		failures = failures + 1;
		$display("BPause didn't give the right output :(");
	end	
	#(2*HALF_PERIOD);
	//Test: bge	
	#(2*HALF_PERIOD);
	resetReg = 1;
	#(2*HALF_PERIOD);
	resetReg = 0;
	input_opcode = 'b1001;
	input_cmpRst = 0;	
	#(2*HALF_PERIOD);
	$display("Fetch BGE");
	#(2*HALF_PERIOD);
	$display("Decode BGE");
	#(2*HALF_PERIOD);
	$display("BPause BGE");
	if(out_PCWriteEnable != 0)
	begin
		failures = failures + 1;
		$display("BPause didn't give the right output :(");
	end
	#(2*HALF_PERIOD);
	$display("BWrite BGE");
	if(out_PCWriteEnable != 'b1 || out_PCSource != 'b1)
	begin
		failures = failures + 1;
		$display("BWrite didn't give the right output :(");
	end	
	#(2*HALF_PERIOD);
	
	#(2*HALF_PERIOD);
	resetReg = 1;
	#(2*HALF_PERIOD);
	resetReg = 0;
	input_opcode = 'b1001;
	input_cmpRst = 1;	
	#(2*HALF_PERIOD);
	$display("Fetch BGE");
	#(2*HALF_PERIOD);
	$display("Decode BGE");
	#(2*HALF_PERIOD);
	$display("BPause BGE");
	if(out_PCWriteEnable != 0)
	begin
		failures = failures + 1;
		$display("BPause didn't give the right output :(");
	end
	#(2*HALF_PERIOD);
	$display("BWrite BGE");
	if(out_PCWriteEnable != 'b1 || out_PCSource != 'b1)
	begin
		failures = failures + 1;
		$display("BWrite didn't give the right output :(");
	end	
	#(2*HALF_PERIOD);
	
	#(2*HALF_PERIOD);
	resetReg = 1;
	#(2*HALF_PERIOD);
	resetReg = 0;
	input_opcode = 'b1001;
	input_cmpRst = 'b10;	
	#(2*HALF_PERIOD);
	$display("Fetch BGE");
	#(2*HALF_PERIOD);
	$display("Decode BGE");
	#(2*HALF_PERIOD);
	$display("BPause BGE");
	if(out_PCWriteEnable != 0)
	begin
		failures = failures + 1;
		$display("BPause didn't give the right output :(");
	end	
	//Test: blt
	#(2*HALF_PERIOD);
	resetReg = 1;
	#(2*HALF_PERIOD);
	resetReg = 0;
	input_opcode = 'b1010;
	input_cmpRst = 'b10;	
	#(2*HALF_PERIOD);
	$display("Fetch BLT");
	#(2*HALF_PERIOD);
	$display("Decode BLT");
	#(2*HALF_PERIOD);
	$display("BPause BLT");
	if(out_PCWriteEnable != 0)
	begin
		failures = failures + 1;
		$display("BPause didn't give the right output :(");
	end
	#(2*HALF_PERIOD);
	$display("BWrite BLT");
	if(out_PCWriteEnable != 'b1 || out_PCSource != 'b1)
	begin
		failures = failures + 1;
		$display("BWrite didn't give the right output :(");
	end	
	#(2*HALF_PERIOD);
	
	#(2*HALF_PERIOD);
	resetReg = 1;
	#(2*HALF_PERIOD);
	resetReg = 0;
	input_opcode = 'b1010;
	input_cmpRst = 1;	
	#(2*HALF_PERIOD);
	$display("Fetch BLT");
	#(2*HALF_PERIOD);
	$display("Decode BLT");
	#(2*HALF_PERIOD);
	$display("BPause BLT");
	if(out_PCWriteEnable != 0)
	begin
		failures = failures + 1;
		$display("BPause didn't give the right output :(");
	end	
	#(2*HALF_PERIOD);
	//Test: tst
	#(2*HALF_PERIOD);
	resetReg = 1;
	#(2*HALF_PERIOD);
	resetReg = 0;
	input_opcode = 'b0101;
	input_cmpRst = 0;	
	#(2*HALF_PERIOD);
	$display("Fetch TST");
	#(2*HALF_PERIOD);
	$display("Decode TST");
	#(2*HALF_PERIOD);
	$display("TST TST");
	if(out_PCWriteEnable != 0 || out_writeEnable != 1 || out_regDataWrite != 'b100)
	begin
		failures = failures + 1;
		$display("TST didn't give the right output :(");
	end	
	#(2*HALF_PERIOD);
	
	//Test: jalr
	#(2*HALF_PERIOD);
	resetReg = 1;
	#(2*HALF_PERIOD);
	resetReg = 0;
	input_opcode = 'b1011;
	input_cmpRst = 0;	
	#(2*HALF_PERIOD);
	$display("Fetch JALR");
	#(2*HALF_PERIOD);
	$display("Decode JALR");
	#(2*HALF_PERIOD);
	$display("MemBase JALR");
	if(out_PCWriteEnable != 0 || out_immShift != 0 || out_ALUOp != 'b000 || out_numBits != 'b01 || out_ALUSrcA != 1 || out_ALUSrcB != 1)
	begin
		failures = failures + 1;
		$display("MemBase didn't give the right output :(");
	end
	#(2*HALF_PERIOD);	
	$display("JALR JALR");
	if(out_regDataWrite != 'b010 || out_PCSource != 1 || out_PCWriteEnable != 1 || out_writeEnable != 1)
	begin
		failures = failures + 1;
		$display("JALR didn't give the right output :(");
	end
	#(2*HALF_PERIOD);	
	
	//Test: sequential instructions
		#(2*HALF_PERIOD);
	resetReg = 1;
	#(2*HALF_PERIOD);
	resetReg = 0;
	
	input_opcode = 'b1110;
	input_cmpRst = 0;
	#(2*HALF_PERIOD);
	$display("Fetch SLLI");
	#(2*HALF_PERIOD);
	$display("Decode SLLI");
	#(2*HALF_PERIOD);
	$display("ISelect SLLI");
	if(out_PCWriteEnable != 0 || out_immShift != 0 || out_ALUOp != 'b101 || out_numBits != 'b10 || out_ALUSrcA != 1)
	begin
		failures = failures + 1;
		$display("ISelect didn't give the right output :(");
	end
	#(2*HALF_PERIOD);
	#(2*HALF_PERIOD);
	$display("ALUWrite SLLI");
	if(out_regDataWrite != 'b000 || out_writeEnable != 'b1)
	begin
		failures = failures + 1;
		$display("ALUWrite didn't give the right output :(");
	end
	#(2*HALF_PERIOD);
	$display("Fetch ADDI");
	input_opcode = 'b1100;
	input_cmpRst = 0;
	#(2*HALF_PERIOD);
	$display("Decode ADDI");
	#(2*HALF_PERIOD);
	$display("ISelect ADDI");
	if(out_PCWriteEnable != 0 || out_immShift != 0 || out_ALUOp != 'b000 || out_numBits != 'b10 || out_ALUSrcA != 1)
	begin
		failures = failures + 1;
		$display("ISelect didn't give the right output :(");
	end
	#(2*HALF_PERIOD);
	#(2*HALF_PERIOD);
	$display("ALUWrite ADDI");
	if(out_regDataWrite != 'b000 || out_writeEnable != 'b1)
	begin
		failures = failures + 1;
		$display("ALUWrite didn't give the right output :(");
	end
	
//	
//	
////	$display("Cycle 1");
////	$display("out_memAddrSel: %b", out_memAddrSel);
////	$display("out_memEnableRead: %b", out_memEnableRead);
////	$display("out_IRWrite: %b", out_IRWrite);
////	if(out_memAddrSel != 0) begin
////		failures = failures + 1;
////		$display("Error: FETCH cycle does not choose correct memory selection.");
////	end
////	if(out_memEnableRead != 1) begin
////		failures = failures + 1;
////		$display("Error: FETCH cycle does not enable reading from memory.");
////	end
////	if(out_IRWrite != 1) begin
////		failures = failures + 1;
////		$display("Error: FETCH cycle does not allow loading an instruction into the instruction register");
////	end
////
////	#(2*HALF_PERIOD)
////	$display("Cycle 2");
////	$display("out_immShift: %b", out_immShift);
////	$display("out_ALUOp: %b", out_ALUOp);
////	$display("out_numBits: %b", out_numBits);
////	$display("out_ALUSrcA: %b", out_ALUSrcA);
////	$display("out_ALUSrcB: %b", out_ALUSrcB);
////	$display("out_PCWriteEnable: %b", out_PCWriteEnable);
////	$display("out_PCSource: %b", out_PCSource);
////	$display("out_IRWrite: %b", out_IRWrite);
////	if(out_immShift != 1) begin
////		failures = failures + 1;
////		$display("Error: DECODE cycle does not set immShift to 1.");
////	end
////	if(out_ALUOp != 000) begin
////		failures = failures + 1;
////		$display("Error: DECODE cycle uses wrong ALUOp.");
////	end
////	if(out_ALUSrcA != 0) begin
////		failures = failures + 1;
////		$display("Error: DECODE cycle uses wrong ALUSrcA.");
////	end
////	if(out_ALUSrcB != 1) begin
////		failures = failures + 1;
////		$display("Error: DECODE cycle uses wrong ALUSrcB.");
////	end
////	if(out_numBits != 3) begin
////		failures = failures + 1;
////		$display("Error: DECODE cycle does not set numBits to 11.");
////	end
////	if(out_PCWriteEnable != 1)begin
////		failures = failures + 1;
////		$display("Error: DECODE cycle does not enable writing to the PC.");
////	end
////	if(out_PCSource != 0)begin
////		failures = failures + 1;
////		$display("Error: DECODE cycle uses wrong PCSource.");
////	end
////	if(out_IRWrite != 1)begin
////		failures = failures + 1;
////		$display("Error: DECODE cycle does not enable writing to the Instruction Register.");
////	end
////	
////	#(2*HALF_PERIOD)
////	$display("Cycle 3");
////	$display("out_DOrS: %b", out_DOrS);
////	if(out_DOrS != 1) begin
////		failures = failures + 1;
////		$display("Error: ISelect cycle does not enable the correct destination register.");
////	end
////	
////	
////	#(2*HALF_PERIOD)
////	$display("Cycle 4");
////	$display("out_ALUOp: %b", out_ALUOp);
////	$display("out_ALUSrcA: %b", out_ALUSrcA);
////	$display("out_ALUSrcB: %b", out_ALUSrcB);
////	if(out_ALUSrcA != 1) begin
////		failures = failures + 1;
////		$display("Error: IALU cycle does not select correct ALUSrcA.");
////	end
////	if(out_ALUSrcB != 1) begin
////		failures = failures + 1;
////		$display("Error: IALU cycle does not select correct ALUSrcB.");
////	end
////	if(out_ALUOp != 000) begin
////		failures = failures + 1;
////		$display("Error: IALU cycle does not select correct ALUOp.");
////	end
////	
////	
////	#(2*HALF_PERIOD)
////	$display("Cycle 5");
////	$display("out_writeEnable: %b", out_writeEnable);
////	$display("out_regDataWrite: %b", out_regDataWrite);
////	if(out_regDataWrite != 000) begin
////		failures = failures + 1;
////		$display("Error: ALUWrite cycle does not select correct register data input.");
////	end
////	if(out_writeEnable != 1) begin
////		failures = failures + 1;
////		$display("Error: ALUWrite cycle does not enable writing to the register file.");
////	end
////	
//	
//	resetReg = 1;
//	#(2*HALF_PERIOD)
//	resetReg = 0;
//	
//	//Test: SLLI
//	input_opcode = 14;
//	input_cmpRst = 00;
//	$display("Testing SLLI");	
//	#(2*HALF_PERIOD)
//	$display("Cycle 1");
//	$display("out_memAddrSel: %b", out_memAddrSel);
//	$display("out_memEnableRead: %b", out_memEnableRead);
//	$display("out_IRWrite: %b", out_IRWrite);
//	if(out_memAddrSel != 0) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not choose correct memory selection.");
//	end
//	if(out_memEnableRead != 1) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not enable reading from memory.");
//	end
//	if(out_IRWrite != 1) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not allow loading an instruction into the instruction register");
//	end
//
//	#(2*HALF_PERIOD)
//	$display("Cycle 2");
//	$display("out_immShift: %b", out_immShift);
//	$display("out_ALUOp: %b", out_ALUOp);
//	$display("out_numBits: %b", out_numBits);
//	$display("out_ALUSrcA: %b", out_ALUSrcA);
//	$display("out_ALUSrcB: %b", out_ALUSrcB);
//	$display("out_PCWriteEnable: %b", out_PCWriteEnable);
//	$display("out_PCSource: %b", out_PCSource);
//	$display("out_IRWrite: %b", out_IRWrite);
//	if(out_immShift != 1) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not set immShift to 1.");
//	end
//	if(out_ALUOp != 000) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUOp.");
//	end
//	if(out_ALUSrcA != 0) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUSrcA.");
//	end
//	if(out_ALUSrcB != 1) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUSrcB.");
//	end
//	if(out_numBits != 3) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not set numBits to 11.");
//	end
//	if(out_PCWriteEnable != 1)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not enable writing to the PC.");
//	end
//	if(out_PCSource != 0)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong PCSource.");
//	end
//	if(out_IRWrite != 1)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not enable writing to the Instruction Register.");
//	end
//	
//	#(2*HALF_PERIOD)
//	$display("Cycle 3");
//	$display("out_DOrS: %b", out_DOrS);
//	if(out_DOrS != 1) begin
//		failures = failures + 1;
//		$display("Error: ISelect cycle does not enable the correct destination register.");
//	end
//	
//	
//	#(2*HALF_PERIOD)
//	$display("Cycle 4");
//	$display("out_ALUOp: %b", out_ALUOp);
//	$display("out_ALUSrcA: %b", out_ALUSrcA);
//	$display("out_ALUSrcB: %b", out_ALUSrcB);
//	if(out_ALUSrcA != 1) begin
//		failures = failures + 1;
//		$display("Error: IALU cycle does not select correct ALUSrcA.");
//	end
//	if(out_ALUSrcB != 1) begin
//		failures = failures + 1;
//		$display("Error: IALU cycle does not select correct ALUSrcB.");
//	end
//	if(out_ALUOp != 101) begin
//		failures = failures + 1;
//		$display("Error: IALU cycle does not select correct ALUOp.");
//	end
//	
//	
//	#(2*HALF_PERIOD)
//	$display("Cycle 5");
//	$display("out_writeEnable: %b", out_writeEnable);
//	$display("out_regDataWrite: %b", out_regDataWrite);
//	if(out_regDataWrite != 000) begin
//		failures = failures + 1;
//		$display("Error: ALUWrite cycle does not select correct register data input.");
//	end
//	if(out_writeEnable != 1) begin
//		failures = failures + 1;
//		$display("Error: ALUWrite cycle does not enable writing to the register file.");
//	end
//
//
//	resetReg = 1;
//	#(2*HALF_PERIOD)
//	resetReg = 0;
//	
//	//Test: SRLI
//	input_opcode = 13;
//	input_cmpRst = 00;
//	$display("Testing SRLI");	
//	#(2*HALF_PERIOD)
//	$display("Cycle 1");
//	$display("out_memAddrSel: %b", out_memAddrSel);
//	$display("out_memEnableRead: %b", out_memEnableRead);
//	$display("out_IRWrite: %b", out_IRWrite);
//	if(out_memAddrSel != 0) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not choose correct memory selection.");
//	end
//	if(out_memEnableRead != 1) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not enable reading from memory.");
//	end
//	if(out_IRWrite != 1) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not allow loading an instruction into the instruction register");
//	end
//
//	#(2*HALF_PERIOD)
//	$display("Cycle 2");
//	$display("out_immShift: %b", out_immShift);
//	$display("out_ALUOp: %b", out_ALUOp);
//	$display("out_numBits: %b", out_numBits);
//	$display("out_ALUSrcA: %b", out_ALUSrcA);
//	$display("out_ALUSrcB: %b", out_ALUSrcB);
//	$display("out_PCWriteEnable: %b", out_PCWriteEnable);
//	$display("out_PCSource: %b", out_PCSource);
//	$display("out_IRWrite: %b", out_IRWrite);
//	if(out_immShift != 1) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not set immShift to 1.");
//	end
//	if(out_ALUOp != 000) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUOp.");
//	end
//	if(out_ALUSrcA != 0) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUSrcA.");
//	end
//	if(out_ALUSrcB != 1) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUSrcB.");
//	end
//	if(out_numBits != 3) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not set numBits to 11.");
//	end
//	if(out_PCWriteEnable != 1)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not enable writing to the PC.");
//	end
//	if(out_PCSource != 0)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong PCSource.");
//	end
//	if(out_IRWrite != 1)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not enable writing to the Instruction Register.");
//	end
//	
//	#(2*HALF_PERIOD)
//	$display("Cycle 3");
//	$display("out_DOrS: %b", out_DOrS);
//	if(out_DOrS != 1) begin
//		failures = failures + 1;
//		$display("Error: ISelect cycle does not enable the correct destination register.");
//	end
//	
//	
//	#(2*HALF_PERIOD)
//	$display("Cycle 4");
//	$display("out_ALUOp: %b", out_ALUOp);
//	$display("out_ALUSrcA: %b", out_ALUSrcA);
//	$display("out_ALUSrcB: %b", out_ALUSrcB);
//	if(out_ALUSrcA != 1) begin
//		failures = failures + 1;
//		$display("Error: IALU cycle does not select correct ALUSrcA.");
//	end
//	if(out_ALUSrcB != 1) begin
//		failures = failures + 1;
//		$display("Error: IALU cycle does not select correct ALUSrcB.");
//	end
//	if(out_ALUOp != 110) begin
//		failures = failures + 1;
//		$display("Error: IALU cycle does not select correct ALUOp.");
//	end
//	
//	
//	#(2*HALF_PERIOD)
//	$display("Cycle 5");
//	$display("out_writeEnable: %b", out_writeEnable);
//	$display("out_regDataWrite: %b", out_regDataWrite);
//	if(out_regDataWrite != 000) begin
//		failures = failures + 1;
//		$display("Error: ALUWrite cycle does not select correct register data input.");
//	end
//	if(out_writeEnable != 1) begin
//		failures = failures + 1;
//		$display("Error: ALUWrite cycle does not enable writing to the register file.");
//	end
//
//
//	resetReg = 1;
//	#(2*HALF_PERIOD)
//	resetReg = 0;
//
//	//Test: TST
//	input_opcode = 5;
//	input_cmpRst = 0;
//	$display("Testing TST");
//	#(2*HALF_PERIOD);
//	$display("Cycle 1");
//	$display("out_memAddrSel: %b", out_memAddrSel);
//	$display("out_memEnableRead: %b", out_memEnableRead);
//	$display("out_IRWrite: %b", out_IRWrite);
//	if(out_memAddrSel != 0) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not choose correct memory selection.");
//	end
//	if(out_memEnableRead != 1) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not enable reading from memory.");
//	end
//	if(out_IRWrite != 1) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not allow loading an instruction into the instruction register");
//	end
//
//	#(2*HALF_PERIOD);
//	$display("Cycle 2");
//	$display("out_immShift: %b", out_immShift);
//	$display("out_ALUOp: %b", out_ALUOp);
//	$display("out_numBits: %b", out_numBits);
//	$display("out_ALUSrcA: %b", out_ALUSrcA);
//	$display("out_ALUSrcB: %b", out_ALUSrcB);
//	$display("out_PCWriteEnable: %b", out_PCWriteEnable);
//	$display("out_PCSource: %b", out_PCSource);
//	$display("out_IRWrite: %b", out_IRWrite);
//	if(out_immShift != 1) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not set immShift to 1.");
//	end
//	if(out_ALUOp != 000) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUOp.");
//	end
//	if(out_ALUSrcA != 0) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUSrcA.");
//	end
//	if(out_ALUSrcB != 1) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUSrcB.");
//	end
//	if(out_numBits != 3) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not set numBits to 11.");
//	end
//	if(out_PCWriteEnable != 1)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not enable writing to the PC.");
//	end
//	if(out_PCSource != 0)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong PCSource.");
//	end
//	if(out_IRWrite != 1)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not enable writing to the Instruction Register.");
//	end
//
//	#(2*HALF_PERIOD);
//	$display("Cycle 3");
//	$display("out_writeEnable: %b", out_writeEnable);
//	$display("out_regDataWrite: %b", out_regDataWrite);
//	if(out_regDataWrite != 4) begin
//		failures = failures + 1;
//		$display("Error: TST cycle does not select correct register data input.");
//	end
//	if(out_writeEnable != 1) begin
//		failures = failures + 1;
//		$display("Error: TST cycle does not enable writing to the register file.");
//	end
//
//	resetReg = 1;
//	#(2*HALF_PERIOD)
//	resetReg = 0;
//
//	//Test: LW
//	input_opcode = 6;
//	input_cmpRst = 0;
//	$display("Testing LW");
//	#(2*HALF_PERIOD);
//	$display("Cycle 1");
//	$display("out_memAddrSel: %b", out_memAddrSel);
//	$display("out_memEnableRead: %b", out_memEnableRead);
//	$display("out_IRWrite: %b", out_IRWrite);
//	if(out_memAddrSel != 0) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not choose correct memory selection.");
//	end
//	if(out_memEnableRead != 1) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not enable reading from memory.");
//	end
//	if(out_IRWrite != 1) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not allow loading an instruction into the instruction register");
//	end
//
//	#(2*HALF_PERIOD);
//	$display("Cycle 2");
//	$display("out_immShift: %b", out_immShift);
//	$display("out_ALUOp: %b", out_ALUOp);
//	$display("out_numBits: %b", out_numBits);
//	$display("out_ALUSrcA: %b", out_ALUSrcA);
//	$display("out_ALUSrcB: %b", out_ALUSrcB);
//	$display("out_PCWriteEnable: %b", out_PCWriteEnable);
//	$display("out_PCSource: %b", out_PCSource);
//	$display("out_IRWrite: %b", out_IRWrite);
//	if(out_immShift != 1) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not set immShift to 1.");
//	end
//	if(out_ALUOp != 000) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUOp.");
//	end
//	if(out_ALUSrcA != 0) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUSrcA.");
//	end
//	if(out_ALUSrcB != 1) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUSrcB.");
//	end
//	if(out_numBits != 3) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not set numBits to 11.");
//	end
//	if(out_PCWriteEnable != 1) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not enable writing to the PC.");
//	end
//	if(out_PCSource != 0)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong PCSource.");
//	end
//	if(out_IRWrite != 1)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not enable writing to the Instruction Register.");
//	end
//
//	#(2*HALF_PERIOD);
//	$display("Cycle 3");
//	$display("out_immShift: %b", out_immShift);
//	$display("out_ALUOp: %b", out_ALUOp);
//	$display("out_numBits: %b", out_numBits);
//	$display("out_ALUSrcA: %b", out_ALUSrcA);
//	$display("out_ALUSrcB: %b", out_ALUSrcB);
//	$display("out_PCWriteEnable: %b", out_PCWriteEnable);
//	if(out_immShift != 0) begin
//		failures = failures + 1;
//		$display("Error: MemBase cycle does not set immShift to 0.");
//	end
//	if(out_ALUOp != 000) begin
//		failures = failures + 1;
//		$display("Error: MemBase cycle uses the wrong ALUOp.");
//	end
//	if(out_ALUSrcA != 1) begin
//		failures = failures + 1;
//		$display("Error: MemBase cycle uses the wrong ALUSrcA.");
//	end
//	if(out_ALUSrcB != 1) begin
//		failures = failures + 1;
//		$display("Error: MemBase cycle uses the wrong ALUSrcB.");
//	end
//	if(out_numBits != 3) begin
//		failures = failures + 1;
//		$display("Error: MemBase cycle does not set numBits to 11.");
//	end
//	if(out_PCWriteEnable != 0) begin
//		failures = failures + 1;
//		$display("Error: MemBase does not disable writing to the PC.");
//	end
//
//	#(2*HALF_PERIOD);
//	$display("Cycle 4");
//	$display("out_memEnableRead: %b", out_memEnableRead);
//	$display("out_memAddrSet: %b", out_memAddrSet);
//	if(out_memAddrSet != 1) begin
//		failures = failures + 1;
//		$display("Error: LWRead cycle does not set correct memory reading address.");
//	end
//	if(out_memEnableRead != 1) begin
//		failures = failures + 1;
//		$display("Error: LWRead cycle does not enable reading from memory.");
//	end
//
//	#(2*HALF_PERIOD);
//	$display("Cycle 5");
//	$display("out_writeEnable: %b", out_writeEnable);
//	$display("out_regDataWrite: %b", out_regDataWrite);
//	if(out_regDataWrite != 001) begin
//		failures = failures + 1;
//		$display("Error: LWWrite cycle does not set correct register data input.");
//	end
//	if(out_writeEnable != 1) begin
//		failures = failures + 1;
//		$display("Error: LWWrite cycle does not enable writing to the register file.");
//	end
//
//
//	resetReg = 1;
//	#(2*HALF_PERIOD)
//	resetReg = 0;
//
//	//Test: SW
//	input_opcode = 7;
//	input_cmpRst = 0;
//	$display("Testing SW");
//	#(2*HALF_PERIOD);
//	$display("Cycle 1");
//	$display("out_memAddrSel: %b", out_memAddrSel);
//	$display("out_memEnableRead: %b", out_memEnableRead);
//	$display("out_IRWrite: %b", out_IRWrite);
//	if(out_memAddrSel != 0) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not choose correct memory selection.");
//	end
//	if(out_memEnableRead != 1) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not enable reading from memory.");
//	end
//	if(out_IRWrite != 1) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not allow loading an instruction into the instruction register");
//	end
//
//	#(2*HALF_PERIOD);
//	$display("Cycle 2");
//	$display("out_immShift: %b", out_immShift);
//	$display("out_ALUOp: %b", out_ALUOp);
//	$display("out_numBits: %b", out_numBits);
//	$display("out_ALUSrcA: %b", out_ALUSrcA);
//	$display("out_ALUSrcB: %b", out_ALUSrcB);
//	$display("out_PCWriteEnable: %b", out_PCWriteEnable);
//	$display("out_PCSource: %b", out_PCSource);
//	$display("out_IRWrite: %b", out_IRWrite);
//	if(out_immShift != 1) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not set immShift to 1.");
//	end
//	if(out_ALUOp != 000) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUOp.");
//	end
//	if(out_ALUSrcA != 0) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUSrcA.");
//	end
//	if(out_ALUSrcB != 1) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUSrcB.");
//	end
//	if(out_numBits != 3) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not set numBits to 11.");
//	end
//	if(out_PCWriteEnable != 1)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not enable writing to the PC.");
//	end
//	if(out_PCSource != 0)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong PCSource.");
//	end
//	if(out_IRWrite != 1)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not enable writing to the Instruction Register.");
//	end
//
//	#(2*HALF_PERIOD);
//	$display("Cycle 3");
//	$display("out_immShift: %b", out_immShift);
//	$display("out_ALUOp: %b", out_ALUOp);
//	$display("out_numBits: %b", out_numBits);
//	$display("out_ALUSrcA: %b", out_ALUSrcA);
//	$display("out_ALUSrcB: %b", out_ALUSrcB);
//	$display("out_PCWriteEnable: %b", out_PCWriteEnable);
//	if(out_immShift != 0) begin
//		failures = failures + 1;
//		$display("Error: MemBase cycle does not set immShift to 0.");
//	end
//	if(out_ALUOp != 000) begin
//		failures = failures + 1;
//		$display("Error: MemBase cycle uses the wrong ALUOp.");
//	end
//	if(out_ALUSrcA != 1) begin
//		failures = failures + 1;
//		$display("Error: MemBase cycle uses the wrong ALUSrcA.");
//	end
//	if(out_ALUSrcB != 1) begin
//		failures = failures + 1;
//		$display("Error: MemBase cycle uses the wrong ALUSrcB.");
//	end
//	if(out_numBits != 3) begin
//		failures = failures + 1;
//		$display("Error: MemBase cycle does not set numBits to 11.");
//	end
//	if(out_PCWriteEnable != 0) begin
//		failures = failures + 1;
//		$display("Error: MemBase cycle does not disable writing to the PC.");
//	end
//
//	#(2*HALF_PERIOD);
//	$display("Cycle 4");
//	$display("out_memEnableWrite: %b", out_memEnableWrite);
//	$display("out_memAddrSet: %b", out_memAddrSet);
//	if(out_memAddrSet != 1) begin
//		failures = failures + 1;
//		$display("Error: SW cycle does not set correct memory address.");
//	end
//	if(out_memEnableWrite != 1) begin
//		failures = failures + 1;
//		$display("Error: SW cycle does not enable writing to memory.");
//	end
//
//
//	resetReg = 1;
//	#(2*HALF_PERIOD)
//	resetReg = 0;
//
//	//Test: JALR
//	input_opcode = 11;
//	input_cmpRst = 0;
//	$display("Testing JALR");
//	#(2*HALF_PERIOD);
//	$display("Cycle 1");
//	$display("out_memAddrSel: %b", out_memAddrSel);
//	$display("out_memEnableRead: %b", out_memEnableRead);
//	$display("out_IRWrite: %b", out_IRWrite);
//	if(out_memAddrSel != 0) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not choose correct memory selection.");
//	end
//	if(out_memEnableRead != 1) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not enable reading from memory.");
//	end
//	if(out_IRWrite != 1) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not allow loading an instruction into the instruction register");
//	end
//
//	#(2*HALF_PERIOD);
//	$display("Cycle 2");
//	$display("out_immShift: %b", out_immShift);
//	$display("out_ALUOp: %b", out_ALUOp);
//	$display("out_numBits: %b", out_numBits);
//	$display("out_ALUSrcA: %b", out_ALUSrcA);
//	$display("out_ALUSrcB: %b", out_ALUSrcB);
//	$display("out_PCWriteEnable: %b", out_PCWriteEnable);
//	$display("out_PCSource: %b", out_PCSource);
//	$display("out_IRWrite: %b", out_IRWrite);
//	if(out_immShift != 1) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not set immShift to 1.");
//	end
//	if(out_ALUOp != 000) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUOp.");
//	end
//	if(out_ALUSrcA != 0) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUSrcA.");
//	end
//	if(out_ALUSrcB != 1) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUSrcB.");
//	end
//	if(out_numBits != 3) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not set numBits to 11.");
//	end
//	if(out_PCWriteEnable != 1)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not enable writing to the PC.");
//	end
//	if(out_PCSource != 0)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong PCSource.");
//	end
//	if(out_IRWrite != 1)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not enable writing to the Instruction Register.");
//	end
//
//	#(2*HALF_PERIOD);
//	$display("Cycle 3");
//	$display("out_immShift: %b", out_immShift);
//	$display("out_ALUOp: %b", out_ALUOp);
//	$display("out_numBits: %b", out_numBits);
//	$display("out_ALUSrcA: %b", out_ALUSrcA);
//	$display("out_ALUSrcB: %b", out_ALUSrcB);
//	$display("out_PCWriteEnable: %b", out_PCWriteEnable);
//	if(out_immShift != 0) begin
//		failures = failures + 1;
//		$display("Error: MemBase cycle does not set immShift to 0.");
//	end
//	if(out_ALUOp != 000) begin
//		failures = failures + 1;
//		$display("Error: MemBase cycle uses the wrong ALUOp.");
//	end
//	if(out_ALUSrcA != 1) begin
//		failures = failures + 1;
//		$display("Error: MemBase cycle uses the wrong ALUSrcA.");
//	end
//	if(out_ALUSrcB != 1) begin
//		failures = failures + 1;
//		$display("Error: MemBase cycle uses the wrong ALUSrcB.");
//	end
//	if(out_numBits != 3) begin
//		failures = failures + 1;
//		$display("Error: MemBase cycle does not set numBits to 11.");
//	end
//	if(out_PCWriteEnable != 0) begin
//		failures = failures + 1;
//		$display("Error: MemBase does not disable writing to the PC.");
//	end
//
//	#(2*HALF_PERIOD);
//	$display("Cycle 4");
//	$display("out_writeEnable: %b", out_writeEnable);
//	$display("out_PCWriteEnable: %b", out_PCWriteEnable);
//	$display("out_PCSource: %b", out_PCSource);
//	$display("out_regDataWrite: %b", out_regDataWrite);
//	if(out_regDataWrite != 2) begin
//		failures = failures + 1;
//		$display("Error: JALR cycle does not select correct register data input.");
//	end
//	if(out_PCSource != 1) begin
//		failures = failures + 1;
//		$display("Error: JALR cycle does not select correct PCSource.");
//	end
//	if(out_PCWriteEnable != 1) begin
//		failures = failures + 1;
//		$display("Error: JALR cycle does not enable writing to the PC.");
//	end
//	if(out_writeEnable != 1) begin
//		failures = failures + 1;
//		$display("Error: JALR cycle does not enable writing to the register file.");
//	end
//
//
//	resetReg = 1;
//	#(2*HALF_PERIOD)
//	resetReg = 0;
//
//	//Test: BEQ (successful)
//	input_opcode = 8;
//	input_cmpRst = 0;
//	$display("Testing BEQ (successful)");
//	#(2*HALF_PERIOD);
//	$display("Cycle 1");
//	$display("out_memAddrSel: %b", out_memAddrSel);
//	$display("out_memEnableRead: %b", out_memEnableRead);
//	$display("out_IRWrite: %b", out_IRWrite);
//	if(out_memAddrSel != 0) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not choose correct memory selection.");
//	end
//	if(out_memEnableRead != 1) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not enable reading from memory.");
//	end
//	if(out_IRWrite != 1) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not allow loading an instruction into the instruction register");
//	end
//
//	#(2*HALF_PERIOD);
//	$display("Cycle 2");
//	$display("out_immShift: %b", out_immShift);
//	$display("out_ALUOp: %b", out_ALUOp);
//	$display("out_numBits: %b", out_numBits);
//	$display("out_memAddrSel: %b", out_memAddrSel);
//	$display("out_ALUSrcA: %b", out_ALUSrcA);
//	$display("out_ALUSrcB: %b", out_ALUSrcB);
//	$display("out_PCWriteEnable: %b", out_PCWriteEnable);
//	$display("out_PCSource: %b", out_PCSource);
//	$display("out_IRWrite: %b", out_IRWrite);
//	if(out_immShift != 1) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not set immShift to 1.");
//	end
//	if(out_ALUOp != 000) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUOp.");
//	end
//	if(out_ALUSrcA != 0) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUSrcA.");
//	end
//	if(out_ALUSrcB != 1) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUSrcB.");
//	end
//	if(out_numBits != 3) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not set numBits to 11.");
//	end
//	if(out_PCWriteEnable != 1)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not enable writing to the PC.");
//	end
//	if(out_PCSource != 0)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong PCSource.");
//	end
//	if(out_IRWrite != 1)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not enable writing to the Instruction Register.");
//	end
//
//	#(2*HALF_PERIOD);
//	$display("Cycle 3");
//
//	#(2*HALF_PERIOD);
//	$display("Cycle 4");
//	$display("out_PCWriteEnable: %b", out_PCWriteEnable);
//	$display("out_PCSource: %b", out_PCSource);
//	if(out_PCWriteEnable != 1) begin
//		failures = failures + 1;
//		$display("Error: BWrite cycle does not enable writing to the PC.");
//	end
//	if(out_PCSource != 1) begin
//		failures = failures + 1;
//		$display("Error: BWrite cycle does not select correct PCSource.");
//	end
//
//
//	resetReg = 1;
//	#(2*HALF_PERIOD)
//	resetReg = 0;
//
//	//Test: BEQ (failed)
//	input_opcode = 8;
//	input_cmpRst = 1;
//	$display("Testing BEQ (failed)");
//	#(2*HALF_PERIOD);
//	$display("Cycle 1");
//	$display("out_memAddrSel: %b", out_memAddrSel);
//	$display("out_memEnableRead: %b", out_memEnableRead);
//	$display("out_IRWrite: %b", out_IRWrite);
//	if(out_memAddrSel != 0) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not choose correct memory selection.");
//	end
//	if(out_memEnableRead != 1) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not enable reading from memory.");
//	end
//	if(out_IRWrite != 1) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not allow loading an instruction into the instruction register");
//	end
//
//	#(2*HALF_PERIOD);
//	$display("Cycle 2");
//	$display("out_immShift: %b", out_immShift);
//	$display("out_ALUOp: %b", out_ALUOp);
//	$display("out_numBits: %b", out_numBits);
//	$display("out_ALUSrcA: %b", out_ALUSrcA);
//	$display("out_ALUSrcB: %b", out_ALUSrcB);
//	$display("out_PCWriteEnable: %b", out_PCWriteEnable);
//	$display("out_PCSource: %b", out_PCSource);
//	$display("out_IRWrite: %b", out_IRWrite);
//	if(out_immShift != 1) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not set immShift to 1.");
//	end
//	if(out_ALUOp != 000) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUOp.");
//	end
//	if(out_ALUSrcA != 0) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUSrcA.");
//	end
//	if(out_ALUSrcB != 1) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUSrcB.");
//	end
//	if(out_numBits != 3) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not set numBits to 11.");
//	end
//	if(out_PCWriteEnable != 1)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not enable writing to the PC.");
//	end
//	if(out_PCSource != 0)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong PCSource.");
//	end
//	if(out_IRWrite != 1)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not enable writing to the Instruction Register.");
//	end
//
//	#(2*HALF_PERIOD);
//	$display("Cycle 3");
//
//
//	resetReg = 1;
//	#(2*HALF_PERIOD)
//	resetReg = 0;
//
//	//Test: LUI
//	input_opcode = 15;
//	input_cmpRst = 0;
//	$display("Testing LUI");
//	#(2*HALF_PERIOD);
//	$display("Cycle 1");
//	$display("out_memAddrSel: %b", out_memAddrSel);
//	$display("out_memEnableRead: %b", out_memEnableRead);
//	$display("out_IRWrite: %b", out_IRWrite);
//	if(out_memAddrSel != 0) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not choose correct memory selection.");
//	end
//	if(out_memEnableRead != 1) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not enable reading from memory.");
//	end
//	if(out_IRWrite != 1) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not allow loading an instruction into the instruction register");
//	end
//
//	#(2*HALF_PERIOD);
//	$display("Cycle 2");
//	$display("out_immShift: %b", out_immShift);
//	$display("out_ALUOp: %b", out_ALUOp);
//	$display("out_numBits: %b", out_numBits);
//	$display("out_ALUSrcA: %b", out_ALUSrcA);
//	$display("out_ALUSrcB: %b", out_ALUSrcB);
//	$display("out_PCWriteEnable: %b", out_PCWriteEnable);
//	$display("out_PCSource: %b", out_PCSource);
//	$display("out_IRWrite: %b", out_IRWrite);
//	if(out_immShift != 1) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not set immShift to 1.");
//	end
//	if(out_ALUOp != 000) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUOp.");
//	end
//	if(out_ALUSrcA != 0) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUSrcA.");
//	end
//	if(out_ALUSrcB != 1) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUSrcB.");
//	end
//	if(out_numBits != 3) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not set numBits to 11.");
//	end
//	if(out_PCWriteEnable != 1)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not enable writing to the PC.");
//	end
//	if(out_PCSource != 0)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong PCSource.");
//	end
//	if(out_IRWrite != 1)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not enable writing to the Instruction Register.");
//	end
//
//	#(2*HALF_PERIOD);
//	$display("Cycle 3");
//	$display("out_writeEnable: %b", out_writeEnable);
//	$display("out_regDataWrite: %b", out_regDataWrite);
//	if(out_regDataWrite != 3) begin
//		failures = failures + 1;
//		$display("Error: LUI cycle does not select correct register data input.");
//	end
//	if(out_writeEnable != 1) begin
//		failures = failures + 1;
//		$display("Error: LUI cycle does not enable writing to the register file.");
//	end
//
//
//	resetReg = 1;
//	#(2*HALF_PERIOD)
//	resetReg = 0;
//	
//	//Test: ADD
//	input_opcode = 0;
//	input_cmpRst = 0;
//	$display("Testing ADD");
//	#(2*HALF_PERIOD);
//	$display("Cycle 1");
//	$display("out_memAddrSel: %b", out_memAddrSel);
//	$display("out_memEnableRead: %b", out_memEnableRead);
//	$display("out_IRWrite: %b", out_IRWrite);
//	if(out_memAddrSel != 0) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not choose correct memory selection.");
//	end
//	if(out_memEnableRead != 1) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not enable reading from memory.");
//	end
//	if(out_IRWrite != 1) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not allow loading an instruction into the instruction register");
//	end
//
//	#(2*HALF_PERIOD);
//	$display("Cycle 2");
//	$display("out_immShift: %b", out_immShift);
//	$display("out_ALUOp: %b", out_ALUOp);
//	$display("out_numBits: %b", out_numBits);
//	$display("out_ALUSrcA: %b", out_ALUSrcA);
//	$display("out_ALUSrcB: %b", out_ALUSrcB);
//	$display("out_PCWriteEnable: %b", out_PCWriteEnable);
//	$display("out_PCSource: %b", out_PCSource);
//	$display("out_IRWrite: %b", out_IRWrite);
//	if(out_immShift != 1) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not set immShift to 1.");
//	end
//	if(out_ALUOp != 000) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUOp.");
//	end
//	if(out_ALUSrcA != 0) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUSrcA.");
//	end
//	if(out_ALUSrcB != 1) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUSrcB.");
//	end
//	if(out_numBits != 3) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not set numBits to 11.");
//	end
//	if(out_PCWriteEnable != 1)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not enable writing to the PC.");
//	end
//	if(out_PCSource != 0)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong PCSource.");
//	end
//	if(out_IRWrite != 1)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not enable writing to the Instruction Register.");
//	end
//
//	#(2*HALF_PERIOD)
//	$display("Cycle 3");
//	$display("out_ALUOp: %b", out_ALUOp);
//	$display("out_ALUSrcA: %b", out_ALUSrcA);
//	$display("out_ALUSrcB: %b", out_ALUSrcB);
//	if(out_ALUSrcA != 1) begin
//		failures = failures + 1;
//		$display("Error: RALU cycle does not select correct ALUSrcA.");
//	end
//	if(out_ALUSrcB != 1) begin
//		failures = failures + 1;
//		$display("Error: RALU cycle does not select correct ALUSrcB.");
//	end
//	if(out_ALUOp != 000) begin
//		failures = failures + 1;
//		$display("Error: RALU cycle does not select correct ALUOp.");
//	end
//	
//	#(2*HALF_PERIOD)
//	$display("Cycle 4");
//	$display("out_writeEnable: %b", out_writeEnable);
//	$display("out_regDataWrite: %b", out_regDataWrite);
//	if(out_regDataWrite != 000) begin
//		failures = failures + 1;
//		$display("Error: ALUWrite cycle does not select correct register data input.");
//	end
//	if(out_writeEnable != 1) begin
//		failures = failures + 1;
//		$display("Error: ALUWrite cycle does not enable writing to the register file.");
//	end
//	
//	
//	resetReg = 1;
//	#(2*HALF_PERIOD)
//	resetReg = 0;
//	
//	//Test: SUB
//	input_opcode = 1;
//	input_cmpRst = 0;
//	$display("Testing SUB");
//	#(2*HALF_PERIOD);
//	$display("Cycle 1");
//	$display("out_memAddrSel: %b", out_memAddrSel);
//	$display("out_memEnableRead: %b", out_memEnableRead);
//	$display("out_IRWrite: %b", out_IRWrite);
//	if(out_memAddrSel != 0) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not choose correct memory selection.");
//	end
//	if(out_memEnableRead != 1) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not enable reading from memory.");
//	end
//	if(out_IRWrite != 1) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not allow loading an instruction into the instruction register");
//	end
//
//	#(2*HALF_PERIOD);
//	$display("Cycle 2");
//	$display("out_immShift: %b", out_immShift);
//	$display("out_ALUOp: %b", out_ALUOp);
//	$display("out_numBits: %b", out_numBits);
//	$display("out_ALUSrcA: %b", out_ALUSrcA);
//	$display("out_ALUSrcB: %b", out_ALUSrcB);
//	$display("out_PCWriteEnable: %b", out_PCWriteEnable);
//	$display("out_PCSource: %b", out_PCSource);
//	$display("out_IRWrite: %b", out_IRWrite);
//	if(out_immShift != 1) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not set immShift to 1.");
//	end
//	if(out_ALUOp != 000) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUOp.");
//	end
//	if(out_ALUSrcA != 0) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUSrcA.");
//	end
//	if(out_ALUSrcB != 1) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUSrcB.");
//	end
//	if(out_numBits != 3) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not set numBits to 11.");
//	end
//	if(out_PCWriteEnable != 1)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not enable writing to the PC.");
//	end
//	if(out_PCSource != 0)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong PCSource.");
//	end
//	if(out_IRWrite != 1)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not enable writing to the Instruction Register.");
//	end
//
//	#(2*HALF_PERIOD)
//	$display("Cycle 3");
//	$display("out_ALUOp: %b", out_ALUOp);
//	$display("out_ALUSrcA: %b", out_ALUSrcA);
//	$display("out_ALUSrcB: %b", out_ALUSrcB);
//	if(out_ALUSrcA != 1) begin
//		failures = failures + 1;
//		$display("Error: RALU cycle does not select correct ALUSrcA.");
//	end
//	if(out_ALUSrcB != 1) begin
//		failures = failures + 1;
//		$display("Error: RALU cycle does not select correct ALUSrcB.");
//	end
//	if(out_ALUOp != 001) begin
//		failures = failures + 1;
//		$display("Error: RALU cycle does not select correct ALUOp.");
//	end
//	
//	#(2*HALF_PERIOD)
//	$display("Cycle 4");
//	$display("out_writeEnable: %b", out_writeEnable);
//	$display("out_regDataWrite: %b", out_regDataWrite);
//	if(out_regDataWrite != 000) begin
//		failures = failures + 1;
//		$display("Error: ALUWrite cycle does not select correct register data input.");
//	end
//	if(out_writeEnable != 1) begin
//		failures = failures + 1;
//		$display("Error: ALUWrite cycle does not enable writing to the register file.");
//	end
//	
//	
//	resetReg = 1;
//	#(2*HALF_PERIOD)
//	resetReg = 0;
//	
//	//Test: XOR
//	input_opcode = 2;
//	input_cmpRst = 0;
//	$display("Testing XOR");
//	#(2*HALF_PERIOD);
//	$display("Cycle 1");
//	$display("out_memAddrSel: %b", out_memAddrSel);
//	$display("out_memEnableRead: %b", out_memEnableRead);
//	$display("out_IRWrite: %b", out_IRWrite);
//	if(out_memAddrSel != 0) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not choose correct memory selection.");
//	end
//	if(out_memEnableRead != 1) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not enable reading from memory.");
//	end
//	if(out_IRWrite != 1) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not allow loading an instruction into the instruction register");
//	end
//
//	#(2*HALF_PERIOD);
//	$display("Cycle 2");
//	$display("out_immShift: %b", out_immShift);
//	$display("out_ALUOp: %b", out_ALUOp);
//	$display("out_numBits: %b", out_numBits);
//	$display("out_ALUSrcA: %b", out_ALUSrcA);
//	$display("out_ALUSrcB: %b", out_ALUSrcB);
//	$display("out_PCWriteEnable: %b", out_PCWriteEnable);
//	$display("out_PCSource: %b", out_PCSource);
//	$display("out_IRWrite: %b", out_IRWrite);
//	if(out_immShift != 1) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not set immShift to 1.");
//	end
//	if(out_ALUOp != 000) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUOp.");
//	end
//	if(out_ALUSrcA != 0) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUSrcA.");
//	end
//	if(out_ALUSrcB != 1) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUSrcB.");
//	end
//	if(out_numBits != 3) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not set numBits to 11.");
//	end
//	if(out_PCWriteEnable != 1)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not enable writing to the PC.");
//	end
//	if(out_PCSource != 0)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong PCSource.");
//	end
//	if(out_IRWrite != 1)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not enable writing to the Instruction Register.");
//	end
//
//	#(2*HALF_PERIOD)
//	$display("Cycle 3");
//	$display("out_ALUOp: %b", out_ALUOp);
//	$display("out_ALUSrcA: %b", out_ALUSrcA);
//	$display("out_ALUSrcB: %b", out_ALUSrcB);
//	if(out_ALUSrcA != 1) begin
//		failures = failures + 1;
//		$display("Error: RALU cycle does not select correct ALUSrcA.");
//	end
//	if(out_ALUSrcB != 1) begin
//		failures = failures + 1;
//		$display("Error: RALU cycle does not select correct ALUSrcB.");
//	end
//	if(out_ALUOp != 4) begin
//		failures = failures + 1;
//		$display("Error: RALU cycle does not select correct ALUOp.");
//	end
//	
//	#(2*HALF_PERIOD)
//	$display("Cycle 4");
//	$display("out_writeEnable: %b", out_writeEnable);
//	$display("out_regDataWrite: %b", out_regDataWrite);
//	if(out_regDataWrite != 000) begin
//		failures = failures + 1;
//		$display("Error: ALUWrite cycle does not select correct register data input.");
//	end
//	if(out_writeEnable != 1) begin
//		failures = failures + 1;
//		$display("Error: ALUWrite cycle does not enable writing to the register file.");
//	end
//	
//	
//	resetReg = 1;
//	#(2*HALF_PERIOD)
//	resetReg = 0;
//	
//	//Test: OR
//	input_opcode = 3;
//	input_cmpRst = 0;
//	$display("Testing OR");
//	#(2*HALF_PERIOD);
//	$display("Cycle 1");
//	$display("out_memAddrSel: %b", out_memAddrSel);
//	$display("out_memEnableRead: %b", out_memEnableRead);
//	$display("out_IRWrite: %b", out_IRWrite);
//	if(out_memAddrSel != 0) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not choose correct memory selection.");
//	end
//	if(out_memEnableRead != 1) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not enable reading from memory.");
//	end
//	if(out_IRWrite != 1) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not allow loading an instruction into the instruction register");
//	end
//
//	#(2*HALF_PERIOD);
//	$display("Cycle 2");
//	$display("out_immShift: %b", out_immShift);
//	$display("out_ALUOp: %b", out_ALUOp);
//	$display("out_numBits: %b", out_numBits);
//	$display("out_ALUSrcA: %b", out_ALUSrcA);
//	$display("out_ALUSrcB: %b", out_ALUSrcB);
//	$display("out_PCWriteEnable: %b", out_PCWriteEnable);
//	$display("out_PCSource: %b", out_PCSource);
//	$display("out_IRWrite: %b", out_IRWrite);
//	if(out_immShift != 1) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not set immShift to 1.");
//	end
//	if(out_ALUOp != 000) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUOp.");
//	end
//	if(out_ALUSrcA != 0) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUSrcA.");
//	end
//	if(out_ALUSrcB != 1) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUSrcB.");
//	end
//	if(out_numBits != 3) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not set numBits to 11.");
//	end
//	if(out_PCWriteEnable != 1)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not enable writing to the PC.");
//	end
//	if(out_PCSource != 0)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong PCSource.");
//	end
//	if(out_IRWrite != 1)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not enable writing to the Instruction Register.");
//	end
//
//	#(2*HALF_PERIOD)
//	$display("Cycle 3");
//	$display("out_ALUOp: %b", out_ALUOp);
//	$display("out_ALUSrcA: %b", out_ALUSrcA);
//	$display("out_ALUSrcB: %b", out_ALUSrcB);
//	if(out_ALUSrcA != 1) begin
//		failures = failures + 1;
//		$display("Error: RALU cycle does not select correct ALUSrcA.");
//	end
//	if(out_ALUSrcB != 1) begin
//		failures = failures + 1;
//		$display("Error: RALU cycle does not select correct ALUSrcB.");
//	end
//	if(out_ALUOp != 3) begin
//		failures = failures + 1;
//		$display("Error: RALU cycle does not select correct ALUOp.");
//	end
//	
//	#(2*HALF_PERIOD)
//	$display("Cycle 4");
//	$display("out_writeEnable: %b", out_writeEnable);
//	$display("out_regDataWrite: %b", out_regDataWrite);
//	if(out_regDataWrite != 000) begin
//		failures = failures + 1;
//		$display("Error: ALUWrite cycle does not select correct register data input.");
//	end
//	if(out_writeEnable != 1) begin
//		failures = failures + 1;
//		$display("Error: ALUWrite cycle does not enable writing to the register file.");
//	end
//	
//	
//	resetReg = 1;
//	#(2*HALF_PERIOD)
//	resetReg = 0;
//	
//	//Test: AND
//	input_opcode = 4;
//	input_cmpRst = 0;
//	$display("Testing AND");
//	#(2*HALF_PERIOD);
//	$display("Cycle 1");
//	$display("out_memAddrSel: %b", out_memAddrSel);
//	$display("out_memEnableRead: %b", out_memEnableRead);
//	$display("out_IRWrite: %b", out_IRWrite);
//	if(out_memAddrSel != 0) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not choose correct memory selection.");
//	end
//	if(out_memEnableRead != 1) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not enable reading from memory.");
//	end
//	if(out_IRWrite != 1) begin
//		failures = failures + 1;
//		$display("Error: FETCH cycle does not allow loading an instruction into the instruction register");
//	end
//
//	#(2*HALF_PERIOD);
//	$display("Cycle 2");
//	$display("out_immShift: %b", out_immShift);
//	$display("out_ALUOp: %b", out_ALUOp);
//	$display("out_numBits: %b", out_numBits);
//	$display("out_ALUSrcA: %b", out_ALUSrcA);
//	$display("out_ALUSrcB: %b", out_ALUSrcB);
//	$display("out_PCWriteEnable: %b", out_PCWriteEnable);
//	$display("out_PCSource: %b", out_PCSource);
//	$display("out_IRWrite: %b", out_IRWrite);
//	if(out_immShift != 1) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not set immShift to 1.");
//	end
//	if(out_ALUOp != 000) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUOp.");
//	end
//	if(out_ALUSrcA != 0) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUSrcA.");
//	end
//	if(out_ALUSrcB != 1) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong ALUSrcB.");
//	end
//	if(out_numBits != 3) begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not set numBits to 11.");
//	end
//	if(out_PCWriteEnable != 1)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not enable writing to the PC.");
//	end
//	if(out_PCSource != 0)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle uses wrong PCSource.");
//	end
//	if(out_IRWrite != 1)begin
//		failures = failures + 1;
//		$display("Error: DECODE cycle does not enable writing to the Instruction Register.");
//	end
//
//	#(2*HALF_PERIOD)
//	$display("Cycle 3");
//	$display("out_ALUOp: %b", out_ALUOp);
//	$display("out_ALUSrcA: %b", out_ALUSrcA);
//	$display("out_ALUSrcB: %b", out_ALUSrcB);
//	if(out_ALUSrcA != 1) begin
//		failures = failures + 1;
//		$display("Error: RALU cycle does not select correct ALUSrcA.");
//	end
//	if(out_ALUSrcB != 1) begin
//		failures = failures + 1;
//		$display("Error: RALU cycle does not select correct ALUSrcB.");
//	end
//	if(out_ALUOp != 2) begin
//		failures = failures + 1;
//		$display("Error: RALU cycle does not select correct ALUOp.");
//	end
//	
//	#(2*HALF_PERIOD)
//	$display("Cycle 4");
//	$display("out_writeEnable: %b", out_writeEnable);
//	$display("out_regDataWrite: %b", out_regDataWrite);
//	if(out_regDataWrite != 000) begin
//		failures = failures + 1;
//		$display("Error: ALUWrite cycle does not select correct register data input.");
//	end
//	if(out_writeEnable != 1) begin
//		failures = failures + 1;
//		$display("Error: ALUWrite cycle does not enable writing to the register file.");
//	end
//	
//	
//	resetReg = 1;
//	#(2*HALF_PERIOD)
//	resetReg = 0;
//	
//
//	$display("Done testing. \nError total: %d", failures);
end


endmodule
