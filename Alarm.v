module Alarm(
	input clk,
	input alarm,
	output reg led,
	output reg buzzer
	);
	parameter CLK_DIV_PERIDO=8000;//CLK /100
	parameter LED_COUNT=1000;
	reg [15:0] cnt=0;
	reg [13:0] led_cnt=0;
	
	reg clk_div=0;
	always@(posedge clk)begin
		if(cnt>=(CLK_DIV_PERIDO-1)) begin
			cnt<=1'b0;
			clk_div=~clk_div;
		end else cnt<=cnt+1'b1;
	end
	
	always@(posedge clk_div) begin
		if(alarm)
			begin
				if(led_cnt>=(LED_COUNT-1)) begin led<=~led; led_cnt<=0;end
				else led_cnt<=led_cnt+1'b1;
				buzzer<=~buzzer;
			end
		else
			begin
				led<=1'b0;
				buzzer<=1'b1;
			end
	end
	
endmodule
