module Show_Password(
	input clk,//50Mbz
	input state,//显示数字还是-
	input [4:0] p0,
	input [4:0] p1,
	input [4:0] p2,
	input [4:0] p3,
	input [4:0] p4,
	input [4:0] p5,
	output reg[7:0] disps,//4 disps are used 
	output reg[7:0] digital_leds//8 parts
	);
	
	//reg state=1;
	reg  [7:0]  disps_data[15:0];//17 numbers,each number takes 8 bit,and close cmd
	parameter CLK_DIV_PERIOD=12500;//divide into 4*100,=CLK/400
	reg [19:0] cnt=0;//counter of system clock
	reg clk_div=0;
	reg [2:0] pos;
	reg [2:0] pd_cnt=0;
	initial begin
			pos=0;
			disps[0]=1;
			disps[1]=1;
			disps[2]=1;
			disps[3]=1;
			disps[4]=1;
			disps[5]=1;
			disps[6]=1;
			disps[7]=1;
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
			disps_data[11]=8'h7C;
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
				pos<=(pos+1'b1)%6;
			end
		else cnt<=cnt+1'b1;
	end
		
integer i;	
/*
always@(clk_div)begin
		for(i=0;i<8;i=i+1'b1) begin disps[i]=1; end
		if(state)begin
		if(pos==0) 		 if(p0>15)begin digital_leds=0;disps[pos]=1;end else begin digital_leds=disps_data[p0];disps[pos]=0;end 
		else if(pos==1) if(p1>15)begin digital_leds=0;disps[pos]=1;end else begin digital_leds=disps_data[p1];disps[pos]=0;end 
		else if(pos==2) if(p2>15)begin digital_leds=0;disps[pos]=1;end else begin digital_leds=disps_data[p2];disps[pos]=0;end 
		else if(pos==3) if(p3>15)begin digital_leds=0;disps[pos]=1;end else begin digital_leds=disps_data[p3];disps[pos]=0;end
		end else begin
		digital_leds=8'h40;
		if(pos==0) 		 if(p0>15)begin digital_leds=0;disps[pos]=1;end else disps[pos]=0;
		else if(pos==1) if(p1>15)begin digital_leds=0;disps[pos]=1;end else disps[pos]=0;
		else if(pos==2) if(p2>15)begin digital_leds=0;disps[pos]=1;end else disps[pos]=0;
		else if(pos==3) if(p3>15)begin digital_leds=0;disps[pos]=1;end else disps[pos]=0;	
	end
end
*/

always@(clk_div)begin
		if(p5<16) pd_cnt=6;
		else if(p4<16) pd_cnt=5;
		else if(p3<16) pd_cnt=4;
		else if(p2<16) pd_cnt=3;
		else if(p1<16) pd_cnt=2;
		else if(p0<16) pd_cnt=1;
		else pd_cnt=0;
		
		
		for(i=0;i<8;i=i+1'b1) begin disps[i]=1; end
		if(state)begin
			case(pos)
			0:begin//最右边,当pd_cnt==3的时候显示p0 
				case(pd_cnt)
					6: begin digital_leds=disps_data[p0];disps[0]=0;end
					default:begin digital_leds=0;disps[0]=1;end
				endcase
			end
			1:begin//右1,当pd_cnt==2的时候显示p0,pd_cnt==3的时候显示p1
				case(pd_cnt)
					6: begin digital_leds=disps_data[p1];disps[1]=0;end
					5: begin digital_leds=disps_data[p0];disps[1]=0;end
					default:begin digital_leds=0;disps[1]=1;end
					endcase
			end
			2:begin//左1,pd_cnt==3:p2,pd_cnt==2:p1,pd_cnt==1,p0
					case(pd_cnt)
							6:begin digital_leds=disps_data[p2];disps[2]=0;end
							5:begin digital_leds=disps_data[p1];disps[2]=0;end
							4:begin digital_leds=disps_data[p0];disps[2]=0;end
							default:begin digital_leds=0;disps[2]=1;end
					endcase
				end
			
			3:begin//最左边,pd_cnt==3:p3,pd_cnt==2:p2,pd_cnt==1:p1,pd_cnt==0_p0;
				case(pd_cnt)
					6:begin digital_leds=disps_data[p3];disps[3]=0;end
					5:begin digital_leds=disps_data[p2];disps[3]=0;end
					4:begin digital_leds=disps_data[p1];disps[3]=0;end
					3:begin digital_leds=disps_data[p0];disps[3]=0;end
					default:begin digital_leds=0;disps[3]=1;end
				endcase
			end 
			4:begin
				case(pd_cnt)
					6:begin digital_leds=disps_data[p4];disps[4]=0;end
					5:begin digital_leds=disps_data[p3];disps[4]=0;end
					4:begin digital_leds=disps_data[p2];disps[4]=0;end
					3:begin digital_leds=disps_data[p1];disps[4]=0;end
					2:begin digital_leds=disps_data[p0];disps[4]=0;end
					default:begin digital_leds=0;disps[4]=1;end
				endcase
			end
			5:begin
				case(pd_cnt)
						6:begin digital_leds=disps_data[p5];disps[5]=0;end
						5:begin digital_leds=disps_data[p4];disps[5]=0;end
						4:begin digital_leds=disps_data[p3];disps[5]=0;end
						3:begin digital_leds=disps_data[p2];disps[5]=0;end
						2:begin digital_leds=disps_data[p1];disps[5]=0;end
						1:begin digital_leds=disps_data[p0];disps[5]=0;end
						default:begin digital_leds=0;disps[5]=1;end
					endcase
			end
			endcase
		end
		else begin
			digital_leds=8'h40;
			if(pos==0) 		begin  if(p5>15)begin digital_leds=0;disps[pos]=1;end else disps[pos]=0;end 
			else if(pos==1)begin  if(p4>15)begin digital_leds=0;disps[pos]=1;end else disps[pos]=0;end 
			else if(pos==2)begin  if(p3>15)begin digital_leds=0;disps[pos]=1;end else disps[pos]=0;end 
			else if(pos==3)begin  if(p2>15)begin digital_leds=0;disps[pos]=1;end else disps[pos]=0;end
			else if(pos==4)begin  if(p1>15)begin digital_leds=0;disps[pos]=1;end else disps[pos]=0;end 
			else if(pos==5)begin  if(p0>15)begin digital_leds=0;disps[pos]=1;end else disps[pos]=0;end
	end
end

endmodule
