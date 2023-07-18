//to perform these tests, set r4 =5, r5 = 2
//these tests must be done one at a time, with the memory file
//changed to have the correct instructions. The intended use 
//is to comment all but one test out at a time, change the memory
//file and run that test

module tb_stepc();

reg memAddrSelReg;
reg [15:0] pc; //0 input to memory mux
reg memEnableWriteReg;
reg loadInstReg;
reg memToRegReg;
reg ALUSrcAReg;
reg ALUSrcBReg;
reg [1:0] immShiftReg;
reg [1:0] numBitsReg;
reg [2:0] ALUOpReg;
reg clockReg;
reg writeEnableReg;
reg resetReg;
reg memEnableReadReg;
reg [2:0] regDataWriteReg;
wire [15:0] AWire;
wire [15:0] BWire;
wire [15:0] ALUOutWire;
wire [3:0] OpWire;
wire [15:0] outputWire;


newStep3 UUT(
	.memAddrSel(memAddrSelReg),
	.memEnableRead(memEnableReadReg),
	.memEnableWrite(memEnableWriteReg),
	.IRWrite(loadInstReg),
	.PC(pc),
	.ALUSrcA(ALUSrcAReg),
	.ALUSrcB(ALUSrcBReg),
	.ALUOp(ALUOpReg),
	.numBits(numBitsReg),
	.immShift(immShiftReg),
	.writeEnable(writeEnableReg),
	.CLK(clockReg),
	.reset(resetReg),
	.inputWire(15),
	.regDataWrite(regDataWriteReg),
	.compOut(0),
	.A(AWire),
	.B(BWire),
	.ALUOut(ALUOutWire),
	.Op(OpWire),
	.outputWire(outputWire)
);


parameter HALF_PERIOD = 50;

integer failures = 0;

initial begin
	regDataWriteReg = 0;
	resetReg = 0;
    clockReg = 1;
    forever begin
        #(HALF_PERIOD);
        clockReg = ~clockReg;
    end
end

initial begin
	#(2*HALF_PERIOD);

	//test 1: simple add
	//make sure registers are loaded (top of file)
	//0x345 at memory[0] (add r3 r4 r5)
	
	// Setting data
	pc = 0;
	
	//Fetch
	memAddrSelReg = 'b000;
	loadInstReg = 1;
	memEnableReadReg = 1;

	#(2*HALF_PERIOD);
	//Decode
	ALUOpReg = 0;
	immShiftReg = 1;
	loadInstReg = 0;
	ALUSrcAReg = 0;
	ALUSrcBReg = 1;
	numBitsReg = 'b11;
	
	#(2*HALF_PERIOD);
	//Execute
	ALUOpReg = 0;
	ALUSrcAReg = 1;
	ALUSrcBReg = 0;
	
	#(2*HALF_PERIOD);
	//Write Back
	regDataWriteReg = 'b000;
	writeEnableReg = 1;
	#(2*HALF_PERIOD);

	$display("test 1 done, check that 7 is stored in reg 3");
	
	#(2*HALF_PERIOD);
	writeEnableReg = 0;
	resetReg = 1;
	#(4*HALF_PERIOD);
	resetReg = 0;
	#(2*HALF_PERIOD);


	
	//test 2, writing to memory (write r4 to memory address 7)
	//7407 at memory[0]
	
	//Fetch
	memAddrSelReg = 0;
	memEnableReadReg = 1;
	loadInstReg = 1;
	
	#(2*HALF_PERIOD);
	//Decode
	immShiftReg = 1;
	ALUOpReg = 0;
	ALUSrcAReg = 0;
	ALUSrcBReg = 1;
	numBitsReg = 3;
	loadInstReg = 0;
	
	#(2*HALF_PERIOD);
	//Execute
	immShiftReg = 0;
	ALUOpReg = 0;
	ALUSrcAReg = 1;
	ALUSrcBReg = 1;
	numBitsReg = 1;
	
	#(2*HALF_PERIOD);
	//Store in Mem
	memAddrSelReg = 1;
	$display("memAddrSel");
	$display(memAddrSelReg);
	memEnableWriteReg = 1;
	

	#(2*HALF_PERIOD);
	
	$display("test 2 done: check that 5 has been written to mem[7]");

end

endmodule