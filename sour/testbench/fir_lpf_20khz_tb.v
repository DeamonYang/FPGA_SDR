`timescale 1ns/1ns
module fir_lpf_20khz_tb;
	
	reg rst_n	;

	reg clk2M;
	reg clk4M;


	integer fp20k;
	
	reg signed [15:0]reg_data_in_lpf20k;
	wire[28:0]data_out_lpf20k;
	

	
	initial begin
		rst_n = 0;
		clk2M = 0;
		clk4M = 0;
		#2000;
		rst_n = 1;
		#150000;
		$stop;
	end
	
//	always #20 clk2M = ~clk2M;

	always #10 clk4M = ~clk4M;
	
	always @(posedge clk4M)
		clk2M <= ~clk2M;
	

//	initial fp20k = $fopen("./../sour/data_in_file_lpf20k.txt","r");

	initial fp20k = $fopen("K:/SDR/FPGA/SDR20190109/sour/data_in_file_lpf20k.txt","r");


	

	
	always@(posedge clk2M or negedge rst_n)
	if(!rst_n)
		reg_data_in_lpf20k = 16'd0;
	else begin
		$fscanf(fp20k,"%d,",reg_data_in_lpf20k);
	//	$display("%d",reg_data_in_lpf20k);
	end	
	
	
	
	

	
	fir_lpf_20khz fir20k(
		.rst_n		(rst_n		),
		.clk			(clk2M		),
		.clkx2		(clk4M		),
		.data_in		(reg_data_in_lpf20k	),
		.data_out	(data_out_lpf20k	)
	
	
	);
	

		
endmodule

