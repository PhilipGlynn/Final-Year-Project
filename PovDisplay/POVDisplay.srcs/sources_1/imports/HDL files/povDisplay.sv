module povDisplay (input clk, input wire hallSensor, input RxD, input RESET, output reg leds, output reg[7:0]led); //50Mhz CLK
                    reg [31:0] verticlePixles = 55;
                    reg [31:0] horizontalPixles = 18;
                    reg [31:0] zeroLow = 34;
                    reg [31:0] oneLow = 89;
                    reg [31:0] Period = 125;
                    reg [31:0] ledsIndex = 0;
					reg [31:0] clkCount = 0;
					reg [31:0] clkCount2 = 0;
                    reg [31:0] clkCount3 = 0;	
					//reg [31:0] leds = 0;
					reg [23:0] colourReg ;
					reg [23:0] ledsColour [54:0];
                    reg [2:0] reset = 0;
                    reg rpsToggle = 0;
                    reg [31:0] firstRead = 0;
                    reg checkPin = 0;
                    int colourPos = 0;
                    int position = 0;
					//green red blue 
                    reg [23:0] rgb [19:0];
                    assign rgb[0] = 24'hFF0000;
                    assign rgb[1] = 24'h00FF00;
                    assign rgb[2] = 24'h0000FF;
                    assign rgb[3] = 24'hFF0000;
                    assign rgb[4] = 24'h00FF00;
                    assign rgb[5] = 24'h0000FF;
                    assign rgb[6] = 24'hFF0000;
                    assign rgb[7] = 24'h00FF00;
                    assign rgb[8] = 24'h0000FF;
                    assign rgb[9] = 24'hFF0000;
                    assign rgb[10] = 24'h00FF00;
                    assign rgb[11] = 24'h0000FF;
                    assign rgb[12] = 24'hFF0000;
                    assign rgb[13] = 24'h00FF00;
                    assign rgb[14] = 24'h0000FF;
                    assign rgb[15] = 24'hFF0000;
                    assign rgb[16] = 24'h00FF00;
                    assign rgb[17] = 24'h0000FF;
                    
                    int rotationTime = 3640000;
                    
                    //input clk, //input clock
                    //input reset, //input reset 
                    //input RxD, //input receving data line
                    //output [7:0]RxData // output for 8 bits data
                    // output [7:0]LED // output 8 LEDs
                    
                    UART_RX( 
                        .clk(clk),
                        .reset(RESET),
                        .RxD(RxD),
                        .RxData(led)
                        );
			         
			        
                     
                    always @ ( posedge clk)
                    begin
                            //colourReg <=  ledsColour[ledsIndex];
                            
                            if ( hallSensor == 0 && clkCount3 == 0)
                               begin 
                                    
                                     if (rpsToggle == 0)
                                      begin
                                           firstRead = clkCount3;
                                           rpsToggle = 1;
                                      end 
                                      else
                                      begin
                                           rotationTime = clkCount3 - firstRead;
                                           rotationTime = rotationTime / horizontalPixles;
                                           firstRead = 0;
                                           clkCount3 = 0;
                                           rpsToggle = 0;
                                      end  
                                      checkPin = 1; 
                                end  
                                else if ( hallSensor == 1 &&  checkPin == 1)
                                begin
                                    checkPin = 0;
                                end   
                            
                            clkCount2 = clkCount2 + 1;
                            clkCount3 = clkCount3 + 1;
                            
                            if (position == 24)
                            begin
                                  position = 0;
                                  ledsIndex = ledsIndex + 1;
                                  leds = 0;
                                  clkCount = 0;
                                  if (clkCount2 >= rotationTime / horizontalPixles)
                                  begin
                                      colourReg <=  rgb[colourPos];
                                      colourPos = colourPos + 1;
                                      if (colourPos == horizontalPixles)
                                      begin
                                          colourPos = 0;
                                      end  
                                      clkCount2 = 0;  
                                  end
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
                    
                    
                     
endmodule		