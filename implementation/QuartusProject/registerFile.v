module registerFile(
 input    CLK,
 input    regWrite,
 input  [3:0] rd,
 input  signed [15:0] dataWrite,
 input  [3:0] rs0,
 output reg signed [15:0] A,
 input  [3:0] rs1,
 input reset,
 output reg signed [15:0] B
);
 reg [15:0] reg_array [0:15];
 integer i;
 initial begin
  for(i=0;i<16;i=i+1)
   reg_array[i] = 0;
	
  reg_array[2] = 65535;
 end
 always @ (posedge CLK ) begin
   if(regWrite) begin
		if(rd != 0) begin
			reg_array[rd] <= dataWrite;
		end
   end
		
	 A = reg_array[rs0];
	 B = reg_array[rs1];
	
  if(reset) begin
  for(i=0;i<16;i=i+1)
   reg_array[i] = 0;
	
  reg_array[2] = 65535;
  end
 end


endmodule