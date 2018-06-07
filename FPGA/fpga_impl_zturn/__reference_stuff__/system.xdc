######################################################################
# LEDs
######################################################################
# set_property  -dict {PACKAGE_PIN  D18   IOSTANDARD LVCMOS33   PULLUP TRUE} [get_ports ampli_iic_scl]    ; ## CN2 29

# Triple Led Color
set_property -dict {PACKAGE_PIN R14     IOSTANDARD  LVCMOS18} [get_ports LEDR]
set_property -dict {PACKAGE_PIN Y16     IOSTANDARD  LVCMOS18} [get_ports LEDG]
set_property -dict {PACKAGE_PIN Y17     IOSTANDARD  LVCMOS18} [get_ports LEDB]

# User led 1 ==> MIO0

# User led 2 ==> MIO9

######################################################################
# Buzzer
######################################################################
set_property -dict {PACKAGE_PIN P18     IOSTANDARD  LVCMOS18} [get_ports BP]

######################################################################
# I2C for Zturn
######################################################################
set_property -dict {PACKAGE_PIN P15     IOSTANDARD  LVCMOS18   PULLUP TRUE} [get_ports IIC_ZTURN_sda_io]
set_property -dict {PACKAGE_PIN P16     IOSTANDARD  LVCMOS18   PULLUP TRUE} [get_ports IIC_ZTURN_scl_io]

## 3 Axis GSensor ADXL345
set_property -dict {PACKAGE_PIN N17     IOSTANDARD  LVCMOS18} [get_ports MEMS_INTn]

# Temperature Sensor STLM75
# Interrupt shared with 3 Axis GSensor ADXL345

######################################################################
# GPIO Key
######################################################################

# MIO50 User Switch 1 used as wakeup?

######################################################################
# CAN
######################################################################

# TX MIO15
# RX MIO14

######################################################################
# Spinnaker
######################################################################
# Z7020 Bank 13
# CN1.16
set_property PACKAGE_PIN Y9      [get_ports data_2of7_from_spinnaker[6]]
# CN1.17
set_property PACKAGE_PIN Y7      [get_ports data_2of7_from_spinnaker[5]]
# CN1.18
set_property PACKAGE_PIN Y8      [get_ports data_2of7_from_spinnaker[4]]
# CN1.19
set_property PACKAGE_PIN Y6      [get_ports data_2of7_from_spinnaker[3]]
# CN1.20
set_property PACKAGE_PIN V11     [get_ports data_2of7_from_spinnaker[2]]
# CN1.21
set_property PACKAGE_PIN V8      [get_ports data_2of7_from_spinnaker[1]]
# CN1.22
set_property PACKAGE_PIN V10     [get_ports data_2of7_from_spinnaker[0]]
set_property IOSTANDARD LVCMOS18 [get_ports [list data_2of7_from_spinnaker[*]]]
# CN1.23
set_property PACKAGE_PIN W8      [get_ports ack_to_spinnaker]
set_property IOSTANDARD LVCMOS18 [get_ports ack_to_spinnaker]
# Z7020 Banck 34
# CN1.26
set_property PACKAGE_PIN T11     [get_ports data_2of7_to_spinnaker[6]]
# CN1.27
set_property PACKAGE_PIN T12     [get_ports data_2of7_to_spinnaker[5]]
# CN1.28
set_property PACKAGE_PIN T10     [get_ports data_2of7_to_spinnaker[4]]
# CN1.29
set_property PACKAGE_PIN U12     [get_ports data_2of7_to_spinnaker[3]]
# CN1.30
set_property PACKAGE_PIN U13     [get_ports data_2of7_to_spinnaker[2]]
# CN1.31
set_property PACKAGE_PIN V12     [get_ports data_2of7_to_spinnaker[1]]
# CN1.32
set_property PACKAGE_PIN V13     [get_ports data_2of7_to_spinnaker[0]]
set_property IOSTANDARD LVCMOS18 [get_ports [list data_2of7_to_spinnaker[*]]]

# CN1.33
set_property PACKAGE_PIN W13     [get_ports ack_from_spinnaker]
set_property IOSTANDARD LVCMOS18 [get_ports ack_from_spinnaker]

#############################################################
# Switches for Loopback                                     #
#############################################################
# SW0
set_property IOSTANDARD LVCMOS18 [get_ports {LpbkDefault_i[0]}]
set_property PACKAGE_PIN R19     [get_ports {LpbkDefault_i[0]}]
# SW1
set_property IOSTANDARD LVCMOS18 [get_ports {LpbkDefault_i[1]}]
set_property PACKAGE_PIN T19     [get_ports {LpbkDefault_i[1]}]
# SW2
set_property IOSTANDARD LVCMOS33 [get_ports {LpbkDefault_i[2]}]
set_property PACKAGE_PIN G14     [get_ports {LpbkDefault_i[2]}]
# SW3
set_property IOSTANDARD LVCMOS33 [get_ports {SW_3}]
set_property PACKAGE_PIN J15     [get_ports {SW_3}            ]

#############################################################
# Generic GPIO lines                                        #
#############################################################
# GPIO line 1 on CN1.7 (GPIO14)
set_property IOSTANDARD LVCMOS18 [get_ports {zturngpio[0]}]
set_property PACKAGE_PIN U7      [get_ports {zturngpio[0]}]

# GPIO line 2 on CN1.9 (GPIO15)
set_property IOSTANDARD LVCMOS18 [get_ports {zturngpio[1]}]
set_property PACKAGE_PIN V7      [get_ports {zturngpio[1]}]

# GPIO line 3 on CN1.11 (GPIO20)
set_property IOSTANDARD LVCMOS18 [get_ports {zturngpio[2]}]
set_property PACKAGE_PIN T9      [get_ports {zturngpio[2]}]

# GPIO line 4 on CN1.13 (GPIO21)
set_property IOSTANDARD LVCMOS18 [get_ports {zturngpio[3]}]
set_property PACKAGE_PIN U10     [get_ports {zturngpio[3]}]

##############################################################
## Enable Voltage regulators                                 #
##############################################################
## ZTURN ENA 1V8 on CN1.36 (GPIO 16)
#set_property IOSTANDARD LVCMOS18 [get_ports {zturn_ena_1v8}]
#set_property PACKAGE_PIN T14     [get_ports {zturn_ena_1v8}]

## ZTURN ENA 3V3 on CN1.37 (GPIO 17)
#set_property IOSTANDARD LVCMOS18 [get_ports {zturn_ena_3v3}]
#set_property PACKAGE_PIN P14     [get_ports {zturn_ena_3v3}]


##############################################################
## Dummy GPIO                                                #
##############################################################
## Dummy GPIO on CN2.32 (GPIO 0)
#set_property IOSTANDARD LVCMOS18 [get_ports {gpio_0_dummy[0]}]
#set_property PACKAGE_PIN F16     [get_ports {gpio_0_dummy[0]}]

## Dummy GPIO on CN2.33 (GPIO 18)
#set_property IOSTANDARD LVCMOS18 [get_ports {gpio_0_dummy[1]}]
#set_property PACKAGE_PIN E18     [get_ports {gpio_0_dummy[1]}]

## Dummy GPIO on CN2.34 (GPIO 19)
#set_property IOSTANDARD LVCMOS18 [get_ports {gpio_0_dummy[2]}]
#set_property PACKAGE_PIN F17     [get_ports {gpio_0_dummy[2]}]

######################################################################
# I2C for IMU Eye
######################################################################
# CN2.35
set_property -dict {PACKAGE_PIN E19     IOSTANDARD  LVCMOS33   PULLUP TRUE} [get_ports IIC_IMUEYE_sda_io]
# CN2.36
set_property -dict {PACKAGE_PIN M17     IOSTANDARD  LVCMOS33   PULLUP TRUE} [get_ports IIC_IMUEYE_scl_io]
