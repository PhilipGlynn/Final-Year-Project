module povDisplay (input clk, 
						 input wire hallSensor, 
						 input RxD,input RESET, 
						 output reg leds, 
						 output reg leds1, 
						 output reg leds2, 
						 output reg leds3, 
						 output reg[4:0]led); //50Mhz CLK
                    
		  reg RecieveFlag;
		  int position = 0;
		  int position1 = 0;
		  int position2 = 0;
		  int position3 = 0;
		  
		  reg [31:0] horizontalPixles = 100;
		  reg [31:0] rotationClkCount = 0;	
		  reg [31:0] rotationClkCount1 = 0;	
		  reg [23:0] colourReg ;
		  reg [23:0] verticleLine [55:0];
		  reg [23:0] rgb1 [13:0];
		  reg [23:0] rgb2 [13:0];
		  reg [23:0] rgb3 [13:0];
		  reg [23:0] rgb4 [13:0];
		  reg [23:0] rgb1Buffer [13:0];
		  reg [23:0] rgb2Buffer [13:0];
		  reg [23:0] rgb3Buffer [13:0];
		  reg [23:0] rgb4Buffer [13:0];
		  reg [7:0] RxData;
		  int rotationTime = 3640000;
		  reg [13:0] memAddr = 0;
		  reg [13:0] memAddrRead = 0;
		  reg [7:0] temp[2:0];
		  reg [7:0] data[2:0];
		  reg [23:0] dataOut;
		  reg [23:0] inData;
		  reg [13:0] memStep = 0;
		  reg [13:0] memPos = 0;
		  reg [8:0] forCounter = 0;
		  reg we;
		  reg oe;
		  reg[9:0] forwardCount = 0;
		  reg[9:0] backwardCount = 0;
		  int charCounter  = 0;
		  
		  reg receivingLock = 0;
		  reg prevLock = 0;
		  reg receivingLockToggle = 0;
		  reg [31:0] uartTimout = 0;
		  reg receivePrev = 0;
		  reg reveiveCurr = 0;
		  reg resetAddress = 0;
		  
		  reg [13:0] deleteMe = 0;

		  int ledNum = 0;
		  
		  UART_RX( 
				.clk(clk),
				.reset(RESET),
				.RxD(RxD),
				.RxData(RxData),
				.o_recieveFlag(RecieveFlag)
				);				
				
		  memory(
				.clk(clk),
				.rdaddress(memAddrRead),
				.wraddress(memAddr),
				.data(inData),
				.wren(we),
				.q(dataOut)
		  );

		  DriveLed driveLed1(
				.clk(clk), //input clock 
				.rgb(rgb1),
				.leds(leds),
				.position(position)
		  );
		  
		   DriveLed driveLed2(
				.clk(clk), //input clock 
				.rgb(rgb2),
				.leds(leds1),
				.position(position1)
		  );
		   
		   DriveLed driveLed3(
				.clk(clk), //input clock 
				.rgb(rgb3),
				.leds(leds2),
				.position(position2)
		  );
		  
		   DriveLed driveLed4(
				.clk(clk), //input clock 
				.rgb(rgb4),
				.leds(leds3),
				.position(position3)
		  );
		  
		  
		  
		  
		  
		  

	  always @ (posedge RecieveFlag) // receive from uart
	  begin 		
			
			//find way of reseting memaddress
			if(resetAddress == 1)
			begin
				memAddr = 0;
			end

			temp[charCounter] = RxData;
			//led = ~RxData;
			charCounter <= charCounter + 1;  
			if(charCounter == 2)
			begin   
				forwardCount = 0;
				backwardCount = 7;
				for(forwardCount = 0; forwardCount <=7; forwardCount = forwardCount + 1)
				begin
					 data[0][forwardCount] = temp[0][backwardCount];
					 data[1][forwardCount] = temp[1][backwardCount];
					 data[2][forwardCount] = temp[2][backwardCount];
					 backwardCount = backwardCount - 1;
				end
				
				we = 0;
				inData <= {data[2], data[0],data[1]};
				//colourReg = {data[2], data[0],data[1]};
				we = 1;                       
				memAddr = memAddr + 1;
				
				charCounter <= 0;
			end    
			receivingLockToggle = ~receivingLockToggle;
	  end
	  
	  
	  
	  always @ (posedge clk) // timeout uart if it stops recieveing 
	  begin
			if(uartTimout > 0)
			begin
				receivingLock = 1;				
				uartTimout = uartTimout - 1;
			end
			else
			begin
				receivingLock = 0;
				resetAddress = 1;
			end
			reveiveCurr = receivingLockToggle;
			if(reveiveCurr != receivePrev)
			begin
				uartTimout = 500000000;
				receivePrev = reveiveCurr;
			end							
		
			if(memAddr == 0)
			begin
				resetAddress = 0;
			end
			// for debugging
			led = ~(memStep/178);
	
			
	  end
	  
	  always @ ( negedge hallSensor) // calculate rotation time
	  begin
			
			
	  end

		always @ (posedge clk) // read from memory
	  begin
			if(uartTimout > 0)
			begin
				memStep = 0;
				deleteMe = 53;
			end
			rotationClkCount = rotationClkCount + 1;
			rotationClkCount1 = rotationClkCount1 + 1;
			
				if (rotationClkCount >= (rotationTime / horizontalPixles))
				begin
					// read in verticle line of pixles
					if(receivingLock == 0) 
					begin			
						 memAddrRead = memStep;
						 if(deleteMe >= 0 &&  deleteMe <= 13)
						 begin
							rgb1Buffer[deleteMe] = dataOut;
						 end
						 if(deleteMe > 13 &&  deleteMe <= 27)
						 begin
							rgb2Buffer[deleteMe- 14] = dataOut;
						 end
						 if(deleteMe > 27 &&  deleteMe <= 41)
						 begin
							rgb3Buffer[deleteMe - 28] = dataOut;
						 end
						 if(deleteMe > 41 &&  deleteMe <= 55)
						 begin
							rgb4Buffer[deleteMe - 42] = dataOut;
						 end
						 deleteMe = deleteMe + 1;
						 if(deleteMe ==  55)
						 begin
							rgb1 = rgb1Buffer;
							rgb2 = rgb2Buffer;
							rgb3 = rgb3Buffer;
							rgb4 = rgb4Buffer;
							deleteMe = 0;
							rotationClkCount = 0;
						 end
						 memStep = memStep + 1; // change to use horizontal position when you get rotation timer working
						 if(memStep > 5499)
						 begin
							  memStep = 0;
							  
						 end
					end      
					
				end	
	  end


	  
                     
endmodule		