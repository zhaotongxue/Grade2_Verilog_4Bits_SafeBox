module Controller(
	input clk,//50MHz
	input key_open_close,//BTN 7,开关键
	input key_reset_password,//BTN 1 设置新密码，开锁后按下设置新密码
	input key_clean_password,//BTN 6 清除密码键
	input key_confirm_new_password,//BTN 0 确定新密码
	input  [3:0] row,//4 rows 从row接收
	output [3:0] col,//4 columns	从column发送
	output [7:0] disps,//用到了四个七段数字管
	output [7:0] digital_leds,//每个数字管8个部分
	output alarm_led,//警示LED
	output alarm_buzzer,//蜂鸣器
	output  [7:0] col_r,
	output  [7:0] col_g,
	output  [7:0] row_color,
	output reg test_led,
	output reg test_led1,
	output reg test_led2,
	output reg test_led3
);
wire open_close;
wire reset_password;
wire clean_password;
wire confirm_new_password;
reg [3:0] cp1;//当前密码，默认4'h0000
reg [3:0] cp2;
reg [3:0] cp3;
reg [3:0] cp0;
reg state=1'b0;//显示密码或者‘-’
reg Graph_type=1'b0;//图形类型，开锁或者关锁
reg opened=1'b0;//是否已开门
reg alarm=1'b0;//是否报警
wire [4:0] p1;//输入的密码
wire [4:0] p2;
wire [4:0] p3;
wire [4:0] p0;
reg [15:0] cnt;
reg clk_div;
reg clean_after_confirm;//是否有什么键按下,从而清除输入
reg clean_after_open;
reg clean_after_close;
reg clean_after_reset;
reg clean_after_clean;
reg clean_after_error;

wire clean;
initial begin
	clean_after_confirm=0;
	clean_after_open=0;
	clean_after_close=0;
	clean_after_reset=0;
	clean_after_clean=0;
	clean_after_error=0;
	cp1=4'h0;
	cp2=4'h0;
	cp3=4'h0;
	cp0=4'h0;
	state=1'b0;
	cnt=0;
	clk_div=0;
	test_led=0;
	test_led1=0;
	test_led2=0;
	test_led3=0;
	$display("Controller started");
end

always@(posedge clk)begin
	if(cnt==0) clk_div<=~clk_div;
	else cnt<=1'b1+cnt;
end

debounce clean_password_debounce(.clk(clk),.key(key_clean_password),.key_pulse(clean_password));
debounce confirm_new_password_debounce(.clk(clk),.key(key_confirm_new_password),.key_pulse(confirm_new_password));
debounce reset_password_debounce(.clk(clk),.key(key_reset_password),.key_pulse(reset_password));
debounce open_close_debounce(.clk(clk),.key(key_open_close),.key_pulse(open_close));

always @(posedge clk)begin
if(!opened)begin
	if(open_close)begin//pressed open key
		$display("Pressed OPEN_CLOSE key");
		if((p1==cp1)&(p2==cp2)&(p3==cp3)&(p0==cp0)&(!alarm))begin
			opened<=1'b1;//已经开锁
			Graph_type<=1'b1;//显示开锁图形
			alarm<=1'b0;//不报警
			$display("open the door successful");
			clean_after_open<=1;
//			#20 clean_after_open<=0;
		end else begin
			alarm<=~alarm;
			Graph_type<=1'b0;
			opened<=0;
			clean_after_close<=~clean_after_close;
			#20 clean_after_close<=~clean_after_close;

			
//			#20 clean_after_close<=1;
////			#20 clean_after_close<=0;
//	#20 clean_after_close<=1;
//	#500 clean_after_close<=0;
//			if(clean_after_close) clean_after_close<=0;
//			 clean_after_close<=1;
			$display("open the door fail");
		end
	
	
end end else begin
if(open_close)begin//关锁
	$display("The clock is clocked");
	state<=1'b0;
	Graph_type<=1'b0;
	opened<=1'b0;
	alarm<=1'b0;
	clean_after_confirm=0;
	clean_after_open<=0;
	#20 clean_after_close<=0;
	#20 clean_after_close<=1;
	#20 clean_after_close<=0;
	clean_after_reset<=0;
	clean_after_clean<=0;
end if(reset_password)begin
	$display("Pressed RESET PASSWORD key");
	state<=1'b1;//这个时候应该显示密码
	clean_after_open<=0;
	clean_after_reset<=0;
	#10 clean_after_reset<=1;//关机，确认，重设
	#20 clean_after_reset<=0;
	clean_after_clean<=0;
	clean_after_confirm<=0;
end if(confirm_new_password)begin
$display("Pressed CONFIRM NEW PASSWORD key");
if(state)begin//如果密码显示着
	cp1<=p1;
	cp2<=p2;
	cp3<=p3;
	cp0<=p0;
	state<=1'b0;
end
clean_after_confirm<=1;//下一步关机，或者重设，或者清零
clean_after_reset<=0;
clean_after_clean<=0;
end
if(clean_password)begin
$display("Pressed CLEAN PASSWORD key");
	state<=1'b0;
	cp1<=4'h0;
	cp2<=4'h0;
	cp3<=4'h0;
	cp0<=4'h0;
	clean_after_open<=0;
	clean_after_clean<=1;//下一步 关机，重设，
	clean_after_confirm<=0;
	clean_after_reset<=0;
end end end 

Show_Graph show_graph(
.clk(clk),
.state(Graph_type),
.col_r(col_r),
.col_g(col_g),
.row(row_color));

Alarm alarmer(
.clk(clk),
.alarm(alarm),
.led(alarm_led),
.buzzer(alarm_buzzer));

Scan_Password scan_password(
.clk(clk),
.rst(clean_after_close),
.rst1(clean_after_open),
.rst2(clean_after_reset),
.rst3(clean_after_confirm),
.rst4(clean_after_clean),
//.rst5(clean_after_error),
.row(row),
.col(col),
.p0(p0),
.p1(p1),
.p2(p2),
.p3(p3));

Show_Password show_password(
.clk(clk),
.state(state),		
.p0(p0),
.p1(p1),
.p2(p2),
.p3(p3),
.disps(disps),
.digital_leds(digital_leds));

endmodule

		