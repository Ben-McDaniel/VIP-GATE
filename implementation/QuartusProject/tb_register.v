module tb_register();

wire signed [15:0] doutWire;
reg [15:0] dinReg;
reg regWriteReg;
reg resetReg;
reg clockReg;

register UTT(
	.din(dinReg),
	.reset(resetReg),
	.CLK(clockReg),
	.regWrite(regWriteReg),
	.dout(doutWire)
	);

parameter HALF_PERIOD = 50;

integer reg_val = -32768;
integer cycle_counter = 0;
integer failures = 0;

initial begin
    clockReg = 0;
    forever begin
        #(HALF_PERIOD);
        clockReg = ~clockReg;
    end
end

initial begin
	//Test 1
	//Resetting a reg
	$display("Testing resetting a register.");
	resetReg = 1;
	#(2*HALF_PERIOD);
	resetReg = 0;
	if(doutWire != 0) begin 
		failures = failures + 1;
		$display("(RESET) Error: register does not initially reset to 0.");
	end
	dinReg = 1;
	regWriteReg = 1;
	#(2*HALF_PERIOD);
	resetReg = 1;
	#(2*HALF_PERIOD);
	resetReg = 0;
	if(doutWire != 0) begin 
		failures = failures + 1;
		$display("(RESET) Error: register does not reset to 0 after being set.");
	end
	//Test 2
	//Setting a reg
	$display("Testing setting a register.");
	resetReg = 1;
	#(2*HALF_PERIOD);
	resetReg = 0;
	cycle_counter = 0;
	regWriteReg = 1;
	repeat(65535) begin
		dinReg = reg_val;
		#(2*HALF_PERIOD);
		cycle_counter = cycle_counter + 1;
		if(doutWire != reg_val) begin
			failures = failures + 1;
			$display("(SET) Error at cycle %d: input %d, output %d.", cycle_counter, reg_val, doutWire);
		end
		reg_val = reg_val + 1;
	end
	
	$display("Done testing.\nError total: %d", failures);
end
endmodule
		