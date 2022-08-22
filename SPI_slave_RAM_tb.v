`timescale 1ps/1ps
module SPI_slave_RAM_tb ();
wire MISO;
reg clk,rst_n,SS_n,MOSI;
integer  i  ;
always #50 clk = ~clk ;
reg [8:0] j = 0;
task send_SPI_frame (input [9:0] packet);
begin
    for (i = 9 ; i >= 0 ; i = i-1 ) begin
        MOSI = packet[i];
        #100;
    end
end
endtask

initial begin
    MOSI = 1;
    clk = 1 ;
    rst_n = 1;
    SS_n = 0;
    i = 9 ;
    #340; 
    @(posedge clk)
    begin  
        for (j = 0; j<256 ; j = j+1 ) begin
            #100 SS_n = 1 ;
            send_SPI_frame ({2'b00,j[7:0]});
            send_SPI_frame ({2'b01,j[7:0]});
            send_SPI_frame ({2'b10,j[7:0]});
            send_SPI_frame ({2'b11,8'hEA}); // writing  j in the address j 
            #100 SS_n = 0 ;
        end
        $stop;
    end 
end   
SPI_slave_RAM UUT (MOSI,SS_n,clk,rst_n,MISO);
endmodule //SPI_slave_RAM_tb

/* stimulus put it on Modelsim:

sim:/SPI_slave_RAM_tb/MISO sim:/SPI_slave_RAM_tb/MOSI sim:/SPI_slave_RAM_tb/rst_n sim:
/SPI_slave_RAM_tb/SS_n sim:/SPI_slave_RAM_tb/send_SPI_frame/packet sim:/SPI_slave_RAM_tb/UUT/memory/rx_valid sim:
/SPI_slave_RAM_tb/UUT/memory/din sim:/SPI_slave_RAM_tb/UUT/state sim:/SPI_slave_RAM_tb/UUT/count sim:/SPI_slave_RAM_tb/UUT/cnt sim:
/SPI_slave_RAM_tb/UUT/shift_reg_rx sim:/SPI_slave_RAM_tb/UUT/memory/write_addr_reg sim:/SPI_slave_RAM_tb/UUT/memory/read_addr_reg sim:
/SPI_slave_RAM_tb/i sim:/SPI_slave_RAM_tb/clk sim:/SPI_slave_RAM_tb/UUT/shift_reg_tx sim:/SPI_slave_RAM_tb/UUT/memory/dout sim:
/SPI_slave_RAM_tb/UUT/memory/read_data_flag sim:/SPI_slave_RAM_tb/UUT/memory/tx_valid sim:/SPI_slave_RAM_tb/UUT/tx_data

*/