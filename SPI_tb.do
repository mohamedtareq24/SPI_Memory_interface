onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /SPI_slave_RAM_tb/MISO
add wave -noupdate /SPI_slave_RAM_tb/MOSI
add wave -noupdate /SPI_slave_RAM_tb/rst_n
add wave -noupdate /SPI_slave_RAM_tb/SS_n
add wave -noupdate /SPI_slave_RAM_tb/send_SPI_frame/packet
add wave -noupdate /SPI_slave_RAM_tb/UUT/memory/rx_valid
add wave -noupdate /SPI_slave_RAM_tb/UUT/memory/din
add wave -noupdate /SPI_slave_RAM_tb/UUT/state
add wave -noupdate /SPI_slave_RAM_tb/UUT/count
add wave -noupdate /SPI_slave_RAM_tb/UUT/cnt
add wave -noupdate /SPI_slave_RAM_tb/UUT/shift_reg_rx
add wave -noupdate /SPI_slave_RAM_tb/UUT/memory/write_addr_reg
add wave -noupdate /SPI_slave_RAM_tb/UUT/memory/read_addr_reg
add wave -noupdate /SPI_slave_RAM_tb/i
add wave -noupdate /SPI_slave_RAM_tb/clk
add wave -noupdate /SPI_slave_RAM_tb/UUT/shift_reg_tx
add wave -noupdate /SPI_slave_RAM_tb/UUT/memory/dout
add wave -noupdate /SPI_slave_RAM_tb/UUT/memory/tx_valid
add wave -noupdate /SPI_slave_RAM_tb/UUT/tx_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1074707 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ms
update
WaveRestoreZoom {1074650 ps} {1075650 ps}
