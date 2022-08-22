`timescale 1ps/1ps
module RAM_tb ();
reg clk,rst_n,rx_valid,SS_n,MOSI,MISO;
reg[9:0] rx_data,shift_reg_rx,shift_reg_tx;
wire  [7:0] tx_data;//,shift_reg_tx;
integer i=9 ;
reg tx_valid;

always #50 clk = ~clk; 

always @(negedge clk ) begin 
    if (~SS_n)
        begin
            shift_reg_rx <= 0; // serial to parallel
            shift_reg_tx[8:1] <= tx_data[7:0]; //  parallel to serial  
        end
	else
        begin
            shift_reg_rx <= {shift_reg_rx[8:0],MOSI}; // serial to parallel
            shift_reg_tx <= shift_reg_tx >> tx_valid; //  parallel to serial  
        end
end 

task send_SPI_frame (input [9:0] packet);
begin
    for (i = 9 ; i >= 0 ; i = i-1 ) begin
        rx_valid = (i == 0);
        tx_valid = (packet[9:8] == 2'b11);
        MOSI = packet[i];
        #100;
    end  
end
endtask


initial begin                   // writing cycle
    clk = 0;
    MOSI = 1 ;
    rst_n = 1;
    MISO = 0; 
    shift_reg_tx = 0;
    rx_valid = 0;
    rx_data = 0;
    SS_n = 0;

    #120
    @(negedge clk)
    begin 
    SS_n = 1;
    send_SPI_frame ({2'b00,8'h01});
    rx_data =shift_reg_rx;
    end
    @(negedge clk) send_SPI_frame ({2'b01,8'h32});
    rx_data = shift_reg_rx;
    @(negedge clk) send_SPI_frame ({2'b10,8'h01});
    rx_data = shift_reg_rx;
    @(negedge clk) send_SPI_frame ({2'b11,8'hFF});
    rx_data = shift_reg_rx;
    MISO = shift_reg_tx[0];    
 /*   #900 rx_data = 10'b0000000010;
    rx_valid = 1;
    #100 rx_valid = 0; 

    #900 rx_data = 10'b0101010100;
    rx_valid = 1;
    #100 rx_valid = 0;

    #900 rx_data = 10'b0000000011;    
    rx_valid = 1;
    #100 rx_valid = 0;

    #900 rx_data = 10'b0101010000;
    rx_valid = 1;
    #100 rx_valid = 0;
// we wrote some addresses ,let's read them 
    #900 rx_data = 10'b1000000001;
    rx_valid = 1;
    #100 rx_valid = 0;

    #900 rx_data = 10'b1101010101;
    rx_valid = 1;
    #100 rx_valid = 0; 

    #900 rx_data = 10'b1000000010;
    rx_valid = 1;
    #100 rx_valid = 0;

    #900 rx_data = 10'b1101010101;
    rx_valid = 1;        
    #100 rx_valid = 0;

    #900 rx_data = 10'b1000000011;
    rx_valid = 1;
    #100 rx_valid = 0;

    #900 rx_data = 10'b1101010101;
    rx_valid = 1;
    #100 rx_valid = 0;
*/
    #1 $stop;        
end
always @(posedge clk or negedge rst_n) begin
    
end
RAM UUT (rx_valid,rst_n,rx_data,clk,tx_data,tx_valid);
endmodule //RAM_tb



