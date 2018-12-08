module debounce (clk,rst,key,key_pulse);
   parameter       N  =  1;                      //要消除的按键的数量		
	input             clk;
   input             rst;
   input 	[N-1:0]   key;                        //输入的按键					
	output   [N-1:0]   key_pulse;                  //按键动作产生的脉冲		
	reg     	[N-1:0]   key_rst_pre;                //定义一个寄存器型变量存储上一个触发时的按键值
	reg     	[N-1:0]   key_rst;                    //定义一个寄存器变量储存储当前时刻触发的按键值
	wire    	[N-1:0]   key_edge;                   //检测到按键由高到低变化是产生一个高脉冲

	  //利用非阻塞赋值特点，将两个时钟触发时按键状态存储在两个寄存器变量中
        always @(posedge clk  or  posedge rst)begin
             if (rst) begin
                 key_rst <= {N{1'b0}};               
                 key_rst_pre <= {N{1'b0}};
             end else begin
                 key_rst <= key;
                 key_rst_pre <= key_rst;
             end    
           end
 
        assign  key_edge = (~key_rst_pre) & key_rst;
 
        reg	[23:0]	  cnt;                          
 
        //产生20ms延时，当检测到key_edge有效是计数器清零开始计数
        always @(posedge clk or posedge rst)
           begin
             if(rst)
                cnt <= 24'h0;
             else if(key_edge)
                cnt <= 24'h0;
             else
                cnt <= cnt + 1'h1;
             end  
 
        reg     [N-1:0]   key_sec_pre;               
        reg     [N-1:0]   key_sec;                    
 
 
        //延时后检测key
        always @(posedge clk  or  posedge rst)
          begin
             if (rst) 
                 key_sec <= {N{1'b0}};                
             else if (cnt==24'd10000000)
                 key_sec <= key;  
          end
       always @(posedge clk  or  posedge rst)
          begin
             if (rst)
                 key_sec_pre <= {N{1'b0}};
             else                   
                 key_sec_pre <= key_sec;             
         end      
       assign  key_pulse = (~key_sec_pre) & (key_sec);     
 
endmodule