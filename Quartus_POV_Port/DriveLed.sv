module DriveLed(
input clk, //input clock 
input reg [23:0]colourReg,
output leds,
output int position

);

	reg [31:0] ledsIndex = 0;
	reg [31:0] clkCount = 0;
	reg [31:0] verticlePixles = 56;
	reg [2:0] reset = 0;
	reg [31:0] zeroLow = 34;
	reg [31:0] oneLow = 89;
	reg [31:0] Period = 125;
	
	always @ ( posedge clk)
	begin       
		
			if (position == 24)
			begin
					position = 0;
					ledsIndex = ledsIndex + 1;
					leds = 0;
					clkCount = 0;
					
					if (ledsIndex == verticlePixles )
					 begin  
						 reset = 1;
						 leds = 0;
						 ledsIndex = 0;
						 clkCount = 0;
					 end    
											  
			end
			if( reset == 0 )
			begin
					 if (colourReg[position] == 0)
					 begin
							if (clkCount < zeroLow)
							begin
								 leds = 1;
							end
							if (clkCount == zeroLow)
							begin
								 leds = 0;
							end                                     
					 end 
					 if (colourReg[position] == 1)
					 begin
						  if (clkCount < oneLow)
						  begin
								leds = 1;
						  end
						  if (clkCount == oneLow)
						  begin
								leds = 0;
						  end                                     
					 end 
					  if( clkCount == Period )
						  begin
								position = position + 1;
								clkCount = 0;                                         
								leds = 0;                                          
						  end 
					 
			end
			if (reset == 1) 
			begin
			leds = 0;
				 if(clkCount >= 5900) 
				 begin
					  reset = 0;
					  clkCount = 0;
					  ledsIndex = 0;
				  end 
			end   
			clkCount = clkCount + 1;  
				 
	  end 


endmodule // UART_RX