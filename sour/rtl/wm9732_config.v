module wm9732_config(
		clk_50m		,
		rst_n			,
		
		iic_sdata	,
		iic_sclk		,
		
		wm_cf_done	

	);
	
	input clk_50m;
	input rst_n;
	inout iic_sdata;
	output iic_sclk;
	output reg wm_cf_done;
	
	wire iic_ref_clk;
	reg [23:0]iic_data;
	reg iic_tr_go;
	wire iic_tr_done;
	reg [23:0]delay_cnt;
	reg [3:0]step_cnt;
	
	parameter DELAY_TIME = 24'd10_000_000;
	
	iic_cm wmiic(
		.clk_50m(clk_50m)		,
		.rst_n(rst_n)			,
		.iic_sdata(iic_sdata)	,
		.iic_sclk(iic_sclk)		,
		.iic_ref_clk(iic_ref_clk)	,
		.iic_data(iic_data),
		.iic_tr_go(iic_tr_go)	,
		.iic_tr_done(iic_tr_done)	
	);
	
	always@(posedge clk_50m or negedge rst_n)
	if(!rst_n)
		delay_cnt <= 24'd0;
	else if(delay_cnt <= DELAY_TIME)
		delay_cnt <= delay_cnt + 1'b1;
		
	always@(posedge iic_ref_clk or negedge rst_n)
	if(!rst_n)begin
		step_cnt <= 4'b0;
		iic_tr_go <= 1'b1;
	end else if((step_cnt < 4'd9)&(delay_cnt == DELAY_TIME | iic_tr_done))begin
		step_cnt <= step_cnt + 1'b1;
		iic_tr_go <= 1'b1;
	end else
		iic_tr_go <= 1'b0;
	
	/*配置完成*/
	always@(posedge clk_50m or negedge rst_n)
	if(!rst_n) 
		wm_cf_done <= 1'b0;
	else if(step_cnt == 4'd9 & iic_tr_done)
		wm_cf_done <= 1'b1;
	else
		wm_cf_done <= 1'b0;
		
	always@(posedge clk_50m or negedge rst_n)
	if(!rst_n) begin
		iic_data <= 24'd0;
	end else case(step_cnt)
			0:iic_data <= 24'h34001f;
			1:iic_data <= 24'h34021f;
			2:iic_data <= 24'h340479;
			3:iic_data <= 24'h340679;
			4:iic_data <= 24'h3408f8;
			5:iic_data <= 24'h340a06;
			6:iic_data <= 24'h340c00;
			7:iic_data <= 24'h340e01;
			8:iic_data <= 24'h341002;
			9:iic_data <= 24'h341201;
		default: iic_data <= 24'd0;
	endcase
		
		
	
endmodule

