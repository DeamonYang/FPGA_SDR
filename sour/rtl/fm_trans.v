module	fm_trans(
		clk,
		rst_n,
		data_in,
		fm_out
	);
	
	input clk;
	input rst_n;
	input [9:0]data_in;
	output reg fm_out;
	reg[12:0]audo_dev;
	reg aud_sam_clk;
	
	reg [5:0]audio_idx;
	
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		audo_dev <= 13'd0;
	else if(audo_dev < 13'd43333)
		audo_dev <= audo_dev + 1'b1;
	else
		audo_dev <= 13'd0;
	
	
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		aud_sam_clk <= 1'd0;
	else if(audo_dev ==  13'd1)
		aud_sam_clk <= ~aud_sam_clk;
		
	always@(posedge aud_sam_clk or negedge rst_n)
	if(!rst_n)
		audio_idx <= 6'd0;
	else 	
		audio_idx <= audio_idx + 1'b1;
		
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		fm_out <= 13'd0;
	else
		fm_out <= ~fm_out;
		
	

endmodule
