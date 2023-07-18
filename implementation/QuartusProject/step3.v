module step3(
	input [1:0] numBits,
	input IRWrite,
	input [1:0] immShift,
	input ALUSrcA,
	input ALUSrcB,
	input [2:0] ALUOp,
	input writeEnable,
	input DOrS,
	input memEnableWrite,
	input memEnableRead,
	input PCWriteEnable,
	input PCSource,
	input [2:0] regDataWrite,
	input loadInst,
	input memAddrSel,
	input CLK,
	
	output reg [1:0] cmpRst,
	output reg [3:0] op
	);

wire signed [15:0] ALUOutWire;
wire signed [15:0] AWire;
wire signed [15:0] BWire;
wire signed [15:0] immGenWire;
reg [15:0] instructionReg;
reg [3:0] rs0Reg;
reg [3:0] rs1Reg;
reg signed [15:0] dataWriteReg;
reg [15:0] PCReg;

step2 UTT(
	.instruction(instructionReg),
	.rs0(rs0Reg),
	.rs1(rs1Reg),
	.dataWrite(dataWriteReg),
	.writeEnable(writeEnable),
	.ALUSrcA(ALUSrcA),
	.PC(PCReg),
	.ALUSrcB(ALUSrcB),
	.ALUOp(ALUOp),
	.numBits(numBits),
	.immShift(immShift),
	.DOrS(DOrS),
	.CLK(CLK),
	.IRWrite(IRWrite),

	.ALUOut(ALUOutWire),
	.A(AWire),
	.B(BWire),
	.immGen(immGenWire)
	);

reg [15:0] aluPCA;
reg [15:0] aluPCB = 2;
reg [2:0] aluPCOP = 0;
wire signed [15:0] aluPCWire;
	
alu UTT2(
	.A(aluPCA),
	.B(aluPCB),
	.ALUOp(aluPCOP),
	.CLK(CLK),
	.ALUOut(aluPCWire)
	);
	
reg [15:0] cmpA;
reg [15:0] cmpB;
wire signed [15:0] doutCMPWire;

comparator UTT3(
	.A(cmpA),
	.B(cmpB),
	.CLK(CLK),
	.dout(doutCMPWire)
	);

reg [15:0] dataWriteMem;
reg [15:0] memAddr;
wire signed [15:0] dataReadMem;

memory UTT4(
	.data(dataWriteMem),
	.addr(memAddr),
	.we(memEnableWrite),
	.clk(CLK),
	.q(dataReadMem)
	);

reg [15:0] PCdinReg;
wire signed [15:0] PCOut;
reg reset = 0;
register PCRegister(
	.din(PCdinReg),
	.dout(PCOut),
	.reset(reset),
	.regWrite(PCWriteEnable),
	.CLK(CLK)
);
reg [15:0] MDRReg;
wire signed [15:0] MDROut;
register MDRRegister(
	.din(MDRReg),
	.dout(MDROut),
	.reset(reset),
	.regWrite(reset),
	.CLK(CLK)
);

always @ (posedge(CLK))
begin
	aluPCA = PCOut;
	if(PCSource == 0) begin
		PCdinReg = aluPCWire;
	end else begin
		PCdinReg = ALUOutWire;
	end
	
	if(memAddrSel == 0) begin
		memAddr = PCOut;
	end else begin
		memAddr = ALUOutWire;
	end
	
	MDRReg = dataReadMem;

	instructionReg = dataReadMem;
	op = {dataReadMem[15:11]};
	rs0Reg = {dataReadMem[7:4]};
	rs1Reg = {dataReadMem[3:0]};
$display("Instruction: ");
$display(instructionReg);
$display("rs0Reg (Step 3): ");
$display(rs0Reg);
	
	cmpA = AWire;
	cmpB = BWire;
	
	if(regDataWrite == 0) begin
		dataWriteReg = ALUOutWire;
	end
	if(regDataWrite == 1) begin
		dataWriteReg = MDROut;
	end
	if(regDataWrite == 2) begin
		dataWriteReg = PCOut;
	end
	if(regDataWrite == 3) begin
		dataWriteReg = immGenWire;
	end
	if(regDataWrite == 4) begin
		dataWriteReg = doutCMPWire;
	end
	
	dataWriteMem = BWire;
	
	PCReg = PCOut;
	
	cmpRst = doutCMPWire;
end	
endmodule