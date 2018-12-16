module debounce (clk,key,key_pulse);
parameter       	N  =  1;                      
input             clk;
input    			key;                        		
output     			key_pulse;                   
reg     			   key_rst_pre;                
reg     			   key_rst;                    
wire    			   key_edge;                 

always @(posedge clk)begin
  key_rst <= key;                     
  key_rst_pre <= key_rst;              
end
assign  key_edge = key_rst_pre & (~key_rst);
reg	[17:0]	  cnt;                        
always @(posedge clk)begin
		if(key_edge)cnt <= 18'h0;
		else cnt <= cnt + 1'h1;
end  
reg  key_sec_pre;                
reg  key_sec;                    
always @(posedge clk)if (cnt==18'h3ffff) key_sec <= key;  
always @(posedge clk)key_sec_pre <= key_sec;                 
assign  key_pulse = key_sec_pre & (~key_sec);    


endmodule
