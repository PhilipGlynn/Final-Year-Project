transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/sgspe/Desktop/HDL\ files {C:/Users/sgspe/Desktop/HDL files/povDisplay.sv}
vlog -sv -work work +incdir+C:/Users/sgspe/Desktop/HDL\ files {C:/Users/sgspe/Desktop/HDL files/UART-RX.sv}
vlog -sv -work work +incdir+C:/Users/sgspe/Desktop/HDL\ files {C:/Users/sgspe/Desktop/HDL files/memory.sv}

vlog -sv -work work +incdir+C:/Users/sgspe/Desktop/HDL\ files/output_files {C:/Users/sgspe/Desktop/HDL files/output_files/uart_tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  Uart_tb

add wave *
view structure
view signals
run -all
