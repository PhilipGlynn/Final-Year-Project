module povDisplay (input clk, 
						 input wire hallSensor, 
						 input RxD,input RESET, 
						 output reg leds, 
						 output reg leds1, 
						 output reg leds2, 
						 output reg leds3, 
						 output reg[7:0]led); //50Mhz CLK
                    
		  reg RecieveFlag;
		  int position = 0;
		  reg [31:0] horizontalPixles = 18;
		  reg [31:0] rotationClkCount = 0;	
		  reg [23:0] colourReg ;
		  reg [23:0] rgb [13:0];
		  reg [23:0] rgb2 [13:0];
		  reg [23:0] rgb3 [13:0];
		  reg [23:0] rgb4 [13:0];
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
				.colourReg(rgb1),
				.leds(leds),
				.position(position)
		  );
		  
		   DriveLed driveLed2(
				.clk(clk), //input clock 
				.colourReg(colourReg),
				.leds(leds1),
				.position(position)
		  );
		   
		   DriveLed driveLed3(
				.clk(clk), //input clock 
				.colourReg(colourReg),
				.leds(leds2),
				.position(position)
		  );
		  
		   DriveLed driveLed4(
				.clk(clk), //input clock 
				.colourReg(colourReg),
				.leds(leds3),
				.position(position)
		  );

	  always @ (posedge RecieveFlag)
	  begin 		
			if(prevLock != receivingLock)
				begin
					//prevLock = receivingLock;
					memAddr = 0;
				end						
			temp[charCounter] = RxData;
			//led = ~RxData;
			charCounter <= charCounter + 1;  
			if(charCounter == 2)
			begin   
				charCounter <= 0;
				forwardCount = 0;
				backwardCount = 7;
				for(forwardCount = 0; forwardCount <=7; forwardCount = forwardCount + 1)
				begin
					 data[0][forwardCount] = temp[0][backwardCount];
					 data[1][forwardCount] = temp[1][backwardCount];
					 data[2][forwardCount] = temp[2][backwardCount];
					 backwardCount = backwardCount - 1;
				end
				we = 1;
				inData <= {data[2], data[0],data[1]};
				colourReg = {data[2], data[0],data[1]};
				we = 0;                       
				memAddr = memAddr + 1;
			end    
			receivingLockToggle = ~receivingLockToggle;
	  end
	  
	  always @ ( negedge hallSensor)
	  begin
			led = ~led;
			
	  end
	  
	  always @ (posedge clk)
	  begin
			if(uartTimout > 0)
			begin
				if(prevLock != receivingLock)
				begin
					prevLock = receivingLock;
					//led = 8'hFF;
				end
				receivingLock = 1;
				//led = 8'hff;													
				uartTimout = uartTimout - 1;
			end
			else
			begin
				if(prevLock != receivingLock)
				begin
					prevLock = receivingLock;
					//led = 8'h00;
					memAddrRead = 0;
				end
				receivingLock = 0;
			end
			reveiveCurr = receivingLockToggle;
			if(reveiveCurr != receivePrev)
			begin
				uartTimout = 500000000;
				receivePrev = reveiveCurr;
			end	
			
			
			
			
			rotationClkCount = rotationClkCount + 1;
			if (position == 24)
			begin
				if (rotationClkCount >= rotationTime / horizontalPixles)
				begin
					// read in verticle line of pixles
					if(receivingLock == 0) //receivelock is currently not functional
					begin
						  //led = 8'h01;
						  memStep = memPos;
						  for(forCounter = 0; forCounter == 56; forCounter = forCounter + 1)
						  begin 
						  //led = 8'h01;
							 if(we == 0)
							 begin
								 oe = 1;
								 memAddrRead = memStep;
								 rgb[forCounter] = dataOut;
								 oe = 0;
								 memStep = memStep + 100; // change to use horizontal position when you get rotation timer working
							 end  
			 
						  end
						  memPos = memPos + 1;
						  if(memPos == 100)
						  begin
								memPos = 0;
						  end
					end      
				end
			end
	  end
	                    
                     
endmodule		