module newStep1(
	input CLK,
	input [2:0] ALUOp,
	input signed [15:0] immediate,
	input ALUSrcA,
	input ALUSrcB,
	input reset,
	input [3:0] rdAddr,
	input [3:0] rs0Addr,
	input [3:0] rs1Addr,
	input writeEnable,
	input signed [15:0] dataWrite,
	input [15:0] PC,
	output wire signed [15:0] ALUOut,
	output wire signed [15:0] A,
	output wire signed [15:0] B
);

reg signed [15:0] ALUA;
reg signed [15:0] ALUB;
wire signed [15:0] AValue;
wire signed [15:0] BValue;

alu ALU(
	.A(ALUA),
	.B(ALUB),
	.ALUOp(ALUOp),
	.ALUOut(ALUOut)
	);
	
register AReg(
	.din(AValue),
	.dout(A),
	.reset(reset),
	.regWrite(~reset),
	.CLK(CLK)
);

register BReg(
	.din(BValue),
	.dout(B),
	.reset(reset),
	.regWrite(~reset),
	.CLK(CLK)
);

registerFile regFile(
	.regWrite(writeEnable),
	.rd(rdAddr),
	.dataWrite(dataWrite),
	.rs0(rs0Addr),
	.rs1(rs1Addr),
	.CLK(CLK),
	.A(AValue),
	.B(BValue),
	.reset(reset)
);

initial begin
	ALUA = 0;
	ALUB = 0;
end

always @ (posedge(CLK))
begin
	if(ALUSrcA == 0) begin
		ALUA = PC;
	end
	if(ALUSrcA == 1) begin
		ALUA = A;
	end
	if(ALUSrcB == 0) begin
		ALUB = B;
	end
	if(ALUSrcB == 1) begin
		ALUB = immediate;
	end

end
	
endmodule