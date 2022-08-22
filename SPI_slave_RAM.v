module SPI_slave_RAM (
    input  MOSI,SS_n,clk,rst_n,
    //output reg [8:0] shift_reg_tx,
	output MISO
);

wire [9:0] rx_data;
reg [3:0] count ,state;
wire [7:0] tx_data;
reg  rx_valid,read_data_flag ;
wire tx_valid,cnt;
RAM memory (rx_valid,rst_n,SS_n,rx_data,clk,tx_data,tx_valid); // 256 / 8
reg [9:0] shift_reg_rx ;
reg [8:0]  shift_reg_tx ;
initial begin
   count=0;
   state=0;
   rx_valid = 0;
   shift_reg_rx = 10'b0;
   shift_reg_tx = 9'hAA;   
   read_data_flag = 0;
end

localparam IDLE = 0 ,WRITE = 1,READ = 2, WRITE_ADDR_DATA = 3, RAM_STORE = 4,READ_ADDR = 5, READ_DATA = 6; 

// Determine the next state
always @ (negedge clk or negedge rst_n) 
begin
	if (~rst_n)
		state <= IDLE;
	else if (~SS_n)
        state <= IDLE;
    else    
		case (state)
			IDLE:
                if ({cnt,MOSI,tx_valid} == 3'b000)
                    state <= WRITE;
                    else if ({cnt,MOSI,tx_valid} == 3'b010)
                    state <= READ;
                    else
                    state <= IDLE;  
            WRITE:
                if ({cnt,MOSI,tx_valid} == 3'b000)
                    state <= WRITE_ADDR_DATA;
                else if ({cnt,MOSI,tx_valid} == 3'b010)
                    state <= WRITE_ADDR_DATA;
                else 
                    state <= WRITE;
            WRITE_ADDR_DATA:
                    if (cnt)
                        state <= RAM_STORE;
                    else 
                        state <= WRITE_ADDR_DATA;
            RAM_STORE:
                    if ({cnt,MOSI,tx_valid} == 3'b000)
                        state <= WRITE;
                    else if ({cnt,MOSI,tx_valid} == 3'b010)
                        state <= READ;
                    else 
                        state <= IDLE;
            READ:
                    if (MOSI)
                        state <= READ_DATA;
                    else 
                        state <= READ_ADDR;

            READ_ADDR:
                        if (cnt)
                            state <= RAM_STORE;
                        else 
                            state <= READ_ADDR;
            READ_DATA :
                    state <= READ_DATA;                
    
            default : state <= IDLE  ;                                 
	    endcase
    end

always @ (state) begin
    rx_valid = (state == RAM_STORE);   ///// must sync with cnt 
    read_data_flag = (state == READ_DATA);
end

always @(negedge clk ) begin 
    if (tx_valid & ~read_data_flag)
        shift_reg_tx[7:0] <= tx_data[7:0];
    else if (read_data_flag)
        shift_reg_tx <= shift_reg_tx << 1;   
    shift_reg_rx <= {shift_reg_rx[8:0],MOSI}; 
    // //  parallel to serial     
    end 
// MISO depends on tx_valid 
assign MISO = shift_reg_tx[8];
assign rx_data = shift_reg_rx;


always @(negedge clk ) begin   
    if (~SS_n) 
        count <= 4'b0;
    else if (count < 9) 
        count <= count +1'b1 ;
    else 
        count <= 0;       
end

assign cnt = (count == 4'd9); // counter signal
endmodule //SPI_slave_RAM