module newStep2(
	input CLK,
	input [2:0] ALUOp,
	input ALUSrcA,
	input ALUSrcB,
	input reset,
	input writeEnable,
	input signed [15:0] dataWrite,
	input [1:0] immShift,
	input [1:0] numBits,
//	input loadInst,
	input IRWrite,
	input [15:0] instruction,
	input [15:0] PC,
	output wire signed [15:0] A,
	output wire signed [15:0] B,
	output wire signed [15:0] ALUOut, //This is the register output this time
	output wire [3:0] Op,
	output wire signed [15:0] immediateGenerated
);

wire [3:0] rdAddr;
wire [3:0] rs1Addr;
wire [3:0] rs0Addr;
wire signed [15:0] ALUsOutput;
wire [15:0] instructionOutput;

newStep1 UUT(
	.CLK(CLK),
	.ALUOp(ALUOp),
	.immediate(immediateGenerated),
	.ALUSrcA(ALUSrcA),
	.ALUSrcB(ALUSrcB),
	.reset(reset),
	.rdAddr(rdAddr),
	.rs0Addr(rs0Addr),
	.rs1Addr(rs1Addr),
	.writeEnable(writeEnable),
	.dataWrite(dataWrite),
	.PC(PC),
	.ALUOut(ALUsOutput),
	.A(A),
	.B(B)
);

register ALUOutReg(
	.din(ALUsOutput),
	.reset(reset),
	.dout(ALUOut),
	.CLK(CLK),
	.regWrite(~reset)
);


instructionRegister IR(
	.instruction(instruction),
	.reset(reset),
	.regWrite(IRWrite),
	.CLK(CLK),
	.instructionOut(instructionOutput),
	.rs1Addr(rs1Addr),
	.rs0Addr(rs0Addr),
	.rdAddr(rdAddr),
	.Opcode(Op)
);

immediateGenerator immGen(
	.din(instructionOutput),
	.numBits(numBits),
	.immShift(immShift),
	.dout(immediateGenerated)
	);

endmodule