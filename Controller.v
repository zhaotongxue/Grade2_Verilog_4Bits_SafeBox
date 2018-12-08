module Controller(
	input clk,//50MHz
	input key_open_close,//BTN 7,开关键
	input key_reset_password,//BTN 1 设置新密码，开锁后按下设置新密码
	input key_clean_password,//BTN 6 清除密码键
	input key_confirm_new_password,//BTN 0 确定新密码
	input  [3:0] row,//4 rows 从row接收
	output [3:0] col,//4 columns	从column发送
	output [3:0] disps,//用到了四个七段数字管
	output [7:0] digital_leds,//每个数字管8个部分
	output alarm_led,//警示LED
	output alarm_buzzer//蜂鸣器
);
	wire open_close,reset_password,clean_password,confirm_new_password;
	
	reg [3:0] cp1;//当前密码，默认4'h0000
	reg [3:0] cp2;
	reg [3:0] cp3;
	reg [3:0] cp0;
	reg state=1'b0;//显示密码或者‘-’
	reg Graph_type=1'b0;//图形类型，开锁或者关锁
	reg opened=1'b0;//是否已开门
	reg alarm=1'b0;//是否报警
	wire [3:0] p1;//输入的密码
	wire [3:0] p2;
	wire [3:0] p3;
	wire [3:0] p0;
	reg clean_input;//是否有什么键按下,从而清除输入

initial begin
	$display("in controller");
	cp1=4'h0;
	cp2=4'h0;
	cp3=4'h0;
	cp0=4'h0;
	state=1'b0;
	clean_input=1'b0;
	$display("Controller started");
end
	always @(posedge clk)begin
			if(!opened)begin//锁着的情况下
				if(open_close)begin//pressed open key
					clean_input=~clean_input;
    				if((p1==cp1)&(p2==cp2)&(p3==cp3)&(p0==cp0))begin
                     state=1'b0;//显示‘-’
							opened=1'b1;//已经开锁
							Graph_type=1'b1;//显示开锁图形
							alarm=1'b0;//不报警
					end else begin
                  state=1'b0;
						alarm=1'b1;
						Graph_type=1'b0;
			end end end else	begin
			if(open_close)begin//关锁
				state=1'b0;
				Graph_type=1'b0;
				opened=1'b0;
				alarm=1'b0;
				clean_input=~clean_input;
			end if(reset_password)begin
				state=1'b1;//这个时候应该显示密码
				clean_input=~clean_input;
			end if(confirm_new_password)begin
		   if(state)begin//如果密码显示着
				cp1=p1;
				cp2=p2;
				cp3=p3;
				cp0=p0;
				state=1'b0;
				clean_input=~clean_input;
		  end else begin 
				clean_input=~clean_input;
		  end if(clean_password)begin
				state=1'b0;
				cp1=4'h0;
				cp2=4'h0;
				cp3=4'h0;
				cp0=4'h0;
			end end end end
		Show_Graph show_graph(
			.clk(clk),
			.state(opened));
		Alarm alarmer(
			.clk(clk),
			.alarm(alarm),
			.led(alarm_led),
			.buzzer(alarm_buzzer));
		Scan_Password scan_password(
			.clk(clk),
			.rst(clean_input),
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
		debounce d1(
		.clk(clk),
		.rst(reset),
		.key(key_clean_password),
		.key_pulse(clean_password));
		debounce d2(
		.clk(clk),
		.rst(reset),
		.key(key_confirm_new_password),
		.key_pulse(confirm_new_password));
		debounce d3(
		.clk(clk),
		.rst(reset),
		.key(key_open_close),
		.key_pulse(open_close));
		debounce d4(
		.clk(clk),
		.rst(reset),
		.key(key_reset_password),
		.key_pulse(reset_password));
		
endmodule

		