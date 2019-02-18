//module ddc65(
//		rst_n		,
//		clk		,
//		data_in	,
//		data_out	,
//		data_done
//	);
//	
//	input rst_n;
//	input clk;
//	input [15:0]data_in;
//	output[20:0]data_out;
//	output data_done;
//	
//	/*32阶*/
//	/*前级积分器*/
//	/**中间变量字长 WI = Wi + N*log2(MD) Wi 为输入位宽 N为CIC阶数 M为抽取因子 **/
//	reg signed[175:0]I_data_in;
//	always@(posedge clk or negedge rst_n)
//	if(!rst_n)
//		I_data_in <= 176'd0;
//	else
//		I_data_in <= I_data_in + {{160{data_in[15]}},data_in};//{160'd0,data_in};
//	
//	/*抽取计数器*/
//	reg [4:0]dec_cnt;
//	always@(posedge clk or negedge rst_n)
//	if(!rst_n)
//		dec_cnt <= 5'd0;
//	else
//		dec_cnt <= dec_cnt + 1'b1;
//	
//	/*抽取模块*/
//	reg signed[175:0]dec_data;
//	always@(posedge clk or negedge rst_n)
//	if(!rst_n)
//		dec_data <= 5'd0;
//	else if(dec_cnt == 5'd31)
//		dec_data <= I_data_in;
//	
//	/*抽取数据更新标志 持续一个时钟周期*/
//	reg dec_done;
//	always@(posedge clk or negedge rst_n)
//	if(!rst_n)
//		dec_done <= 1'd0;
//	else if(dec_cnt == 5'd31)
//		dec_done <= 1'b1;	
//	else
//		dec_done <= 1'd0;
//		
//	/*梳状模块*/
//	reg signed[175:0]comb_data;
//	always@(posedge clk or negedge rst_n)
//	if(!rst_n)
//		comb_data <= 176'd0;
//	else if(dec_done == 1'b1)
//		comb_data <= dec_data;	
//
//	
//	reg unsigned[175:0]sum_comb_data;
//	always@(posedge clk or negedge rst_n)
//	if(!rst_n)
//		sum_comb_data <= 176'd0;
//	else if(dec_done == 1'b1)
//		sum_comb_data <= dec_data - comb_data;	
//	
//	
//	/*CIC滤波数据输出标志 持续一个时钟周期*/
//	reg cic_done;
//	always@(posedge clk or negedge rst_n)
//	if(!rst_n)
//		cic_done <= 1'b0;
//	else if(dec_done == 1'b1)
//		cic_done <= 1'b1;	
//	else
//		cic_done <= 1'b0;
//	
//	/**输出数据字长估算 Wo = Win + log2(N^D)  Win 输入宽度 N CIC阶数 D滤波器级数  21位**/
//	assign data_out = sum_comb_data[20:0];
//	assign data_done = cic_done;
//	
//endmodule
	


module ddc65(
		rst_n		,
		clk		,
		data_in	,
		data_out	,
		data_done
	);
	
	input rst_n;
	input clk;
	input [15:0]data_in;
	output[20:0]data_out;
	output data_done;
	
	/*32阶*/
	/*前级积分器*/
	/**中间变量字长 WI = Wi + N*log2(MD) Wi 为输入位宽 N为CIC阶数 M为抽取因子 **/
	reg signed[175:0]I_data_in;
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		I_data_in <= 176'd0;
	else
		I_data_in <= I_data_in + {{160{data_in[15]}},data_in};//{160'd0,data_in};
	
	/*抽取计数器*/
	reg [4:0]dec_cnt;
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		dec_cnt <= 5'd0;
	else
		dec_cnt <= dec_cnt + 1'b1;
	
	/*抽取模块*/
	reg signed[175:0]dec_data;
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		dec_data <= 5'd0;
	else if(dec_cnt == 5'd31)
		dec_data <= I_data_in;
	
	/*抽取数据更新标志 持续一个时钟周期*/
	reg dec_done;
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		dec_done <= 1'd0;
	else if(dec_cnt == 5'd31)
		dec_done <= 1'b1;	
	else
		dec_done <= 1'd0;
		
	/*梳状模块*/
	reg signed[175:0]comb_data;
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		comb_data <= 176'd0;
	else if(dec_done == 1'b1)
		comb_data <= dec_data;	

	
	reg unsigned[175:0]sum_comb_data;
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		sum_comb_data <= 176'd0;
	else if(dec_done == 1'b1)
		sum_comb_data <= dec_data - comb_data;	
	
	
	/*CIC滤波数据输出标志 持续一个时钟周期*/
	reg cic_done;
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		cic_done <= 1'b0;
	else if(dec_done == 1'b1)
		cic_done <= 1'b1;	
	else
		cic_done <= 1'b0;
	
	/**输出数据字长估算 Wo = Win + log2(N^D)  Win 输入宽度 N CIC阶数 D滤波器级数  21位**/
	assign data_out = sum_comb_data[20:0];
	assign data_done = cic_done;
	
endmodule
	