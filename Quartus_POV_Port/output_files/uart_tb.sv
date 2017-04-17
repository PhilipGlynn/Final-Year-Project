module uart_tb ();

reg clk, rst;
reg [7:0] tx_data;
reg tx_data_valid;
wire tx_data_ack;
wire txd,rxd;
wire [7:0] rx_data;
wire rx_data_fresh;


 UART_RX( 
	.clk(clk),
	.reset(rst),
	.RxD(rxd),
	.RxData(RxData),
	.o_recieveFlag(rx_data_fresh)
	);		

assign rxd = txd;

initial begin
	clk = 0;
	rst = 1;
	tx_data_valid = 1'b0;
	@(posedge clk);
	@(negedge clk);
	rst = 0;
end

always begin
	#50 clk = ~clk;
end

// tx data driver
always begin
	#1000 @(negedge clk) tx_data_valid = $random;
end

always @(posedge clk) begin
$display ("Running");
	if (rst) tx_data <= "a";
	else if (tx_data_ack) begin
		if (tx_data == "z") tx_data <= "a";
		else tx_data <= tx_data + 1'b1;
	end
end

// rx data checker
reg fail = 0;
reg [7:0] expected_rx;
always @(posedge clk) begin
	if (rst) expected_rx <= "a";
	else if (rx_data_fresh) begin
		if (rx_data !== expected_rx) begin
			$display ("Mismatch at time %d",$time);
			fail = 1;
			#1000
			$stop();
		end
		if (expected_rx == "z") expected_rx <= "a";
		else expected_rx <= expected_rx + 1'b1;
	end
end

initial begin
	#1000000 if (!fail) $display ("PASS");
	$stop();
end

endmodule