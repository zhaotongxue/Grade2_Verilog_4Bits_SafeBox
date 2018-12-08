module Show_Graph(
	input clk,
	input state
);
	reg [19:0] cnt;
	reg CLK_DIV=1'b0;
	initial begin
		cnt=0;
	end
	parameter CLK_DIV_PERIOD=500000;//=CLK/100
	
	always@(posedge clk)begin
		if(cnt>=(CLK_DIV_PERIOD-1))begin
			cnt=1'b0;
			CLK_DIV=~CLK_DIV;
		end
		else cnt<=cnt+1'b1;
	end
	
	always@(CLK_DIV)begin
		//show graph
		if(state)begin
			//show opened graph
		end
		else begin
			// show clocked graph
		end
	end
	endmodule
	