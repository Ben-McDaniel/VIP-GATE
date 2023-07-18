module step2(
	input [15:0] instruction,
	input [7:4] rs0,
	input [3:0] rs1,
	input  [15:0] dataWrite,
	input IRWrite,
	input writeEnable,
	input [1:0] immShift,
	input [1:0] numBits,
	input [2:0] ALUOp,
	input ALUSrcB,
	input ALUSrcA,
	input DOrS,
	input [15:0] PC,
	input CLK,
	output reg [15:0] immGen,
	output reg [15:0] ALUOut,
	output reg [15:0] A,
	output reg [15:0] B
);

reg reset = 0;
reg [3:0] rdReg;
reg [3:0] rs0Reg;
reg [3:0] rs1Reg;
reg [15:0] AReg;
reg [15:0] BReg;
reg [11:0] dinReg;
wire signed [15:0] AWire;
wire signed [15:0] BWire;
wire signed [15:0] immGenWire;
wire signed [15:0] ALUOutWire;
wire [15:0] instructionWire;

step1 UTT1(
	.A(AReg),
	.B(BReg),
	.ALUSrcB(ALUSrcB),
	.ALUOp(ALUOp),
	.din(dinReg),
	.numBits(numBits),
	.immShift(immShift),
	.CLK(CLK),
	.ALUOut(ALUOutWire),
	.immGen(immGenWire)
	);

registerFile UTT2(
	.regWrite(writeEnable),
	.rd(rdReg),
	.dataWrite(dataWrite),
	.rs0(rs0Reg),
	.rs1(rs1Reg),
	.CLK(CLK),
	.A(AWire),
	.B(BWire)
);

register UTT3(
	.din(instruction),
	.reset(reset),
	.dout(instructionWire),
	.CLK(CLK),
	.regWrite(IRWrite)
);

initial begin
	ALUOut = 0;
end

always @ (negedge(CLK))
begin
	$display("Instruction (step2): ");
$display(instruction);
$display("rs0Reg (Step 2): ");
$display(rs0Reg);
	if(ALUSrcA == 0) begin
		AReg = PC;
	end
	if(ALUSrcA == 1) begin
		AReg = AWire;
	end
	A = AWire;
	B = BWire;
	BReg = BWire;
$display("AWire: ");
$display(rs0Reg);
$display("BWire: ");
$display(rs1Reg);
	dinReg = {instruction[11:0]}; // switched
	rdReg = {instruction[11:8]}; // switched from wire
	if(DOrS == 0) begin
		rs0Reg = rs0; //switched
	end
	if(DOrS == 1) begin
		rs0Reg = rdReg;
	end
	immGen = immGenWire;
	rs1Reg = rs1; // switched
	ALUOut = ALUOutWire;
end
endmodule