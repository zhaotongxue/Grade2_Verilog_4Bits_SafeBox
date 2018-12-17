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
		index=0;
	end
	parameter CLK_DIV_PERIOD=5000;//=CLK/100
	reg [2:0] index;
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
			//送花ow opened graph
			if(index==0)begin 
			col_r<=8'b1000_0001; 
			row<=8'b1111_1101;
			end else if(index==1)begin 
			col_r<=8'b0100_0010;  
			row<=8'b1101_1111;
			end else if(index==2)begin 
			col_r<=8'b0010_0100;  
			row<=8'b1111_0111;
			end else if(index==3)begin 
			col_r<=8'b0001_1000; 
			row<=8'b1101_1111;
			end else if(index==4)begin 
			col_r<=8'b0001_1000;
			row<=8'b1110_1111;
			end else if(index==5)begin 
			col_r<=8'b0010_0100;   
			row<=8'b1111_1110;
			end else if(index==6)begin 
			col_r<=8'b0100_0010;  
			row<=8'b1111_1011;
			end else if(index==7)begin 
			col_r<=8'b1000_0001; 
			row<=8'b1111_0111;
			end
		end
		else begin
			// show clocked graph
			if(index==0)begin 
			col_g<=8'b0111_1110; 
			row<=8'b1101_1111;
			end else if(index==1)begin 
			col_g<=8'b0010_0100; 
			row<=8'b1111_1110;
			end else if(index==2)begin  
			col_g<=8'b0010_0100; 
			row<=8'b1101_1111;
			end else if(index==3)begin 
			col_g<=8'b1111_1111; 
			row<=8'b1111_1110;
			end else if(index==4)begin 
			col_g<=8'b0010_0100; 
			row<=8'b1111_1011;
			end else if(index==5)begin  
			col_g<=8'b0010_0100; 
			row<=8'b1111_1011;
			end else if(index==6)begin  
			col_g<=8'b0010_0100; 
			row<=8'b1110_1111;
			end else if(index==7)begin 
			col_g<=8'b0010_0100;
			row<=8'b1111_1101;
			end
		end
	end
	endmodule
	
