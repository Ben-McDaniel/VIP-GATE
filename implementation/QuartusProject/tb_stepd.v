//How to use this test file:
//In total there is "1" test which when run tests 'TST, jalr, branch' and ensure that the pc is implemented
//correctly. If youre feeling bold you can just run it, however it works best to comment out all of the 
//individual parts. My recomended order for testing is-
//1) add and make sure the pc gets updated 
//2) add and TST1
//3) TST2 and beq
//4) jalr
// if you do run everything, pc should end at 0, you will also need to remove setting the pc before each
// test, since the previous test will have done that


module tb_stepd();

reg [1:0] immShiftReg;
wire opReg;
wire [1:0] cmpRstReg;
wire outputWire;
reg [2:0] ALUOpReg;
reg writeEnableReg;
reg [1:0] numBitsReg;
reg memAddrSelReg;
reg ALUSrcAReg;
reg ALUSrcBReg;
reg memEnableReadReg;
reg memEnableWriteReg;
reg PCWriteEnableReg;
reg PCSourceReg;
reg IRWriteReg;
reg [2:0] regDataWriteReg;
reg DOrSReg;
reg clockReg;
reg resetReg; 


newStep4 UUT(
	.immShift(immShiftReg),
	.op(opReg),
	.cmpRst(cmpRstReg),
	.ALUOp(ALUOpReg),
	.writeEnable(writeEnableReg),
	.numBits(numBitsReg),
	.memAddrSel(memAddrSelReg),
	.ALUSrcA(ALUSrcAReg),
	.ALUSrcB(ALUSrcBReg),
	.memEnableRead(memEnableReadReg),
	.memEnableWrite(memEnableWriteReg),
	.PCWriteEnable(PCWriteEnableReg),
	.regDataWrite(regDataWriteReg),
	.DOrS(DOrSReg),
	.IRWrite(IRWriteReg),
	.CLK(clockReg),
	.reset(resetReg),
	.inputWire(0),
	.outputWire(outputWire),
	.PCSource(PCSourceReg)
);


parameter HALF_PERIOD = 50;

integer failures = 0;

initial begin
	PCWriteEnableReg = 0;
	IRWriteReg = 0;
	memEnableWriteReg = 0;
	writeEnableReg = 0;
    clockReg = 1;
    forever begin
        #(HALF_PERIOD);
        clockReg = ~clockReg;
    end
end




//memory file:
//add r5 r6 r6 0000010101100110
//tst r5 r6    1010111101010110
//tst r0 r0    1010111100000000
//beq 2        1000000000000010
//NOP          0000000000000000
//jalr r8 2(r9) //need r9 to have -12     1011100010010010

//registers
//r5 = 2, r6 = 10, r9 = -12

//memory:
//0566
//AF56
//AF00
//8002
//0000
//B892


initial begin
	resetReg = 0;
	#(2*HALF_PERIOD);
	
	//fetch
	memAddrSelReg = 0;
	memEnableReadReg = 1;
	IRWriteReg = 1;
	PCWriteEnableReg = 0;
	memEnableWriteReg = 0;
	writeEnableReg = 0;
	
	#(2*HALF_PERIOD);
	
	//decode
	immShiftReg = 'b01;
	ALUOpReg = 'b000;
	ALUSrcAReg = 0;
	ALUSrcBReg = 1;
	numBitsReg = 'b11;
	PCWriteEnableReg = 1;
	PCSourceReg = 0;
	IRWriteReg = 0;
	memEnableReadReg = 0;
	
	#(2*HALF_PERIOD);
	
	//Mem
	immShiftReg = 'b00;
	ALUOpReg = 'b000;
	ALUSrcAReg = 1;
	ALUSrcBReg = 1;
	numBitsReg = 'b01;
	PCWriteEnableReg = 0;
	
	#(2*HALF_PERIOD);

	
	//sw
	memAddrSelReg = 1;
	memEnableWriteReg = 1;
	memEnableReadReg = 0;
	
	#(2*HALF_PERIOD);


//	//test 1: add and confirm pc increments
//	
//	//fetch
//	memAddrSelReg = 0;
//	memEnableReadReg = 1;
//	IRWriteReg = 1;
//	PCWriteEnableReg = 0;
//	memEnableWriteReg = 0;
//	writeEnableReg = 0;
//	
//	#(2*HALF_PERIOD);
//	
//	//decode
//	immShiftReg = 'b01;
//	ALUOpReg = 'b000;
//	ALUSrcAReg = 0;
//	ALUSrcBReg = 1;
//	numBitsReg = 'b11;
//	PCWriteEnableReg = 1;
//	PCSourceReg = 0;
//	IRWriteReg = 0;
//	memEnableReadReg = 0;
//	
//	#(2*HALF_PERIOD);
//	
//	//RALU
//	ALUOpReg = 'b000;
//	ALUSrcAReg = 1;
//	ALUSrcBReg = 0;
//	PCWriteEnableReg = 0;
//	DOrSReg = 0;
//	
//	#(2*HALF_PERIOD);
//	
//	//ALUWrite
//	regDataWriteReg = 'b000;
//	writeEnableReg = 1;
//	
//	#(2*HALF_PERIOD);
//	
//	$display("check that 2*r6 is in r5");
//	
//	#(2*HALF_PERIOD);
//	
//	
//	//test 2: add and TST, confirm tst works on newly updated reg
//	
//	//fetch
//	memAddrSelReg = 0;
//	memEnableReadReg = 1;
//	IRWriteReg = 1;
//	PCWriteEnableReg = 0;
//	memEnableWriteReg = 0;
//	writeEnableReg = 0;
//	
//	#(2*HALF_PERIOD);
//	
//	//decode
//	immShiftReg = 'b01;
//	ALUOpReg = 'b000;
//	ALUSrcAReg = 0;
//	ALUSrcBReg = 1;
//	numBitsReg = 'b11;
//	PCWriteEnableReg = 1;
//	PCSourceReg = 0;
//	IRWriteReg = 0;
//	memEnableReadReg = 0;
//	
//	#(2*HALF_PERIOD);
//	
//	//TST
//	regDataWriteReg = 'b100;
//	writeEnableReg = 1;
//	PCWriteEnableReg = 0;
//	DOrSReg = 0;
//	
//	#(2*HALF_PERIOD);
//	
//	//Wait
//	
//	#(2*HALF_PERIOD);
//	
//	$display("tst r5 and r6");
//	
//	#(2*HALF_PERIOD);
//	
//	
//	//test 3: TST 0 = 0 and the 
//	
//	//fetch
//	memEnableReadReg = 1;
//	IRWriteReg = 1;
//	PCWriteEnableReg = 0;
//	memEnableWriteReg = 0;
//	writeEnableReg = 0;
//	
//	#(2*HALF_PERIOD);
//	
//	//decode
//	immShiftReg = 'b01;
//	ALUOpReg = 'b000;
//	ALUSrcAReg = 0;
//	ALUSrcBReg = 1;
//	numBitsReg = 'b11;
//	PCWriteEnableReg = 1;
//	PCSourceReg = 0;
//	IRWriteReg = 0;
//	memEnableReadReg = 0;
//	
//	#(2*HALF_PERIOD);
//	
//	//TST
//	regDataWriteReg = 'b100;
//	writeEnableReg = 1;
//	PCWriteEnableReg = 0;
//	DOrSReg = 0;
//	
//	#(2*HALF_PERIOD);
//	
//	//Wait
//	
//	#(2*HALF_PERIOD);
//	
//	$display("tst 0s");
//	
//	#(2*HALF_PERIOD);
//	
//	
//	//test 4: beq 4
//	//fetch
//	memEnableReadReg = 1;
//	IRWriteReg = 1;
//	PCWriteEnableReg = 0;
//	memEnableWriteReg = 0;
//	writeEnableReg = 0;
//	
//	#(2*HALF_PERIOD);
//	
//	//decode
//	immShiftReg = 'b01;
//	ALUOpReg = 'b000;
//	ALUSrcAReg = 0;
//	ALUSrcBReg = 1;
//	numBitsReg = 'b11;
//	PCWriteEnableReg = 1;
//	PCSourceReg = 0;
//	IRWriteReg = 0;
//	memEnableReadReg = 0;
//	
//	#(2*HALF_PERIOD);
//	
//	//BPause
//	PCWriteEnableReg = 0;
//	#(2*HALF_PERIOD);
//	
//	//BWrite
//	PCWriteEnableReg = 1;
//	PCSourceReg = 1;
//	
//	#(2*HALF_PERIOD);
//	
//	// Wait
//	
//	#(2*HALF_PERIOD);
//	
//	
//	
//	//test 5: jalr back to test 1
//	
//	//fetch
//	memEnableReadReg = 1;
//	IRWriteReg = 1;
//	PCWriteEnableReg = 0;
//	memEnableWriteReg = 0;
//	writeEnableReg = 0;
//	
//	#(2*HALF_PERIOD);
//	
//	//decode
//	immShiftReg = 'b01;
//	ALUOpReg = 'b000;
//	ALUSrcAReg = 0;
//	ALUSrcBReg = 1;
//	numBitsReg = 'b11;
//	PCWriteEnableReg = 1;
//	PCSourceReg = 0;
//	IRWriteReg = 0;
//	memEnableReadReg = 0;
//	
//	#(2*HALF_PERIOD);
//	
//	//membase
//	immShiftReg = 'b00;
//	ALUOpReg = 'b000;
//	ALUSrcAReg = 'b1;
//	ALUSrcBReg = 'b1;
//	numBitsReg = 'b01;
//	PCWriteEnableReg = 'b0;
//	
//	#(2*HALF_PERIOD);
//	
//	//jalr
//	regDataWriteReg = 'b010;
//	PCSourceReg = 'b1;
//	PCWriteEnableReg = 'b1;
//	writeEnableReg = 'b1;
//	DOrSReg = 'b0;
//	
//	
//	$display("jalr");
//	
//	#(2*HALF_PERIOD);

end


//	//test 2: beq (MAKE SURE r15 is 0)
//	//This test starts at a beq and jumps backwards to the add instruction above
//	//all instructions in between add 1 to r7 (C701), use this to see if any instructions in
//	//between are called and if so how many times
//	0345
//	C701
//	C701
//	C701
//	
//	pc = 0;
//	memAddrSelReg = 0;
//	IRWriteReg = 1;
//	memToRegReg = 0;
//	ALUOpReg = 0;
//	ALUSrcAReg = 1;
//	numBitsReg = 'b10;
//	immShiftReg = 0;
//	ALUSrcBReg = 1;
//	
//	//fetch and decode
//	//wait a cycle
//	$display("
//	
//
//
//	//test 3: jalr
//	//This test starts at jalr and jumps forwards to the add instruction from test 1
//	//all instructions in between add 1 to r7, use this to see if any instructions in
//	//between are called and if so how many times


endmodule