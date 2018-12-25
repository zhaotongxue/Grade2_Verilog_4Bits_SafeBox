module Scan_Password(
  input            clk,
  input            rst,
  input            rst1,
  input            rst2,
  input            rst3,
  input            rst4,
  input      [3:0] row,                 // 矩阵键盘 行
  output reg [3:0] col,                 // 矩阵键盘 列
  output reg [4:0] p1,         			// 键盘值     
  output reg [4:0] p2,
  output reg [4:0] p3,
  output reg [4:0] p0,
  output reg [4:0] p4,
  output reg [4:0] p5
);

reg [4:0] keyboard_val;
reg [2:0] pos;
reg [19:0] cnt;                       // 计数子
reg key_clk;
 
reg [5:0] current_state, next_state;    // 现态、次态
parameter NO_KEY_PRESSED = 6'b000_001;  // 没有按键按下  
parameter SCAN_COL0      = 6'b000_010;  // 扫描第0列 
parameter SCAN_COL1      = 6'b000_100;  // 扫描第1列 
parameter SCAN_COL2      = 6'b001_000;  // 扫描第2列 
parameter SCAN_COL3      = 6'b010_000;  // 扫描第3列 
parameter KEY_PRESSED    = 6'b100_000;  // 有按键按下

initial begin
	keyboard_val=16;
	pos=0;
	cnt=0;
	key_clk=0;
	p0=16;
	p1=16;
	p2=16;
	p3=16;
	p4=16;
	p5=16;
	current_state<=NO_KEY_PRESSED;
	next_state<=NO_KEY_PRESSED;
end

always @ (posedge clk, posedge rst,posedge rst1,posedge rst2,posedge rst3,posedge rst4)begin
  if (rst|rst1|rst2|rst3|rst4) begin cnt <= 0; end // (2^20/50M = 21)ms 
//  else if(rst1)begin cnt<=0;end
//  else if(rst2)begin cnt<=0;end
//  else if(rst3)begin cnt<=0;end
//  else if(rst4)begin cnt<=0;end
  else begin
	if(cnt==20'h7FFF) begin key_clk=~key_clk;cnt<=0;end 
	else  cnt <= cnt + 1'b1;  
	end
end

always @ (posedge key_clk, posedge rst,posedge rst1,posedge rst2,posedge rst3,posedge rst4)begin 
   if (rst|rst1|rst2|rst3|rst4)  begin  current_state <= NO_KEY_PRESSED;  end
//	else if (rst1)  begin  current_state <= NO_KEY_PRESSED;  end
//	else if (rst2)  begin  current_state <= NO_KEY_PRESSED;  end
//	else if (rst3)  begin  current_state <= NO_KEY_PRESSED;  end
//	else if (rst4)  begin  current_state <= NO_KEY_PRESSED;  end
   else begin current_state <= next_state;end
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
        if (row != 4'hF)begin next_state = KEY_PRESSED; end
        else begin next_state = NO_KEY_PRESSED; end
  endcase
end

reg       key_pressed_flag;             // 键盘按下标志
reg [3:0] col_val, row_val;             // 列值、行值

// 根据次态，给相应寄存器赋值
always @ (posedge key_clk, posedge rst,posedge rst1,posedge rst2,posedge rst3,posedge rst4)
  if (rst|rst1|rst2|rst3|rst4)begin col<= 4'b0000;key_pressed_flag <=0;end
//  else if(rst1)begin col<= 4'b0000;key_pressed_flag <=0;end
//  else if(rst2)begin col<= 4'b0000;key_pressed_flag <=0;end
//  else if(rst3)begin col<= 4'b0000;key_pressed_flag <=0;end
//  else if(rst4)begin col<= 4'b0000;key_pressed_flag <=0;end
  else case (next_state)
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
 
always @(negedge key_pressed_flag,posedge rst,posedge rst1,posedge rst2,posedge rst3,posedge rst4)begin
	if(rst|rst1|rst2|rst3|rst4) pos<=0;
//	else if(rst1) pos<=0;
//	else if(rst2) pos<=0;
//	else if(rst3) pos<=0;
//	else if(rst4) pos<=0;
	else begin pos<=(pos+1'b1)%6;end 
	$display("%d %d %d %d",p0,p1,p2,p3);
end

always @ (posedge key_clk,posedge rst,posedge rst1,posedge rst2,posedge rst3,posedge rst4)
  if (rst|rst1|rst2|rst3|rst4)begin keyboard_val<= 16;p0<=16;p1<=16;p2<=16;p3<=16;p4<=16;p5<=16;end
//  else if (rst1)begin keyboard_val<= 16;p0<=16;p1<=16;p2<=16;p3<=16;p4<=16;p5<=16;end
//  else if (rst2)begin keyboard_val<= 16;p0<=16;p1<=16;p2<=16;p3<=16;p4<=16;p5<=16;end
//  else if (rst3)begin keyboard_val<= 16;p0<=16;p1<=16;p2<=16;p3<=16;p4<=16;p5<=16;end
//  else if (rst4)begin keyboard_val<= 16;p0<=16;p1<=16;p2<=16;p3<=16;p4<=16;p5<=16;end
  else if (key_pressed_flag)
	case ({col_val, row_val})
	  8'b1110_1110 : begin
	  keyboard_val <= 4'h0;
	  if(pos==0) p0<=keyboard_val;
	  else if(pos==1)p1<=keyboard_val;
	  else if(pos==2)p2<=keyboard_val;
	  else if(pos==3)p3<=keyboard_val;
	  else if(pos==4)p4<=keyboard_val;
	  else if(pos==5)p5<=keyboard_val;
	  $display("p%d:%d",pos,keyboard_val);
	  end
	  8'b1110_1101 : begin
	  keyboard_val <= 4'h4;
	  if(pos==0) p0<=keyboard_val;
	  else if(pos==1)p1<=keyboard_val;
	  else if(pos==2)p2<=keyboard_val;
	  else if(pos==3)p3<=keyboard_val;
	  else if(pos==4)p4<=keyboard_val;
	  else if(pos==5)p5<=keyboard_val;
	  $display("p%d:%d",pos,keyboard_val);
	  end
	  8'b1110_1011 : begin
	  keyboard_val <= 4'h8;
	  if(pos==0) p0<=keyboard_val;
	  else if(pos==1)p1<=keyboard_val;
	  else if(pos==2)p2<=keyboard_val;
	  else if(pos==3)p3<=keyboard_val;
	  else if(pos==4)p4<=keyboard_val;
	  else if(pos==5)p5<=keyboard_val;
	  $display("p%d:%d",pos,keyboard_val);
	  end
	  8'b1110_0111 : begin
	  keyboard_val <= 4'hC;
	  if(pos==0) p0<=keyboard_val;
	  else if(pos==1)p1<=keyboard_val;
	  else if(pos==2)p2<=keyboard_val;
	  else if(pos==3)p3<=keyboard_val;
	  else if(pos==4)p4<=keyboard_val;
	  else if(pos==5)p5<=keyboard_val;
	  $display("p%d:%d",pos,keyboard_val);
	  end
		
	  8'b1101_1110 : begin
	  keyboard_val <= 4'h1;
	  if(pos==0) p0<=keyboard_val;
	  else if(pos==1)p1<=keyboard_val;
	  else if(pos==2)p2<=keyboard_val;
	  else if(pos==3)p3<=keyboard_val;
	  else if(pos==4)p4<=keyboard_val;
	  else if(pos==5)p5<=keyboard_val;
	  $display("p%d:%d",pos,keyboard_val);
	  end
	  8'b1101_1101 : begin
	  keyboard_val <= 4'h5;
	  if(pos==0) p0<=keyboard_val;
	  else if(pos==1)p1<=keyboard_val;
	  else if(pos==2)p2<=keyboard_val;
	  else if(pos==3)p3<=keyboard_val;
	  else if(pos==4)p4<=keyboard_val;
	  else if(pos==5)p5<=keyboard_val;
	  $display("p%d:%d",pos,keyboard_val);
	  end
	  8'b1101_1011 : begin
	  keyboard_val <= 4'h9;
	  if(pos==0) p0<=keyboard_val;
	  else if(pos==1)p1<=keyboard_val;
	  else if(pos==2)p2<=keyboard_val;
	  else if(pos==3)p3<=keyboard_val;
	  else if(pos==4)p4<=keyboard_val;
	  else if(pos==5)p5<=keyboard_val;
	  $display("p%d:%d",pos,keyboard_val);
	  end
	  8'b1101_0111 : begin
	  keyboard_val <= 4'hD;
	  if(pos==0) p0<=keyboard_val;
	  else if(pos==1)p1<=keyboard_val;
	  else if(pos==2)p2<=keyboard_val;
	  else if(pos==3)p3<=keyboard_val;
	  else if(pos==4)p4<=keyboard_val;
	  else if(pos==5)p5<=keyboard_val;
	  $display("p%d:%d",pos,keyboard_val);
	  end
		
	  8'b1011_1110 : begin
	  keyboard_val <= 4'h2;
	  if(pos==0) p0<=keyboard_val;
	  else if(pos==1)p1<=keyboard_val;
	  else if(pos==2)p2<=keyboard_val;
	  else if(pos==3)p3<=keyboard_val;
	  else if(pos==4)p4<=keyboard_val;
	  else if(pos==5)p5<=keyboard_val;
	  $display("p%d:%d",pos,keyboard_val);
	  end
	  8'b1011_1101 : begin
	  keyboard_val <= 4'h6;
	  if(pos==0) p0<=keyboard_val;
	  else if(pos==1)p1<=keyboard_val;
	  else if(pos==2)p2<=keyboard_val;
	  else if(pos==3)p3<=keyboard_val;
	  else if(pos==4)p4<=keyboard_val;
	  else if(pos==5)p5<=keyboard_val;
	  $display("p%d:%d",pos,keyboard_val);
	  end
	  8'b1011_1011 : begin
	  keyboard_val <= 4'hA;
	  if(pos==0) p0<=keyboard_val;
	  else if(pos==1)p1<=keyboard_val;
	  else if(pos==2)p2<=keyboard_val;
	  else if(pos==3)p3<=keyboard_val;
	  else if(pos==4)p4<=keyboard_val;
	  else if(pos==5)p5<=keyboard_val;
	  $display("p%d:%d",pos,keyboard_val);
	  end
	  8'b1011_0111 : begin
	  keyboard_val <= 4'hE;
	  if(pos==0) p0<=keyboard_val;
	  else if(pos==1)p1<=keyboard_val;
	  else if(pos==2)p2<=keyboard_val;
	  else if(pos==3)p3<=keyboard_val;
	  else if(pos==4)p4<=keyboard_val;
	  else if(pos==5)p5<=keyboard_val;
	  $display("p%d:%d",pos,keyboard_val);
	  end
		
	  8'b0111_1110 : begin
	  keyboard_val <= 4'h3;
	  if(pos==0) p0<=keyboard_val;
	  else if(pos==1)p1<=keyboard_val;
	  else if(pos==2)p2<=keyboard_val;
	  else if(pos==3)p3<=keyboard_val;
	  else if(pos==4)p4<=keyboard_val;
	  else if(pos==5)p5<=keyboard_val;
	  $display("p%d:%d",pos,keyboard_val);
	  end
	  8'b0111_1101 : begin
	  keyboard_val <= 4'h7;
	  if(pos==0) p0<=keyboard_val;
	  else if(pos==1)p1<=keyboard_val;
	  else if(pos==2)p2<=keyboard_val;
	  else if(pos==3)p3<=keyboard_val; 
	  else if(pos==4)p4<=keyboard_val;
	  else if(pos==5)p5<=keyboard_val;
	  $display("p%d:%d",pos,keyboard_val);
	  end
	  8'b0111_1011 : begin
	  keyboard_val <= 4'hB;
	  if(pos==0) p0<=keyboard_val;
	  else if(pos==1)p1<=keyboard_val;
	  else if(pos==2)p2<=keyboard_val;
	  else if(pos==3)p3<=keyboard_val;
	  else if(pos==4)p4<=keyboard_val;
	  else if(pos==5)p5<=keyboard_val;
	  $display("p%d:%d",pos,keyboard_val);
	  end
	  8'b0111_0111 : begin
	  keyboard_val <= 4'hF;
	  if(pos==0) p0<=keyboard_val;
	  else if(pos==1)p1<=keyboard_val;
	  else if(pos==2)p2<=keyboard_val;
	  else if(pos==3)p3<=keyboard_val;
	  else if(pos==4)p4<=keyboard_val;
	  else if(pos==5)p5<=keyboard_val;
	  $display("p%d:%d",pos,keyboard_val);
	  end
	endcase
endmodule
