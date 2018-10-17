
del FSBL_old.elf
rename FSBL.elf FSBL_old.elf
copy ..\fpga\fpga.sdk\FSBL\Debug\FSBL.elf

del system_wrapper_old.bit
rename system_wrapper.bit system_wrapper_old.bit
copy ..\fpga\fpga.runs\impl_1\system_wrapper.bit

del pcw_old.dtsi
rename pcw.dtsi pcw_old.dtsi
copy ..\fpga\fpga.sdk\device_tree_bsp_0\pcw.dtsi

del pl_old.dtsi
rename pl.dtsi pl_old.dtsi
copy ..\fpga\fpga.sdk\device_tree_bsp_0\pl.dtsi

del system-top_old.dts
rename system-top.dts system-top_old.dts
copy ..\fpga\fpga.sdk\device_tree_bsp_0\system-top.dts

del zynq-7000_old.dtsi
rename zynq-7000.dtsi zynq-7000_old.dtsi
copy ..\fpga\fpga.sdk\device_tree_bsp_0\zynq-7000.dtsi

del BOOT_old.bin
rename BOOT.bin BOOT_old.bin
%SDK_2017.4_PATH%/bin/bootgen.bat  -image boot_builder.bif -arch zynq -o D:\Projects\Spinnaker\zynq-spinnakerlink\boot\BOOT.bin -w

