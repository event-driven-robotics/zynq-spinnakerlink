---
# ZYNQ-SpiNNakerLink
Provides an interface with SpiNNaker boards throught SpiNNlink connection.  

---
<br />
  
### Creating FSBL
From **Xilinx SDK (XSDK)**, select **File** -> **New** -> **Application Project** and type FSBL (please, type exactly FSBL in capital letters) as project name; then press "Next" button and chose *Zynq FSBL* as template, and finally, press "Finish" button.  
The XSDK will create the FSBL_bsp that is the board support package (i.e.: all the drivers and libraries used to manage the 
IPs instanced into the SynthTactAER design) and then the FSBL.elf (i.e.: the First Stage Boot Loader program).

### Creating BOOT.bin
To create the **BOOT.bin** file, you need **FSBL.elf** (from SDK), **system_wrapper.bit** (From Vivado Implementation), **u-boot.elf** as sources, and and the information file **boot_builder.bif** gathered in a same folder (e.g. "boot").  
From **Xilinx SDK (XSDK)**, select **Xilinx** -> **Create Boot Image**, then mark *Import from exixting BIF file*.  
Select the bif file path (the folder must contain also "FSBL.elf", "system_wrapper.bit" and "u-boot.elf"), then press "Create Image").

### Creating devicetree
The XSDK tool can also generate the devicetree sources for the design that you have implemented.  
At first you need to have locally the repository https://github.com/Xilinx/device-tree-xlnx;  
then from **Xilinx SDK (XSDK)**, select **Xilinx** -> **Repositories** and add the path (better as Global Repository), and click "OK" button.  
Now you can build the devicetree sources for your implemented design by creating a new *Board Support Package (BSP)* project and choosing *device_tree* as Board Support Package OS.  
Press "Finish" to start the devicetree BSP.  
Into the Board Support Package Settings window, select **device_tree** and modify the value in cell at row ***bootargs***, column ***Value*** with the following text:  
```
console=ttyPS0,115200 root=/dev/mmcblk0p2 rw earlyprintk rootfstype=ext4 rootwait devtmpfs.mount=1
```
  
Press "OK" button and the **pl.dtsi**, **skeleton.dtsi**, **system.dts** and **zynq-7000.dtsi** are generated.  

  
**NOTE:**    
Please, use these devicetree files just as references and feel free to modify them to match completely 
with the corresponding linux drivers. The hardware implemented into the PL, because of its custom-made nature, will be for sure to be fixed!
  