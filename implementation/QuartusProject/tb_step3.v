module tb_step3();

reg [1:0] numBitsReg;
reg IRWriteReg;
reg [1:0] immShiftReg;
reg ALUSrcAReg;
reg ALUSrcBReg;
reg [2:0] ALUOpReg;
reg writeEnableReg;
reg DOrSReg;
reg memEnableWriteReg;
reg memEnableReadReg;
reg PCWriteEnableReg;
reg PCSourceReg;
reg [2:0] regDataWriteReg;
reg loadInstReg;
reg memAddrSelReg;
wire [1:0] cmpRstWire;
wire [3:0] opWire;
reg clockReg;
step3 UTT(
	.numBits(numBitsReg),
	.IRWrite(IRWriteReg),
	.immShift(immShiftReg),
	.ALUSrcA(ALUSrcAReg),
	.ALUSrcB(ALUSrcBReg),
	.ALUOp(ALUOpReg),
	.writeEnable(writeEnableReg),
	.DOrS(DOrSReg),
	.memEnableWrite(memEnableWriteReg),
	.memEnableRead(memEnableReadReg),
	.PCWriteEnable(PCWriteEnableReg),
	.PCSource(PCSourceReg),
	.regDataWrite(regDataWriteReg),
	.loadInst(loadInstReg),
	.memAddrSel(memAddrSelReg),
	.cmpRst(cmpRstWire),
	.op(opWire),
	.CLK(clockReg)
);

parameter HALF_PERIOD = 50;
parameter PERIOD = HALF_PERIOD * 2;

integer failures = 0;
initial begin
    clockReg = 1;
    forever begin
        #(HALF_PERIOD);
        clockReg = ~clockReg;
    end
end

initial begin
#PERIOD;

memAddrSelReg = 'b0;
memEnableReadReg = 'b1;
IRWriteReg = 'b1;

#PERIOD;

immShiftReg = 'b1;
ALUOpReg = 'b000;
ALUSrcAReg = 'b0;
ALUSrcBReg = 'b1;
numBitsReg = 'b11;
PCWriteEnableReg = 'b1;
PCSourceReg = 'b0;
IRWriteReg = 'b0;

#PERIOD;

ALUOpReg = 'b00;
ALUSrcAReg = 'b1;
ALUSrcBReg = 'b0;
DOrSReg = 'b0;

#PERIOD;

regDataWriteReg = 'b000;
writeEnableReg = 'b1;

end
endmodule