`timescale 1ns/1ns
module sdr_tb;

	reg clk		;
	reg rst_n		;	
	reg[11:0]r_AD_DB		;
	reg  VCO_LD	;
	
	wire AD_CLK	;	
	wire [1:0]AD_MOD	;
	wire AD_OEB	;	
	wire AD_OTR	;	
	wire[5:0]ATT_V		;
	wire VCO_CE	;	
	wire VCO_CLK	;	
	wire VCO_DATA;
	wire VCO_LE	;
	
	wire bclk		;
	wire dacdata	;
	wire daclrck	;	
	wire iic_sdata	;
	wire iic_sclk	;	
	wire audxck		;
	wire [11:0]AD_DB;
	
	integer fm;
	integer file_new;
	
	
	assign AD_DB = {r_AD_DB[0],r_AD_DB[1],r_AD_DB[2],r_AD_DB[3],r_AD_DB[4],r_AD_DB[5],r_AD_DB[6],r_AD_DB[7],
							r_AD_DB[8],r_AD_DB[9],r_AD_DB[10],r_AD_DB[11]};

//	assign AD_DB = {r_AD_DB[3],r_AD_DB[4],r_AD_DB[5],r_AD_DB[6],r_AD_DB[7],
//							r_AD_DB[8],r_AD_DB[9],r_AD_DB[10],r_AD_DB[11],
//							r_AD_DB[11],r_AD_DB[11],r_AD_DB[11]};
	
	
	
	sdr ss0(
		.clk		(clk		),
		.rst_n		(rst_n		),
		.AD_CLK	(AD_CLK	),	
		.AD_DB		(AD_DB		),
		.AD_MOD	(AD_MOD	),
		.AD_OEB	(AD_OEB	),	
		.AD_OTR	(AD_OTR	),	
		.ATT_V		(ATT_V		),
		.VCO_CE	(VCO_CE	),	
		.VCO_CLK	(VCO_CLK	),	
		.VCO_DATA	(VCO_DATA	),
		.VCO_LD	(VCO_LD	),	
		.VCO_LE	(VCO_LE	),
		
		.bclk		(bclk		),		
		.dacdata	(dacdata	),	
		.daclrck	(daclrck	),	
		.iic_sdata(iic_sdata),	
		.iic_sclk	(iic_sclk),
		.audxck		(audxck),
		.fm_out()
	);

	


	initial begin
		clk = 0		;
		rst_n	 = 0	;	
		#1000;
		rst_n = 1;
		#2000000;
		$stop;
	
	end
	
	

	
	
	
	

	initial fm = $fopen("./../../../sour/if_adc_data.txt","r");
	initial file_new =  $fopen("./../../../sour/verilog_file_create_new_file.txt","w");
	
	always@(posedge AD_CLK or negedge rst_n)
	if(!rst_n)
		r_AD_DB = 12'd0;
	else begin
		$fscanf(fm,"%d,",r_AD_DB);
		$fwrite(file_new,"%d,",r_AD_DB);
	end
	
	
	always #10 clk = ~clk;


endmodule
