`timescale 1ns/1ns
module iic_com_tb;

	reg  clk_50m		;
	reg  rst_n			;
	reg [23:0] iic_data;
	reg  iic_tr_go	;
	
	wire  iic_sdata		;
	
	wire iic_ref_clk;
	wire iic_sclk		;
	wire iic_tr_done	;


	iic_cm uiic(
		.clk_50m		(clk_50m		),
		.rst_n			(rst_n			),
		.iic_sdata	(iic_sdata	),
		.iic_sclk		(iic_sclk		),
		.iic_ref_clk	(iic_ref_clk	),
		.iic_data		(iic_data		),
		.iic_tr_go	(iic_tr_go	),
		.iic_tr_done	(iic_tr_done	)
	);


	initial begin
		clk_50m = 0;
		rst_n = 0;
		iic_data = 24'h555555;
		iic_tr_go = 0;
		
		#2000;
		rst_n = 1;
		#100;
		
		iic_tr_go = 1;
		#45000;
		iic_tr_go = 0;
		
		#10000000;
		$stop;
	end
	
	
	always #10 clk_50m = ~clk_50m;
	
	


endmodule

