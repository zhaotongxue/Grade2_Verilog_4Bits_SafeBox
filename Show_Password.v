module Show_Password(
	input clk,//50MHZ
	input state,//显示数字还是-
	input [3:0] p1,
	input [3:0] p2,
	input [3:0] p3,
	input [3:0] p0,
	output reg[7:0] disps,//4 disps are used 
	output reg[7:0] digital_leds//8 parts
	);
	reg  [7:0]  disps_data[15:0];//17 numbers,each number takes 8 bit,and close cmd
	parameter CLK_DIV_PERIOD=125000;//divide into 4*100,=CLK/400
	reg [31:0] cnt=0;//counter of system clock
	reg clk_div=0;
	reg [1:0] pos=0;
	initial begin
			disps_data[0]=8'h3f;//0-F
			disps_data[1]=8'h06;
			disps_data[2]=8'h5b;
			disps_data[3]=8'h4f;
			disps_data[4]=8'h66;
			disps_data[5]=8'h6d;
			disps_data[6]=8'h7d;
			disps_data[7]=8'h07;
			disps_data[8]=8'h7f;
			disps_data[9]=8'h6f;
			disps_data[10]=8'h77;
			disps_data[11]=8'h40;
			disps_data[12]=8'h39;
			disps_data[13]=8'h5e;
			disps_data[14]=8'h79;
			disps_data[15]=8'h71;
	end


	always@(posedge clk)
		begin
			if(cnt>=(CLK_DIV_PERIOD-1))
				begin
					cnt<=1'b0;
					clk_div<=~clk_div;
					pos<=pos+1'b1;
				end
			else cnt<=cnt+1'b1;
		end
		
	integer i;
	always@(clk_div)begin
			for(i=0;i<8;i=i+1'b1) begin	disps[i]=1'b1;	end
			if(state)begin
				disps[pos]=0;
				if(pos==0) 		 if(p0!==4'hx)digital_leds=disps_data[p0];else digital_leds=8'h00;
				else if(pos==1) if(p1!==4'hx)digital_leds=disps_data[p1];else digital_leds=8'h00;
				else if(pos==2) if(p2!==4'hx)digital_leds=disps_data[p2];else digital_leds=8'h00;
				else if(pos==3) if(p3!==4'hx)digital_leds=disps_data[p3];else digital_leds=8'h00;
			end else begin
				digital_leds=8'h02;
				if(pos==0) 		 if(p0!==4'hx)disps[pos]=0;else disps[pos]=1;
				else if(pos==1) if(p1!==4'hx)disps[pos]=0;else disps[pos]=1;
				else if(pos==2) if(p2!==4'hx)disps[pos]=0;else disps[pos]=1;
				else if(pos==3) if(p3!==4'hx)disps[pos]=0;else disps[pos]=1;	
				disps[pos]=0;
			end end
endmodule
