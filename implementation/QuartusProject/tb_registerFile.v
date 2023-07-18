module tb_registerFile();

wire signed [15:0] AWire;
wire signed [15:0] BWire;
reg [3:0] rdReg;
reg [15:0] dataWriteReg;
reg [3:0] rs0Reg;
reg [3:0] rs1Reg;
reg clockReg;
reg regWriteReg;

registerFile UTT(
	.regWrite(regWriteReg),
	.rd(rdReg),
	.dataWrite(dataWriteReg),
	.rs0(rs0Reg),
	.rs1(rs1Reg),
	.CLK(clockReg),
	.A(AWire),
	.B(BWire)
	);

parameter HALF_PERIOD = 50;

integer failures = 0;
integer rd = 1;

initial begin
    clockReg = 0;
    forever begin
        #(HALF_PERIOD);
        clockReg = ~clockReg;
    end
end

initial begin
	//Test 1 
	//Test write to register
	$display("Testing writing to a register.");
	rdReg = 0;
	regWriteReg = 1;
	dataWriteReg = 15;
	#(2*HALF_PERIOD);
	rs0Reg = 0;
	#(2*HALF_PERIOD);
	if(AWire != 0) begin
		failures = failures + 1;
		$display("(WRITE) ERROR: trying to write to 0 register, expected 0, got %d", AWire);
	end
	repeat (15) begin
		rdReg = rd;
		dataWriteReg = rd;
		#(2*HALF_PERIOD);
		rs0Reg = rd;
		#(2*HALF_PERIOD);
		if(AWire != rd) begin
			failures = failures + 1;
			$display("(WRITE) ERROR: trying to write to %d register, expected %d, got %d", rdReg, rd, AWire);
		end
		rd = rd + 1;
	end
	//Test 2
	//Test read from register
	rd = 0;
	$display("Testing reading from a register.");
	repeat (15) begin
		rdReg = rd;
		dataWriteReg = rd;
		#(2*HALF_PERIOD);
		rs1Reg = rd;
		#(2*HALF_PERIOD);
		if(BWire != rd) begin
			failures = failures + 1;
			$display("(READ) ERROR: trying to read %d register, expected %d, got %d", rdReg, rd, BWire);
		end
		rd = rd + 1;
	end
	$display("Done testing.\nError total: %d", failures);
end 
endmodule