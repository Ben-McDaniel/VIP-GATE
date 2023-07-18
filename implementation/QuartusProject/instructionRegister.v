module instructionRegister(
    input [15:0] instruction,
    input reset,
	 input regWrite,
    input CLK,
	 output reg [15:0] instructionOut,
	 output reg [3:0] rs1Addr,
	 output reg [3:0] rs0Addr,
	 output reg [3:0] rdAddr,
	 output reg [3:0] Opcode
    );
	 
initial begin
	instructionOut = 0;
	rs1Addr = 0;
	rs0Addr = 0;
	rdAddr = 0;
	Opcode = 0;
end

always @ (negedge(CLK))
begin
	if(regWrite == 1) begin
		instructionOut = instruction;
		rs1Addr = instruction[3:0];
		rs0Addr = instruction[7:4];
		rdAddr = instruction[11:8];
		Opcode = instruction[15:12];

		if(Opcode == 'b1110 || Opcode == 'b1101 || Opcode == 'b1100) begin
			rs0Addr = rdAddr;
		end
		if(Opcode == 'b0111) begin
			rs1Addr = rdAddr;
		end
		if(Opcode == 'b1111) begin
			rs0Addr = 'b0000;
		end
	end 
	if(reset == 1) begin
		instructionOut = 0;
		rs1Addr = 0;
		rs0Addr = 0;
		rdAddr = 0;
		Opcode = 0;
	end
end
endmodule