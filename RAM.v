module RAM
#(parameter MEM_DEPTH = 256 , parameter ADDR_SIZE=8)
(	input rx_valid,rst_n,SS_n,
	input [(ADDR_SIZE+1):0] din,
	input  clk,
	output   [(ADDR_SIZE-1):0] dout,
	output   tx_valid 
);

	// Declare the RAM variable
	reg [ADDR_SIZE-1:0] ram [MEM_DEPTH-1:0];
	reg [ADDR_SIZE+1:0] read_addr_reg,write_addr_reg; 		

	initial begin
		read_addr_reg =  0;
		write_addr_reg = 0;
		ram[17] = 8'hff;  
	end
	
	always @ (negedge clk or negedge rst_n or negedge SS_n)
    begin 
    if (~rst_n || ~SS_n)
        begin
			case (din[ADDR_SIZE+1:ADDR_SIZE])
				default: 
					begin 
						write_addr_reg <= 0;
						read_addr_reg <= 0;
					end 
			endcase
        end 
    else
        begin    
			case (din[ADDR_SIZE+1:ADDR_SIZE])   // 9:8
				2'b00: if (rx_valid) write_addr_reg <=  din[ADDR_SIZE-1:0];
				2'b01: if (rx_valid) ram[write_addr_reg] <= din[ADDR_SIZE-1:0];
				2'b10:
				begin
					if (rx_valid)
						begin 
							read_addr_reg <= din[ADDR_SIZE+1:0]; 
						end
				end		
			endcase
        end		
    end	

assign tx_valid = ((read_addr_reg[ADDR_SIZE+1:ADDR_SIZE] == 2'b10) ) ? 1'b1 : 1'b0 ;
assign dout = (tx_valid) ? ram[read_addr_reg[7:0]] : 8'b0;	
endmodule
