module povDisplay (input clk, input wire hallSensor, output reg led); //50Mhz CLK
                    reg [31:0] verticlePixles = 55;
                    reg [31:0] horizontalPixles = 18;
                    reg [31:0] zeroLow = 34;
                    reg [31:0] oneLow = 89;
                    reg [31:0] Period = 125;
                    reg [31:0] ledIndex = 0;
					reg [31:0] clkCount = 0;
					reg [31:0] clkCount2 = 0;
                    reg [31:0] clkCount3 = 0;	
					//reg [31:0] led = 0;
					reg [23:0] colourReg ;
					reg [23:0] ledColour [54:0];
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
                    
                    
                    
					assign ledColour[0] =  24'h000000;
					assign ledColour[1] =  24'h00FF00;
					assign ledColour[2] =  24'h0000FF;
					assign ledColour[3] =  24'hFF0000;
					assign ledColour[4] =  24'h00FF00;
					assign ledColour[5] =  24'h0000FF;
					assign ledColour[6] =  24'hFF0000;
					assign ledColour[7] =  24'h00FF00;
					assign ledColour[8] =  24'h0000FF;
                    assign ledColour[9] =  24'hFF0000;
                    assign ledColour[10] = 24'h00FF00;
                    assign ledColour[11] = 24'h0000FF;
                    assign ledColour[12] = 24'hFF0000;
                    assign ledColour[13] = 24'h00FF00;  
                    assign ledColour[14] = 24'h0000FF;
                    assign ledColour[15] = 24'hFF0000;
                    assign ledColour[16] = 24'h00FF00;
                    assign ledColour[17] = 24'h0000FF;
                    assign ledColour[18] = 24'hFF0000;
                    assign ledColour[19] = 24'hFF0000;
                    assign ledColour[20] = 24'h00FF00;
                    assign ledColour[21] = 24'h00FF00;
                    assign ledColour[22] = 24'h0000FF;
                    assign ledColour[23] = 24'hFF0000;
                    assign ledColour[24] = 24'h00FF00;
                    assign ledColour[25] = 24'h0000FF;
                    assign ledColour[26] = 24'hFF0000;
                    assign ledColour[27] = 24'h00FF00;
                    assign ledColour[28] = 24'h0000FF;
                    assign ledColour[29] = 24'hFF0000;
                    assign ledColour[30] = 24'h00FF00;
                    assign ledColour[31] = 24'h00FF00;
                    assign ledColour[32] = 24'h0000FF;
                    assign ledColour[33] = 24'hFF0000;
                    assign ledColour[34] = 24'h00FF00;
                    assign ledColour[35] = 24'h0000FF;
                    assign ledColour[36] = 24'hFF0000;
                    assign ledColour[37] = 24'h00FF00;
                    assign ledColour[38] = 24'h0000FF;
                    assign ledColour[39] = 24'hFF0000;
                    assign ledColour[40] = 24'h00FF00;
                    assign ledColour[41] = 24'h00FF00;
                    assign ledColour[42] = 24'h0000FF;
                    assign ledColour[43] = 24'hFF0000;
                    assign ledColour[44] = 24'h00FF00;
                    assign ledColour[45] = 24'h0000FF;
                    assign ledColour[46] = 24'hFF0000;
                    assign ledColour[47] = 24'h00FF00;
                    assign ledColour[48] = 24'h0000FF;
                    assign ledColour[49] = 24'hFF0000;
                    assign ledColour[50] = 24'h00FF00;
                    assign ledColour[51] = 24'h00FF00;
                    assign ledColour[52] = 24'h0000FF;
                    assign ledColour[53] = 24'hFF0000;
                    assign ledColour[54] = 24'h00FF00;
                    int rotationTime = 3640000;
                                  
			
                    always @ ( posedge clk)
                    begin
                            //colourReg <=  ledColour[ledIndex];
                            
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
                                  ledIndex = ledIndex + 1;
                                  led = 0;
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
                                  if (ledIndex == verticlePixles )
                                   begin  
                                      reset = 1;
                                      led = 0;
                                      ledIndex = 0;
                                      clkCount = 0;
                                   end    
                                                      
                            end
                            if( reset == 0 )
                            begin
                                   if (colourReg[position] == 0)
                                   begin
                                        if (clkCount < zeroLow)
                                        begin
                                            led = 1;
                                        end
                                        if (clkCount == zeroLow)
                                        begin
                                            led = 0;
                                        end                                     
                                   end 
                                   if (colourReg[position] == 1)
                                   begin
                                       if (clkCount < oneLow)
                                       begin
                                           led = 1;
                                       end
                                       if (clkCount == oneLow)
                                       begin
                                           led = 0;
                                       end                                     
                                   end 
                                    if( clkCount == Period )
                                       begin
                                           position = position + 1;
                                           clkCount = 0;                                         
                                           led = 0;                                          
                                       end 
                                   
                            end
                            if (reset == 1) 
                            begin
                            led = 0;
                                if(clkCount >= 5900) 
                                begin
                                    reset = 0;
                                    clkCount = 0;
                                    ledIndex = 0;
                                 end 
                            end   
                            clkCount = clkCount + 1;  
                    end  
endmodule		