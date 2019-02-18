`timescale 1ns/1ns
module adf4351_tb;

reg clk_50	;
reg rst_n		;
reg vco_ld	;		//Lock Detect Output Pin. A logic high output on this pin indicates PLL lock
wire vco_clk	;
wire vco_data	;
wire vco_le	;	//Load Enable. When LE goes high, the data stored in the 32-bit shift register is loaded into
wire vco_ce	; //Chip Enable. A logic low on this pin powers down the device and puts the charge pump into th
						


	adf4351 vco(
			.clk_50	(clk_50	),
			.rst_n		(rst_n		),
			.vco_clk	(vco_clk	),
			.vco_data	(vco_data	),
			.vco_le	(vco_le	),
			.vco_ce	(vco_ce	),
			.vco_ld   (vco_ld   )	
		);
		
		
		
	initial begin
		rst_n = 0;
		vco_ld = 0;
		clk_50 = 0;
		#2000;
		rst_n = 1;
		#250000;
		$stop;
	end
	
	always #10 clk_50 = ~clk_50;
endmodule
