module Show_Graph(
	input clk,
	input state,
	output reg [7:0] col_r,
	output reg [7:0] col_g,
	output reg [7:0] row
);
	reg [2:0] index;
	reg [15:0] cnt;
	reg CLK_DIV=1'b0;
	initial begin
		cnt=1;
		index=3'b000;
	end
	
	parameter CLK_DIV_PERIOD=62500;//=CLK/100

	always@(posedge clk)begin
		if(cnt>=(CLK_DIV_PERIOD-1))begin
			cnt<=0;
			CLK_DIV<=~CLK_DIV;
			index<=index+1'b1;
		end
		else cnt<=cnt+1'b1;
	end
	
	always@(CLK_DIV)begin
		//show graph
		if(state)begin
			//show opened graph
			if(index==0)begin 
				col_g<=8'b00000001; 
				col_r<=8'b00000000;
				row<=8'b01111111;	
				
			end else if(index==1)begin 
				col_g<=8'b00000011;  
				col_r<=8'b00000000;
				row<=8'b10111111;
				
			end else if(index==2)begin 
				col_g<=8'b00000110;
				col_r<=8'b00000000;
				row<=8'b11011111;
				
			end else if(index==3)begin 
				col_g<=8'b10001100;
				col_r<=8'b00000000;
				row<=8'b11101111;	
				
			end else if(index==4)begin 
				col_g<=8'b11011000;
				col_r<=8'b00000000;
				row<=8'b11110111;
			end else if(index==5)begin 
				col_g<=8'b11110000; 
				col_r<=8'b00000000;
				row<=8'b11111011;
			end else if(index==6)begin 
				col_g<=8'b01100000;
				col_r<=8'b00000000;		
				row<=8'b11111101;
			end else if(index==7)begin 
				col_g<=8'b00000000;
				col_r<=8'b00000000;	
				row<=8'b11111110;
			end
		end
		else begin
			// show clocked graph
			if(index==0)begin 
				col_r<=8'b10000001;
				col_g<=8'b00000000;
				row<=8'b01111111;
			end else if(index==1)begin 
				col_r<=8'b11000011;
				col_g<=8'b00000000;	
				row<=8'b10111111;
			end else if(index==2)begin  
				col_r<=8'b01100110;
				col_g<=8'b00000000;
				row<=8'b11011111;
			end else if(index==3)begin 
				col_r<=8'b00111100; 
				col_g<=8'b00000000;
				row<=8'b11101111;
			end else if(index==4)begin 
				col_r<=8'b00011000; 
				col_g<=8'b00000000;
				row<=8'b11110111;
				
			end else if(index==5)begin  
				col_r<=8'b00111100; 
				col_g<=8'b00000000;
				row<=8'b11111011;
				
			end else if(index==6)begin  
				col_r<=8'b01100110; 
				col_g<=8'b00000000;
				row<=8'b11111101;
				
			end else if(index==7)begin 
				col_r<=8'b11000011;
				col_g<=8'b00000000;
				row<=8'b11111110;
				
			end
		end
	end
	endmodule
	