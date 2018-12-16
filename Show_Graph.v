module Show_Graph(
	input clk,
	input state,
	output reg [7:0] col_r,
	output reg [7:0] col_g,
	output reg [7:0] row
);
	reg [15:0] cnt;
	reg CLK_DIV=1'b0;
	initial begin
		cnt=1;
	end
	parameter CLK_DIV_PERIOD=500000;//=CLK/100
	
	always@(posedge clk)begin
		if(!cnt)begin
			CLK_DIV=~CLK_DIV;
		end
		else cnt<=cnt+1'b1;
	end
	
	always@(CLK_DIV)begin
		//show graph
		if(state)begin
			//show opened graph
			col_r<=8'b0001_1000; 
			col_g<=8'b0001_1000; 
			row<=8'b0111_1111;
		end
		else begin
			// show clocked graph
			col_g<=8'b0011_1100;
			col_r<=8'b0100_0010; 
			row<=8'b1111_1101;
		end
	end
	endmodule
	