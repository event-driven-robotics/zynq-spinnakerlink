//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.4 (lin64) Build 2086221 Fri Dec 15 20:54:30 MST 2017
//Date        : Fri Jun  1 16:11:18 2018
//Host        : IITRBCSWS069 running 64-bit Ubuntu 16.04.4 LTS
//Command     : generate_target system_wrapper.bd
//Design      : system_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module system_wrapper
   (DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
    // ZTURN on board circuitry
    IIC_ZTURN_scl_io,
    IIC_ZTURN_sda_io,
    MEMS_INTn,
    SW_3,
    BP,
    LEDR,
    LEDG,
    LEDB,
    // Spinnaker
    IIC_IMUEYE_scl_io,
    IIC_IMUEYE_sda_io,
    LpbkDefault_i,
    ack_from_spinnaker,
    ack_to_spinnaker,
    data_2of7_from_spinnaker,
    data_2of7_to_spinnaker,
    zturngpio);
  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;
  // ZTURN on board circuitry
  inout IIC_ZTURN_scl_io;
  inout IIC_ZTURN_sda_io;
  input MEMS_INTn;
  inout SW_3;
  inout BP;
  inout LEDR;
  inout LEDG;
  inout LEDB;
  // Spinnaker
  inout IIC_IMUEYE_scl_io;
  inout IIC_IMUEYE_sda_io;
  input [2:0]LpbkDefault_i;
  input ack_from_spinnaker;
  output ack_to_spinnaker;
  input [6:0]data_2of7_from_spinnaker;
  output [6:0]data_2of7_to_spinnaker;
  inout [3:0] zturngpio;
  
  wire [14:0]DDR_addr;
  wire [2:0]DDR_ba;
  wire DDR_cas_n;
  wire DDR_ck_n;
  wire DDR_ck_p;
  wire DDR_cke;
  wire DDR_cs_n;
  wire [3:0]DDR_dm;
  wire [31:0]DDR_dq;
  wire [3:0]DDR_dqs_n;
  wire [3:0]DDR_dqs_p;
  wire DDR_odt;
  wire DDR_ras_n;
  wire DDR_reset_n;
  wire DDR_we_n;
  wire FIXED_IO_ddr_vrn;
  wire FIXED_IO_ddr_vrp;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;
  wire [63:0] gpio_0_tri_i;
  wire [63:0] gpio_0_tri_o;
  wire [63:0] gpio_0_tri_t;
  wire IIC_IMUEYE_scl_i;
  wire IIC_IMUEYE_scl_io;
  wire IIC_IMUEYE_scl_o;
  wire IIC_IMUEYE_scl_t;
  wire IIC_IMUEYE_sda_i;
  wire IIC_IMUEYE_sda_io;
  wire IIC_IMUEYE_sda_o;
  wire IIC_IMUEYE_sda_t;
  wire IIC_ZTURN_scl_i;
  wire IIC_ZTURN_scl_io;
  wire IIC_ZTURN_scl_o;
  wire IIC_ZTURN_scl_t;
  wire IIC_ZTURN_sda_i;
  wire IIC_ZTURN_sda_io;
  wire IIC_ZTURN_sda_o;
  wire IIC_ZTURN_sda_t;
  wire [2:0]LpbkDefault_i;
  wire MEMS_INTn;
  wire ack_from_spinnaker;
  wire ack_to_spinnaker;
  wire [6:0]data_2of7_from_spinnaker;
  wire [6:0]data_2of7_to_spinnaker;

  // ZTURN on board switches

  ad_iobuf #(
    .DATA_WIDTH(5) 
  ) gpio_buf (
      .dio_t(gpio_0_tri_t[63:59]),
      .dio_i(gpio_0_tri_o[63:59]),
      .dio_o(gpio_0_tri_i[63:59]),
      .dio_p({SW_3,BP,LEDB,LEDG,LEDR}));

  ad_iobuf #(
    .DATA_WIDTH(4) 
  ) gpio_zturngpio (
      .dio_t(gpio_0_tri_t[58:55]),
      .dio_i(gpio_0_tri_o[58:55]),
      .dio_o(gpio_0_tri_i[58:55]),
      .dio_p(zturngpio));
   
  IOBUF IIC_IMUEYE_scl_iobuf
       (.I(IIC_IMUEYE_scl_o),
        .IO(IIC_IMUEYE_scl_io),
        .O(IIC_IMUEYE_scl_i),
        .T(IIC_IMUEYE_scl_t));
  IOBUF IIC_IMUEYE_sda_iobuf
       (.I(IIC_IMUEYE_sda_o),
        .IO(IIC_IMUEYE_sda_io),
        .O(IIC_IMUEYE_sda_i),
        .T(IIC_IMUEYE_sda_t));

  IOBUF IIC_ZTURN_scl_iobuf
       (.I(IIC_ZTURN_scl_o),
        .IO(IIC_ZTURN_scl_io),
        .O(IIC_ZTURN_scl_i),
        .T(IIC_ZTURN_scl_t));
  IOBUF IIC_ZTURN_sda_iobuf
       (.I(IIC_ZTURN_sda_o),
        .IO(IIC_ZTURN_sda_io),
        .O(IIC_ZTURN_sda_i),
        .T(IIC_ZTURN_sda_t));

  system system_i
       (.DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .GPIO_0_tri_i(gpio_0_tri_i),
        .GPIO_0_tri_o(gpio_0_tri_o),
        .GPIO_0_tri_t(gpio_0_tri_t),
        .IIC_IMUEYE_scl_i(IIC_IMUEYE_scl_i),
        .IIC_IMUEYE_scl_o(IIC_IMUEYE_scl_o),
        .IIC_IMUEYE_scl_t(IIC_IMUEYE_scl_t),
        .IIC_IMUEYE_sda_i(IIC_IMUEYE_sda_i),
        .IIC_IMUEYE_sda_o(IIC_IMUEYE_sda_o),
        .IIC_IMUEYE_sda_t(IIC_IMUEYE_sda_t),
        .IIC_ZTURN_scl_i(IIC_ZTURN_scl_i),
        .IIC_ZTURN_scl_o(IIC_ZTURN_scl_o),
        .IIC_ZTURN_scl_t(IIC_ZTURN_scl_t),
        .IIC_ZTURN_sda_i(IIC_ZTURN_sda_i),
        .IIC_ZTURN_sda_o(IIC_ZTURN_sda_o),
        .IIC_ZTURN_sda_t(IIC_ZTURN_sda_t),
        .LpbkDefault_i(LpbkDefault_i),
        .MEMS_INTn(MEMS_INTn),
        .ack_from_spinnaker(ack_from_spinnaker),
        .ack_to_spinnaker(ack_to_spinnaker),
        .data_2of7_from_spinnaker(data_2of7_from_spinnaker),
        .data_2of7_to_spinnaker(data_2of7_to_spinnaker));
endmodule
