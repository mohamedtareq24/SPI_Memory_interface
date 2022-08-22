module tst (clk,tx_valid,tx_data,MISO);
input wire clk,tx_valid ;
input wire [7:0] tx_data ;
output MISO;
reg  [8:0] shift_reg_tx;

always @(negedge clk ) begin 
    shift_reg_tx[7:0] <= tx_data[7:0];
    //shift_reg_rx <= {shift_reg_rx[8:0],MOSI}; 
    if (tx_valid)
        begin// serial to parallel
            shift_reg_tx <= shift_reg_tx << 1; //  parallel to serial  
        end    
    end 
    assign MISO = (tx_valid) ? shift_reg_tx[8]:1'b0;
endmodule //tst    