module adf4351(
		clk_50	,
		rst_n		,
		vco_clk	,
		vco_data	,
		vco_le	,
		vco_ce	,
		vco_ld	
	);

	input clk_50	;
	input rst_n		;
	input vco_ld	;		//Lock Detect Output Pin. A logic high output on this pin indicates PLL lock
	output vco_clk	;
	output reg vco_data	;
	output reg vco_le	;	//Load Enable. When LE goes high, the data stored in the 32-bit shift register is loaded into the register that is
							//selected by the three control bits. This input is a high impedance CMOS input.
	output  vco_ce	; //Chip Enable. A logic low on this pin powers down the device and puts the charge pump into three-state mode.
							//A logic high on this pin powers up the device, depending on the status of the power-down bits.
	reg[4:0]onereg_cnt;
	reg[2:0]reg_index;
	
	reg[9:0]clk_div_cnt;
	reg clk_div;
	reg [1:0]config_step;
	
	/*one register data trans control*/
	reg one_tr_st;
	reg one_tr_en;
	reg one_tr_done;
	reg [5:0]one_clk_cnt;
	reg[31:0]reg_data;

	assign vco_ce = 1'b1;
	assign vco_clk = ~clk_div;
	
	always@(posedge clk_div or negedge rst_n)
	if(!rst_n)
		one_clk_cnt <= 6'd34;
	else begin
		if(one_tr_st)
			one_clk_cnt <= 6'd0;
		else if(one_clk_cnt <= 6'd33)
			one_clk_cnt <= one_clk_cnt + 1'b1;
	end
	
	
	
	always@(posedge clk_div or negedge rst_n)
	if(!rst_n)begin
		vco_data <= 1'b0;
		vco_le <= 1'b0;
		one_tr_done <= 1'b0;
	end else case(one_clk_cnt)
	
			0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31:begin
				vco_data <= (((reg_data << one_clk_cnt)&32'h8000_0000)>>31);
			end
			
			32: begin
					vco_le <= 1'b1;
					one_tr_done <= 1'b1;
				end
			33:begin
					vco_le <= 1'b0;
					one_tr_done <= 1'b0;			
				end
				
			default: 
				one_tr_done <= 1'b0;	
	endcase


		
	always@(posedge clk_50 or negedge rst_n)
	if(!rst_n)
		clk_div_cnt <= 10'd0;
	else if(clk_div_cnt <= 10'd49)
		clk_div_cnt <= clk_div_cnt + 1'b1;
	else
		clk_div_cnt <= 10'd0;
		
	/*VCO data clock*/
	always@(posedge clk_50 or negedge rst_n)
	if(!rst_n)
		clk_div <= 1'd0;
	else if(clk_div_cnt == 10'd8)
		clk_div <= ~clk_div;

	always@(posedge clk_div or negedge rst_n)
	if(!rst_n)begin
		reg_index <= 3'b0;
		config_step <= 2'd0;
	end else if(reg_index <= 3'd5 )begin
		case (config_step)
			0:begin
					config_step <= 2'b1;
					one_tr_st <= 1'b1;
			end
			
			1:begin
					one_tr_st <= 1'b0;
				
					if(one_tr_done)
						config_step <= 2'd2; 	
			end
			
			2:begin
					reg_index <= reg_index + 1'b1;
					config_step <= 2'b0;
			end
		endcase
	end
	
	always@(posedge clk_div or negedge rst_n)
	if(!rst_n)
		reg_data <= 32'd0;
	else case(reg_index)
///*90.9M*/
//		0: reg_data <= 32'h00580005;
//		1:	reg_data <= 32'hDC803C;
//		2:	reg_data <= 32'h4B3;
//		3:	reg_data <= 32'h1004E42;
//		4:	reg_data <= 32'h80083E9;
//		5:	reg_data <= 32'h3A0160;
//
///*82.2M*/
//		0: reg_data <= 32'h00580005;
//		1:	reg_data <= 32'hDC803C;
//		2:	reg_data <= 32'h4B3;
//		3:	reg_data <= 32'h1004E42;
//		4:	reg_data <= 32'h80083E9;
//		5:	reg_data <= 32'h3480D8;
//
///*78M*/
//		0: reg_data <= 32'h00580005;
//		1:	reg_data <= 32'hDC803C;
//		2:	reg_data <= 32'h4B3;
//		3:	reg_data <= 32'h1004E42;
//		4:	reg_data <= 32'h80080C9;
//		5:	reg_data <= 32'h3180A8;

/*100M*/
		0: reg_data <= 32'h00580005;
		1:	reg_data <= 32'hDC803C;
		2:	reg_data <= 32'h4B3;
		3:	reg_data <= 32'h1004E42;
		4:	reg_data <= 32'h8008011;
		5:	reg_data <= 32'h400000;
		
	
/*77.4M*/
//		0: reg_data <= 32'h00580005;
//		1:	reg_data <= 32'hDC803C;
//		2:	reg_data <= 32'h4B3;
//		3:	reg_data <= 32'h1004E42;
//		4:	reg_data <= 32'h80083E9;
//		5:	reg_data <= 32'h318048;	
		
/*75M*/
//		0: reg_data <= 32'h580005;
//		1:	reg_data <= 32'hDC803C;
//		2:	reg_data <= 32'h4B3;
//		3:	reg_data <= 32'h1004E42;
//		4:	reg_data <= 32'h8008011;
//		5:	reg_data <= 32'h300000;	



/*82.4M*/
//		0: reg_data <= 32'h00580005;
//		1:	reg_data <= 32'hDC803C;
//		2:	reg_data <= 32'h4B3;
//		3:	reg_data <= 32'h1004E42;
//		4:	reg_data <= 32'h80083E9;
//		5:	reg_data <= 32'h3481D8;


	endcase	
	
endmodule
