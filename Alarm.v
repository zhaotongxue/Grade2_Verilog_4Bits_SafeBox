module Alarm(
	input clk,
	input alarm,
	output reg led,
	output reg buzzer
	);
	parameter CLK_DIV_PERIDO=8000;//CLK /100
	reg [15:0] cnt;
	
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
				led<=1;
				buzzer<=~buzzer;
			end
		else
			begin
				led<=1'b0;
				buzzer<=1'b1;
			end
	end
	
endmodule
