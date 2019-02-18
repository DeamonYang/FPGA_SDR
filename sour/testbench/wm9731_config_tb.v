module wm9731_config_tb;


	reg clk_50m;
	reg rst_n;
	reg wm_cf_go;
	wire iic_sdata;
	wire iic_sclk;
	wire wm_cf_done;


	wm9732_config wf(
		.clk_50m		(clk_50m		),
		.rst_n		(rst_n			),
		.iic_sdata	(iic_sdata	),
		.iic_sclk	(iic_sclk		),
		.wm_cf_go	(wm_cf_go		),
		.wm_cf_done	(wm_cf_done	)		

	);

	initial begin
		clk_50m = 0;
		rst_n = 0;
		#1000;
		rst_n = 1;
		#16000000;
		$stop;
	
	end
	
	always#10 clk_50m = ~clk_50m;

endmodule
