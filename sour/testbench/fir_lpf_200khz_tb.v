`timescale 1ns/1ns

module fir_lpf_200khz_tb;


	reg rst_n	;
	wire clk	;
	wire clkx2	;
	wire clk_dds	;
	reg unsigned [11:0] data_in;
	wire unsigned [28:0]data_out;
	reg clk_50;

	wire[20:0]cic_data_out;
	wire cic_data_done;
	integer fp;
	integer fm;
	
	reg [15:0] fm_data_in;
	
	wire[11:0]fm_data_in_wr;

	
	
		


	wire[15:0]fm_data_out	;
	wire fm_data_done;
	wire pll65M;
	wire pll130M;
	wire pll520M;
	
	assign fm_data_in_wr = fm_data_in[11:0];
	
	initial begin
		rst_n = 0;
//		clk = 0;
//		clkx2 = 0;
//		clk_dds = 0;
		clk_50 = 0;
		#2000;
		rst_n = 1;
		#1500000;
		$stop;
	end
	
	always #10 clk_50 = ~clk_50;
	
	assign clk = 	pll65M;
	assign clkx2 = 	pll130M;
	assign clk_dds	 = pll520M;
	
//	always@(posedge pll520M)
//		clk_dds <= pll520M;
//
//	always@(posedge pll65M)
//		clk <= pll65M;
//
//	always@(posedge pll130M)
//		clkx2 <= pll130M;		
	
	
	initial fp = $fopen("G:/FPWG_WORK/FPGA_W/FIR/testbench/data_in_file.txt","r");
	
	initial fm = $fopen("G:/FPWG_WORK/FPGA_W/FIR/testbench/fm_in_file.txt","r");
	
//	initial fp = $fopen("data_in_file1.txt");
	
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_in = 12'd0;
	else begin
		$fscanf(fp,"%d,",data_in);
//		$display();
	end
	
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		fm_data_in = 12'd0;
	else begin
		$fscanf(fm,"%d,",fm_data_in);
	end
	
	
	reg [11:0] reg_data_in;
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		reg_data_in <= 12'd0;
	else begin
		reg_data_in <= data_in - 12'd2048;
	end
	
	

	fir_lpf_200khz fir(
		.rst_n		(rst_n		),
		.clk		(clk		),
		.clkx2		(clkx2		),
		.data_in	(reg_data_in	),
		.data_out	(data_out	)
	);

	
	
	ddc65 ddc(
		.rst_n		(rst_n		),
		.clk		(clk		),
		.data_in	({{4{reg_data_in[11]}},reg_data_in}),
		.data_out	(cic_data_out	),
		.data_done(cic_data_done)
	);

	
	fm_demodu fm_dm(
		.clk_50M		( clk),
		.clk_dds		( clk_dds),
		.clk_data		( clk),
		.clk_datax2	( clkx2),
		.rst_n			( rst_n),
		.if_data		( fm_data_in_wr),
		.cen_freq		( 8000),
		.data_out		(fm_data_out ),
		.data_done	(fm_data_done )
	);
	

	pll pll01(
		.inclk0(clk_50),
		.c0(pll65M),
		.c1(pll130M),
		.c2(pll520M));

	



endmodule
