module fm_demodu(
		clk_50M	,
		clk_dds	,
		clk_data	,
		clk_datax2,
		rst_n		,
		if_data	,
		cen_freq	,
		data_out	,
		data_done
	);
	
		input clk_50M	;
		input clk_dds	;
		input clk_data	;
		input clk_datax2;
		input rst_n		;
		input [11:0]if_data	;
		input [14:0]cen_freq	;//0-28MHz 步进为1kHz
		output[15:0]data_out	;
		output data_done;
		
		reg [31:0]Fword;
		wire [9:0]DataCHS;
		wire [9:0]DataCHC;		

		reg signed[9:0]reg_DataCHS/*synthesis noprune*/;
		reg signed[9:0]reg_DataCHC/*synthesis noprune*/;
		reg signed[11:0]reg_if_data/*synthesis noprune*/;
		
		reg signed [21:0]Qh/*synthesis noprune*/;
		reg signed [21:0]Ih/*synthesis noprune*/;
//		reg signed [22:0]reg_Qh;
//		reg signed [22:0]reg_Ih;	
		
		wire signed [28:0]Qm/*synthesis noprune*/;
		wire signed [28:0]Im/*synthesis noprune*/;

		reg signed[17:0]reg_Qm/*synthesis noprune*/;
		reg signed[17:0]reg_Im/*synthesis noprune*/;		
		
		reg signed[35:0]dm_Qm/*synthesis noprune*/;
		reg signed[35:0]dm_Im/*synthesis noprune*/;
		
		reg signed[35:0]sn/*synthesis noprune*/;
		wire [20:0]cic_data_out/*synthesis noprune*/;
		wire cic_data_done;
		reg signed[20:0]reg_cic_data_out/*synthesis noprune*/;
		
		
		reg ddc_clk;
		reg ddc_clkx2;
		reg [3:0]ddc_clk_cnt;
		wire [28:0]ddc_lpf_data/*synthesis noprune*/;
		
		wire [28:0]dm_lpf_data/*synthesis noprune*/;
		
		
		dds_du noc_ch(
				.clk		(clk_dds		),
				.reset_n	(rst_n	),
				.Fword		(Fword		),
				.Pword		(11'd0		),
				.DataCHS	(DataCHS	),
				.DataCHC	(DataCHC	)
			);





			
		always@(posedge clk_data or negedge rst_n)
		if(!rst_n)
			Fword <= 32'd0;
		else
//			Fword <= 32'd66076420;//cen_freq * 8605;  
//			Fword <= 32'd108200138; 
//			Fword <= 32'd90855077;//11MHz
//			Fword <= 32'd101592496;//12.3MHz	
//			Fword <= 32'd93332943;//11.3MHz	
			Fword <= 32'd233332358;//11.3MHz	208M 时钟


		always@(posedge clk_data or negedge rst_n)
		if(!rst_n)begin
			reg_DataCHC <= 10'd0;
			reg_DataCHS <= 10'd0;
			reg_if_data <= 12'd0;
		end else begin
			reg_DataCHC <= DataCHC;
			reg_DataCHS <= DataCHS;	
			reg_if_data	<= if_data;	
		end
		
//		integer fp_CHC;
//		initial fp_CHC =  $fopen("./../../../sour/fp_CHC.txt","w");
//		always@(posedge clk_data or negedge rst_n)
//		if(rst_n)begin
//			$fwrite(fp_CHC,"%d\r\n",reg_DataCHC);
//		end	
//		
//		
//		
//		integer fp_CHS;
//		initial fp_CHS =  $fopen("./../../../sour/fp_CHS.txt","w");
//		always@(posedge clk_data or negedge rst_n)
//		if(rst_n)begin
//			$fwrite(fp_CHS,"%d\r\n",reg_DataCHS);
//		end
		
		
		
		always@(posedge clk_data or negedge rst_n )
		if(!rst_n)begin
			Qh <= 22'd0;
			Ih <= 22'd0;
		end else begin
			Qh = {{10{reg_if_data[11]}},reg_if_data} * {{12{reg_DataCHS[9]}},reg_DataCHS}; //有符号数乘法
			Ih = {{10{reg_if_data[11]}},reg_if_data} * {{12{reg_DataCHC[9]}},reg_DataCHC}; //有符号数乘法		
		end
		


//		integer fp_Qh;
//		initial fp_Qh =  $fopen("./../../../sour/fp_Qh.txt","w");
//		always@(posedge clk_data or negedge rst_n)
//		if(rst_n)begin
//			$fwrite(fp_Qh,"%d\r\n",Qh);
//		end	
//		
//		
//		
//		integer fp_Ih;
//		initial fp_Ih =  $fopen("./../../../sour/fp_Ih.txt","w");
//		always@(posedge clk_data or negedge rst_n)
//		if(rst_n)begin
//			$fwrite(fp_Ih,"%d\r\n",Ih);
//		end


	
		fir_lpf_200khz Qch_lpf(
			.rst_n	(rst_n		),
			.clk		(clk_data		),
			.clkx2	(clk_datax2		),
			.data_in	(Qh[21:10]	),   //12bit
			.data_out(Qm)
			);
	
		fir_lpf_200khz Ich_lpf(
			.rst_n	(rst_n		),
			.clk		(clk_data		),
			.clkx2	(clk_datax2		),
			.data_in	(Ih[21:10]	),   //12bit
			.data_out(Im	)
			);
		
		always@(posedge clk_data or negedge rst_n)
		if(!rst_n)begin
			reg_Qm <= 18'd0;
			reg_Im <= 18'd0;
		end else begin
			reg_Qm <= Qm[24:7];
			reg_Im <= Im[24:7];	
		end	
	
		/*解调*/
		always@(posedge clk_data or negedge rst_n)
		if(!rst_n)begin
			dm_Qm <= 36'd0;
			dm_Im <= 36'd0;
		end else begin 
			dm_Qm <= {{18{Qm[24]}},Qm[24:7]} * {{18{reg_Im[17]}},reg_Im};
			dm_Im <= {{18{Im[24]}},Im[24:7]} * {{18{reg_Qm[17]}},reg_Qm};	
		end	
		
		
//		integer fp_Qm;
//		initial fp_Qm =  $fopen("./../../../sour/fp_Qm.txt","w");
//		always@(posedge clk_data or negedge rst_n)
//		if(rst_n)begin
//			$fwrite(fp_Qm,"%d\r\n",reg_Qm);
//		end	
//		
//		
//		
//		integer fp_Im;
//		initial fp_Im =  $fopen("./../../../sour/fp_Im.txt","w");
//		always@(posedge clk_data or negedge rst_n)
//		if(rst_n)begin
//			$fwrite(fp_Im,"%d\r\n",reg_Im);
//		end		
	
	
	
		/*解调*/
		always@(posedge clk_data or negedge rst_n)
		if(!rst_n)
			sn <= 36'd0;
		else
			sn <= dm_Im - dm_Qm;

//		/*解调后经过一级滤波器*/
//			fir_lpf_200khz dm_lpf(
//			.rst_n	(rst_n		),
//			.clk		(clk_data		),
//			.clkx2	(clk_datax2		),
//			.data_in	(sn[26:15]	),   //12bit
//			.data_out(dm_lpf_data)
//			);	
			
			
			
		/*降采样*/
		ddc65 rsmd32(
			.rst_n		(rst_n),
			.clk		(clk_data),
//			.data_in	(dm_lpf_data[24:9]),
//			.data_in	(sn[28:13]),
			.data_in	(sn[33:18]),
			.data_out	(cic_data_out),
			.data_done(cic_data_done)
		);
	
		
		/*降采样后 LPF 滤波器时钟*/
		always@(posedge clk_data or negedge rst_n)
		if(!rst_n)
			ddc_clk_cnt <= 4'b0;
		else
			ddc_clk_cnt <= ddc_clk_cnt + 1'b1;

		always@(posedge clk_data or negedge rst_n)
		if(!rst_n)
			ddc_clkx2 <= 1'b0;
		else if(ddc_clk_cnt == 4'b0)
			ddc_clkx2 <= ~ddc_clkx2;

		always@(posedge clk_data or negedge rst_n)
		if(!rst_n)
			ddc_clk <= 1'b0;
		else if(ddc_clkx2 == 1'b0)
			ddc_clk <= ~ddc_clk;
			
			
		fir_lpf_20khz fir_20khz(
			.rst_n		(rst_n		),
			.clk			(ddc_clk		),
			.clkx2		(ddc_clkx2		),
			.data_in		(cic_data_out[20:9]	),
			.data_out	(ddc_lpf_data	)
		);
		

		
	
	
//		always@(posedge clk_data or negedge rst_n)
//		if(!rst_n)
//			reg_cic_data_out <= 21'd0;
//		else
//			reg_cic_data_out <= cic_data_out;
			

		always@(posedge clk_data or negedge rst_n)
		if(!rst_n)
			reg_cic_data_out <= 21'd0;
		else
			reg_cic_data_out <= ddc_lpf_data[28:7];	

	
		/*直接进行39倍抽取测试*/
		reg[5:0]ddc_cnt;
		always@(posedge cic_data_done or negedge rst_n)
		if(!rst_n)
			ddc_cnt <= 6'd0;
		else if(ddc_cnt < 6'd38)
			ddc_cnt <= ddc_cnt + 1'b1;
		else
			ddc_cnt <= 6'd0;

		reg [15:0]r_ddc_data_out;
		reg r_data_done;
		always@(posedge cic_data_done or negedge rst_n)
		if(!rst_n) begin
			r_data_done <= 1'b0;
			r_ddc_data_out <= 16'd0;
		end else if(ddc_cnt == 6'd38)begin
			r_ddc_data_out <= reg_cic_data_out[15:0];
//			r_ddc_data_out <= reg_cic_data_out[20:5];
			r_data_done <= 1'b1;
		end else
			r_data_done <= 1'b0;
		
	assign data_done =   r_data_done;
//	assign data_out = reg_cic_data_out[17:2];
	assign data_out = r_ddc_data_out;

endmodule

/*************************************************
*输入时钟为520M 频率控制字与频率关系
*fo = fi/2^N*Fw
*8M		66076420
*9M		74335972
*10M		82595525
*11M		90855077
*12M		99114630
*12.3M	101592496
*13.1M	108200138
**************************************************/	
	
