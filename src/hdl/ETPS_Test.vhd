library ieee;
  use ieee.std_logic_1164.all;

library unisim;
  use unisim.vcomponents.all;

entity ETPS_Test is
  port (
    DDR_addr                  : inout std_logic_vector ( 14 downto 0 );       
    DDR_ba                    : inout std_logic_vector ( 2 downto 0 );        
    DDR_cas_n                 : inout std_logic;                              
    DDR_ck_n                  : inout std_logic;                              
    DDR_ck_p                  : inout std_logic;                              
    DDR_cke                   : inout std_logic;                              
    DDR_cs_n                  : inout std_logic;                              
    DDR_dm                    : inout std_logic_vector ( 3 downto 0 );        
    DDR_dq                    : inout std_logic_vector ( 31 downto 0 );       
    DDR_dqs_n                 : inout std_logic_vector ( 3 downto 0 );        
    DDR_dqs_p                 : inout std_logic_vector ( 3 downto 0 );        
    DDR_odt                   : inout std_logic;                              
    DDR_ras_n                 : inout std_logic;                              
    DDR_reset_n               : inout std_logic;                              
    DDR_we_n                  : inout std_logic;                              
    FIXED_IO_ddr_vrn          : inout std_logic;                              
    FIXED_IO_ddr_vrp          : inout std_logic;                              
    FIXED_IO_mio              : inout std_logic_vector ( 53 downto 0 );       
    FIXED_IO_ps_clk           : inout std_logic;                              
    FIXED_IO_ps_porb          : inout std_logic;                              
    FIXED_IO_ps_srstb         : inout std_logic;                              
    LpbkDefault_i             : in std_logic_vector ( 2 downto 0 );           
    ack_from_spinnaker        : in std_logic;                                 
    ack_to_spinnaker          : out std_logic;                                
    data_2of7_from_spinnaker  : in std_logic_vector ( 6 downto 0 );           
    data_2of7_to_spinnaker    : out std_logic_vector ( 6 downto 0 );          
    led0                      : inout std_logic;                              
    led1                      : inout std_logic;                              
    led2                      : inout std_logic;                              
    led3                      : inout std_logic;                              
    led4                      : inout std_logic;                              
    led5                      : inout std_logic;                              
    led6                      : inout std_logic;                              
    led7                      : inout std_logic;                              
    zed_ena_1v8               : inout std_logic;                              
    zed_ena_3v3               : inout std_logic;                              
    zedgpio1                  : inout std_logic;                              
    zedgpio2                  : inout std_logic;                              
    zedgpio3                  : inout std_logic;                              
    zedgpio4                  : inout std_logic;                              
    btnl                      : inout std_logic;                              
    btnr                      : inout std_logic;                              
    btnu                      : inout std_logic;                              
    btnd                      : inout std_logic;                              
    btnc                      : inout std_logic;                              
    gpio_0_dummy_0            : inout std_logic;                              
    gpio_0_dummy_1            : inout std_logic;                              
    gpio_0_dummy_2            : inout std_logic                               
  );
end ETPS_Test;

architecture STRUCTURE of ETPS_Test is

component ETPS_Test_bd is
  port (
    LpbkDefault_i             : in std_logic_vector ( 2 downto 0 );              
    data_2of7_from_spinnaker  : in std_logic_vector ( 6 downto 0 );              
    ack_from_spinnaker        : in std_logic;                                    
    data_2of7_to_spinnaker    : out std_logic_vector ( 6 downto 0 );             
    ack_to_spinnaker          : out std_logic;                                   
    FIXED_IO_mio              : inout std_logic_vector ( 53 downto 0 );          
    FIXED_IO_ddr_vrn          : inout std_logic;                                 
    FIXED_IO_ddr_vrp          : inout std_logic;                                 
    FIXED_IO_ps_srstb         : inout std_logic;                                 
    FIXED_IO_ps_clk           : inout std_logic;                                 
    FIXED_IO_ps_porb          : inout std_logic;                                 
    GPIO_0_tri_i              : in std_logic_vector ( 21 downto 0 );             
    GPIO_0_tri_o              : out std_logic_vector ( 21 downto 0 );            
    GPIO_0_tri_t              : out std_logic_vector ( 21 downto 0 );            
    DDR_cas_n                 : inout std_logic;                                 
    DDR_cke                   : inout std_logic;                                 
    DDR_ck_n                  : inout std_logic;                                 
    DDR_ck_p                  : inout std_logic;                                 
    DDR_cs_n                  : inout std_logic;                                 
    DDR_reset_n               : inout std_logic;                                 
    DDR_odt                   : inout std_logic;                                 
    DDR_ras_n                 : inout std_logic;                                 
    DDR_we_n                  : inout std_logic;                                 
    DDR_ba                    : inout std_logic_vector ( 2 downto 0 );           
    DDR_addr                  : inout std_logic_vector ( 14 downto 0 );          
    DDR_dm                    : inout std_logic_vector ( 3 downto 0 );           
    DDR_dq                    : inout std_logic_vector ( 31 downto 0 );          
    DDR_dqs_n                 : inout std_logic_vector ( 3 downto 0 );           
    DDR_dqs_p                 : inout std_logic_vector ( 3 downto 0 )            
  );
  end component ETPS_Test_bd;
  
component IOBUF is
  port (
    I   : in std_logic;   
    O   : out std_logic;  
    T   : in std_logic;   
    IO  : inout std_logic 
  );
  end component IOBUF;
  
  
  signal GPIO_0_tri_i_0   : std_logic_vector ( 0 to 0 );                               
  signal GPIO_0_tri_i_1   : std_logic_vector ( 1 to 1 );                               
  signal GPIO_0_tri_i_10  : std_logic_vector ( 10 to 10 );                             
  signal GPIO_0_tri_i_11  : std_logic_vector ( 11 to 11 );                             
  signal GPIO_0_tri_i_12  : std_logic_vector ( 12 to 12 );                             
  signal GPIO_0_tri_i_13  : std_logic_vector ( 13 to 13 );                             
  signal GPIO_0_tri_i_14  : std_logic_vector ( 14 to 14 );                             
  signal GPIO_0_tri_i_15  : std_logic_vector ( 15 to 15 );                             
  signal GPIO_0_tri_i_16  : std_logic_vector ( 16 to 16 );                             
  signal GPIO_0_tri_i_17  : std_logic_vector ( 17 to 17 );                             
  signal GPIO_0_tri_i_18  : std_logic_vector ( 18 to 18 );                             
  signal GPIO_0_tri_i_19  : std_logic_vector ( 19 to 19 );                             
  signal GPIO_0_tri_i_2   : std_logic_vector ( 2 to 2 );                               
  signal GPIO_0_tri_i_20  : std_logic_vector ( 20 to 20 );                             
  signal GPIO_0_tri_i_21  : std_logic_vector ( 21 to 21 );                             
  signal GPIO_0_tri_i_3   : std_logic_vector ( 3 to 3 );                               
  signal GPIO_0_tri_i_4   : std_logic_vector ( 4 to 4 );                               
  signal GPIO_0_tri_i_5   : std_logic_vector ( 5 to 5 );                               
  signal GPIO_0_tri_i_6   : std_logic_vector ( 6 to 6 );                               
  signal GPIO_0_tri_i_7   : std_logic_vector ( 7 to 7 );                               
  signal GPIO_0_tri_i_8   : std_logic_vector ( 8 to 8 );                               
  signal GPIO_0_tri_i_9   : std_logic_vector ( 9 to 9 );                               
  signal GPIO_0_tri_io_0  : std_logic_vector ( 0 to 0 );                               
  signal GPIO_0_tri_io_1  : std_logic_vector ( 1 to 1 );                               
  signal GPIO_0_tri_io_10 : std_logic_vector ( 10 to 10 );                             
  signal GPIO_0_tri_io_11 : std_logic_vector ( 11 to 11 );                             
  signal GPIO_0_tri_io_12 : std_logic_vector ( 12 to 12 );                             
  signal GPIO_0_tri_io_13 : std_logic_vector ( 13 to 13 );                             
  signal GPIO_0_tri_io_14 : std_logic_vector ( 14 to 14 );                             
  signal GPIO_0_tri_io_15 : std_logic_vector ( 15 to 15 );                             
  signal GPIO_0_tri_io_16 : std_logic_vector ( 16 to 16 );                             
  signal GPIO_0_tri_io_17 : std_logic_vector ( 17 to 17 );                             
  signal GPIO_0_tri_io_18 : std_logic_vector ( 18 to 18 );                             
  signal GPIO_0_tri_io_19 : std_logic_vector ( 19 to 19 );                             
  signal GPIO_0_tri_io_2  : std_logic_vector ( 2 to 2 );                               
  signal GPIO_0_tri_io_20 : std_logic_vector ( 20 to 20 );                             
  signal GPIO_0_tri_io_21 : std_logic_vector ( 21 to 21 );                             
  signal GPIO_0_tri_io_3  : std_logic_vector ( 3 to 3 );                               
  signal GPIO_0_tri_io_4  : std_logic_vector ( 4 to 4 );                               
  signal GPIO_0_tri_io_5  : std_logic_vector ( 5 to 5 );                               
  signal GPIO_0_tri_io_6  : std_logic_vector ( 6 to 6 );                               
  signal GPIO_0_tri_io_7  : std_logic_vector ( 7 to 7 );                               
  signal GPIO_0_tri_io_8  : std_logic_vector ( 8 to 8 );                               
  signal GPIO_0_tri_io_9  : std_logic_vector ( 9 to 9 );                               
  signal GPIO_0_tri_o_0   : std_logic_vector ( 0 to 0 );                               
  signal GPIO_0_tri_o_1   : std_logic_vector ( 1 to 1 );                               
  signal GPIO_0_tri_o_10  : std_logic_vector ( 10 to 10 );                             
  signal GPIO_0_tri_o_11  : std_logic_vector ( 11 to 11 );                             
  signal GPIO_0_tri_o_12  : std_logic_vector ( 12 to 12 );                             
  signal GPIO_0_tri_o_13  : std_logic_vector ( 13 to 13 );                             
  signal GPIO_0_tri_o_14  : std_logic_vector ( 14 to 14 );                             
  signal GPIO_0_tri_o_15  : std_logic_vector ( 15 to 15 );                             
  signal GPIO_0_tri_o_16  : std_logic_vector ( 16 to 16 );                             
  signal GPIO_0_tri_o_17  : std_logic_vector ( 17 to 17 );                             
  signal GPIO_0_tri_o_18  : std_logic_vector ( 18 to 18 );                             
  signal GPIO_0_tri_o_19  : std_logic_vector ( 19 to 19 );                             
  signal GPIO_0_tri_o_2   : std_logic_vector ( 2 to 2 );                               
  signal GPIO_0_tri_o_20  : std_logic_vector ( 20 to 20 );                             
  signal GPIO_0_tri_o_21  : std_logic_vector ( 21 to 21 );                             
  signal GPIO_0_tri_o_3   : std_logic_vector ( 3 to 3 );                               
  signal GPIO_0_tri_o_4   : std_logic_vector ( 4 to 4 );                               
  signal GPIO_0_tri_o_5   : std_logic_vector ( 5 to 5 );                               
  signal GPIO_0_tri_o_6   : std_logic_vector ( 6 to 6 );                               
  signal GPIO_0_tri_o_7   : std_logic_vector ( 7 to 7 );                               
  signal GPIO_0_tri_o_8   : std_logic_vector ( 8 to 8 );                               
  signal GPIO_0_tri_o_9   : std_logic_vector ( 9 to 9 );                               
  signal GPIO_0_tri_t_0   : std_logic_vector ( 0 to 0 );                               
  signal GPIO_0_tri_t_1   : std_logic_vector ( 1 to 1 );                               
  signal GPIO_0_tri_t_10  : std_logic_vector ( 10 to 10 );                             
  signal GPIO_0_tri_t_11  : std_logic_vector ( 11 to 11 );                             
  signal GPIO_0_tri_t_12  : std_logic_vector ( 12 to 12 );                             
  signal GPIO_0_tri_t_13  : std_logic_vector ( 13 to 13 );                             
  signal GPIO_0_tri_t_14  : std_logic_vector ( 14 to 14 );                             
  signal GPIO_0_tri_t_15  : std_logic_vector ( 15 to 15 );                             
  signal GPIO_0_tri_t_16  : std_logic_vector ( 16 to 16 );                             
  signal GPIO_0_tri_t_17  : std_logic_vector ( 17 to 17 );                             
  signal GPIO_0_tri_t_18  : std_logic_vector ( 18 to 18 );                             
  signal GPIO_0_tri_t_19  : std_logic_vector ( 19 to 19 );                             
  signal GPIO_0_tri_t_2   : std_logic_vector ( 2 to 2 );                               
  signal GPIO_0_tri_t_20  : std_logic_vector ( 20 to 20 );                             
  signal GPIO_0_tri_t_21  : std_logic_vector ( 21 to 21 );                             
  signal GPIO_0_tri_t_3   : std_logic_vector ( 3 to 3 );                               
  signal GPIO_0_tri_t_4   : std_logic_vector ( 4 to 4 );                               
  signal GPIO_0_tri_t_5   : std_logic_vector ( 5 to 5 );                               
  signal GPIO_0_tri_t_6   : std_logic_vector ( 6 to 6 );                               
  signal GPIO_0_tri_t_7   : std_logic_vector ( 7 to 7 );                               
  signal GPIO_0_tri_t_8   : std_logic_vector ( 8 to 8 );                               
  signal GPIO_0_tri_t_9   : std_logic_vector ( 9 to 9 );                               
begin
ETPS_Test_bd_i: component ETPS_Test_bd
     port map (
      DDR_addr(14 downto 0)                 => DDR_addr(14 downto 0),
      DDR_ba(2 downto 0)                    => DDR_ba(2 downto 0),
      DDR_cas_n                             => DDR_cas_n,
      DDR_ck_n                              => DDR_ck_n,
      DDR_ck_p                              => DDR_ck_p,
      DDR_cke                               => DDR_cke,
      DDR_cs_n                              => DDR_cs_n,
      DDR_dm(3 downto 0)                    => DDR_dm(3 downto 0),
      DDR_dq(31 downto 0)                   => DDR_dq(31 downto 0),
      DDR_dqs_n(3 downto 0)                 => DDR_dqs_n(3 downto 0),
      DDR_dqs_p(3 downto 0)                 => DDR_dqs_p(3 downto 0),
      DDR_odt                               => DDR_odt,
      DDR_ras_n                             => DDR_ras_n,
      DDR_reset_n                           => DDR_reset_n,
      DDR_we_n                              => DDR_we_n,
      FIXED_IO_ddr_vrn                      => FIXED_IO_ddr_vrn,
      FIXED_IO_ddr_vrp                      => FIXED_IO_ddr_vrp,
      FIXED_IO_mio(53 downto 0)             => FIXED_IO_mio(53 downto 0),
      FIXED_IO_ps_clk                       => FIXED_IO_ps_clk,
      FIXED_IO_ps_porb                      => FIXED_IO_ps_porb,
      FIXED_IO_ps_srstb                     => FIXED_IO_ps_srstb,
      GPIO_0_tri_i(21)                      => GPIO_0_tri_i_21(21),
      GPIO_0_tri_i(20)                      => GPIO_0_tri_i_20(20),
      GPIO_0_tri_i(19)                      => GPIO_0_tri_i_19(19),
      GPIO_0_tri_i(18)                      => GPIO_0_tri_i_18(18),
      GPIO_0_tri_i(17)                      => GPIO_0_tri_i_17(17),
      GPIO_0_tri_i(16)                      => GPIO_0_tri_i_16(16),
      GPIO_0_tri_i(15)                      => GPIO_0_tri_i_15(15),
      GPIO_0_tri_i(14)                      => GPIO_0_tri_i_14(14),
      GPIO_0_tri_i(13)                      => GPIO_0_tri_i_13(13),
      GPIO_0_tri_i(12)                      => GPIO_0_tri_i_12(12),
      GPIO_0_tri_i(11)                      => GPIO_0_tri_i_11(11),
      GPIO_0_tri_i(10)                      => GPIO_0_tri_i_10(10),
      GPIO_0_tri_i(9)                       => GPIO_0_tri_i_9(9),
      GPIO_0_tri_i(8)                       => GPIO_0_tri_i_8(8),
      GPIO_0_tri_i(7)                       => GPIO_0_tri_i_7(7),
      GPIO_0_tri_i(6)                       => GPIO_0_tri_i_6(6),
      GPIO_0_tri_i(5)                       => GPIO_0_tri_i_5(5),
      GPIO_0_tri_i(4)                       => GPIO_0_tri_i_4(4),
      GPIO_0_tri_i(3)                       => GPIO_0_tri_i_3(3),
      GPIO_0_tri_i(2)                       => GPIO_0_tri_i_2(2),
      GPIO_0_tri_i(1)                       => GPIO_0_tri_i_1(1),
      GPIO_0_tri_i(0)                       => GPIO_0_tri_i_0(0),
      GPIO_0_tri_o(21)                      => GPIO_0_tri_o_21(21),
      GPIO_0_tri_o(20)                      => GPIO_0_tri_o_20(20),
      GPIO_0_tri_o(19)                      => GPIO_0_tri_o_19(19),
      GPIO_0_tri_o(18)                      => GPIO_0_tri_o_18(18),
      GPIO_0_tri_o(17)                      => GPIO_0_tri_o_17(17),
      GPIO_0_tri_o(16)                      => GPIO_0_tri_o_16(16),
      GPIO_0_tri_o(15)                      => GPIO_0_tri_o_15(15),
      GPIO_0_tri_o(14)                      => GPIO_0_tri_o_14(14),
      GPIO_0_tri_o(13)                      => GPIO_0_tri_o_13(13),
      GPIO_0_tri_o(12)                      => GPIO_0_tri_o_12(12),
      GPIO_0_tri_o(11)                      => GPIO_0_tri_o_11(11),
      GPIO_0_tri_o(10)                      => GPIO_0_tri_o_10(10),
      GPIO_0_tri_o(9)                       => GPIO_0_tri_o_9(9),
      GPIO_0_tri_o(8)                       => GPIO_0_tri_o_8(8),
      GPIO_0_tri_o(7)                       => GPIO_0_tri_o_7(7),
      GPIO_0_tri_o(6)                       => GPIO_0_tri_o_6(6),
      GPIO_0_tri_o(5)                       => GPIO_0_tri_o_5(5),
      GPIO_0_tri_o(4)                       => GPIO_0_tri_o_4(4),
      GPIO_0_tri_o(3)                       => GPIO_0_tri_o_3(3),
      GPIO_0_tri_o(2)                       => GPIO_0_tri_o_2(2),
      GPIO_0_tri_o(1)                       => GPIO_0_tri_o_1(1),
      GPIO_0_tri_o(0)                       => GPIO_0_tri_o_0(0),
      GPIO_0_tri_t(21)                      => GPIO_0_tri_t_21(21),
      GPIO_0_tri_t(20)                      => GPIO_0_tri_t_20(20),
      GPIO_0_tri_t(19)                      => GPIO_0_tri_t_19(19),
      GPIO_0_tri_t(18)                      => GPIO_0_tri_t_18(18),
      GPIO_0_tri_t(17)                      => GPIO_0_tri_t_17(17),
      GPIO_0_tri_t(16)                      => GPIO_0_tri_t_16(16),
      GPIO_0_tri_t(15)                      => GPIO_0_tri_t_15(15),
      GPIO_0_tri_t(14)                      => GPIO_0_tri_t_14(14),
      GPIO_0_tri_t(13)                      => GPIO_0_tri_t_13(13),
      GPIO_0_tri_t(12)                      => GPIO_0_tri_t_12(12),
      GPIO_0_tri_t(11)                      => GPIO_0_tri_t_11(11),
      GPIO_0_tri_t(10)                      => GPIO_0_tri_t_10(10),
      GPIO_0_tri_t(9)                       => GPIO_0_tri_t_9(9),
      GPIO_0_tri_t(8)                       => GPIO_0_tri_t_8(8),
      GPIO_0_tri_t(7)                       => GPIO_0_tri_t_7(7),
      GPIO_0_tri_t(6)                       => GPIO_0_tri_t_6(6),
      GPIO_0_tri_t(5)                       => GPIO_0_tri_t_5(5),
      GPIO_0_tri_t(4)                       => GPIO_0_tri_t_4(4),
      GPIO_0_tri_t(3)                       => GPIO_0_tri_t_3(3),
      GPIO_0_tri_t(2)                       => GPIO_0_tri_t_2(2),
      GPIO_0_tri_t(1)                       => GPIO_0_tri_t_1(1),
      GPIO_0_tri_t(0)                       => GPIO_0_tri_t_0(0),
      LpbkDefault_i(2 downto 0)             => LpbkDefault_i(2 downto 0),
      ack_from_spinnaker                    => ack_from_spinnaker,
      ack_to_spinnaker                      => ack_to_spinnaker,
      data_2of7_from_spinnaker(6 downto 0)  => data_2of7_from_spinnaker(6 downto 0),
      data_2of7_to_spinnaker(6 downto 0)    => data_2of7_to_spinnaker(6 downto 0)
    );
    
GPIO_0_tri_iobuf_0: component IOBUF
     port map (
      I => GPIO_0_tri_o_0(0),
      IO => gpio_0_dummy_0,
      O => GPIO_0_tri_i_0(0),
      T => GPIO_0_tri_t_0(0)
    );
GPIO_0_tri_iobuf_1: component IOBUF
     port map (
      I => GPIO_0_tri_o_1(1),
      IO => led0,
      O => GPIO_0_tri_i_1(1),
      T => GPIO_0_tri_t_1(1)
    );
GPIO_0_tri_iobuf_2: component IOBUF
     port map (
      I => GPIO_0_tri_o_2(2),
      IO => led1,
      O => GPIO_0_tri_i_2(2),
      T => GPIO_0_tri_t_2(2)
    );
GPIO_0_tri_iobuf_3: component IOBUF
     port map (
      I => GPIO_0_tri_o_3(3),
      IO => led2,
      O => GPIO_0_tri_i_3(3),
      T => GPIO_0_tri_t_3(3)
    );
GPIO_0_tri_iobuf_4: component IOBUF
     port map (
      I => GPIO_0_tri_o_4(4),
      IO => led3,
      O => GPIO_0_tri_i_4(4),
      T => GPIO_0_tri_t_4(4)
    );
GPIO_0_tri_iobuf_5: component IOBUF
     port map (
      I => GPIO_0_tri_o_5(5),
      IO => led4,
      O => GPIO_0_tri_i_5(5),
      T => GPIO_0_tri_t_5(5)
    );
GPIO_0_tri_iobuf_6: component IOBUF
     port map (
      I => GPIO_0_tri_o_6(6),
      IO => led5,
      O => GPIO_0_tri_i_6(6),
      T => GPIO_0_tri_t_6(6)
    );
GPIO_0_tri_iobuf_7: component IOBUF
     port map (
      I => GPIO_0_tri_o_7(7),
      IO => led6,
      O => GPIO_0_tri_i_7(7),
      T => GPIO_0_tri_t_7(7)
    );
GPIO_0_tri_iobuf_8: component IOBUF
     port map (
      I => GPIO_0_tri_o_8(8),
      IO => led7,
      O => GPIO_0_tri_i_8(8),
      T => GPIO_0_tri_t_8(8)
    );
GPIO_0_tri_iobuf_9: component IOBUF
     port map (
      I => GPIO_0_tri_o_9(9),
      IO => btnu,
      O => GPIO_0_tri_i_9(9),
      T => GPIO_0_tri_t_9(9)
    );    
GPIO_0_tri_iobuf_10: component IOBUF
     port map (
      I => GPIO_0_tri_o_10(10),
      IO => btnr,
      O => GPIO_0_tri_i_10(10),
      T => GPIO_0_tri_t_10(10)
    );
GPIO_0_tri_iobuf_11: component IOBUF
     port map (
      I => GPIO_0_tri_o_11(11),
      IO => btnl,
      O => GPIO_0_tri_i_11(11),
      T => GPIO_0_tri_t_11(11)
    );
GPIO_0_tri_iobuf_12: component IOBUF
     port map (
      I => GPIO_0_tri_o_12(12),
      IO => btnd,
      O => GPIO_0_tri_i_12(12),
      T => GPIO_0_tri_t_12(12)
    );
GPIO_0_tri_iobuf_13: component IOBUF
     port map (
      I => GPIO_0_tri_o_13(13),
      IO => btnc,
      O => GPIO_0_tri_i_13(13),
      T => GPIO_0_tri_t_13(13)
    );
GPIO_0_tri_iobuf_14: component IOBUF
     port map (
      I => GPIO_0_tri_o_14(14),
      IO => zedgpio1,
      O => GPIO_0_tri_i_14(14),
      T => GPIO_0_tri_t_14(14)
    );
GPIO_0_tri_iobuf_15: component IOBUF
     port map (
      I => GPIO_0_tri_o_15(15),
      IO => zedgpio2,
      O => GPIO_0_tri_i_15(15),
      T => GPIO_0_tri_t_15(15)
    );
GPIO_0_tri_iobuf_16: component IOBUF
     port map (
      I => GPIO_0_tri_o_16(16),
      IO => zed_ena_1v8,
      O => GPIO_0_tri_i_16(16),
      T => GPIO_0_tri_t_16(16)
    );
GPIO_0_tri_iobuf_17: component IOBUF
     port map (
      I => GPIO_0_tri_o_17(17),
      IO => zed_ena_3v3,
      O => GPIO_0_tri_i_17(17),
      T => GPIO_0_tri_t_17(17)
    );
GPIO_0_tri_iobuf_18: component IOBUF
     port map (
      I => GPIO_0_tri_o_18(18),
      IO => gpio_0_dummy_1,
      O => GPIO_0_tri_i_18(18),
      T => GPIO_0_tri_t_18(18)
    );
GPIO_0_tri_iobuf_19: component IOBUF
     port map (
      I => GPIO_0_tri_o_19(19),
      IO => gpio_0_dummy_2,
      O => GPIO_0_tri_i_19(19),
      T => GPIO_0_tri_t_19(19)
    );
GPIO_0_tri_iobuf_20: component IOBUF
     port map (
      I => GPIO_0_tri_o_20(20),
      IO => zedgpio3,
      O => GPIO_0_tri_i_20(20),
      T => GPIO_0_tri_t_20(20)
    );
GPIO_0_tri_iobuf_21: component IOBUF
     port map (
      I => GPIO_0_tri_o_21(21),
      IO => zedgpio4,
      O => GPIO_0_tri_i_21(21),
      T => GPIO_0_tri_t_21(21)
    );

end structure;
