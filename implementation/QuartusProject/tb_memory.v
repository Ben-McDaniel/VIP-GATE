module tb_memory();

wire signed [15:0] QWire;
reg [15:0] dataReg;
reg [15:0] addrReg;
reg weReg;
reg clockReg;
reg [15:0] inputReg;
wire [15:0] outputWire;

memory UTT(
	.data(dataReg),
	.addr(addrReg),
	.we(weReg),
	.clk(clockReg),
	.q(QWire),
	.inputWire(inputReg),
	.outputWire(outputWire)
	);

parameter HALF_PERIOD = 50;

integer failures = 0;

initial begin
	inputReg = 73;
    clockReg = 0;
    forever begin
        #(HALF_PERIOD);
        clockReg = ~clockReg;
    end
end

initial begin
   addrReg = 'h0000;
   dataReg = 'h1111;

   #(2*HALF_PERIOD);
   addrReg = addrReg + 1;
	
	#(2*HALF_PERIOD);
   addrReg = addrReg + 1;
	
	#(2*HALF_PERIOD);
   addrReg = addrReg + 1;
	
	#(2*HALF_PERIOD);
	addrReg = 'hFFFF;
	weReg = 1;
	dataReg = 'hbeef;
	
	#(2*HALF_PERIOD);
	addrReg = addrReg - 1;
	weReg = 0;

end
endmodule
