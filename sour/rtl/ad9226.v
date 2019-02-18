module ad9226(
		/*ADC */
		rst_n			,
		adc_oeb		,
		adc_clk		,
		adc_data		,
		adc_mode		,
		adc_otr		,	//out of range
		adc_bus		,
		adc_sck		
);


	input rst_n;
	output adc_oeb;
	input adc_clk;
	output reg[11:0]adc_data;
	output [1:0]adc_mode;
	input	adc_otr;
	input [11:0]adc_bus;
	output adc_sck;
	
	reg signed[11:0]temp_adc_data;
	
	reg signed[13:0]us_adc_data;
	
	
	assign adc_oeb = 1'b0;
	assign adc_mode = 2'b11;
	assign adc_sck = adc_clk;
	
	always@(posedge adc_clk or negedge rst_n)
	if(!rst_n)
		adc_data <= 12'd0;
	else
//		adc_data <= {adc_bus[0],adc_bus[1],adc_bus[2],adc_bus[3],adc_bus[4],adc_bus[5],adc_bus[6],adc_bus[7],adc_bus[8],adc_bus[9],adc_bus[10],adc_bus[11]};

//		adc_data <= {adc_bus[0],adc_bus[0],adc_bus[0],adc_bus[0],adc_bus[1],adc_bus[2],adc_bus[3],adc_bus[4],adc_bus[5],adc_bus[6],adc_bus[7],adc_bus[8]};
		adc_data <= {adc_bus[0],adc_bus[1],adc_bus[2],adc_bus[3],adc_bus[4],adc_bus[5],adc_bus[6],adc_bus[7],adc_bus[8],3'd0};
								
//	always@(posedge adc_clk or negedge rst_n)
//	if(!rst_n)
//		us_adc_data <= 12'd0;
//	else
////		adc_data <= adc_bus;
//		us_adc_data <= {temp_adc_data[11],temp_adc_data[11] ,temp_adc_data} + 12'd2048;
//		
//	assign adc_data = us_adc_data[12:1];
endmodule
