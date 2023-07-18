//to perform these tests, set r4 =5, r5 = 2

module tb_stepb();

reg ALUSrcBReg;
reg clockReg;
reg [2:0] ALUOpReg;
wire signed [15:0] ALUOutWire;
reg [15:0] loadInstReg;
reg enableLoadInst;
reg [1:0] immShiftReg;
reg [1:0] numBitsReg;
reg resetReg;
wire [3:0] OpOut;
wire signed [15:0] BOut;
wire signed [15:0] AOut;

newStep2 UUT(	
	.CLK(clockReg),
	.ALUOut(ALUOutWire),
	.writeEnable(0),
	.dataWrite(0),
	.ALUSrcA(1), //trivial to test if can handle another input 
	.ALUSrcB(ALUSrcBReg),
	.ALUOp(ALUOpReg),
	
	
	.instruction(loadInstReg), //IR input
	.IRWrite(enableLoadInst),
	//imm gen signals
	.numBits(numBitsReg),
	.immShift(immShiftReg),
	.PC(0),
	.reset(resetReg),
	.A(AOut),
	.B(BOut),
	.Op(OpOut)
);




parameter HALF_PERIOD = 50;

integer failures = 0;

initial begin
    clockReg = 1;
	 resetReg = 0;
    forever begin
        #(HALF_PERIOD);
        clockReg = ~clockReg;
    end
end

initial begin

	#(2 * HALF_PERIOD); // Gives user a chance to initialize r4 and r5

	enableLoadInst = 1;
	$display("test 1: add");
	//test 1 add 2 regs from inst
	loadInstReg = 'b0000000001000101; //add r0 r4 r5
	numBitsReg = 0;
	immShiftReg = 0;
	ALUSrcBReg = 0;
	ALUOpReg = 0;
	#(2*HALF_PERIOD);
	enableLoadInst = 0;
	
	#(8*HALF_PERIOD);
	if(ALUOutWire != 7)begin
		failures = failures + 1;
		$display("FAILED: ALUOut = %d",ALUOutWire);
	end
	
	 resetReg = 1;

    #(4*HALF_PERIOD);

    resetReg = 0;

    #(2*HALF_PERIOD);
	

	//test 2 addi
	$display("test 2: addi");
	enableLoadInst = 1;
	loadInstReg = 'b1100010000001010; //addi r4 10
	numBitsReg = 'b10;
	immShiftReg = 0;
	ALUSrcBReg = 1;
	ALUOpReg = 0;
	#(2*HALF_PERIOD);
	enableLoadInst = 0;
	#(8*HALF_PERIOD);
	if(ALUOutWire != 15)begin
		failures = failures + 1;
		$display("FAILED: ALUOut = %d",ALUOutWire);
	end
	
	 resetReg = 1;

    #(4*HALF_PERIOD);

    resetReg = 0;

    #(2*HALF_PERIOD);

	//test 3 lw/sw/jalr -> add SE(imm)
	$display("test 3: add SE(imm)");
	enableLoadInst = 1;
	loadInstReg = 'b1011000001010101;   //jalr r0 r5 5, expecting 2+10 from 2+SE(5)
	numBitsReg = 'b01;
	immShiftReg = 'b01;
	ALUSrcBReg = 1;
	ALUOpReg = 0;
	#(2*HALF_PERIOD);
	enableLoadInst = 0;
	#(8*HALF_PERIOD);	if(ALUOutWire != 12)begin
		failures = failures + 1;
		$display("FAILED: ALUOut = %d",ALUOutWire);
	end
end

endmodule