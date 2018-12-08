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
reg [1:0] pos=0;
reg [19:0] cnt;                         // 计数子
always @ (posedge clk, posedge rst)
  if (rst)  cnt <= 0;
  else  cnt <= cnt + 1'b1;
wire key_clk = cnt[19];                // (2^20/50M = 21)ms 

initial begin
	$display("In scan_Password");
end

parameter NO_KEY_PRESSED = 6'b000_001;  // 没有按键按下  
parameter SCAN_COL0      = 6'b000_010;  // 扫描第0列 
parameter SCAN_COL1      = 6'b000_100;  // 扫描第1列 
parameter SCAN_COL2      = 6'b001_000;  // 扫描第2列 
parameter SCAN_COL3      = 6'b010_000;  // 扫描第3列 
parameter KEY_PRESSED    = 6'b100_000;  // 有按键按下
 
reg [5:0] current_state, next_state;    // 现态、次态
 
always @ (posedge key_clk, posedge rst)
  if (rst)  current_state <= NO_KEY_PRESSED;
  else  current_state <= next_state;
 
// 根据条件转移状态
always @ *
  case (current_state)
    NO_KEY_PRESSED:                    // 没有按键按下
        if (row != 4'hF) begin next_state = SCAN_COL0; $display("No Press");end
        else begin next_state = NO_KEY_PRESSED;$display("Press");end
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
        if (row != 4'hF) next_state = KEY_PRESSED;
        else next_state = NO_KEY_PRESSED;                      
  endcase
 
	reg       key_pressed_flag;             // 键盘按下标志
	reg [3:0] col_val, row_val;             // 列值、行值
 
// 根据次态，给相应寄存器赋值
always @ (posedge key_clk, posedge rst)
  if (rst)begin
    col              <= 4'h0;
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
 
 
//++++++++++++++++++++++++++++++++++++++
// 扫描行列值部分 开始
//++++++++++++++++++++++++++++++++++++++
always @ (posedge key_clk, negedge rst)
  if (!rst) keyboard_val <= 4'h0;
  else if (key_pressed_flag)
	case ({col_val, row_val})
	  8'b1110_1110 : begin  keyboard_val <= 4'h0;if(pos==0) p0<=keyboard_val;else if(pos==1)p1<=keyboard_val;else if(pos==2)p2<=keyboard_val;else if(pos==3)p3<=keyboard_val; pos<=pos+1'b1;end
	  8'b1110_1101 : begin  keyboard_val <= 4'h4;if(pos==0) p0<=keyboard_val;else if(pos==1)p1<=keyboard_val;else if(pos==2)p2<=keyboard_val;else if(pos==3)p3<=keyboard_val; pos<=pos+1'b1;end
	  8'b1110_1011 : begin  keyboard_val <= 4'h8;if(pos==0) p0<=keyboard_val;else if(pos==1)p1<=keyboard_val;else if(pos==2)p2<=keyboard_val;else if(pos==3)p3<=keyboard_val; pos<=pos+1'b1;end
	  8'b1110_0111 : begin  keyboard_val <= 4'hC;if(pos==0) p0<=keyboard_val;else if(pos==1)p1<=keyboard_val;else if(pos==2)p2<=keyboard_val;else if(pos==3)p3<=keyboard_val; pos<=pos+1'b1;end
		
	  8'b1101_1110 : begin  keyboard_val <= 4'h1;if(pos==0) p0<=keyboard_val;else if(pos==1)p1<=keyboard_val;else if(pos==2)p2<=keyboard_val;else if(pos==3)p3<=keyboard_val; pos<=pos+1'b1;end
	  8'b1101_1101 : begin  keyboard_val <= 4'h5;if(pos==0) p0<=keyboard_val;else if(pos==1)p1<=keyboard_val;else if(pos==2)p2<=keyboard_val;else if(pos==3)p3<=keyboard_val; pos<=pos+1'b1;end
	  8'b1101_1011 : begin  keyboard_val <= 4'h9;if(pos==0) p0<=keyboard_val;else if(pos==1)p1<=keyboard_val;else if(pos==2)p2<=keyboard_val;else if(pos==3)p3<=keyboard_val; pos<=pos+1'b1;end
	  8'b1101_0111 : begin  keyboard_val <= 4'hD;if(pos==0) p0<=keyboard_val;else if(pos==1)p1<=keyboard_val;else if(pos==2)p2<=keyboard_val;else if(pos==3)p3<=keyboard_val; pos<=pos+1'b1;end
		
	  8'b1011_1110 : begin  keyboard_val <= 4'h2;if(pos==0) p0<=keyboard_val;else if(pos==1)p1<=keyboard_val;else if(pos==2)p2<=keyboard_val;else if(pos==3)p3<=keyboard_val; pos<=pos+1'b1;end
	  8'b1011_1101 : begin  keyboard_val <= 4'h6;if(pos==0) p0<=keyboard_val;else if(pos==1)p1<=keyboard_val;else if(pos==2)p2<=keyboard_val;else if(pos==3)p3<=keyboard_val; pos<=pos+1'b1;end
	  8'b1011_1011 : begin  keyboard_val <= 4'hA;if(pos==0) p0<=keyboard_val;else if(pos==1)p1<=keyboard_val;else if(pos==2)p2<=keyboard_val;else if(pos==3)p3<=keyboard_val; pos<=pos+1'b1;end
	  8'b1011_0111 : begin  keyboard_val <= 4'hE;if(pos==0) p0<=keyboard_val;else if(pos==1)p1<=keyboard_val;else if(pos==2)p2<=keyboard_val;else if(pos==3)p3<=keyboard_val; pos<=pos+1'b1;end
		
	  8'b0111_1110 : begin  keyboard_val <= 4'h3;if(pos==0) p0<=keyboard_val;else if(pos==1)p1<=keyboard_val;else if(pos==2)p2<=keyboard_val;else if(pos==3)p3<=keyboard_val; pos<=pos+1'b1;end
	  8'b0111_1101 : begin  keyboard_val <= 4'h7;if(pos==0) p0<=keyboard_val;else if(pos==1)p1<=keyboard_val;else if(pos==2)p2<=keyboard_val;else if(pos==3)p3<=keyboard_val; pos<=pos+1'b1;end
	  8'b0111_1011 : begin  keyboard_val <= 4'hB;if(pos==0) p0<=keyboard_val;else if(pos==1)p1<=keyboard_val;else if(pos==2)p2<=keyboard_val;else if(pos==3)p3<=keyboard_val; pos<=pos+1'b1;end
	  8'b0111_0111 : begin  keyboard_val <= 4'hF;if(pos==0) p0<=keyboard_val;else if(pos==1)p1<=keyboard_val;else if(pos==2)p2<=keyboard_val;else if(pos==3)p3<=keyboard_val; pos<=pos+1'b1;end
	endcase

endmodule
