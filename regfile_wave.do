onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /regfile_tb/sim_clk
add wave -noupdate /regfile_tb/sim_write
add wave -noupdate /regfile_tb/sim_writenum
add wave -noupdate /regfile_tb/sim_readnum
add wave -noupdate /regfile_tb/sim_data_in
add wave -noupdate /regfile_tb/sim_data_out
add wave -noupdate /regfile_tb/DUT/R0_out
add wave -noupdate /regfile_tb/DUT/R1_out
add wave -noupdate /regfile_tb/DUT/R2_out
add wave -noupdate /regfile_tb/DUT/R3_out
add wave -noupdate /regfile_tb/DUT/R4_out
add wave -noupdate /regfile_tb/DUT/R5_out
add wave -noupdate /regfile_tb/DUT/R6_out
add wave -noupdate /regfile_tb/DUT/R7_out
add wave -noupdate /regfile_tb/DUT/decoded_readnum
add wave -noupdate /regfile_tb/DUT/decoded_writenum
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {53 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 234
configure wave -valuecolwidth 211
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {189 ps}
