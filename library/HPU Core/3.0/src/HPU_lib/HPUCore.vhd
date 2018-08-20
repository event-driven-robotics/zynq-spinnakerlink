-- ------------------------------------------------------------------------------
-- 
--  Revision 1.1:  07/25/2018
--  - Added SpiNNlink capabilities
--    (M. Casti - IIT)
--    
-- ------------------------------------------------------------------------------


library ieee;
    use ieee.std_logic_1164.all;

library HPU_lib;
    use HPU_lib.aer_pkg.all;
    use HPU_lib.HPUComponents_pkg.all;
    
library neuserial_lib;
    use neuserial_lib.NSComponents_pkg.all;


--****************************
--   PORT DECLARATION
--****************************
------------------------------------------------------------------------------
-- Definition of Generics:
--   C_S_AXI_DATA_WIDTH           -- AXI4LITE slave: Data width
--   C_S_AXI_ADDR_WIDTH           -- AXI4LITE slave: Address Width
--   C_S_AXI_MIN_SIZE             -- AXI4LITE slave: Min Size
--   C_USE_WSTRB                  -- AXI4LITE slave: Write Strobe
--   C_DPHASE_TIMEOUT             -- AXI4LITE slave: Data Phase Timeout
--   C_BASEADDR                   -- AXI4LITE slave: base address
--   C_HIGHADDR                   -- AXI4LITE slave: high address
--   C_FAMILY                     -- FPGA Family
--   C_NUM_REG                    -- Number of software accessible registers
--   C_NUM_MEM                    -- Number of address-ranges
--   C_SLV_AWIDTH                 -- Slave interface address bus width
--   C_SLV_DWIDTH                 -- Slave interface data bus width
--   C_M_AXI_LITE_ADDR_WIDTH      -- Master-Intf address bus width
--   C_M_AXI_LITE_DATA_WIDTH      -- Master-Intf data bus width
--
-- Definition of Ports:
--   S_AXI_ACLK                   -- AXI4LITE slave: Clock
--   S_AXI_ARESETN                -- AXI4LITE slave: Reset
--   S_AXI_AWADDR                 -- AXI4LITE slave: Write address
--   S_AXI_AWVALID                -- AXI4LITE slave: Write address valid
--   S_AXI_WDATA                  -- AXI4LITE slave: Write data
--   S_AXI_WSTRB                  -- AXI4LITE slave: Write strobe
--   S_AXI_WVALID                 -- AXI4LITE slave: Write data valid
--   S_AXI_BREADY                 -- AXI4LITE slave: Response ready
--   S_AXI_ARADDR                 -- AXI4LITE slave: Read address
--   S_AXI_ARVALID                -- AXI4LITE slave: Read address valid
--   S_AXI_RREADY                 -- AXI4LITE slave: Read data ready
--   S_AXI_ARREADY                -- AXI4LITE slave: read addres ready
--   S_AXI_RDATA                  -- AXI4LITE slave: Read data
--   S_AXI_RRESP                  -- AXI4LITE slave: Read data response
--   S_AXI_RVALID                 -- AXI4LITE slave: Read data valid
--   S_AXI_WREADY                 -- AXI4LITE slave: Write data ready
--   S_AXI_BRESP                  -- AXI4LITE slave: Response
--   S_AXI_BVALID                 -- AXI4LITE slave: Resonse valid
--   S_AXI_AWREADY                -- AXI4LITE slave: Wrte address ready
--   S_AXIS_TREADY                -- Stream I/f: Ready to accept data in
--   S_AXIS_TDATA                 -- Stream I/f: Data in
--   S_AXIS_TLAST                 -- Stream I/f: Optional data in qualifier
--   S_AXIS_TVALID                -- Stream I/f: Data in is valid
--   M_AXIS_TVALID                -- Stream I/f: Data out is valid
--   M_AXIS_TDATA                 -- Stream I/f: Data Out
--   M_AXIS_TLAST                 -- Stream I/f: Optional data out qualifier
--   M_AXIS_TREADY                -- Stream I/f: Connected slave device is ready to accept data out
------------------------------------------------------------------------------

entity HPUCore is
    generic (
        -- ADD USER GENERICS BELOW THIS LINE ---------------

        C_PAER_DSIZE               : natural range 1 to 29   := 24;
        C_RX_HAS_PAER              : boolean                 := true;
        C_RX_HAS_HSSAER            : boolean                 := true;
        C_RX_HSSAER_N_CHAN         : natural range 1 to 4    := 3;
        C_RX_HAS_GTP               : boolean                 := true;
        C_RX_HAS_SPNNLNK           : boolean                 := true;
        C_TX_HAS_PAER              : boolean                 := true;
        C_TX_HAS_HSSAER            : boolean                 := true;
        C_TX_HSSAER_N_CHAN         : natural range 1 to 4    := 2;
        C_TX_HAS_GTP               : boolean                 := true;
        C_TX_HAS_SPNNLNK           : boolean                 := true;
        C_PSPNNLNK_WIDTH		   : natural range 1 to 32   := 32;
        C_DEBUG                    : boolean                 := false;
		
        -- ADD USER GENERICS ABOVE THIS LINE ---------------

        -- DO NOT EDIT BELOW THIS LINE ---------------------
        -- Bus protocol parameters, do not add to or delete
        C_S_AXI_DATA_WIDTH             : integer              := 32;
        C_S_AXI_ADDR_WIDTH             : integer              := 7;
        C_S_AXI_MIN_SIZE               : std_logic_vector     := X"000001FF";
        C_USE_WSTRB                    : integer              := 1;
        C_DPHASE_TIMEOUT               : integer              := 8;
        C_BASEADDR                     : std_logic_vector     := X"FFFFFFFF";
        C_HIGHADDR                     : std_logic_vector     := X"00000000";
        C_FAMILY                       : string               := "virtex7";
        C_NUM_REG                      : integer              := 24;
        C_NUM_MEM                      : integer              := 1;
        C_SLV_AWIDTH                   : integer              := 32;
        C_SLV_DWIDTH                   : integer              := 32
        -- DO NOT EDIT ABOVE THIS LINE ---------------------
    );
    port (
        -- ADD USER PORTS BELOW THIS LINE ------------------

        -- SYNC Resetn
        nSyncReset        : in  std_logic := 'X';

        -- Clocks for HSSAER interface
        HSSAER_ClkLS_p    : in  std_logic := '0'; -- 100 Mhz clock p it must be at the same frequency of the clock of the transmitter
        HSSAER_ClkLS_n    : in  std_logic := '1'; -- 100 Mhz clock p it must be at the same frequency of the clock of the transmitter
        HSSAER_ClkHS_p    : in  std_logic := '0'; -- 300 Mhz clock p it must 3x HSSAER_ClkLS
        HSSAER_ClkHS_n    : in  std_logic := '1'; -- 300 Mhz clock p it must 3x HSSAER_ClkLS

        --============================================
        -- Rx Interface from Vision Sensor Controllers
        --============================================

        -- Left Sensor
        ------------------
        -- Parallel AER
        LRx_PAER_Addr_i           : in  std_logic_vector(C_PAER_DSIZE-1 downto 0) := (others => '0');
        LRx_PAER_Req_i            : in  std_logic := '0';
        LRx_PAER_Ack_o            : out std_logic;

        -- HSSAER interface
        LRx_HSSAER_i              : in  std_logic_vector(C_RX_HSSAER_N_CHAN-1 downto 0) := (others => '0');

        -- GTP interface


        -- Right Sensor
        ------------------
        -- Parallel AER
        RRx_PAER_Addr_i           : in  std_logic_vector(C_PAER_DSIZE-1 downto 0) := (others => '0');
        RRx_PAER_Req_i            : in  std_logic := '0';
        RRx_PAER_Ack_o            : out std_logic;

        -- HSSAER interface
        RRx_HSSAER_i              : in  std_logic_vector(C_RX_HSSAER_N_CHAN-1 downto 0) := (others => '0');

        -- GTP interface

        -- Aux Sensor
        ------------------
        -- Parallel AER
        AuxRx_PAER_Addr_i         : in  std_logic_vector(C_PAER_DSIZE-1 downto 0) := (others => '0');
        AuxRx_PAER_Req_i          : in  std_logic := '0';
        AuxRx_PAER_Ack_o          : out std_logic;

        -- HSSAER interface
        AuxRx_HSSAER_i            : in  std_logic_vector(C_RX_HSSAER_N_CHAN-1 downto 0) := (others => '0');

        -- GTP interface
        ---------------------

        -- SpiNNlink interface
        LRx_data_2of7_from_spinnaker_i   : in  std_logic_vector(6 downto 0) := (others => '0'); 
        LRx_ack_to_spinnaker_o           : out std_logic;
        RRx_data_2of7_from_spinnaker_i   : in  std_logic_vector(6 downto 0) := (others => '0'); 
        RRx_ack_to_spinnaker_o           : out std_logic;
        AuxRx_data_2of7_from_spinnaker_i : in  std_logic_vector(6 downto 0) := (others => '0'); 
        AuxRx_ack_to_spinnaker_o         : out std_logic;
        
        --============================================
        -- Tx Interface
        --============================================

        -- Parallel AER
        Tx_PAER_Addr_o            : out std_logic_vector(C_PAER_DSIZE-1 downto 0);
        Tx_PAER_Req_o             : out std_logic;
        Tx_PAER_Ack_i             : in  std_logic := '0';

        -- HSSAER interface
        Tx_HSSAER_o               : out std_logic_vector(C_TX_HSSAER_N_CHAN-1 downto 0);

        -- GTP interface
        
        -- SpiNNlink interface
        Tx_data_2of7_to_spinnaker_o      : out std_logic_vector(6 downto 0);
        Tx_ack_from_spinnaker_i          : in  std_logic := '0';
            
        --============================================
        -- Configuration interface
        --============================================
        DefLocFarLpbk_i   : in  std_logic := '0';
        DefLocNearLpbk_i  : in  std_logic := '0';

        --============================================
        -- Processor interface
        --============================================
        Interrupt_o       : out std_logic;

        -- Debug signals interface
        DBG_dataOk        : out std_logic;
        DBG_rawi          : out std_logic_vector(15 downto 0);
        DBG_data_written  : out std_logic;
        DBG_dma_burst_counter : out std_logic_vector(10 downto 0);
        DBG_dma_test_mode      : out std_logic;
        DBG_dma_EnableDma      : out std_logic;
        DBG_dma_is_running     : out std_logic;
        DBG_dma_Length         : out std_logic_vector(10 downto 0);
        DBG_dma_nedge_run      : out std_logic;


        -- ADD USER PORTS ABOVE THIS LINE ------------------

        -- DO NOT EDIT BELOW THIS LINE ---------------------
        -- Bus protocol ports, do not add to or delete
        -- Axi lite I/f
        S_AXI_ACLK        : in  std_logic;
        S_AXI_ARESETN     : in  std_logic;
        S_AXI_AWADDR      : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        S_AXI_AWVALID     : in  std_logic;
        S_AXI_WDATA       : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        S_AXI_WSTRB       : in  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
        S_AXI_WVALID      : in  std_logic;
        S_AXI_BREADY      : in  std_logic;
        S_AXI_ARADDR      : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        S_AXI_ARVALID     : in  std_logic;
        S_AXI_RREADY      : in  std_logic;
        S_AXI_ARREADY     : out std_logic;
        S_AXI_RDATA       : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        S_AXI_RRESP       : out std_logic_vector(1 downto 0);
        S_AXI_RVALID      : out std_logic;
        S_AXI_WREADY      : out std_logic;
        S_AXI_BRESP       : out std_logic_vector(1 downto 0);
        S_AXI_BVALID      : out std_logic;
        S_AXI_AWREADY     : out std_logic;
        -- Axi Stream I/f
        S_AXIS_TREADY     : out std_logic;
        S_AXIS_TDATA      : in  std_logic_vector(31 downto 0);
        S_AXIS_TLAST      : in  std_logic;
        S_AXIS_TVALID     : in  std_logic;
        M_AXIS_TVALID     : out std_logic;
        M_AXIS_TDATA      : out std_logic_vector(31 downto 0);
        M_AXIS_TLAST      : out std_logic;
        M_AXIS_TREADY     : in  std_logic;
        -- DO NOT EDIT ABOVE THIS LINE ---------------------

        DBG_din             : out std_logic_vector(63 downto 0);     
        DBG_wr_en           : out std_logic;  
        DBG_rd_en           : out std_logic;     
        DBG_dout            : out std_logic_vector(63 downto 0);          
        DBG_full            : out std_logic;    
        DBG_almost_full     : out std_logic;    
        DBG_overflow        : out std_logic;       
        DBG_empty           : out std_logic;           
        DBG_almost_empty    : out std_logic;    
        DBG_underflow       : out std_logic;     
        DBG_data_count      : out std_logic_vector(10 downto 0);
        DBG_CH0_DATA        : out std_logic_vector(C_INTERNAL_DSIZE-1 downto 0);
        DBG_CH0_SRDY        : out std_logic;   
        DBG_CH0_DRDY        : out std_logic;        
        DBG_CH1_DATA        : out std_logic_vector(C_INTERNAL_DSIZE-1 downto 0);
        DBG_CH1_SRDY        : out std_logic;   
        DBG_CH1_DRDY        : out std_logic;        
        DBG_CH2_DATA        : out std_logic_vector(C_INTERNAL_DSIZE-1 downto 0);
        DBG_CH2_SRDY        : out std_logic;   
        DBG_CH2_DRDY        : out std_logic;
        DBG_Timestamp_xD    : out std_logic_vector(31 downto 0);       
        DBG_MonInAddr_xD    : out std_logic_vector(31 downto 0); 
        DBG_MonInSrcRdy_xS  : out std_logic;
        DBG_MonInDstRdy_xS  : out std_logic;
        DBG_RESETFIFO       : out std_logic;
        DBG_CTRG_reg        : out std_logic_vector(C_SLV_DWIDTH-1 downto 0); 
        DBG_ctrl_rd         : out std_logic_vector(C_SLV_DWIDTH-1 downto 0);
        DBG_src_rdy         : out std_logic_vector(C_RX_HSSAER_N_CHAN-1 downto 0);
        DBG_dst_rdy         : out std_logic_vector(C_RX_HSSAER_N_CHAN-1 downto 0);
        DBG_err             : out std_logic_vector(C_RX_HSSAER_N_CHAN-1 downto 0);  
        DBG_run             : out std_logic_vector(C_RX_HSSAER_N_CHAN-1 downto 0);
        DBG_RX              : out std_logic_vector(C_RX_HSSAER_N_CHAN-1 downto 0);
        DBG_AUXRxSaerChanEn : out std_logic_vector(C_RX_HSSAER_N_CHAN-1 downto 0);

        DBG_shreg_aux0      : out std_logic_vector(3 downto 0);
        DBG_shreg_aux1      : out std_logic_vector(3 downto 0);
        DBG_shreg_aux2      : out std_logic_vector(3 downto 0);
        DBG_FIFO_0          : out std_logic_vector(C_INTERNAL_DSIZE-1 downto 0);
        DBG_FIFO_1          : out std_logic_vector(C_INTERNAL_DSIZE-1 downto 0);
        DBG_FIFO_2          : out std_logic_vector(C_INTERNAL_DSIZE-1 downto 0);
        DBG_FIFO_3          : out std_logic_vector(C_INTERNAL_DSIZE-1 downto 0);
        DBG_FIFO_4          : out std_logic_vector(C_INTERNAL_DSIZE-1 downto 0)
    );

    attribute MAX_FANOUT  : string;
    attribute SIGIS       : string;

    attribute MAX_FANOUT of S_AXI_ACLK     : signal is "10000";
    attribute MAX_FANOUT of S_AXI_ARESETN  : signal is "10000";
    attribute SIGIS      of S_AXI_ACLK     : signal is "Clk";
    attribute SIGIS      of S_AXI_ARESETN  : signal is "Rst";
    attribute SIGIS      of Interrupt_o    : signal is "Interrupt";

end entity HPUCore;



--****************************
--   IMPLEMENTATION
--****************************



architecture str of HPUCore is

    signal nRst                      : std_logic;

    signal i_dma_rxDataBuffer        : std_logic_vector(31 downto 0);
    signal i_dma_readRxBuffer        : std_logic;
    signal i_dma_rxBufferEmpty       : std_logic;
    signal i_dma_rxBufferReady       : std_logic;

    signal i_dma_txDataBuffer        : std_logic_vector(31 downto 0);
    signal i_dma_writeTxBuffer       : std_logic;
    signal i_dma_txBufferFull        : std_logic;

    signal i_fifoCoreDat             : std_logic_vector(31 downto 0);
    signal i_fifoCoreRead            : std_logic;
    signal i_fifoCoreEmpty           : std_logic;
    signal i_fifoCoreAlmostEmpty     : std_logic;
    signal i_fifoCoreBurstReady      : std_logic;
    signal i_fifoCoreFull            : std_logic;
    signal i_fifoCoreNumData         : std_logic_vector(10 downto 0);
    
    signal i_coreFifoDat             : std_logic_vector(31 downto 0);
    signal i_coreFifoWrite           : std_logic;
    signal i_coreFifoFull            : std_logic;
    signal i_coreFifoAlmostFull      : std_logic;
    signal i_coreFifoEmpty           : std_logic;

    signal i_uP_spinnlnk_dump_mode   : std_logic;
    signal i_uP_spinnlnk_parity_err  : std_logic;
    signal i_uP_spinnlnk_rx_err      : std_logic;

    signal i_uP_DMAIsRunning         : std_logic;
    signal i_uP_enableDmaIf          : std_logic;
    signal i_uP_resetstream          : std_logic;
    signal i_uP_dmaLength            : std_logic_vector(10 downto 0);
    signal i_uP_DMA_test_mode        : std_logic;
    signal i_uP_fulltimestamp        : std_logic;

    signal i_uP_readRxBuffer         : std_logic;
    signal i_uP_rxDataBuffer         : std_logic_vector(31 downto 0);
    signal i_uP_rxTimeBuffer         : std_logic_vector(31 downto 0);
    signal i_up_rxFifoThresholdNumData : std_logic_vector(10 downto 0);
    signal i_uP_rxBufferReady        : std_logic;
    signal i_uP_rxBufferEmpty        : std_logic;
    signal i_uP_rxBufferAlmostEmpty  : std_logic;
    signal i_uP_rxBufferFull         : std_logic;
    signal i_rxBufferNotEmpty        : std_logic;
    signal i_uP_rxFifoDataAF         : std_logic;

    signal i_uP_writeTxBuffer        : std_logic;
    signal i_uP_txDataBuffer         : std_logic_vector(31 downto 0);
    signal i_uP_txBufferEmpty        : std_logic;
    signal i_uP_txBufferAlmostFull   : std_logic;
    signal i_uP_txBufferFull         : std_logic;

    signal i_uP_cleanTimer           : std_logic;
    signal i_uP_flushFifos           : std_logic;
    signal i_uP_LRxFlushFifos        : std_logic;
    signal i_uP_RRxFlushFifos        : std_logic;
    signal i_uP_AuxRxPaerFlushFifos  : std_logic;

    signal i_uP_RemoteLpbk           : std_logic;
    signal i_uP_LocalNearLpbk        : std_logic;
    signal i_uP_LocalFarLPaerLpbk    : std_logic;
    signal i_uP_LocalFarRPaerLpbk    : std_logic;
    signal i_uP_LocalFarAuxPaerLpbk  : std_logic;
    signal i_uP_LocalFarLSaerLpbk    : std_logic;
    signal i_uP_LocalFarRSaerLpbk    : std_logic;
    signal i_uP_LocalFarAuxSaerLpbk  : std_logic;
    signal i_uP_LocalFarSaerLpbkCfg  : t_XConCfg; 
    signal i_uP_LocalFarSpnnLnkLpbkSel : std_logic_vector(1 downto 0);
    signal i_uP_TxPaerEn             : std_logic;
    signal i_uP_TxHSSaerEn           : std_logic;
    signal i_up_TxGtpEn              : std_logic;
    signal i_up_TxSpnnLnkEn          : std_logic;
    signal i_uP_TxPaerReqActLevel    : std_logic;
    signal i_uP_TxPaerAckActLevel    : std_logic;
    signal i_uP_TxSaerChanEn         : std_logic_vector(C_TX_HSSAER_N_CHAN-1 downto 0);
    signal i_uP_LRxPaerEn            : std_logic;
    signal i_uP_RRxPaerEn            : std_logic;
    signal i_uP_AUXRxPaerEn          : std_logic;
    signal i_uP_LRxHSSaerEn          : std_logic;
    signal i_uP_RRxHSSaerEn          : std_logic;
    signal i_uP_AUXRxHSSaerEn        : std_logic;
    signal i_up_LRxGtpEn             : std_logic;
    signal i_up_RRxGtpEn             : std_logic;
    signal i_up_AUXRxGtpEn           : std_logic;
    signal i_up_LRxSpnnLnkEn         : std_logic;
    signal i_up_RRxSpnnLnkEn         : std_logic;
    signal i_up_AUXRxSpnnLnkEn         : std_logic;
    signal i_uP_LRxSaerChanEn        : std_logic_vector(C_RX_HSSAER_N_CHAN-1 downto 0);
    signal i_uP_RRxSaerChanEn        : std_logic_vector(C_RX_HSSAER_N_CHAN-1 downto 0);
    signal i_uP_AUXRxSaerChanEn      : std_logic_vector(C_RX_HSSAER_N_CHAN-1 downto 0);
    signal i_uP_RxPaerReqActLevel    : std_logic;
    signal i_uP_RxPaerAckActLevel    : std_logic;
    signal i_uP_RxPaerIgnoreFifoFull : std_logic;
    signal i_uP_RxPaerAckSetDelay    : std_logic_vector(7 downto 0);
    signal i_uP_RxPaerSampleDelay    : std_logic_vector(7 downto 0);
    signal i_uP_RxPaerAckRelDelay    : std_logic_vector(7 downto 0);

    signal i_uP_wrapDetected         : std_logic;
    signal i_uP_txSaerStat           : t_TxSaerStat_array(C_TX_HSSAER_N_CHAN-1 downto 0);
    signal i_uP_LRXPaerFifoFull      : std_logic;
    signal i_uP_RRXPaerFifoFull      : std_logic;
    signal i_uP_AuxRxPaerFifoFull    : std_logic;
    signal i_uP_LRxSaerStat          : t_RxSaerStat_array(C_RX_HSSAER_N_CHAN-1 downto 0);
    signal i_uP_RRxSaerStat          : t_RxSaerStat_array(C_RX_HSSAER_N_CHAN-1 downto 0);
    signal i_uP_AUXRxSaerStat        : t_RxSaerStat_array(C_RX_HSSAER_N_CHAN-1 downto 0);
    
    signal i_uP_TxSpnnlnkStat        : t_TxSpnnlnkStat;
    signal i_uP_LRxSpnnlnkStat       : t_RxSpnnlnkStat;
    signal i_uP_RRxSpnnlnkStat       : t_RxSpnnlnkStat;
    signal i_uP_AuxRxSpnnlnkStat     : t_RxSpnnlnkStat;

    signal i_rawInterrupt            : std_logic_vector(15 downto 0);
    signal i_interrupt               : std_logic;
    
    signal shreg_aux0                : std_logic_vector (3 downto 0);
    signal shreg_aux1                : std_logic_vector (3 downto 0);
    signal shreg_aux2                : std_logic_vector (3 downto 0);

    
 --   for all : neuserial_axilite  use entity neuserial_lib.neuserial_axilite(rtl);
 --   for all : neuserial_axistream  use entity neuserial_lib.neuserial_axistream(rtl);
 --   for all : neuserial_core  use entity neuserial_lib.neuserial_core(str);


begin


    Interrupt_o <= i_interrupt;


    -- Debug assignments --
    -----------------------
    DBG_rawi <= i_rawInterrupt;


    -- Reset generation --
    ----------------------
    nRst    <= S_AXI_ARESETN and nSyncReset;


    ------------------------------------------------------
    -- NeuSerial AXI interfaces instantiation
    ------------------------------------------------------

    i_rxBufferNotEmpty <= not(i_uP_rxBufferEmpty);

    i_rawInterrupt <=  i_uP_rxFifoDataAF             &
                       i_uP_AuxRxPaerFifoFull        &
                       i_uP_RRXPaerFifoFull          &
                       i_uP_LRXPaerFifoFull          &
                       "00"                          &
                       i_rxBufferNotEmpty            &
                       i_uP_rxBufferReady            &
                       i_uP_wrapDetected             &
                       '0'                           &
                       i_uP_txBufferFull             &
                       i_uP_txBufferAlmostFull       &
                       i_uP_txBufferEmpty            &
                       i_uP_rxBufferFull             &
                       i_uP_rxBufferAlmostEmpty      &
                       i_uP_rxBufferEmpty            ;


    u_neuserial_axilite : neuserial_axilite
                           generic map (
                               C_DATA_WIDTH => C_S_AXI_DATA_WIDTH,
                               C_ADDR_WIDTH => C_S_AXI_ADDR_WIDTH,
                               -- HSSAER lines parameters
                               C_RX_HAS_PAER           => C_RX_HAS_PAER,         -- boolean;
                               C_RX_HAS_GTP            => C_RX_HAS_GTP,          -- boolean;
                               C_RX_HAS_SPNNLNK        => C_RX_HAS_SPNNLNK,      -- boolean;
                               C_RX_HAS_HSSAER         => C_RX_HAS_HSSAER,       -- boolean;
                               C_RX_HSSAER_N_CHAN      => C_RX_HSSAER_N_CHAN,    -- natural range 1 to 4;
                               C_TX_HAS_PAER           => C_TX_HAS_PAER,         -- boolean;
                               C_TX_HAS_GTP            => C_TX_HAS_GTP,          -- boolean;
                               C_TX_HAS_SPNNLNK        => C_TX_HAS_SPNNLNK,      -- boolean;
                               C_TX_HAS_HSSAER         => C_TX_HAS_HSSAER,       -- boolean;
                               C_TX_HSSAER_N_CHAN      => C_TX_HSSAER_N_CHAN     -- natural range 1 to 4
                           )
                           port map (
                               -- ADD USER PORTS BELOW THIS LINE ------------------
                   
                               -- Interrupt
                               -------------------------
                               RawInterrupt_i                 => i_rawInterrupt,                   -- in  std_logic_vector(15 downto 0);
                               InterruptLine_o                => i_interrupt,                      -- out std_logic;
                   
                               -- RX Buffer Reg
                               -------------------------
                               ReadRxBuffer_o                 => i_uP_readRxBuffer,                -- out std_logic;
                               RxDataBuffer_i                 => i_uP_rxDataBuffer,                -- in  std_logic_vector(31 downto 0);
                               RxTimeBuffer_i                 => i_uP_rxTimeBuffer,                -- in  std_logic_vector(31 downto 0);
                               RxFifoThresholdNumData_o       => i_up_rxFifoThresholdNumData,      -- out std_logic_vector(10 downto 0);
                               -- Tx Buffer Reg
                               -------------------------
                               WriteTxBuffer_o                => i_uP_writeTxBuffer,               -- out std_logic;
                               TxDataBuffer_o                 => i_uP_txDataBuffer,                -- out std_logic_vector(31 downto 0);
                   
                   
                               -- Controls
                               -------------------------
                               DMA_is_running_i               => i_uP_DMAIsRunning,                -- in  std_logic;
                               EnableDMAIf_o                  => i_uP_enableDmaIf,                 -- out std_logic;
                               ResetStream_o                  => i_uP_resetstream,                 -- out std_logic;
                               DmaLength_o                    => i_uP_dmaLength,                   -- out std_logic_vector(10 downto 0);
                               DMA_test_mode_o                => i_uP_DMA_test_mode,               -- out std_logic;
                               fulltimestamp_o                => i_uP_fulltimestamp,               -- out std_logic;
                   
                               CleanTimer_o                   => i_uP_cleanTimer,              -- out std_logic;
                               FlushFifos_o                   => i_uP_flushFifos,              -- out std_logic;
                               --TxEnable_o                     => ,                             -- out std_logic;
                               --TxPaerFlushFifos_o             => ,                             -- out std_logic;
                               --LRxEnable_o                    => ,                             -- out std_logic;
                               --RRxEnable_o                    => ,                             -- out std_logic;
                               LRxPaerFlushFifos_o            => i_uP_LRxFlushFifos,           -- out std_logic;
                               RRxPaerFlushFifos_o            => i_uP_RRxFlushFifos,           -- out std_logic;
                               AuxRxPaerFlushFifos_o          => i_uP_AuxRxPaerFlushFifos,        -- out std_logic;
                   
                               -- Configurations
                               -------------------------
                               DefLocFarLpbk_i                => DefLocFarLpbk_i,              -- in  std_logic;
                               DefLocNearLpbk_i               => DefLocNearLpbk_i,             -- in  std_logic;
                               --EnableLoopBack_o               => i_uP_enableLoopBack,          -- out std_logic;
                               RemoteLoopback_o               => i_uP_RemoteLpbk,              -- out std_logic;
                               LocNearLoopback_o              => i_uP_LocalNearLpbk,           -- out std_logic;
                               LocFarLPaerLoopback_o          => i_uP_LocalFarLPaerLpbk,       -- out std_logic;
                               LocFarRPaerLoopback_o          => i_uP_LocalFarRPaerLpbk,       -- out std_logic;
                               LocFarAuxPaerLoopback_o        => i_uP_LocalFarAuxPaerLpbk,     -- out std_logic;
                               LocFarLSaerLoopback_o          => i_uP_LocalFarLSaerLpbk,       -- out std_logic;
                               LocFarRSaerLoopback_o          => i_uP_LocalFarRSaerLpbk,       -- out std_logic;
                               LocFarAuxSaerLoopback_o        => i_uP_LocalFarAuxSaerLpbk,     -- out std_logic;
                               LocFarSaerLpbkCfg_o            => i_uP_LocalFarSaerLpbkCfg,     -- out t_XConCfg;
                               LocFarSpnnLnkLoopbackSel_o     => i_uP_LocalFarSpnnLnkLpbkSel,  -- out  std_logic_vector(1 downto 0);
                   
                               --EnableIp_o                     => i_uP_enableIp,                -- out std_logic;
                   
                               TxPaerEn_o                     => i_uP_TxPaerEn,                -- out std_logic;
                               TxHSSaerEn_o                   => i_uP_TxHSSaerEn,              -- out std_logic;
                               TxGtpEn_o                      => i_up_TxGtpEn,                 -- out std_logic;
                               TxSpnnLnkEn_o                  => i_uP_TxSpnnLnkEn,             -- out std_logic;
                               --TxPaerIgnoreFifoFull_o         => ,                             -- out std_logic;
                               TxPaerReqActLevel_o            => i_uP_TxPaerReqActLevel,       -- out std_logic;
                               TxPaerAckActLevel_o            => i_uP_TxPaerAckActLevel,       -- out std_logic;
                               TxSaerChanEn_o                 => i_uP_TxSaerChanEn,            -- out std_logic_vector(C_TX_HSSAER_N_CHAN-1 downto 0);
                   
                               LRxPaerEn_o                    => i_uP_LRxPaerEn,               -- out std_logic;
                               RRxPaerEn_o                    => i_uP_RRxPaerEn,               -- out std_logic;
                               AUXRxPaerEn_o                  => i_uP_AuxRxPaerEn,             -- out std_logic;
                               LRxHSSaerEn_o                  => i_uP_LRxHSSaerEn,             -- out std_logic;
                               RRxHSSaerEn_o                  => i_uP_RRxHSSaerEn,             -- out std_logic;
                               AUXRxHSSaerEn_o                => i_uP_AuxRxHSSaerEn,           -- out std_logic;
                               LRxGtpEn_o                     => i_up_LRxGtpEn,                -- out std_logic;
                               RRxGtpEn_o                     => i_up_RRxGtpEn,                -- out std_logic;
                               AUXRxGtpEn_o                   => i_up_AUXRxGtpEn,              -- out std_logic;
                               LRxSpnnLnkEn_o                 => i_uP_LRxSpnnLnkEn,            -- out std_logic
                               RRxSpnnLnkEn_o                 => i_uP_RRxSpnnLnkEn,            -- out std_logic;
                               AUXRxSpnnLnkEn_o               => i_uP_AUXRxSpnnLnkEn,          -- out std_logic;
                                                                                                                            
                               LRxSaerChanEn_o                => i_uP_LRxSaerChanEn,           -- out std_logic_vector(C_RX_HSSAER_N_CHAN-1 downto 0);
                               RRxSaerChanEn_o                => i_uP_RRxSaerChanEn,           -- out std_logic_vector(C_RX_HSSAER_N_CHAN-1 downto 0);
                               AUXRxSaerChanEn_o              => i_uP_AUXRxSaerChanEn,         -- out std_logic_vector(C_RX_HSSAER_N_CHAN-1 downto 0);
                               RxPaerReqActLevel_o            => i_uP_RxPaerReqActLevel,       -- out std_logic;
                               RxPaerAckActLevel_o            => i_uP_RxPaerAckActLevel,       -- out std_logic;
                               RxPaerIgnoreFifoFull_o         => i_uP_RxPaerIgnoreFifoFull,    -- out std_logic;
                               RxPaerAckSetDelay_o            => i_uP_RxPaerAckSetDelay,       -- out std_logic_vector(7 downto 0);
                               RxPaerSampleDelay_o            => i_uP_RxPaerSampleDelay,       -- out std_logic_vector(7 downto 0);
                               RxPaerAckRelDelay_o            => i_uP_RxPaerAckRelDelay,       -- out std_logic_vector(7 downto 0);
                   
                               -- Status
                               -------------------------
                               WrapDetected_i                 => i_uP_wrapDetected,            -- in  std_logic;
                   
                               TxSaerStat_i                   => i_uP_txSaerStat,              -- in  t_TxSaerStat_array(C_TX_HSSAER_N_CHAN-1 downto 0);
                               LRxSaerStat_i                  => i_uP_LRxSaerStat,             -- in  t_RxSaerStat_array(C_RX_HSSAER_N_CHAN-1 downto 0);
                               RRxSaerStat_i                  => i_uP_RRxSaerStat,             -- in  t_RxSaerStat_array(C_RX_HSSAER_N_CHAN-1 downto 0);
                               AUXRxSaerStat_i                => i_uP_AUXRxSaerStat,           -- in  t_RxSaerStat_array(C_RX_HSSAER_N_CHAN-1 downto 0);
                               TxSpnnlnkStat_i                => i_uP_TxSpnnlnkStat,           -- in  t_TxSpnnlnkStat;
                               LRxSpnnlnkStat_i               => i_uP_LRxSpnnlnkStat,          -- in  t_RxSpnnlnkStat;
                               RRxSpnnlnkStat_i               => i_uP_RRxSpnnlnkStat,          -- in  t_RxSpnnlnkStat;
                               AuxRxSpnnlnkStat_i             => i_uP_AuxRxSpnnlnkStat,        -- in  t_RxSpnnlnkStat;
                   
                               DBG_CTRL_reg                   => DBG_CTRG_reg,                 -- out std_logic_vector(C_SLV_DWIDTH-1 downto 0);
                               DBG_ctrl_rd                    => DBG_ctrl_rd,                  -- out std_logic_vector(C_SLV_DWIDTH-1 downto 0);
                   
                               -- ADD USER PORTS ABOVE THIS LINE ------------------
                   
                               -- DO NOT EDIT BELOW THIS LINE ---------------------
                               -- Bus protocol ports, do not add to or delete
                               -- Axi lite I-f
                               S_AXI_ACLK                     => S_AXI_ACLK,                       -- in  std_logic;
                               S_AXI_ARESETN                  => S_AXI_ARESETN,                    -- in  std_logic;
                               S_AXI_AWADDR                   => S_AXI_AWADDR,                     -- in  std_logic_vector(C_ADDR_WIDTH-1 downto 0);
                               S_AXI_AWVALID                  => S_AXI_AWVALID,                    -- in  std_logic;
                               S_AXI_WDATA                    => S_AXI_WDATA,                      -- in  std_logic_vector(C_DATA_WIDTH-1 downto 0);
                               S_AXI_WSTRB                    => S_AXI_WSTRB,                      -- in  std_logic_vector(3 downto 0);
                               S_AXI_WVALID                   => S_AXI_WVALID,                     -- in  std_logic;
                               S_AXI_BREADY                   => S_AXI_BREADY,                     -- in  std_logic;
                               S_AXI_ARADDR                   => S_AXI_ARADDR,                     -- in  std_logic_vector(C_ADDR_WIDTH-1 downto 0);
                               S_AXI_ARVALID                  => S_AXI_ARVALID,                    -- in  std_logic;
                               S_AXI_RREADY                   => S_AXI_RREADY,                     -- in  std_logic;
                               S_AXI_ARREADY                  => S_AXI_ARREADY,                    -- out std_logic;
                               S_AXI_RDATA                    => S_AXI_RDATA,                      -- out std_logic_vector(C_DATA_WIDTH-1 downto 0);
                               S_AXI_RRESP                    => S_AXI_RRESP,                      -- out std_logic_vector(1 downto 0);
                               S_AXI_RVALID                   => S_AXI_RVALID,                     -- out std_logic;
                               S_AXI_WREADY                   => S_AXI_WREADY,                     -- out std_logic;
                               S_AXI_BRESP                    => S_AXI_BRESP,                      -- out std_logic_vector(1 downto 0);
                               S_AXI_BVALID                   => S_AXI_BVALID,                     -- out std_logic;
                               S_AXI_AWREADY                  => S_AXI_AWREADY                     -- out std_logic
                               -- DO NOT EDIT ABOVE THIS LINE ---------------------
                           );


    u_neuserial_axistream : neuserial_axistream
        generic map (
            C_DEBUG => C_DEBUG
            )
        port map (
            Clk                            => S_AXI_ACLK,                       -- in  std_logic;
            nRst                           => nRst,                             -- in  std_logic;
            --
            DMA_test_mode_i                => i_uP_DMA_test_mode,               -- in  std_logic;
            EnableAxistreamIf_i            => i_uP_enableDmaIf,                 -- in  std_logic;
            DMA_is_running_o               => i_uP_DMAIsRunning,                -- out std_logic;
            DmaLength_i                    => i_uP_dmaLength,                   -- in  std_logic_vector(10 downto 0);
            ResetStream_i                  => i_uP_resetstream,                 -- in  std_logic;
            -- From Fifo to core/dma
            FifoCoreDat_i                  => i_dma_rxDataBuffer,               -- in  std_logic_vector(31 downto 0);
            FifoCoreRead_o                 => i_dma_readRxBuffer,               -- out std_logic;
            FifoCoreEmpty_i                => i_dma_rxBufferEmpty,              -- in  std_logic;
            FifoCoreBurstReady_i           => i_dma_rxBufferReady,              -- in  std_logic;
            -- From core/dma to Fifo
            CoreFifoDat_o                  => i_dma_txDataBuffer,               -- out std_logic_vector(31 downto 0);
            CoreFifoWrite_o                => i_dma_writeTxBuffer,              -- out std_logic;
            CoreFifoFull_i                 => i_dma_txBufferFull,               -- in  std_logic;
            -- Axi Stream I/f
            S_AXIS_TREADY                  => S_AXIS_TREADY,                    -- out std_logic;
            S_AXIS_TDATA                   => S_AXIS_TDATA,                     -- in  std_logic_vector(31 downto 0);
            S_AXIS_TLAST                   => S_AXIS_TLAST,                     -- in  std_logic;
            S_AXIS_TVALID                  => S_AXIS_TVALID,                    -- in  std_logic;
            M_AXIS_TVALID                  => M_AXIS_TVALID,                    -- out std_logic;
            M_AXIS_TDATA                   => M_AXIS_TDATA,                     -- out std_logic_vector(31 downto 0);
            M_AXIS_TLAST                   => M_AXIS_TLAST,                     -- out std_logic;
            M_AXIS_TREADY                  => M_AXIS_TREADY,                    -- in  std_logic;
            -- DBG
            DBG_data_written               => DBG_data_written,                 -- out std_logic;
            DBG_dma_burst_counter          => DBG_dma_burst_counter,            -- out std_logic_vector(10 downto 0)
            DBG_dma_test_mode              => DBG_dma_test_mode,                -- out std_logic;
            DBG_dma_EnableDma              => DBG_dma_EnableDma,                -- std_logic;
            DBG_dma_is_running             => DBG_dma_is_running,               -- std_logic;
            DBG_dma_Length                 => DBG_dma_Length,                   -- std_logic_vector(10 downto 0);
            DBG_dma_nedge_run              => DBG_dma_nedge_run                 -- std_logic

        );


    -- Muxing AXI-Lite and AXI-Stream Fifo interfaces --
    ----------------------------------------------------

    i_uP_rxFifoDataAF                <= '1' when (i_fifoCoreNumData >= i_up_rxFifoThresholdNumData) else '0';
    i_uP_rxDataBuffer                <= i_fifoCoreDat;
    i_uP_rxTimeBuffer                <= i_fifoCoreDat;
    i_uP_rxBufferReady               <= i_fifoCoreBurstReady;
    i_uP_rxBufferEmpty               <= i_fifoCoreEmpty;
    i_uP_rxBufferAlmostEmpty         <= i_fifoCoreAlmostEmpty;
    i_uP_rxBufferFull                <= i_fifoCoreFull;

    i_dma_rxDataBuffer               <= i_fifoCoreDat;
    i_dma_rxBufferReady              <= i_fifoCoreBurstReady;
    i_dma_rxBufferEmpty              <= i_fifoCoreEmpty;

    i_fifoCoreRead                   <= i_dma_readRxBuffer  when (i_uP_DMAIsRunning='1') else
                                        i_uP_readRxBuffer;


    i_uP_txBufferEmpty               <= i_coreFifoEmpty;
    i_uP_txBufferAlmostFull          <= i_coreFifoAlmostFull;
    i_uP_txBufferFull                <= i_coreFifoFull;

    i_dma_txBufferFull               <= i_coreFifoFull;

    i_coreFifoDat                    <= i_dma_txDataBuffer  when (i_uP_DMAIsRunning='1') else
                                        i_uP_txDataBuffer;
    i_coreFifoWrite                  <= i_dma_writeTxBuffer when (i_uP_DMAIsRunning='1') else
                                        i_uP_writeTxBuffer;



    -- -----------------------------------------------------------------------------
    -- NeuSerial core instantiation
    -- -----------------------------------------------------------------------------
    u_neuserial_core : neuserial_core
        generic map (
            C_PAER_DSIZE            => C_PAER_DSIZE,          -- natural range 1 to 29;
            C_RX_HAS_PAER           => C_RX_HAS_PAER,         -- boolean;
            C_RX_HAS_GTP            => C_RX_HAS_GTP,          -- boolean;
            C_RX_HAS_HSSAER         => C_RX_HAS_HSSAER,       -- boolean;
            C_RX_HSSAER_N_CHAN      => C_RX_HSSAER_N_CHAN,    -- natural range 1 to 4;
            C_RX_HAS_SPNNLNK        => C_RX_HAS_SPNNLNK,      -- boolean;
            C_TX_HAS_PAER           => C_TX_HAS_PAER,         -- boolean;
            C_TX_HAS_GTP            => C_TX_HAS_GTP,          -- boolean;
            C_TX_HAS_HSSAER         => C_TX_HAS_HSSAER,       -- boolean;
            C_TX_HSSAER_N_CHAN      => C_TX_HSSAER_N_CHAN,    -- natural range 1 to 4
            C_TX_HAS_SPNNLNK        => C_TX_HAS_SPNNLNK,      -- boolean;
			C_PSPNNLNK_WIDTH	    => C_PSPNNLNK_WIDTH       -- natural range 1 to 32
        )
        port map (
            --
            -- Clocks & Reset
            ---------------------
            nRst                    => nRst,                         -- in  std_logic;
            Clk_core                => S_AXI_ACLK,                   -- in  std_logic;
            ClkLS_p                 => HSSAER_ClkLS_p,               -- in  std_logic;
            ClkLS_n                 => HSSAER_ClkLS_n,               -- in  std_logic;
            ClkHS_p                 => HSSAER_ClkHS_p,               -- in  std_logic;
            ClkHS_n                 => HSSAER_ClkHS_n,               -- in  std_logic;

            --
            -- TX DATA PATH
            ---------------------
            -- Parallel AER
            Tx_PAER_Addr_o          => Tx_PAER_Addr_o,               -- out std_logic_vector(C_PAER_DSIZE-1 downto 0);
            Tx_PAER_Req_o           => Tx_PAER_Req_o,                -- out std_logic;
            Tx_PAER_Ack_i           => Tx_PAER_Ack_i,                -- in  std_logic;
            -- HSSAER channels
            Tx_HSSAER_o             => Tx_HSSAER_o,                  -- out std_logic_vector(0 to C_TX_HSSAER_N_CHAN-1);
            -- GTP lines

            --
            -- RX Left DATA PATH
            ---------------------
            -- Parallel AER
            LRx_PAER_Addr_i         => LRx_PAER_Addr_i,              -- in  std_logic_vector(C_PAER_DSIZE-1 downto 0);
            LRx_PAER_Req_i          => LRx_PAER_Req_i,               -- in  std_logic;
            LRx_PAER_Ack_o          => LRx_PAER_Ack_o,               -- out std_logic;
            -- HSSAER channels
            LRx_HSSAER_i            => LRx_HSSAER_i,                 -- in  std_logic_vector(0 to C_RX_HSSAER_N_CHAN-1);
            -- GTP lines

            --
            -- RX Right DATA PATH
            ---------------------
            -- Parallel AER
            RRx_PAER_Addr_i         => RRx_PAER_Addr_i,              -- in  std_logic_vector(C_PAER_DSIZE-1 downto 0);
            RRx_PAER_Req_i          => RRx_PAER_Req_i,               -- in  std_logic;
            RRx_PAER_Ack_o          => RRx_PAER_Ack_o,               -- out std_logic;
            -- HSSAER channels
            RRx_HSSAER_i            => RRx_HSSAER_i,                 -- in  std_logic_vector(0 to C_RX_HSSAER_N_CHAN-1);
            -- GTP lines

            --
            -- Aux DATA PATH
            ---------------------
            -- Parallel AER
            AuxRx_PAER_Addr_i       => AuxRx_PAER_Addr_i,              -- in  std_logic_vector(C_PAER_DSIZE-1 downto 0);
            AuxRx_PAER_Req_i        => AuxRx_PAER_Req_i,               -- in  std_logic;
            AuxRx_PAER_Ack_o        => AuxRx_PAER_Ack_o,               -- out std_logic;
            -- HSSAER channels
            AuxRx_HSSAER_i          => AuxRx_HSSAER_i,                 -- in  std_logic_vector(C_RX_HSSAER_N_CHAN-1 downto 0);
 
        --
            -- SpiNNlink DATA PATH
            ---------------------
            -- input SpiNNaker link interface
            LRx_data_2of7_from_spinnaker_i   => LRx_data_2of7_from_spinnaker_i,
            LRx_ack_to_spinnaker_o           => LRx_ack_to_spinnaker_o,
            RRx_data_2of7_from_spinnaker_i   => RRx_data_2of7_from_spinnaker_i,
            RRx_ack_to_spinnaker_o           => RRx_ack_to_spinnaker_o,
            AuxRx_data_2of7_from_spinnaker_i => AuxRx_data_2of7_from_spinnaker_i,
            AuxRx_ack_to_spinnaker_o         => AuxRx_ack_to_spinnaker_o,
            -- output SpiNNaker link interface
            Tx_data_2of7_to_spinnaker_o      => Tx_data_2of7_to_spinnaker_o,
            Tx_ack_from_spinnaker_i          => Tx_ack_from_spinnaker_i,

            --
            -- FIFOs interfaces
            ---------------------
            FifoCoreDat_o           => i_fifoCoreDat,                -- out std_logic_vector(31 downto 0);
            FifoCoreRead_i          => i_fifoCoreRead,               -- in  std_logic;
            FifoCoreEmpty_o         => i_fifoCoreEmpty,              -- out std_logic;
            FifoCoreAlmostEmpty_o   => i_fifoCoreAlmostEmpty,        -- out std_logic;
            FifoCoreBurstReady_o    => i_fifoCoreBurstReady,         -- out std_logic;
            FifoCoreFull_o          => i_fifoCoreFull,               -- out std_logic;
            FifoCoreNumData_o       => i_fifoCoreNumData,            -- out std_logic_vector(10 downto 0);
            --
            CoreFifoDat_i           => i_coreFifoDat,                -- in  std_logic_vector(31 downto 0);
            CoreFifoWrite_i         => i_coreFifoWrite,              -- in  std_logic;
            CoreFifoFull_o          => i_coreFifoFull,               -- out std_logic;
            CoreFifoAlmostFull_o    => i_coreFifoAlmostFull,         -- out std_logic;
            CoreFifoEmpty_o         => i_coreFifoEmpty,              -- out std_logic;

            -----------------------------------------------------------------------
            -- uController Interface
            ---------------------
            -- Control
            CleanTimer_i            => i_uP_cleanTimer,              -- in  std_logic;
            FlushFifos_i            => i_uP_flushFifos,              -- in  std_logic;
            --TxEnable_i              => ,                             -- in  std_logic;
            --TxPaerFlushFifos_i      => ,                             -- in  std_logic;
            --LRxEnable_i             => ,                             -- in  std_logic;
            --RRxEnable_i             => ,                             -- in  std_logic;
            LRxPaerFlushFifos_i     => i_uP_LRxFlushFifos,           -- in  std_logic;
            RRxPaerFlushFifos_i     => i_uP_RRxFlushFifos,           -- in  std_logic;
            AuxRxPaerFlushFifos_i   => i_uP_AuxRxPaerFlushFifos,      -- in  std_logic;
            FullTimestamp_i         => i_uP_fulltimestamp,           -- in  std_logic;


            -- Configurations
            DmaLength_i             => i_uP_dmaLength,               -- in  std_logic_vector(10 downto 0);
            RemoteLoopback_i        => i_uP_RemoteLpbk,              -- in  std_logic;
            LocNearLoopback_i       => i_uP_LocalNearLpbk,           -- in  std_logic;
            LocFarLPaerLoopback_i   => i_uP_LocalFarLPaerLpbk,       -- in  std_logic;
            LocFarRPaerLoopback_i   => i_uP_LocalFarRPaerLpbk,       -- in  std_logic;
            LocFarAuxPaerLoopback_i => i_uP_LocalFarAuxPaerLpbk,     -- in  std_logic;
            LocFarLSaerLoopback_i   => i_uP_LocalFarLSaerLpbk,       -- in  std_logic;
            LocFarRSaerLoopback_i   => i_uP_LocalFarRSaerLpbk,       -- in  std_logic;
            LocFarAuxSaerLoopback_i => i_uP_LocalFarAuxSaerLpbk,     -- in  std_logic;
            LocFarSaerLpbkCfg_i     => i_uP_LocalFarSaerLpbkCfg,     -- in  t_XConCfg;
            LocFarSpnnLnkLoopbackSel_i => i_uP_LocalFarSpnnLnkLpbkSel, -- in  std_logic_vector(1 downto 0);

            TxPaerEn_i              => i_uP_TxPaerEn,                -- in  std_logic;
            TxHSSaerEn_i            => i_uP_TxHSSaerEn,              -- in  std_logic;
            TxGtpEn_i               => i_up_TxGtpEn,                 -- in  std_logic;
            TxSpnnLnkEn_i           => i_up_TxSpnnLnkEn,             -- in  std_logic;
            --TxPaerIgnoreFifoFull_i  => ,                             -- in  std_logic;
            TxPaerReqActLevel_i     => i_uP_TxPaerReqActLevel,       -- in  std_logic;
            TxPaerAckActLevel_i     => i_uP_TxPaerAckActLevel,       -- in  std_logic;
            TxSaerChanEn_i          => i_uP_TxSaerChanEn,            -- in  std_logic_vector(C_TX_HSSAER_N_CHAN-1 downto 0);
            --TxSaerChanCfg_i         => ,                             -- in  t_hssaerCfg_array(C_TX_HSSAER_N_CHAN-1 downto 0);

            LRxPaerEn_i             => i_uP_LRxPaerEn,               -- in  std_logic;
            RRxPaerEn_i             => i_uP_RRxPaerEn,               -- in  std_logic;
            AuxRxPaerEn_i           => i_uP_AuxRxPaerEn,             -- in  std_logic;
            LRxHSSaerEn_i           => i_uP_LRxHSSaerEn,             -- in  std_logic;
            RRxHSSaerEn_i           => i_uP_RRxHSSaerEn,             -- in  std_logic;
            AuxRxHSSaerEn_i         => i_uP_AuxRxHSSaerEn,           -- in  std_logic;
            LRxGtpEn_i              => i_up_LRxGtpEn,                -- in  std_logic;
            RRxGtpEn_i              => i_up_RRxGtpEn,                -- in  std_logic;
            AuxRxGtpEn_i            => i_up_AuxRxGtpEn,              -- in  std_logic;
            LRxSpnnLnkEn_i          => i_uP_LRxSpnnLnkEn,            -- in  std_logic;
            RRxSpnnLnkEn_i          => i_uP_RRxSpnnLnkEn,            -- in  std_logic;
            AuxRxSpnnLnkEn_i        => i_uP_AuxRxSpnnLnkEn,          -- in  std_logic;
            LRxSaerChanEn_i         => i_uP_LRxSaerChanEn,           -- in  std_logic_vector(C_RX_HSSAER_N_CHAN-1 downto 0);
            RRxSaerChanEn_i         => i_uP_RRxSaerChanEn,           -- in  std_logic_vector(C_RX_HSSAER_N_CHAN-1 downto 0);
            AUXRxSaerChanEn_i       => i_uP_AUXRxSaerChanEn,         -- in  std_logic_vector(C_RX_HSSAER_N_CHAN-1 downto 0);
            RxPaerReqActLevel_i     => i_uP_RxPaerReqActLevel,       -- in  std_logic;
            RxPaerAckActLevel_i     => i_uP_RxPaerAckActLevel,       -- in  std_logic;
            RxPaerIgnoreFifoFull_i  => i_uP_RxPaerIgnoreFifoFull,    -- in  std_logic;
            RxPaerAckSetDelay_i     => i_uP_RxPaerAckSetDelay,       -- in  std_logic_vector(7 downto 0);
            RxPaerSampleDelay_i     => i_uP_RxPaerSampleDelay,       -- in  std_logic_vector(7 downto 0);
            RxPaerAckRelDelay_i     => i_uP_RxPaerAckRelDelay,       -- in  std_logic_vector(7 downto 0);

            -- Status
            WrapDetected_o          => i_uP_wrapDetected,            -- out std_logic;

            --TxPaerFifoEmpty_o       => i_uP_TxPaerFifoEmpty,         -- out std_logic;
            TxSaerStat_o            => i_uP_txSaerStat,              -- out t_TxSaerStat_array(C_TX_HSSAER_N_CHAN-1 downto 0);

            LRxPaerFifoFull_o       => i_uP_LRxPaerFifoFull,         -- out std_logic;
            RRxPaerFifoFull_o       => i_uP_RRxPaerFifoFull,         -- out std_logic;
            AuxRxPaerFifoFull_o     => i_uP_AuxRxPaerFifoFull,       -- out std_logic;
            LRxSaerStat_o           => i_uP_LRxSaerStat,             -- out t_RxSaerStat_array(C_RX_HSSAER_N_CHAN-1 downto 0);
            RRxSaerStat_o           => i_uP_RRxSaerStat,             -- out t_RxSaerStat_array(C_RX_HSSAER_N_CHAN-1 downto 0);
            AUXRxSaerStat_o         => i_uP_AUXRxSaerStat,           -- out t_RxSaerStat_array(C_RX_HSSAER_N_CHAN-1 downto 0);

            TxSpnnlnkStat_o         => i_uP_TxSpnnlnkStat,           -- out t_TxSpnnlnkStat;
            LRxSpnnlnkStat_o        => i_uP_LRxSpnnlnkStat,          -- out t_RxSpnnlnkStat;
            RRxSpnnlnkStat_o        => i_uP_RRxSpnnlnkStat,          -- out t_RxSpnnlnkStat;
            AuxRxSpnnlnkStat_o      => i_uP_AuxRxSpnnlnkStat,        -- out t_RxSpnnlnkStat;

            --
            -- LED drivers
            ---------------------
            LEDo_o                  => open,                         -- out std_logic;
            LEDr_o                  => open,                         -- out std_logic;
            LEDy_o                  => open,                         -- out std_logic;

            --
            -- DEBUG SIGNALS
            ---------------------
            DBG_dataOk              => DBG_dataOk,                   -- out std_logic

            DBG_din             => DBG_din,   
            DBG_wr_en           => DBG_wr_en,       
            DBG_rd_en           => DBG_rd_en,       
            DBG_dout            => DBG_dout,            
            DBG_full            => DBG_full,        
            DBG_almost_full     => DBG_almost_full, 
            DBG_overflow        => DBG_overflow,      
            DBG_empty           => DBG_empty,            
            DBG_almost_empty    => DBG_almost_empty,
            DBG_underflow       => DBG_underflow,   
            DBG_data_count      => DBG_data_count,
            DBG_CH0_DATA        => DBG_CH0_DATA,
            DBG_CH0_SRDY        => DBG_CH0_SRDY,
            DBG_CH0_DRDY        => DBG_CH0_DRDY,
            DBG_CH1_DATA        => DBG_CH1_DATA,
            DBG_CH1_SRDY        => DBG_CH1_SRDY,
            DBG_CH1_DRDY        => DBG_CH1_DRDY,
            DBG_CH2_DATA        => DBG_CH2_DATA,
            DBG_CH2_SRDY        => DBG_CH2_SRDY,
            DBG_CH2_DRDY        => DBG_CH2_DRDY,
            DBG_Timestamp_xD    => DBG_Timestamp_xD,
            DBG_MonInAddr_xD    => DBG_MonInAddr_xD,
            DBG_MonInSrcRdy_xS  => DBG_MonInSrcRdy_xS,
            DBG_MonInDstRdy_xS  => DBG_MonInDstRdy_xS,
            DBG_RESETFIFO       => DBG_RESETFIFO,
            DBG_src_rdy         => DBG_src_rdy,
            DBG_dst_rdy         => DBG_dst_rdy,
            DBG_err             => DBG_err,     
            DBG_run             => DBG_run,
            DBG_RX              => DBG_RX,
            DBG_FIFO_0          => DBG_FIFO_0,
            DBG_FIFO_1          => DBG_FIFO_1,
            DBG_FIFO_2          => DBG_FIFO_2,
            DBG_FIFO_3          => DBG_FIFO_3,
            DBG_FIFO_4          => DBG_FIFO_4
        );

    process (HSSAER_ClkLS_p) is
        begin
        if (rising_edge(HSSAER_ClkLS_p)) then
            shreg_aux0 <= shreg_aux0(2 downto 0)&AuxRx_HSSAER_i(0);
            shreg_aux1 <= shreg_aux1(2 downto 0)&AuxRx_HSSAER_i(1);
            shreg_aux2 <= shreg_aux2(2 downto 0)&AuxRx_HSSAER_i(2);
        end if;
    end process ;

DBG_shreg_aux0 <= shreg_aux0;
DBG_shreg_aux1 <= shreg_aux1;
DBG_shreg_aux2 <= shreg_aux2;

DBG_AUXRxSaerChanEn <= i_uP_AUXRxSaerChanEn;

end architecture str;
