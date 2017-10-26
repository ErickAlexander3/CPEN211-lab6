onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /datapath_tb/sim_clk
add wave -noupdate /datapath_tb/sim_write
add wave -noupdate /datapath_tb/sim_asel
add wave -noupdate /datapath_tb/sim_bsel
add wave -noupdate /datapath_tb/sim_vsel
add wave -noupdate /datapath_tb/sim_loada
add wave -noupdate /datapath_tb/sim_loadb
add wave -noupdate /datapath_tb/sim_loadc
add wave -noupdate /datapath_tb/sim_loads
add wave -noupdate /datapath_tb/sim_readnum
add wave -noupdate /datapath_tb/sim_writenum
add wave -noupdate /datapath_tb/sim_ALUop
add wave -noupdate /datapath_tb/sim_shift
add wave -noupdate /datapath_tb/sim_status
add wave -noupdate /datapath_tb/sim_datapath_out
add wave -noupdate /datapath_tb/sim_mdata
add wave -noupdate /datapath_tb/sim_sximm8
add wave -noupdate /datapath_tb/sim_sximm5
add wave -noupdate /datapath_tb/sim_PC
add wave -noupdate /datapath_tb/DUT/reg_data_in
add wave -noupdate /datapath_tb/DUT/reg_data_out
add wave -noupdate /datapath_tb/DUT/pipeline_reg_A_out
add wave -noupdate /datapath_tb/DUT/pipeline_reg_B_out
add wave -noupdate /datapath_tb/DUT/pipeline_reg_B_out_shifted
add wave -noupdate /datapath_tb/DUT/alu_out
add wave -noupdate /datapath_tb/DUT/alu_status
add wave -noupdate /datapath_tb/DUT/vsel
add wave -noupdate /datapath_tb/DUT/mdata
add wave -noupdate /datapath_tb/DUT/sximm8
add wave -noupdate /datapath_tb/DUT/sximm5
add wave -noupdate /datapath_tb/DUT/PC
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {98 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 340
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
configure wave -timelineunits ps
update
WaveRestoreZoom {80 ps} {142 ps}
