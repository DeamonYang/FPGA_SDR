module dds_du(
	clk,
	reset_n,
	Fword,
	Pword,
	DataCHS,
	DataCHC

	);
	input clk;
	input reset_n;
	input [31:0]Fword;
	input [10:0]Pword;
	output [9:0]DataCHS;
	output [9:0]DataCHC;
	
	reg [31:0]r_Fword;
	reg [11:0]r_Pword;
	
	reg [31:0]Fcnt;
	
	wire [11:0]rom_addr;
	wire [11:0]rom_addr_chc;
	
	reg[9:0]reg_DataCHS;
	reg[9:0]reg_DataCHC;

	wire[9:0]wire_DataCHS;
	wire[9:0]wire_DataCHC;
	
	always@(posedge clk)begin
		r_Fword <= Fword;
		r_Pword <= Pword;
	end
	
	always@(posedge clk or negedge reset_n)
	if(!reset_n)
		Fcnt <= 32'd0;
	else
		Fcnt <= Fcnt + r_Fword;
	
	assign rom_addr = Fcnt[31:20] + r_Pword;
	assign rom_addr_chc = Fcnt[31:20] + r_Pword + 12'd1024;
	
	dds_rom roms(
		.address(rom_addr),
		.clock(clk),
		.q(wire_DataCHS)
	);	

	dds_rom romc(
		.address(rom_addr_chc),
		.clock(clk),
		.q(wire_DataCHC)
	);	
	
	/*将数据转化为有符号数*/
	always@(posedge clk or negedge reset_n)
	if(!reset_n)begin
		reg_DataCHS <= 10'd0;
		reg_DataCHC <= 10'd0;
	end else begin
		reg_DataCHS <= wire_DataCHS - 10'd512;
		reg_DataCHC <= wire_DataCHC - 10'd512;	
	end

	
	assign DataCHS = reg_DataCHS;
	assign DataCHC = reg_DataCHC;
	
endmodule
