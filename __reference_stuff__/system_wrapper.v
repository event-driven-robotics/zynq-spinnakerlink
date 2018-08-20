//Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2014.4 (lin64) Build 1071353 Tue Nov 18 16:47:07 MST 2014
//Date        : Fri Jul 10 14:15:06 2015
//Host        : IITiCubXilinx2-VM running 64-bit Ubuntu 14.04.2 LTS
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
    LpbkDefault_i,
    ack_from_spinnaker,
    ack_to_spinnaker,
    data_2of7_from_spinnaker,
    data_2of7_to_spinnaker,
    led0,
    led1,
    led2,
    led3,
    led4,
    led5,
    led6,
    led7,
    zed_ena_1v8,
    zed_ena_3v3,
    zedgpio1,
    zedgpio2,
    zedgpio3,
    zedgpio4,
    btnl,
    btnr,
    btnu,
    btnd,
    btnc,
    gpio_0_dummy_0,
    gpio_0_dummy_1,
    gpio_0_dummy_2);

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
  input [2:0]LpbkDefault_i;
  input ack_from_spinnaker;
  output ack_to_spinnaker;
  input [6:0]data_2of7_from_spinnaker;
  output [6:0]data_2of7_to_spinnaker;
  inout led0;
  inout led1;
  inout led2;
  inout led3;
  inout led4;
  inout led5;
  inout led6;
  inout led7;
  inout zed_ena_1v8;
  inout zed_ena_3v3;
  inout zedgpio1;
  inout zedgpio2;
  inout zedgpio3;
  inout zedgpio4;
  inout btnl;
  inout btnr;
  inout btnu;
  inout btnd;
  inout btnc;
  inout gpio_0_dummy_0;
  inout gpio_0_dummy_1;
  inout gpio_0_dummy_2;

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
  wire [2:0]LpbkDefault_i;
  wire ack_from_spinnaker;
  wire ack_to_spinnaker;
  wire [6:0]data_2of7_from_spinnaker;
  wire [6:0]data_2of7_to_spinnaker;
  wire [0:0]gpio_0_tri_i_0;
  wire [1:1]gpio_0_tri_i_1;
  wire [10:10]gpio_0_tri_i_10;
  wire [11:11]gpio_0_tri_i_11;
  wire [12:12]gpio_0_tri_i_12;
  wire [13:13]gpio_0_tri_i_13;
  wire [14:14]gpio_0_tri_i_14;
  wire [15:15]gpio_0_tri_i_15;
  wire [16:16]gpio_0_tri_i_16;
  wire [17:17]gpio_0_tri_i_17;
  wire [18:18]gpio_0_tri_i_18;
  wire [19:19]gpio_0_tri_i_19;
  wire [2:2]gpio_0_tri_i_2;
  wire [20:20]gpio_0_tri_i_20;
  wire [21:21]gpio_0_tri_i_21;
  wire [3:3]gpio_0_tri_i_3;
  wire [4:4]gpio_0_tri_i_4;
  wire [5:5]gpio_0_tri_i_5;
  wire [6:6]gpio_0_tri_i_6;
  wire [7:7]gpio_0_tri_i_7;
  wire [8:8]gpio_0_tri_i_8;
  wire [9:9]gpio_0_tri_i_9;
  wire [0:0]gpio_0_tri_io_0;
  wire [1:1]gpio_0_tri_io_1;
  wire [10:10]gpio_0_tri_io_10;
  wire [11:11]gpio_0_tri_io_11;
  wire [12:12]gpio_0_tri_io_12;
  wire [13:13]gpio_0_tri_io_13;
  wire [14:14]gpio_0_tri_io_14;
  wire [15:15]gpio_0_tri_io_15;
  wire [16:16]gpio_0_tri_io_16;
  wire [17:17]gpio_0_tri_io_17;
  wire [18:18]gpio_0_tri_io_18;
  wire [19:19]gpio_0_tri_io_19;
  wire [2:2]gpio_0_tri_io_2;
  wire [20:20]gpio_0_tri_io_20;
  wire [21:21]gpio_0_tri_io_21;
  wire [3:3]gpio_0_tri_io_3;
  wire [4:4]gpio_0_tri_io_4;
  wire [5:5]gpio_0_tri_io_5;
  wire [6:6]gpio_0_tri_io_6;
  wire [7:7]gpio_0_tri_io_7;
  wire [8:8]gpio_0_tri_io_8;
  wire [9:9]gpio_0_tri_io_9;
  wire [0:0]gpio_0_tri_o_0;
  wire [1:1]gpio_0_tri_o_1;
  wire [10:10]gpio_0_tri_o_10;
  wire [11:11]gpio_0_tri_o_11;
  wire [12:12]gpio_0_tri_o_12;
  wire [13:13]gpio_0_tri_o_13;
  wire [14:14]gpio_0_tri_o_14;
  wire [15:15]gpio_0_tri_o_15;
  wire [16:16]gpio_0_tri_o_16;
  wire [17:17]gpio_0_tri_o_17;
  wire [18:18]gpio_0_tri_o_18;
  wire [19:19]gpio_0_tri_o_19;
  wire [2:2]gpio_0_tri_o_2;
  wire [20:20]gpio_0_tri_o_20;
  wire [21:21]gpio_0_tri_o_21;
  wire [3:3]gpio_0_tri_o_3;
  wire [4:4]gpio_0_tri_o_4;
  wire [5:5]gpio_0_tri_o_5;
  wire [6:6]gpio_0_tri_o_6;
  wire [7:7]gpio_0_tri_o_7;
  wire [8:8]gpio_0_tri_o_8;
  wire [9:9]gpio_0_tri_o_9;
  wire [0:0]gpio_0_tri_t_0;
  wire [1:1]gpio_0_tri_t_1;
  wire [10:10]gpio_0_tri_t_10;
  wire [11:11]gpio_0_tri_t_11;
  wire [12:12]gpio_0_tri_t_12;
  wire [13:13]gpio_0_tri_t_13;
  wire [14:14]gpio_0_tri_t_14;
  wire [15:15]gpio_0_tri_t_15;
  wire [16:16]gpio_0_tri_t_16;
  wire [17:17]gpio_0_tri_t_17;
  wire [18:18]gpio_0_tri_t_18;
  wire [19:19]gpio_0_tri_t_19;
  wire [2:2]gpio_0_tri_t_2;
  wire [20:20]gpio_0_tri_t_20;
  wire [21:21]gpio_0_tri_t_21;
  wire [3:3]gpio_0_tri_t_3;
  wire [4:4]gpio_0_tri_t_4;
  wire [5:5]gpio_0_tri_t_5;
  wire [6:6]gpio_0_tri_t_6;
  wire [7:7]gpio_0_tri_t_7;
  wire [8:8]gpio_0_tri_t_8;
  wire [9:9]gpio_0_tri_t_9;

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
        .GPIO_0_tri_i({gpio_0_tri_i_21,gpio_0_tri_i_20,gpio_0_tri_i_19,gpio_0_tri_i_18,gpio_0_tri_i_17,gpio_0_tri_i_16,gpio_0_tri_i_15,gpio_0_tri_i_14,gpio_0_tri_i_13,gpio_0_tri_i_12,gpio_0_tri_i_11,gpio_0_tri_i_10,gpio_0_tri_i_9,gpio_0_tri_i_8,gpio_0_tri_i_7,gpio_0_tri_i_6,gpio_0_tri_i_5,gpio_0_tri_i_4,gpio_0_tri_i_3,gpio_0_tri_i_2,gpio_0_tri_i_1,gpio_0_tri_i_0}),
        .GPIO_0_tri_o({gpio_0_tri_o_21,gpio_0_tri_o_20,gpio_0_tri_o_19,gpio_0_tri_o_18,gpio_0_tri_o_17,gpio_0_tri_o_16,gpio_0_tri_o_15,gpio_0_tri_o_14,gpio_0_tri_o_13,gpio_0_tri_o_12,gpio_0_tri_o_11,gpio_0_tri_o_10,gpio_0_tri_o_9,gpio_0_tri_o_8,gpio_0_tri_o_7,gpio_0_tri_o_6,gpio_0_tri_o_5,gpio_0_tri_o_4,gpio_0_tri_o_3,gpio_0_tri_o_2,gpio_0_tri_o_1,gpio_0_tri_o_0}),
        .GPIO_0_tri_t({gpio_0_tri_t_21,gpio_0_tri_t_20,gpio_0_tri_t_19,gpio_0_tri_t_18,gpio_0_tri_t_17,gpio_0_tri_t_16,gpio_0_tri_t_15,gpio_0_tri_t_14,gpio_0_tri_t_13,gpio_0_tri_t_12,gpio_0_tri_t_11,gpio_0_tri_t_10,gpio_0_tri_t_9,gpio_0_tri_t_8,gpio_0_tri_t_7,gpio_0_tri_t_6,gpio_0_tri_t_5,gpio_0_tri_t_4,gpio_0_tri_t_3,gpio_0_tri_t_2,gpio_0_tri_t_1,gpio_0_tri_t_0}),
        .LpbkDefault_i(LpbkDefault_i),
        .ack_from_spinnaker(ack_from_spinnaker),
        .ack_to_spinnaker(ack_to_spinnaker),
        .data_2of7_from_spinnaker(data_2of7_from_spinnaker),
        .data_2of7_to_spinnaker(data_2of7_to_spinnaker));

IOBUF gpio_0_tri_iobuf_0
       (.I(gpio_0_tri_o_0),
        .IO(gpio_0_dummy_0),
        .O(gpio_0_tri_i_0),
        .T(gpio_0_tri_t_0));
IOBUF gpio_0_tri_iobuf_1
       (.I(gpio_0_tri_o_1),
        .IO(led0),
        .O(gpio_0_tri_i_1),
        .T(gpio_0_tri_t_1));
IOBUF gpio_0_tri_iobuf_10
       (.I(gpio_0_tri_o_10),
        .IO(btnr),
        .O(gpio_0_tri_i_10),
        .T(gpio_0_tri_t_10));
IOBUF gpio_0_tri_iobuf_11
       (.I(gpio_0_tri_o_11),
        .IO(btnl),
        .O(gpio_0_tri_i_11),
        .T(gpio_0_tri_t_11));
IOBUF gpio_0_tri_iobuf_12
       (.I(gpio_0_tri_o_12),
        .IO(btnd),
        .O(gpio_0_tri_i_12),
        .T(gpio_0_tri_t_12));
IOBUF gpio_0_tri_iobuf_13
       (.I(gpio_0_tri_o_13),
        .IO(btnc),
        .O(gpio_0_tri_i_13),
        .T(gpio_0_tri_t_13));
IOBUF gpio_0_tri_iobuf_14
       (.I(gpio_0_tri_o_14),
        .IO(zedgpio1),
        .O(gpio_0_tri_i_14),
        .T(gpio_0_tri_t_14));
IOBUF gpio_0_tri_iobuf_15
       (.I(gpio_0_tri_o_15),
        .IO(zedgpio2),
        .O(gpio_0_tri_i_15),
        .T(gpio_0_tri_t_15));
IOBUF gpio_0_tri_iobuf_16
       (.I(gpio_0_tri_o_16),
        .IO(zed_ena_1v8),
        .O(gpio_0_tri_i_16),
        .T(gpio_0_tri_t_16));
IOBUF gpio_0_tri_iobuf_17
       (.I(gpio_0_tri_o_17),
        .IO(zed_ena_3v3),
        .O(gpio_0_tri_i_17),
        .T(gpio_0_tri_t_17));
IOBUF gpio_0_tri_iobuf_18
       (.I(gpio_0_tri_o_18),
        .IO(gpio_0_dummy_1),
        .O(gpio_0_tri_i_18),
        .T(gpio_0_tri_t_18));
IOBUF gpio_0_tri_iobuf_19
       (.I(gpio_0_tri_o_19),
        .IO(gpio_0_dummy_2),
        .O(gpio_0_tri_i_19),
        .T(gpio_0_tri_t_19));
IOBUF gpio_0_tri_iobuf_2
       (.I(gpio_0_tri_o_2),
        .IO(led1),
        .O(gpio_0_tri_i_2),
        .T(gpio_0_tri_t_2));
IOBUF gpio_0_tri_iobuf_20
       (.I(gpio_0_tri_o_20),
        .IO(zedgpio3),
        .O(gpio_0_tri_i_20),
        .T(gpio_0_tri_t_20));
IOBUF gpio_0_tri_iobuf_21
       (.I(gpio_0_tri_o_21),
        .IO(zedgpio4),
        .O(gpio_0_tri_i_21),
        .T(gpio_0_tri_t_21));
IOBUF gpio_0_tri_iobuf_3
       (.I(gpio_0_tri_o_3),
        .IO(led2),
        .O(gpio_0_tri_i_3),
        .T(gpio_0_tri_t_3));
IOBUF gpio_0_tri_iobuf_4
       (.I(gpio_0_tri_o_4),
        .IO(led3),
        .O(gpio_0_tri_i_4),
        .T(gpio_0_tri_t_4));
IOBUF gpio_0_tri_iobuf_5
       (.I(gpio_0_tri_o_5),
        .IO(led4),
        .O(gpio_0_tri_i_5),
        .T(gpio_0_tri_t_5));
IOBUF gpio_0_tri_iobuf_6
       (.I(gpio_0_tri_o_6),
        .IO(led5),
        .O(gpio_0_tri_i_6),
        .T(gpio_0_tri_t_6));
IOBUF gpio_0_tri_iobuf_7
       (.I(gpio_0_tri_o_7),
        .IO(led6),
        .O(gpio_0_tri_i_7),
        .T(gpio_0_tri_t_7));
IOBUF gpio_0_tri_iobuf_8
       (.I(gpio_0_tri_o_8),
        .IO(led7),
        .O(gpio_0_tri_i_8),
        .T(gpio_0_tri_t_8));
IOBUF gpio_0_tri_iobuf_9
       (.I(gpio_0_tri_o_9),
        .IO(btnu),
        .O(gpio_0_tri_i_9),
        .T(gpio_0_tri_t_9));

endmodule
