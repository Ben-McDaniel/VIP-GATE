module memory_tb;
	reg [9:0] addr;
	reg [15:0] din;
	wire [15:0] dout;
	reg we;
	reg clk;
	
	memory UUT (.addr(addr), .data(din), .we(we), .clk(clk), .q(dout));
	
	parameter HALF_PERIOD = 50;
	parameter PERIOD = HALF_PERIOD * 2;
	
	initial begin
		clk = 0;
		forever begin
			#(HALF_PERIOD);
			clk = ~clk;
		end
	end
	
	initial begin
		clk = 0;
		addr = 'h000;
		din = 'h1111;
		
		#PERIOD;
		
		addr = 'h001;
		
		#PERIOD;
		
		addr = addr + 1;
		
		#PERIOD;
		
		addr = addr + 1;
	end
endmodule