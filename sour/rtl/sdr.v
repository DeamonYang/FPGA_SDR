module sdr(
	clk		,
	rst_n		,

	AD_CLK	,	
	AD_DB		,
	AD_MOD	,
	AD_OEB	,	
	AD_OTR	,	

	ATT_V		,

	VCO_CE	,	
	VCO_CLK	,	
	VCO_DATA	,
	VCO_LD	,	
	VCO_LE	,

	bclk		,		
	dacdata	,	
	daclrck	,	
	iic_sdata,	
	iic_sclk	,
	audxck	,
	fm_out	
	
	
	
);

	input clk		;
	input rst_n		;	
	
	output AD_CLK	;	
	input[11:0]AD_DB	;
	output [1:0]AD_MOD;
	output AD_OEB	;	
	output AD_OTR	;	
	output[5:0]ATT_V;
	output VCO_CE	;	
	output VCO_CLK	;	
	output VCO_DATA;
	input  VCO_LD	;	
	output VCO_LE	;

	output reg fm_out;
	
	/*WM8731*/
	output bclk		;	
	output dacdata	;
	output daclrck	;
	inout iic_sdata;	
	output iic_sclk;
	output audxck;
	
	wire wm_cf_done;	
	wire adc_clk;
	wire [11:0]adc_data; //ADC 数据采集结果
	
	wire [15:0]audio_in;
	
	wire clk_dds	;
	wire clk_datax2;
	wire [14:0]cen_freq	;//0-28MHz 步进为1kHz
	wire data_done;
	wire clk_aud_ref;
	wire clk_fm_send;
	
	assign audxck = clk_aud_ref;
	
	assign AD_CLK = adc_clk;

	pll pllu0(
		.inclk0(clk),
		.c0(adc_clk), 	//65MHz
		.c1(clk_datax2),	//130MHz
		.c2(clk_dds),	//520MHz
		.c3(clk_aud_ref),
		.c4(clk_fm_send));	//18.571429MHz
		
		
		
	always@(posedge clk_fm_send or negedge rst_n)
	if(!rst_n)
		fm_out <= 1'b1;
	else
		fm_out <= 1;

		/*理论音频时钟为18.432 经过 384 分频为 48k  即数据 为 64.512M经过 3.5*384 分频 得到 48k数据 */

	assign ATT_V = 6'b111_111;
	adf4351 vco(
		.clk_50	(clk),
		.rst_n		(rst_n),
		.vco_clk	(VCO_CLK),
		.vco_data	(VCO_DATA),
		.vco_le	(VCO_LE),
		.vco_ce	(VCO_CE),
		.vco_ld	(VCO_LD)	
	);
	
	/*wm8978 音频接口*/
	audio audio_u1(
		.clk_aud_ref(clk_aud_ref),
		.rst_n		(rst_n		),
		.bclk			(bclk			),
		.dacdata		(dacdata		),
		.daclrck		(daclrck		),
		.audio_in	(audio_in	)
	);
	
	
	wm9732_config  wm_con_u2(
		.clk_50m		(clk			),
		.rst_n		(rst_n		),
		.iic_sdata	(iic_sdata	),
		.iic_sclk	(iic_sclk	),
		.wm_cf_done	(wm_cf_done	)	
	);

	
	 ad9226 adc_u3(
		/*ADC */
		.rst_n		(rst_n		),
		.adc_oeb		(AD_OEB		),
		.adc_clk		(adc_clk		),
		.adc_data	(adc_data	),
		.adc_mode	(AD_MOD		),
		.adc_otr		(AD_OTR		),	//out of range
		.adc_bus		(AD_DB		),
		.adc_sck		(		)
	);
	
	
	wire [9:0]sim_if_data;
	dds_du noc_SG(
		.clk		(clk_dds		),
		.reset_n	(rst_n	),
		.Fword		(233332358		),
		.Pword		(11'd0		),
		.DataCHS	(DataCHS	),
		.DataCHC	( sim_if_data	)
	);

	

	
	
	
	/*FM 解调*/
	fm_demodu fm_u4(
		.clk_50M		(clk			),
		.clk_dds		(clk_dds		),
		.clk_data	(adc_clk		),
		.clk_datax2	(clk_datax2	),
		.rst_n		(rst_n		),
		.if_data		(adc_data	),
//		.if_data		({sim_if_data,2'd0}),
		.cen_freq	(cen_freq	),
		.data_out	(audio_in	),
		.data_done	(data_done	)
	);
	
	

endmodule