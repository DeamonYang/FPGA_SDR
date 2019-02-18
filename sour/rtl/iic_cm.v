module iic_cm(
		clk_50m		,
		rst_n			,
		
		iic_sdata	,
		iic_sclk		,
		
		iic_ref_clk	,
		
		iic_data		,
		iic_tr_go	,
		iic_tr_done	
	);
	
	input clk_50m		;
	input rst_n			;
	input[23:0] iic_data;
	input iic_tr_go	;
	
	inout iic_sdata		;
	
	output iic_ref_clk;
	output iic_sclk		;
	output reg iic_tr_done	;
	
	
	reg [5:0]iic_cnt;
	reg [9:0]clk_div; 
	reg clk_dev_iic;
	reg r_sdata;
	reg r_clk_en;
	reg [23:0] r_iic_data;
	assign iic_sdata = r_sdata?1'bz:1'b0;
	assign iic_sclk = r_clk_en?clk_dev_iic:1'b1;
	assign iic_ref_clk = clk_dev_iic;
	
	
	/*IIC 时钟产生*/
	
	always@(posedge clk_50m or negedge rst_n)
	if(!rst_n)
		clk_div <= 10'd0;
	else
		clk_div <= clk_div + 1'b1;
	
	always@(posedge clk_50m or negedge rst_n)
	if(!rst_n)
		clk_dev_iic <= 1'b0;
	else if(clk_div == 10'd1)
		clk_dev_iic <= ~clk_dev_iic;
		
	
	always@(posedge clk_dev_iic or negedge rst_n)
	if(!rst_n) begin
		iic_cnt <= 6'd60;
		r_iic_data <= 24'd0;
	end else if(iic_tr_go) begin
		iic_cnt <= 6'b0;
		r_iic_data <= iic_data;
	end else if(iic_cnt <= 6'd30)
		iic_cnt <= iic_cnt + 1'b1;

	
	always@(posedge clk_dev_iic or negedge rst_n)
	if(!rst_n)begin
		r_sdata <= 1'b1;
		iic_tr_done <= 1'b0;
		r_clk_en <= 1'b0;
		
	end else 
		case(iic_cnt)
		
			/*srt*/
			0:	 r_sdata <= 1'b0;
			1:	 r_clk_en <= 1'b1;
			
			/*chip addr */
			2:	 begin r_sdata <= r_iic_data[23]; end
			3:	 r_sdata <= r_iic_data[22];
			4:	 r_sdata <= r_iic_data[21];
			5:	 r_sdata <= r_iic_data[20];
			6:	 r_sdata <= r_iic_data[19];
			7:	 r_sdata <= r_iic_data[18];
			8:	 r_sdata <= r_iic_data[17];
			9:	 r_sdata <= r_iic_data[16];
			
			/*ack*/
			10: r_sdata <= 1'b1;
			
			/*reg addr*/
			11:	r_sdata <= r_iic_data[15];
			12:	r_sdata <= r_iic_data[14];
			13:	r_sdata <= r_iic_data[13];
			14:	r_sdata <= r_iic_data[12];
			15:	r_sdata <= r_iic_data[11];
			16:	r_sdata <= r_iic_data[10];
			17:	r_sdata <= r_iic_data[9];
			18:	r_sdata <= r_iic_data[8];

			/*ack*/
			19:	r_sdata <= 1'b1;			
			
			/*reg val*/
			20:	r_sdata <= r_iic_data[7];
			21:	r_sdata <= r_iic_data[6];
			22:	r_sdata <= r_iic_data[5];
			23:	r_sdata <= r_iic_data[4];
			24:	r_sdata <= r_iic_data[3];
			25:	r_sdata <= r_iic_data[2];
			26:	r_sdata <= r_iic_data[1];
			27:	r_sdata <= r_iic_data[0];

			/*ack*/
			28: 	begin
						r_sdata <= 1'b1;
//						r_clk_en <= 1'b0; 
					end
			
			/*stop*/
			29:	begin
					r_clk_en <= 1'b0;
					r_sdata <= 1'b0;
					iic_tr_done <= 1'b1;
				end 
			
			30:	begin 
					
					r_sdata <= 1'b1;
					iic_tr_done <= 1'b0;
				end
			default:begin
					r_sdata <= 1'b1;
					iic_tr_done <= 1'b0;				
				end
		endcase

endmodule
	