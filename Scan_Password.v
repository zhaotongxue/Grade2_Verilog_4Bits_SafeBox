module Scan_Password(
  input            clk,
  input            rst,
  input      [3:0] row,                 // 矩阵键盘 行
  output reg [3:0] col,                 // 矩阵键盘 列
  output reg [3:0] p1,         			// 键盘值     
  output reg [3:0] p2,
  output reg [3:0] p3,
  output reg [3:0] p0
);
reg [3:0] keyboard_val;
reg [1:0] pos;
reg [19:0] cnt;                       // 计数子
reg key_clk;
wire next_one;
//localparam CLK_PERIOD=10000000;
always @ (posedge clk, posedge rst)begin
  if (rst) begin cnt <= 0; end // (2^20/50M = 21)ms 
  else begin
	if(!cnt) begin cnt<=0;key_clk=~key_clk;end 
	else  cnt <= cnt + 1'b1;  
	end
end

parameter NO_KEY_PRESSED = 6'b000_001;  // 没有按键按下  
parameter SCAN_COL0      = 6'b000_010;  // 扫描第0列 
parameter SCAN_COL1      = 6'b000_100;  // 扫描第1列 
parameter SCAN_COL2      = 6'b001_000;  // 扫描第2列 
parameter SCAN_COL3      = 6'b010_000;  // 扫描第3列 
parameter KEY_PRESSED    = 6'b100_000;  // 有按键按下
 
reg [5:0] current_state, next_state;    // 现态、次态
initial begin
	keyboard_val<=0;
	pos<=0;
	cnt<=0;
	key_clk<=0;
	p0<=4;
	p1<=4;
	p2<=4;
	p3<=4;
	current_state<=NO_KEY_PRESSED;
	next_state<=NO_KEY_PRESSED;
end
assign next_one=~(current_state!=KEY_PRESSED);
always @ (posedge key_clk, posedge rst)begin 
  if (rst)  begin current_state <= NO_KEY_PRESSED;end
  else  begin current_state <= next_state;end
 end
 
// 根据条件转移状态
always @* begin
  case (current_state)
    NO_KEY_PRESSED:                    // 没有按键按下
        if (row != 4'hF) begin next_state = SCAN_COL0;end
        else begin next_state = NO_KEY_PRESSED;end
    SCAN_COL0 :                         // 扫描第0列 
        if (row != 4'hF) next_state = KEY_PRESSED;
        else next_state = SCAN_COL1;
    SCAN_COL1 :                         // 扫描第1列 
        if (row != 4'hF) next_state = KEY_PRESSED;
        else  next_state = SCAN_COL2;    
    SCAN_COL2 :                         // 扫描第2列
        if (row != 4'hF) next_state = KEY_PRESSED;
        else next_state = SCAN_COL3;
    SCAN_COL3 :                         // 扫描第3列
        if (row != 4'hF) next_state = KEY_PRESSED;
        else next_state = NO_KEY_PRESSED;
    KEY_PRESSED :                       // 有按键按下
        if (row != 4'hF)begin next_state = KEY_PRESSED;end
        else begin next_state = NO_KEY_PRESSED;end
  endcase
end
	reg       key_pressed_flag;             // 键盘按下标志
	reg [3:0] col_val, row_val;             // 列值、行值
 
// 根据次态，给相应寄存器赋值
always @ (posedge key_clk, posedge rst)
  if (rst)begin
    col              <= 4'b0000;
    key_pressed_flag <=    0;
  end else case (next_state)
      NO_KEY_PRESSED :                  // 没有按键按下
      begin 
        col              <= 4'h0;
        key_pressed_flag <=    0;       // 清键盘按下标志
      end
      SCAN_COL0 :                       // 扫描第0列
        col <= 4'b1110;
      SCAN_COL1 :                       // 扫描第1列
        col <= 4'b1101;
      SCAN_COL2 :                       // 扫描第2列
        col <= 4'b1011;
      SCAN_COL3 :                       // 扫描第3列
        col <= 4'b0111;
      KEY_PRESSED :                     // 有按键按下
      begin
        col_val          <= col;        // 锁存列值
        row_val          <= row;        // 锁存行值
        key_pressed_flag <= 1;          // 置键盘按下标志  
      end
    endcase
 

always @ (posedge key_pressed_flag, posedge rst)
  if (rst) keyboard_val <= 4'h0;
  else if (key_pressed_flag)
	case ({col_val, row_val})
	  8'b1110_1110 : begin  keyboard_val <= 4'h0;if(pos==0) p0<=keyboard_val;else if(pos==1)p1<=keyboard_val;else if(pos==2)p2<=keyboard_val;else if(pos==3)p3<=keyboard_val;$display("Value changed,pos is %d,value is %d",pos,keyboard_val); pos<=pos+1'b1;end
	  8'b1110_1101 : begin  keyboard_val <= 4'h4;if(pos==0) p0<=keyboard_val;else if(pos==1)p1<=keyboard_val;else if(pos==2)p2<=keyboard_val;else if(pos==3)p3<=keyboard_val;$display("Value changed,pos is %d,value is %d",pos,keyboard_val); pos<=pos+1'b1;end
	  8'b1110_1011 : begin  keyboard_val <= 4'h8;if(pos==0) p0<=keyboard_val;else if(pos==1)p1<=keyboard_val;else if(pos==2)p2<=keyboard_val;else if(pos==3)p3<=keyboard_val;$display("Value changed,pos is %d,value is %d",pos,keyboard_val); pos<=pos+1'b1;end
	  8'b1110_0111 : begin  keyboard_val <= 4'hC;if(pos==0) p0<=keyboard_val;else if(pos==1)p1<=keyboard_val;else if(pos==2)p2<=keyboard_val;else if(pos==3)p3<=keyboard_val;$display("Value changed,pos is %d,value is %d",pos,keyboard_val); pos<=pos+1'b1;end
		
	  8'b1101_1110 : begin  keyboard_val <= 4'h1;if(pos==0) p0<=keyboard_val;else if(pos==1)p1<=keyboard_val;else if(pos==2)p2<=keyboard_val;else if(pos==3)p3<=keyboard_val;$display("Value changed,pos is %d,value is %d",pos,keyboard_val); pos<=pos+1'b1;end
	  8'b1101_1101 : begin  keyboard_val <= 4'h5;if(pos==0) p0<=keyboard_val;else if(pos==1)p1<=keyboard_val;else if(pos==2)p2<=keyboard_val;else if(pos==3)p3<=keyboard_val;$display("Value changed,pos is %d,value is %d",pos,keyboard_val);pos<=pos+1'b1;end
	  8'b1101_1011 : begin  keyboard_val <= 4'h9;if(pos==0) p0<=keyboard_val;else if(pos==1)p1<=keyboard_val;else if(pos==2)p2<=keyboard_val;else if(pos==3)p3<=keyboard_val;$display("Value changed,pos is %d,value is %d",pos,keyboard_val); pos<=pos+1'b1;end
	  8'b1101_0111 : begin  keyboard_val <= 4'hD;if(pos==0) p0<=keyboard_val;else if(pos==1)p1<=keyboard_val;else if(pos==2)p2<=keyboard_val;else if(pos==3)p3<=keyboard_val;$display("Value changed,pos is %d,value is %d",pos,keyboard_val); pos<=pos+1'b1;end
		
	  8'b1011_1110 : begin  keyboard_val <= 4'h2;if(pos==0) p0<=keyboard_val;else if(pos==1)p1<=keyboard_val;else if(pos==2)p2<=keyboard_val;else if(pos==3)p3<=keyboard_val; $display("Value changed,pos is %d,value is %d",pos,keyboard_val);pos<=pos+1'b1;end
	  8'b1011_1101 : begin  keyboard_val <= 4'h6;if(pos==0) p0<=keyboard_val;else if(pos==1)p1<=keyboard_val;else if(pos==2)p2<=keyboard_val;else if(pos==3)p3<=keyboard_val; $display("Value changed,pos is %d,value is %d",pos,keyboard_val);pos<=pos+1'b1;end
	  8'b1011_1011 : begin  keyboard_val <= 4'hA;if(pos==0) p0<=keyboard_val;else if(pos==1)p1<=keyboard_val;else if(pos==2)p2<=keyboard_val;else if(pos==3)p3<=keyboard_val; $display("Value changed,pos is %d,value is %d",pos,keyboard_val);pos<=pos+1'b1;end
	  8'b1011_0111 : begin  keyboard_val <= 4'hE;if(pos==0) p0<=keyboard_val;else if(pos==1)p1<=keyboard_val;else if(pos==2)p2<=keyboard_val;else if(pos==3)p3<=keyboard_val; $display("Value changed,pos is %d,value is %d",pos,keyboard_val);pos<=pos+1'b1;end
		
	  8'b0111_1110 : begin  keyboard_val <= 4'h3;if(pos==0) p0<=keyboard_val;else if(pos==1)p1<=keyboard_val;else if(pos==2)p2<=keyboard_val;else if(pos==3)p3<=keyboard_val; $display("Value changed,pos is %d,value is %d",pos,keyboard_val);pos<=pos+1'b1;end
	  8'b0111_1101 : begin  keyboard_val <= 4'h7;if(pos==0) p0<=keyboard_val;else if(pos==1)p1<=keyboard_val;else if(pos==2)p2<=keyboard_val;else if(pos==3)p3<=keyboard_val; $display("Value changed,pos is %d,value is %d",pos,keyboard_val);pos<=pos+1'b1;end
	  8'b0111_1011 : begin  keyboard_val <= 4'hB;if(pos==0) p0<=keyboard_val;else if(pos==1)p1<=keyboard_val;else if(pos==2)p2<=keyboard_val;else if(pos==3)p3<=keyboard_val; $display("Value changed,pos is %d,value is %d",pos,keyboard_val);pos<=pos+1'b1;end
	  8'b0111_0111 : begin  keyboard_val <= 4'hF;if(pos==0) p0<=keyboard_val;else if(pos==1)p1<=keyboard_val;else if(pos==2)p2<=keyboard_val;else if(pos==3)p3<=keyboard_val; $display("Value changed,pos is %d,value is %d",pos,keyboard_val);pos<=pos+1'b1;end
	endcase
always@(pos) $display("Pos changed to %d,value is %d",pos,keyboard_val);
endmodule


/*
localparam STATE0=4'b0001;
localparam STATE1=4'b0010;
localparam STATE2=4'b0100;
localparam STATE3=4'b1000;

reg [1:0] postion;
reg [1:0] c_state;//current state
reg clk_200HZ;
reg [23:0]  cnt;
initial begin
	postion<=0;
	p0<=0;
	p1<=0;
	p2<=0;
	p3<=0;
	c_state<=STATE0;
	clk_200HZ<=0;
	cnt<=0;
end
	
parameter CLK_DIV_PERIOD=250000;//=CLK/200

//Frequency Division
always @(posedge clk) begin
  if(cnt>=(CLK_DIV_PERIOD-1)) 
	  begin
		  cnt<=1'b0;
		  clk_200HZ<=~clk_200HZ;
	  end
  else cnt<=cnt+1'b1;
end
  
		
always @(posedge clk_200HZ or posedge rst) begin
	if(rst)begin 
		c_state<=STATE0;
		postion<=0;
		p0<=0;
		p1<=0;
		p2<=0;
		p3<=0;
	end else case (c_state) 
	  STATE0: begin c_state <= STATE1; row <= 4'b1101; end
	  STATE1: begin c_state <= STATE2; row <= 4'b1011; end
	  STATE2: begin c_state <= STATE3; row <= 4'b0111; end
	  STATE3: begin c_state <= STATE0; row <= 4'b1110; end
	  default:begin c_state <= STATE0; row <= 4'b1110; end
   endcase
end 

  always@(negedge clk_200HZ) begin
     case(c_state)
     STATE0:
        begin
            if(col==4'b1110)begin
					if(postion==0)begin p0<=0; postion<=postion+1'b1;end
					else if(postion==1)begin p1<=0; postion<=postion+1'b1;end
					else if(postion==2)begin p2<=0; postion<=postion+1'b1;end
					else p3<=0;postion<=postion+1'b1;end
				end
            else if(col==4'b1101)begin
					if(postion==0)begin p0<=1; postion<=postion+1'b1;end
					else if(postion==1)begin p1<=1; postion<=postion+1'b1;end
					else if(postion==2)begin p2<=1; postion<=postion+1'b1;end
					else p3<=1;postion<=postion+1'b1;end
				end
            else if(col==4'b1101)begin
					if(postion==0)begin p0<=2; postion<=postion+1'b1;end
					else if(postion==1)begin p1<=2; postion<=postion+1'b1;end
					else if(postion==2)begin p2<=2; postion<=postion+1'b1;end
					else p3<=2;postion<=postion+1'b1;end
				end
            else if(col==4'b1101)begin
					if(postion==0)begin p0<=3; postion<=postion+1'b1;end
					else if(postion==1)begin p1<=3; postion<=postion+1'b1;end
					else if(postion==2)begin p2<=3; postion<=postion+1'b1;end
					else p3<=3;postion<=postion+1'b1;end
				end
        end
     STATE1:
        begin
            if(col==4'b1110)begin
					if(postion==0)begin p0<=4; postion<=postion+1'b1;end
					else if(postion==1)begin p1<=4; postion<=postion+1'b1;end
					else if(postion==2)begin p2<=4; postion<=postion+1'b1;end
					else p3<=4;postion<=postion+1'b1;end
				end
            else if(col==4'b1101)begin
					if(postion==0)begin p0<=5; postion<=postion+1'b1;end
					else if(postion==1)begin p1<=5; postion<=postion+1'b1;end
					else if(postion==2)begin p2<=5; postion<=postion+1'b1;end
					else p3<=5;postion<=postion+1'b1;end
				end
            else if(col==4'b1101)begin
					if(postion==0)begin p0<=6; postion<=postion+1'b1;end
					else if(postion==1)begin p1<=6; postion<=postion+1'b1;end
					else if(postion==2)begin p2<=6; postion<=postion+1'b1;end
					else p3<=6;postion<=postion+1'b1;end
				end
            else if(col==4'b1101)begin
					if(postion==0)begin p0<=7; postion<=postion+1'b1;end
					else if(postion==1)begin p1<=7; postion<=postion+1'b1;end
					else if(postion==2)begin p2<=7; postion<=postion+1'b1;end
					else p3<=7;postion<=postion+1'b1;end
				end
        end
     STATE2:
        begin
            if(col==4'b1110)begin
					if(postion==0)begin p0<=8; postion<=postion+1'b1;end
					else if(postion==1)begin p1<=8; postion<=postion+1'b1;end
					else if(postion==2)begin p2<=8; postion<=postion+1'b1;end
					else p3<=8;postion<=postion+1'b1;end
				end
            else if(col==4'b1101)begin
					if(postion==0)begin p0<=9; postion<=postion+1'b1;end
					else if(postion==1)begin p1<=9; postion<=postion+1'b1;end
					else if(postion==2)begin p2<=9; postion<=postion+1'b1;end
					else p3<=9;postion<=postion+1'b1;end
				end
            else if(col==4'b1101)begin
					if(postion==0)begin p0<=10; postion<=postion+1'b1;end
					else if(postion==1)begin p1<=10; postion<=postion+1'b1;end
					else if(postion==2)begin p2<=10; postion<=postion+1'b1;end
					else p3<=10;postion<=postion+1'b1;end
				end
            else if(col==4'b1101)begin
					if(postion==0)begin p0<=11; postion<=postion+1'b1;end
					else if(postion==1)begin p1<=11; postion<=postion+1'b1;end
					else if(postion==2)begin p2<=11; postion<=postion+1'b1;end
					else p3<=11;postion<=postion+1'b1;end
				end
        end
     STATE3:
        begin
            if(col==4'b1110)begin
					if(postion==0)begin p0<=12; postion<=postion+1'b1;end
					else if(postion==1)begin p1<=12; postion<=postion+1'b1;end
					else if(postion==2)begin p2<=12; postion<=postion+1'b1;end
					else p3<=12;postion<=postion+1'b1;end
				end
            else if(col==4'b1101)begin
					if(postion==0)begin p0<=13; postion<=postion+1'b1;end
					else if(postion==1)begin p1<=13; postion<=postion+1'b1;end
					else if(postion==2)begin p2<=13; postion<=postion+1'b1;end
					else p3<=13;postion<=postion+1'b1;end
				end
				else if(col==4'b1101)begin
					if(postion==0)begin p0<=14; postion<=postion+1'b1;end
					else if(postion==1)begin p1<=14; postion<=postion+1'b1;end
					else if(postion==2)begin p2<=14; postion<=postion+1'b1;end
					else p3<=14;postion<=postion+1'b1;end
				end
				else if(col==4'b1101)begin
					if(postion==0)begin p0<=15; postion<=postion+1'b1;end
					else if(postion==1)begin p1<=15; postion<=postion+1'b1;end
					else if(postion==2)begin p2<=15; postion<=postion+1'b1;end
					else p3<=15;postion<=postion+1'b1;end
				end
        end
     default:begin
			if(postion==0)begin p0<=0; postion<=postion+1'b1;end
			else if(postion==1)begin p1<=0; postion<=postion+1'b1;end
			else if(postion==2)begin p2<=0; postion<=postion+1'b1;end
			else p3<=0;postion<=postion+1'b1;end
	  end
  endcase
 end
endmodule
*/
