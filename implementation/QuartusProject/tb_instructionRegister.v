module tb_instructionRegister ();

reg [15:0] instruction;
reg reset;
reg regWrite;
reg CLK;
wire [15:0] instructionOut;
wire [3:0] rs1Addr;
wire [3:0] rs0Addr;
wire [3:0] rdAddr;
wire [3:0] op;

instructionRegister IR(
	.instruction(instruction),
	.reset(reset),
	.regWrite(regWrite),
	.CLK(CLK),
	.instructionOut(instructionOut),
	.rs1Addr(rs1Addr),
	.rs0Addr(rs0Addr),
	.rdAddr(rdAddr),
	.Opcode(op)
);

parameter HALF_PERIOD = 50;
parameter PERIOD = 2 * HALF_PERIOD;

integer failures = 0;

initial begin
    CLK = 0;
	 instruction = 0;
	 reset = 0;
	 regWrite = 0;
    forever begin
        #(HALF_PERIOD);
        CLK = ~CLK;
    end
end
	

initial begin
	//Test 1
	//Test op = 0, rd = 3, rs0 = 3, rs1 = 4
	$display("Testing op = 0, rd = 3, rs0 = 3, rs1 = 4.");
	instruction = 'h0334;
	regWrite = 1;
	#(PERIOD);
	regWrite = 0;
	if(op != 0 || rdAddr != 3 || rs0Addr != 3 || rs1Addr != 4 || instructionOut != 'h0334) begin
		failures = failures + 1;
		$display("Error: expected 000001100110100, got %d", instructionOut);
	end
	
	//Test 2
	//Test op = 15, rd = 12, rs0 = 2, rs1 = 7
	$display("Testing op = 15, rd = 12, rs0 = 2, rs1 = 7.");
	instruction = 'hFC27;
	regWrite = 1;
	#(PERIOD);
	regWrite = 0;
	if(op != 15 || rdAddr != 12 || rs0Addr != 2 || rs1Addr != 7 || instructionOut != 'hFC27) begin
		failures = failures + 1;
		$display("Error: expected 1111110000100111, got %d", instructionOut);
	end
	
	//Test 3
	//Test op = 15, rd = 12, rs0 = 2, rs1 = 7
	$display("Testing STILL op = 15, rd = 12, rs0 = 2, rs1 = 7.");
	instruction = 'h0000;
	#(PERIOD);
	if(op != 15 || rdAddr != 12 || rs0Addr != 2 || rs1Addr != 7 || instructionOut != 'hFC27) begin
		failures = failures + 1;
		$display("Error: expected 1111110000100111, got %d", instructionOut);
	end
	$display("Done testing.\nError total: %d", failures);
end 
endmodule