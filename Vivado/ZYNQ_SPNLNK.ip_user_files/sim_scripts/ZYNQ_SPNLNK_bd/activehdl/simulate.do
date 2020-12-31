onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+ZYNQ_SPNLNK_bd -L xilinx_vip -L xil_defaultlib -L xpm -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.ZYNQ_SPNLNK_bd xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {ZYNQ_SPNLNK_bd.udo}

run -all

endsim

quit -force
