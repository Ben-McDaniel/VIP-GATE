//wire going into mux called 'mux1'
//to perform these tests, set r4 =5, r5 = 2

module tb_stepa();
reg ALUSrcAReg;
reg ALUSrcBReg;
reg clockReg;
reg [2:0] ALUOpReg;
wire signed [15:0] ALUOutWire;
wire signed [15:0] AWire;
wire signed [15:0] BWire;
reg [15:0] muxInputWire;
reg writeEnableReg;
reg [15:0] dataWriteReg;
reg resetReg;


newStep1 UUT(
	.rdAddr(0),
	.rs0Addr(4),
	.rs1Addr(5),
	.immediate(muxInputWire),
	.reset(resetReg),
	.CLK(clockReg),
	.ALUOut(ALUOutWire),
	.A(AWire),
	.B(BWire),
	.ALUSrcA(ALUSrcAReg),
	.ALUSrcB(ALUSrcBReg),
	.ALUOp(ALUOpReg),
	.writeEnable(writeEnableReg),
	.dataWrite(dataWriteReg),
	.PC(22)
);

parameter HALF_PERIOD = 50;

integer failures = 0;

initial begin
    clockReg = 1;
	 resetReg = 0;
	 writeEnableReg = 0;
	 dataWriteReg = 0;
    forever begin
        #(HALF_PERIOD);
        clockReg = ~clockReg;
    end
end


initial begin	
	#(2*HALF_PERIOD); //Allows the system to be initialized so you can modify registers

	//test 1, r4 op r5 in 2 cycles
	ALUSrcAReg = 1; //use reg a
	ALUSrcBReg = 0; //use reg b
	ALUOpReg = 0; //add
	muxInputWire = 0;
	$display("testing 5 + 2");
	#(4*HALF_PERIOD);
	
	if(ALUOutWire != 7)begin
		failures = failures + 1;
		$display("FAILED: got %d", ALUOutWire);
	end
	resetReg = 1;

	#(2*HALF_PERIOD);

	resetReg = 0;

	#(2*HALF_PERIOD);

	//test 2 r4 op mux1 in 2 cycles
	ALUSrcBReg = 1;
	ALUOpReg = 0;
	muxInputWire = 10;
	$display("testing 5 + 10 using imm gen");
	#(4*HALF_PERIOD);
	
	if(ALUOutWire != 15)begin
		failures = failures + 1;
		$display("FAILED: got %d", ALUOutWire);
	end

	resetReg = 1;

	#(2*HALF_PERIOD);

	resetReg = 0;

	#(2*HALF_PERIOD);

	//test 3 r4 op mux1 in 2 cycles w/ overflow number
	muxInputWire = 65535;
	$display("5 + 65535, this will cause overflow");
	#(4*HALF_PERIOD);
	if(ALUOutWire != 4) begin
		failures = failures + 1;
		$display("FAILED: got %d",ALUOutWire);
	end

	resetReg = 1;

	#(2*HALF_PERIOD);

	resetReg = 0;

	#(2*HALF_PERIOD);
	
	//test 4 PC op r5 in 2 cycles
	ALUSrcAReg = 0;
	ALUSrcBReg = 0;
	ALUOpReg = 0;
	$display("testing 22 + 2 using PC");
	#(4*HALF_PERIOD);
	
	if(ALUOutWire != 24)begin
		failures = failures + 1;
		$display("FAILED: got %d", ALUOutWire);
	end
end

endmodule