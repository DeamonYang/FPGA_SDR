/***************************************************************
*@description： FIR LPF
*@parameters ： sampile friquence 65MHz  
*					 cutoff 0.2MHz  stop 15MHz -80dB
*@author		 ： DeamonYang
****************************************************************/
module fir_lpf_200khz(
		rst_n		,
		clk		,
		clkx2		,
		data_in	,
		data_out	
	);
		input rst_n	;
		input clk	;
		input clkx2	;
		input  [11:0] data_in;
		output [28:0]data_out;
		
		reg [11:0] reg_data_in[19:0];
		/*延时网络*/
		always@(posedge clk or negedge rst_n)
		if(!rst_n)begin
			reg_data_in[0] <= 12'd0;
			reg_data_in[1] <= 12'd0;
			reg_data_in[2] <= 12'd0;
			reg_data_in[3] <= 12'd0;
			reg_data_in[4] <= 12'd0;
			reg_data_in[5] <= 12'd0;
			reg_data_in[6] <= 12'd0;
			reg_data_in[7] <= 12'd0;
			reg_data_in[8] <= 12'd0;
			reg_data_in[9] <= 12'd0;
			reg_data_in[10] <= 12'd0;
			reg_data_in[11] <= 12'd0;
			reg_data_in[12] <= 12'd0;
			reg_data_in[13] <= 12'd0;
			reg_data_in[14] <= 12'd0;
			reg_data_in[15] <= 12'd0;
			reg_data_in[16] <= 12'd0;
			reg_data_in[17] <= 12'd0;
			reg_data_in[18] <= 12'd0;
			reg_data_in[19] <= 12'd0;		
		end else begin
			reg_data_in[0] <= data_in;
			reg_data_in[1] <= reg_data_in[0];
			reg_data_in[2] <= reg_data_in[1];
			reg_data_in[3] <= reg_data_in[2];
			reg_data_in[4] <= reg_data_in[3];
			reg_data_in[5] <= reg_data_in[4];
			reg_data_in[6] <= reg_data_in[5];
			reg_data_in[7] <= reg_data_in[6];
			reg_data_in[8] <= reg_data_in[7];
			reg_data_in[9] <= reg_data_in[8];
			reg_data_in[10] <= reg_data_in[9];
			reg_data_in[11] <= reg_data_in[10];
			reg_data_in[12] <= reg_data_in[11];
			reg_data_in[13] <= reg_data_in[12];
			reg_data_in[14] <= reg_data_in[13];
			reg_data_in[15] <= reg_data_in[14];
			reg_data_in[16] <= reg_data_in[15];
			reg_data_in[17] <= reg_data_in[16];
			reg_data_in[18] <= reg_data_in[17];
			reg_data_in[19] <= reg_data_in[18];
		end
		
		/*对称结构增加一级寄存器求和后再计算乘法 将乘法器数目减半*/
		reg [12:0]sum_reg_symetry[9:0];
		always@(posedge clk or negedge rst_n)
		if(!rst_n)begin
			sum_reg_symetry[0] <= 12'd0;
			sum_reg_symetry[1] <= 12'd0;
			sum_reg_symetry[2] <= 12'd0;
			sum_reg_symetry[3] <= 12'd0;
			sum_reg_symetry[4] <= 12'd0;
			sum_reg_symetry[5] <= 12'd0;
			sum_reg_symetry[6] <= 12'd0;
			sum_reg_symetry[7] <= 12'd0;
			sum_reg_symetry[8] <= 12'd0;
			sum_reg_symetry[9] <= 12'd0;
	
		end else begin
			sum_reg_symetry[0] <= {reg_data_in[0][11],reg_data_in[0]} + { reg_data_in[19][11],reg_data_in[19]};
			sum_reg_symetry[1] <= {reg_data_in[1][11],reg_data_in[1]} + { reg_data_in[18][11],reg_data_in[18]};
			sum_reg_symetry[2] <= {reg_data_in[2][11],reg_data_in[2]} + { reg_data_in[17][11],reg_data_in[17]};
			sum_reg_symetry[3] <= {reg_data_in[3][11],reg_data_in[3]} + { reg_data_in[16][11],reg_data_in[16]};
			sum_reg_symetry[4] <= {reg_data_in[4][11],reg_data_in[4]} + { reg_data_in[15][11],reg_data_in[15]};
			sum_reg_symetry[5] <= {reg_data_in[5][11],reg_data_in[5]} + { reg_data_in[14][11],reg_data_in[14]};
			sum_reg_symetry[6] <= {reg_data_in[6][11],reg_data_in[6]} + { reg_data_in[13][11],reg_data_in[13]};
			sum_reg_symetry[7] <= {reg_data_in[7][11],reg_data_in[7]} + { reg_data_in[12][11],reg_data_in[12]};
			sum_reg_symetry[8] <= {reg_data_in[8][11],reg_data_in[8]} + { reg_data_in[11][11],reg_data_in[11]};
			sum_reg_symetry[9] <= {reg_data_in[9][11],reg_data_in[9]} + { reg_data_in[10][11],reg_data_in[10]};
		end
		
		/*计算乘法*/
		reg [24:0]mout[9:0];
		always@(posedge clk or negedge rst_n)
		if(!rst_n)begin
			mout[0] <= 24'd0;
			mout[1] <= 24'd0;
			mout[2] <= 24'd0;
			mout[3] <= 24'd0;
			mout[4] <= 24'd0;
			mout[5] <= 24'd0;
			mout[6] <= 24'd0;
			mout[7] <= 24'd0;
			mout[8] <= 24'd0;
			mout[9] <= 24'd0;
		end else begin
			mout[0] <= {{12{sum_reg_symetry[0][12]}},sum_reg_symetry[0]} ;//*2;
			mout[1] <= {{12{sum_reg_symetry[1][12]}},sum_reg_symetry[1]}*25'd11;//*14;
			mout[2] <= {{12{sum_reg_symetry[2][12]}},sum_reg_symetry[2]}*25'd63;
			mout[3] <= {{12{sum_reg_symetry[3][12]}},sum_reg_symetry[3]}*25'd213;
			mout[4] <= {{12{sum_reg_symetry[4][12]}},sum_reg_symetry[4]}*25'd541 ;
			mout[5] <= {{12{sum_reg_symetry[5][12]}},sum_reg_symetry[5]}*25'd1107 ;
			mout[6] <= {{12{sum_reg_symetry[6][12]}},sum_reg_symetry[6]}*25'd1901 ;
			mout[7] <= {{12{sum_reg_symetry[7][12]}},sum_reg_symetry[7]}*25'd2807 ;
			mout[8] <= {{12{sum_reg_symetry[8][12]}},sum_reg_symetry[8]}*25'd3615 ;
			mout[9] <= {{12{sum_reg_symetry[9][12]}},sum_reg_symetry[9]}*25'd4095 ;
		end
	
		reg suncnt;
		always@(posedge clkx2 or negedge rst_n)
		if(!rst_n)begin
			suncnt <= 1'b0;
		end else
			suncnt <= suncnt + 1'b1;
	
		/*求和输出结果*/
		reg [29:0]sum;
		reg [29:0]yout/*synthesis noprune*/; 
		always@(posedge clkx2 or negedge rst_n)
		if(!rst_n)begin
			sum <= 30'd0;
			yout <= 30'd0;
		end else begin 
			if(suncnt) begin  
				yout <= sum;
				sum <= 30'd0;//阻塞赋值 清零
			end else  
				sum <= {{5{mout[0][24]}},mout[0]}+{{5{mout[1][24]}},mout[1]}+{{5{mout[2][24]}},mout[2]}+{{5{mout[3][24]}},mout[3]}+{{5{mout[4][24]}},mout[4]}
							+{{5{mout[5][24]}},mout[5]}+{{5{mout[6][24]}},mout[6]}+{{5{mout[7][24]}},mout[7]}+{{5{mout[8][24]}},mout[8]}+{{5{mout[9][24]}},mout[9]};
		end
		
		assign data_out = yout[29:1];
	
endmodule





