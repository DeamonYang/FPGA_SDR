module  audio(
		clk_aud_ref	,
		rst_n			,
		bclk			,
		dacdata		,
		daclrck		,
		audio_in		
	);

	
	input clk_aud_ref	; // 时钟 18.432MHz
	input rst_n			;
	input [15:0]audio_in		;
	output bclk			;
	output reg dacdata		;
	output daclrck		;
		
	reg	[7:0]dac_clk_cnt;
	reg dacclk;
	reg [3:0]data_rt_cnt;
	reg data_rt_clk;
	reg [3:0]data_bit_cnt;
	reg [5:0]test_audio_idx;
	reg [15:0]audio_data;
	
	assign bclk = ~data_rt_clk;
	assign daclrck = dacclk;
	/*产生48kHz 的音频采样时钟 计数*/
	always@(posedge clk_aud_ref or negedge rst_n)
	if(!rst_n)
		dac_clk_cnt <= 8'd0;
	else if(dac_clk_cnt < 8'd191)
		dac_clk_cnt <= dac_clk_cnt + 1'b1;
	else
		dac_clk_cnt <= 8'd0;
	/*产生48kHz 的音频采样时钟*/
	always@(posedge clk_aud_ref or negedge rst_n)
	if(!rst_n)
		dacclk <= 1'b0;
	else if(dac_clk_cnt ==  4'd2)
		dacclk <= ~dacclk;
		
	/*产生48*32 kHz 的音频数据传输时钟 计数*/
	always@(posedge clk_aud_ref or negedge rst_n)
	if(!rst_n)
		data_rt_cnt <= 4'd0;
	else if(data_rt_cnt < 4'd5)
		data_rt_cnt <= data_rt_cnt + 1'b1;
	else 
		data_rt_cnt <= 4'd0;

	/*产生48*32 kHz 的音频数据传输时钟*/
	always@(posedge clk_aud_ref or negedge rst_n)
	if(!rst_n)
		data_rt_clk <= 1'b0;
	else if(data_rt_cnt ==  4'd2)
		data_rt_clk <= ~data_rt_clk;
		
	/*数据位标识*/
	always@(posedge data_rt_clk or negedge rst_n)
	if(!rst_n)
		data_bit_cnt <= 4'd15;
	else
		data_bit_cnt <= data_bit_cnt - 1'b1;	
	
	always@(posedge dacclk or negedge rst_n)
	if(!rst_n)
		test_audio_idx <= 6'd0;
	else if(test_audio_idx <= 6'd47)
		test_audio_idx <= test_audio_idx + 1'b1;
	else
		test_audio_idx <= 6'd0;
	
	/*串行输出数据*/ 
	always@(posedge data_rt_clk or negedge rst_n)
	if(!rst_n)
		dacdata <= 1'd0;
	else
		dacdata <= audio_data[data_bit_cnt];//((audio_data << data_bit_cnt)&16'h80)>>15);	
	
	
	always@(posedge dacclk or negedge rst_n)
	if(!rst_n)
		audio_data <= 16'd0;
	else
		audio_data <= audio_in;
	
	
	
/*
	always@(posedge dacclk or negedge rst_n)
	if(!rst_n)
		audio_data <= 16'd0;
	else case(test_audio_idx)
		 0 :  audio_data = 16'd0 ; //32767*sin0               
		 1 :  audio_data = 16'd4276 ; //32767*sin7.5（角度）               
		 2 :  audio_data = 16'd8480 ; //32767*sin15（角度）               
		 3 :  audio_data = 16'd12539 ;               
		 4 :  audio_data = 16'd16383 ;               
		 5 :  audio_data = 16'd19947 ;               
		 6 :  audio_data = 16'd23169 ;               
		 7 :  audio_data = 16'd25995 ;               
		 8 :  audio_data = 16'd28377 ;               
		 9 :  audio_data = 16'd30272 ;               
		 10 : audio_data = 16'd31650 ;               
		 11 : audio_data = 16'd32486 ;               
		 12 : audio_data = 16'd32767 ;               
		 13 : audio_data = 16'd32486 ;               
		 14 : audio_data = 16'd31650 ;               
		 15 : audio_data = 16'd30272 ;               
		 16 : audio_data = 16'd28377 ;               
		 17 : audio_data = 16'd25995 ;               
		 18 : audio_data = 16'd23169 ;               
		 19 : audio_data = 16'd19947 ;               
		 20 : audio_data = 16'd16383 ;               
		 21 : audio_data = 16'd12539 ;               
		 22 : audio_data = 16'd8480 ;               
		 23 : audio_data = 16'd4276 ;               
		 24 : audio_data = 16'd0 ;               
		 25 : audio_data = 16'd61259 ;               
		 26 : audio_data = 16'd57056 ;               
		 27 : audio_data = 16'd52997 ;               
		 28 : audio_data = 16'd49153 ;               
		 29 : audio_data = 16'd45589 ;               
		 30 : audio_data = 16'd42366 ;               
		 31 : audio_data = 16'd39540 ;               
		 32 : audio_data = 16'd37159 ;               
		 33 : audio_data = 16'd35263 ;               
		 34 : audio_data = 16'd33885 ;               
		 35 : audio_data = 16'd33049 ;               
		 36 : audio_data = 16'd32768 ;               
		 37 : audio_data = 16'd33049 ;               
		 38 : audio_data = 16'd33885 ;               
		 39 : audio_data = 16'd35263 ;               
		 40 : audio_data = 16'd37159 ;               
		 41 : audio_data = 16'd39540 ;               
		 42 : audio_data = 16'd42366 ;               
		 43 : audio_data = 16'd45589 ;               
		 44 : audio_data = 16'd49152 ;               
		 45 : audio_data = 16'd52997 ;               
		 46 : audio_data = 16'd57056 ;               
		 47 : audio_data = 16'd61259 ; 
		default : audio_data = 16'd0;
	endcase
	
*/	
	
endmodule
