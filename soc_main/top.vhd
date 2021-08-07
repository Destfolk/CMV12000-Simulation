----------------------------------------------------------------------------
--  top.vhd (for cmv_hdmi)
--	Axiom Beta CMV HDMI Test
--	Version 1.3
--
--  Copyright (C) 2013-2015 H.Poetzl
--
--	This program is free software: you can redistribute it and/or
--	modify it under the terms of the GNU General Public License
--	as published by the Free Software Foundation, either version
--	2 of the License, or (at your option) any later version.
--
--  Vivado 2014.2:
--    mkdir -p build.vivado
--    (cd build.vivado && vivado -mode tcl -source ../vivado.tcl)
----------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

library unisim;
use unisim.VCOMPONENTS.ALL;

library unimacro;
use unimacro.VCOMPONENTS.ALL;

use work.axi3m_pkg.ALL;		-- AXI3 Master
use work.axi3ml_pkg.ALL;	-- AXI3 Lite Master
use work.axi3s_pkg.ALL;		-- AXI3 Slave

use work.vivado_pkg.ALL;	-- Vivado Attributes



entity top is
    --port (
	--i2c_scl : inout std_ulogic;
	--i2c_sda : inout std_ulogic;
	--
	--spi_en : out std_ulogic;
	--spi_clk : out std_ulogic;
	--spi_in : out std_ulogic;
	--spi_out : in std_ulogic;
	--
	--cmv_clk : out std_ulogic;
	--cmv_sys_res_n : out std_ulogic;
	--cmv_frame_req : out std_ulogic;
	--cmv_t_exp1 : out std_ulogic;
	--cmv_t_exp2 : out std_ulogic;
	--
	--cmv_lvds_clk_p : out std_logic;
	--cmv_lvds_clk_n : out std_logic;
	--
	--cmv_lvds_outclk_p : in std_logic;
	--cmv_lvds_outclk_n : in std_logic;
	--
	--cmv_lvds_data_p : in unsigned(31 downto 0);
	--cmv_lvds_data_n : in unsigned(31 downto 0);
	--
	--cmv_lvds_ctrl_p : in std_logic;
	--cmv_lvds_ctrl_n : in std_logic
	--
	--hdmi_south_clk_p : out std_logic;
	--hdmi_south_clk_n : out std_logic
	--
	--hdmi_south_d_p : out std_logic_vector (2 downto 0);
	--hdmi_south_d_n : out std_logic_vector (2 downto 0);
	--
        --hdmi_north_clk_p : out std_logic;
	--hdmi_north_clk_n : out std_logic;
	--
	--hdmi_north_d_p : out std_logic_vector (2 downto 0);
	--hdmi_north_d_n : out std_logic_vector (2 downto 0);	
	--
	--debug_tmds: out std_logic_vector (3 downto 0);
	--debug : out std_logic_vector (3 downto 0)
    --);

end entity top;


architecture RTL of top is

    attribute KEEP_HIERARCHY of RTL : architecture is "TRUE";

    signal clk_100 : std_logic;

    --------------------------------------------------------------------
    -- PS7 Signals
    --------------------------------------------------------------------

    signal ps_fclk : std_logic_vector (3 downto 0);
    signal ps_reset_n : std_logic_vector (3 downto 0);

    --------------------------------------------------------------------
    -- PS7 AXI CMV Master Signals
    --------------------------------------------------------------------

    signal m_axi0_aclk : std_logic;
    signal m_axi0_areset_n : std_logic;

    signal m_axi0_ri : axi3m_read_in_r;
    signal m_axi0_ro : axi3m_read_out_r;
    signal m_axi0_wi : axi3m_write_in_r;
    signal m_axi0_wo : axi3m_write_out_r;

    signal m_axi0l_ri : axi3ml_read_in_r;
    signal m_axi0l_ro : axi3ml_read_out_r;
    signal m_axi0l_wi : axi3ml_write_in_r;
    signal m_axi0l_wo : axi3ml_write_out_r;

    signal m_axi0a_aclk : std_logic_vector (7 downto 0);
    signal m_axi0a_areset_n : std_logic_vector (7 downto 0);

    signal m_axi0a_ri : axi3ml_read_in_a(7 downto 0);
    signal m_axi0a_ro : axi3ml_read_out_a(7 downto 0);
    signal m_axi0a_wi : axi3ml_write_in_a(7 downto 0);
    signal m_axi0a_wo : axi3ml_write_out_a(7 downto 0);

    --------------------------------------------------------------------
    -- PS7 AXI HDMI Master Signals
    --------------------------------------------------------------------

    signal m_axi1_aclk : std_logic;
    signal m_axi1_areset_n : std_logic;

    signal m_axi1_ri : axi3m_read_in_r;
    signal m_axi1_ro : axi3m_read_out_r;
    signal m_axi1_wi : axi3m_write_in_r;
    signal m_axi1_wo : axi3m_write_out_r;

    signal m_axi1l_ri : axi3ml_read_in_r;
    signal m_axi1l_ro : axi3ml_read_out_r;
    signal m_axi1l_wi : axi3ml_write_in_r;
    signal m_axi1l_wo : axi3ml_write_out_r;

    signal m_axi1a_aclk : std_logic_vector (7 downto 0);
    signal m_axi1a_areset_n : std_logic_vector (7 downto 0);

    signal m_axi1a_ri : axi3ml_read_in_a(7 downto 0);
    signal m_axi1a_ro : axi3ml_read_out_a(7 downto 0);
    signal m_axi1a_wi : axi3ml_write_in_a(7 downto 0);
    signal m_axi1a_wo : axi3ml_write_out_a(7 downto 0);

    --------------------------------------------------------------------
    -- PS7 AXI Slave Signals
    --------------------------------------------------------------------

    signal s_axi_aclk : std_logic_vector (3 downto 0);
    signal s_axi_areset_n : std_logic_vector (3 downto 0);

    signal s_axi_ri : axi3s_read_in_a(3 downto 0);
    signal s_axi_ro : axi3s_read_out_a(3 downto 0);
    signal s_axi_wi : axi3s_write_in_a(3 downto 0);
    signal s_axi_wo : axi3s_write_out_a(3 downto 0);

    --------------------------------------------------------------------
    -- PS7 EMIO GPIO Signals
    --------------------------------------------------------------------

    signal emio_gpio_i : std_logic_vector(63 downto 0);
    signal emio_gpio_o : std_logic_vector(63 downto 0);
    signal emio_gpio_t_n : std_logic_vector(63 downto 0);

    --------------------------------------------------------------------
    -- I2C0 Signals
    --------------------------------------------------------------------

    signal i2c0_sda_i : std_ulogic;
    signal i2c0_sda_o : std_ulogic;
    signal i2c0_sda_t : std_ulogic;
    signal i2c0_sda_t_n : std_ulogic;

    signal i2c0_scl_i : std_ulogic;
    signal i2c0_scl_o : std_ulogic;
    signal i2c0_scl_t : std_ulogic;
    signal i2c0_scl_t_n : std_ulogic;

    --------------------------------------------------------------------
    -- I2C1 Signals
    --------------------------------------------------------------------

    signal i2c1_sda_i : std_ulogic;
    signal i2c1_sda_o : std_ulogic;
    signal i2c1_sda_t : std_ulogic;
    signal i2c1_sda_t_n : std_ulogic;

    signal i2c1_scl_i : std_ulogic;
    signal i2c1_scl_o : std_ulogic;
    signal i2c1_scl_t : std_ulogic;
    signal i2c1_scl_t_n : std_ulogic;

    --------------------------------------------------------------------
    -- CMV MMCM Signals
    --------------------------------------------------------------------

    signal cmv_pll_locked : std_ulogic;

    signal cmv_lvds_clk : std_ulogic;
    signal cmv_cmd_clk : std_ulogic;
    signal cmv_spi_clk : std_ulogic;
    signal cmv_axi_clk : std_ulogic;
    signal cmv_dly_clk : std_ulogic;
    
    --------------------------------------------------------------------
    -- CMV SPI Signals
    --------------------------------------------------------------------

    signal spi_en  : std_ulogic;
    signal spi_clk : std_ulogic;
    signal spi_in  : std_ulogic;
    signal spi_out : std_ulogic;

begin

    --------------------------------------------------------------------
    -- PS7 Interface
    --------------------------------------------------------------------

    ps7_stub_inst : entity work.ps7_stub
	port map (
	    i2c0_sda_i => i2c0_sda_i,
	    i2c0_sda_o => i2c0_sda_o,
	    i2c0_sda_t_n => i2c0_sda_t_n,
	    --
	    i2c0_scl_i => i2c0_scl_i,
	    i2c0_scl_o => i2c0_scl_o,
	    i2c0_scl_t_n => i2c0_scl_t_n,
	    --
	    i2c1_sda_i => i2c1_sda_i,
	    i2c1_sda_o => i2c1_sda_o,
	    i2c1_sda_t_n => i2c1_sda_t_n,
	    --
	    i2c1_scl_i => i2c1_scl_i,
	    i2c1_scl_o => i2c1_scl_o,
	    i2c1_scl_t_n => i2c1_scl_t_n,
	    --
	    ps_fclk => ps_fclk,
	    ps_reset_n => ps_reset_n,
	    --
	    emio_gpio_i => emio_gpio_i,
	    emio_gpio_o => emio_gpio_o,
	    emio_gpio_t_n => emio_gpio_t_n,
	    --
	    m_axi0_aclk => m_axi0_aclk,
	    m_axi0_areset_n => m_axi0_areset_n,
	    --
	    m_axi0_arid => m_axi0_ro.arid,
	    m_axi0_araddr => m_axi0_ro.araddr,
	    m_axi0_arburst => m_axi0_ro.arburst,
	    m_axi0_arlen => m_axi0_ro.arlen,
	    m_axi0_arsize => m_axi0_ro.arsize,
	    m_axi0_arprot => m_axi0_ro.arprot,
	    m_axi0_arvalid => m_axi0_ro.arvalid,
	    m_axi0_arready => m_axi0_ri.arready,
	    --
	    m_axi0_rid => m_axi0_ri.rid,
	    m_axi0_rdata => m_axi0_ri.rdata,
	    m_axi0_rlast => m_axi0_ri.rlast,
	    m_axi0_rresp => m_axi0_ri.rresp,
	    m_axi0_rvalid => m_axi0_ri.rvalid,
	    m_axi0_rready => m_axi0_ro.rready,
	    --
	    m_axi0_awid => m_axi0_wo.awid,
	    m_axi0_awaddr => m_axi0_wo.awaddr,
	    m_axi0_awburst => m_axi0_wo.awburst,
	    m_axi0_awlen => m_axi0_wo.awlen,
	    m_axi0_awsize => m_axi0_wo.awsize,
	    m_axi0_awprot => m_axi0_wo.awprot,
	    m_axi0_awvalid => m_axi0_wo.awvalid,
	    m_axi0_awready => m_axi0_wi.wready,
	    --
	    m_axi0_wid => m_axi0_wo.wid,
	    m_axi0_wdata => m_axi0_wo.wdata,
	    m_axi0_wstrb => m_axi0_wo.wstrb,
	    m_axi0_wlast => m_axi0_wo.wlast,
	    m_axi0_wvalid => m_axi0_wo.wvalid,
	    m_axi0_wready => m_axi0_wi.wready,
	    --
	    m_axi0_bid => m_axi0_wi.bid,
	    m_axi0_bresp => m_axi0_wi.bresp,
	    m_axi0_bvalid => m_axi0_wi.bvalid,
	    m_axi0_bready => m_axi0_wo.bready,
	    --
	    m_axi1_aclk => m_axi1_aclk,
	    m_axi1_areset_n => m_axi1_areset_n,
	    --
	    m_axi1_arid => m_axi1_ro.arid,
	    m_axi1_araddr => m_axi1_ro.araddr,
	    m_axi1_arburst => m_axi1_ro.arburst,
	    m_axi1_arlen => m_axi1_ro.arlen,
	    m_axi1_arsize => m_axi1_ro.arsize,
	    m_axi1_arprot => m_axi1_ro.arprot,
	    m_axi1_arvalid => m_axi1_ro.arvalid,
	    m_axi1_arready => m_axi1_ri.arready,
	    --
	    m_axi1_rid => m_axi1_ri.rid,
	    m_axi1_rdata => m_axi1_ri.rdata,
	    m_axi1_rlast => m_axi1_ri.rlast,
	    m_axi1_rresp => m_axi1_ri.rresp,
	    m_axi1_rvalid => m_axi1_ri.rvalid,
	    m_axi1_rready => m_axi1_ro.rready,
	    --
	    m_axi1_awid => m_axi1_wo.awid,
	    m_axi1_awaddr => m_axi1_wo.awaddr,
	    m_axi1_awburst => m_axi1_wo.awburst,
	    m_axi1_awlen => m_axi1_wo.awlen,
	    m_axi1_awsize => m_axi1_wo.awsize,
	    m_axi1_awprot => m_axi1_wo.awprot,
	    m_axi1_awvalid => m_axi1_wo.awvalid,
	    m_axi1_awready => m_axi1_wi.wready,
	    --
	    m_axi1_wid => m_axi1_wo.wid,
	    m_axi1_wdata => m_axi1_wo.wdata,
	    m_axi1_wstrb => m_axi1_wo.wstrb,
	    m_axi1_wlast => m_axi1_wo.wlast,
	    m_axi1_wvalid => m_axi1_wo.wvalid,
	    m_axi1_wready => m_axi1_wi.wready,
	    --
	    m_axi1_bid => m_axi1_wi.bid,
	    m_axi1_bresp => m_axi1_wi.bresp,
	    m_axi1_bvalid => m_axi1_wi.bvalid,
	    m_axi1_bready => m_axi1_wo.bready,
	    --
	    s_axi0_aclk => s_axi_aclk(0),
	    s_axi0_areset_n => s_axi_areset_n(0),
	    --
	    s_axi0_arid => s_axi_ri(0).arid,
	    s_axi0_araddr => s_axi_ri(0).araddr,
	    s_axi0_arburst => s_axi_ri(0).arburst,
	    s_axi0_arlen => s_axi_ri(0).arlen,
	    s_axi0_arsize => s_axi_ri(0).arsize,
	    s_axi0_arprot => s_axi_ri(0).arprot,
	    s_axi0_arvalid => s_axi_ri(0).arvalid,
	    s_axi0_arready => s_axi_ro(0).arready,
	    s_axi0_racount => s_axi_ro(0).racount,
	    --
	    s_axi0_rid => s_axi_ro(0).rid,
	    s_axi0_rdata => s_axi_ro(0).rdata,
	    s_axi0_rlast => s_axi_ro(0).rlast,
	    s_axi0_rvalid => s_axi_ro(0).rvalid,
	    s_axi0_rready => s_axi_ri(0).rready,
	    s_axi0_rcount => s_axi_ro(0).rcount,
	    --
	    s_axi0_awid => s_axi_wi(0).awid,
	    s_axi0_awaddr => s_axi_wi(0).awaddr,
	    s_axi0_awburst => s_axi_wi(0).awburst,
	    s_axi0_awlen => s_axi_wi(0).awlen,
	    s_axi0_awsize => s_axi_wi(0).awsize,
	    s_axi0_awprot => s_axi_wi(0).awprot,
	    s_axi0_awvalid => s_axi_wi(0).awvalid,
	    s_axi0_awready => s_axi_wo(0).awready,
	    s_axi0_wacount => s_axi_wo(0).wacount,
	    --
	    s_axi0_wid => s_axi_wi(0).wid,
	    s_axi0_wdata => s_axi_wi(0).wdata,
	    s_axi0_wstrb => s_axi_wi(0).wstrb,
	    s_axi0_wlast => s_axi_wi(0).wlast,
	    s_axi0_wvalid => s_axi_wi(0).wvalid,
	    s_axi0_wready => s_axi_wo(0).wready,
	    s_axi0_wcount => s_axi_wo(0).wcount,
	    --
	    s_axi0_bid => s_axi_wo(0).bid,
	    s_axi0_bresp => s_axi_wo(0).bresp,
	    s_axi0_bvalid => s_axi_wo(0).bvalid,
	    s_axi0_bready => s_axi_wi(0).bready,
	    --
	    s_axi1_aclk => s_axi_aclk(1),
	    s_axi1_areset_n => s_axi_areset_n(1),
	    --
	    s_axi1_arid => s_axi_ri(1).arid,
	    s_axi1_araddr => s_axi_ri(1).araddr,
	    s_axi1_arburst => s_axi_ri(1).arburst,
	    s_axi1_arlen => s_axi_ri(1).arlen,
	    s_axi1_arsize => s_axi_ri(1).arsize,
	    s_axi1_arprot => s_axi_ri(1).arprot,
	    s_axi1_arvalid => s_axi_ri(1).arvalid,
	    s_axi1_arready => s_axi_ro(1).arready,
	    s_axi1_racount => s_axi_ro(1).racount,
	    --
	    s_axi1_rid => s_axi_ro(1).rid,
	    s_axi1_rdata => s_axi_ro(1).rdata,
	    s_axi1_rlast => s_axi_ro(1).rlast,
	    s_axi1_rvalid => s_axi_ro(1).rvalid,
	    s_axi1_rready => s_axi_ri(1).rready,
	    s_axi1_rcount => s_axi_ro(1).rcount,
	    --
	    s_axi1_awid => s_axi_wi(1).awid,
	    s_axi1_awaddr => s_axi_wi(1).awaddr,
	    s_axi1_awburst => s_axi_wi(1).awburst,
	    s_axi1_awlen => s_axi_wi(1).awlen,
	    s_axi1_awsize => s_axi_wi(1).awsize,
	    s_axi1_awprot => s_axi_wi(1).awprot,
	    s_axi1_awvalid => s_axi_wi(1).awvalid,
	    s_axi1_awready => s_axi_wo(1).awready,
	    s_axi1_wacount => s_axi_wo(1).wacount,
	    --
	    s_axi1_wid => s_axi_wi(1).wid,
	    s_axi1_wdata => s_axi_wi(1).wdata,
	    s_axi1_wstrb => s_axi_wi(1).wstrb,
	    s_axi1_wlast => s_axi_wi(1).wlast,
	    s_axi1_wvalid => s_axi_wi(1).wvalid,
	    s_axi1_wready => s_axi_wo(1).wready,
	    s_axi1_wcount => s_axi_wo(1).wcount,
	    --
	    s_axi1_bid => s_axi_wo(1).bid,
	    s_axi1_bresp => s_axi_wo(1).bresp,
	    s_axi1_bvalid => s_axi_wo(1).bvalid,
	    s_axi1_bready => s_axi_wi(1).bready,
	    --
	    s_axi2_aclk => s_axi_aclk(2),
	    s_axi2_areset_n => s_axi_areset_n(2),
	    --
	    s_axi2_arid => s_axi_ri(2).arid,
	    s_axi2_araddr => s_axi_ri(2).araddr,
	    s_axi2_arburst => s_axi_ri(2).arburst,
	    s_axi2_arlen => s_axi_ri(2).arlen,
	    s_axi2_arsize => s_axi_ri(2).arsize,
	    s_axi2_arprot => s_axi_ri(2).arprot,
	    s_axi2_arvalid => s_axi_ri(2).arvalid,
	    s_axi2_arready => s_axi_ro(2).arready,
	    s_axi2_racount => s_axi_ro(2).racount,
	    --
	    s_axi2_rid => s_axi_ro(2).rid,
	    s_axi2_rdata => s_axi_ro(2).rdata,
	    s_axi2_rlast => s_axi_ro(2).rlast,
	    s_axi2_rvalid => s_axi_ro(2).rvalid,
	    s_axi2_rready => s_axi_ri(2).rready,
	    s_axi2_rcount => s_axi_ro(2).rcount,
	    --
	    s_axi2_awid => s_axi_wi(2).awid,
	    s_axi2_awaddr => s_axi_wi(2).awaddr,
	    s_axi2_awburst => s_axi_wi(2).awburst,
	    s_axi2_awlen => s_axi_wi(2).awlen,
	    s_axi2_awsize => s_axi_wi(2).awsize,
	    s_axi2_awprot => s_axi_wi(2).awprot,
	    s_axi2_awvalid => s_axi_wi(2).awvalid,
	    s_axi2_awready => s_axi_wo(2).awready,
	    s_axi2_wacount => s_axi_wo(2).wacount,
	    --
	    s_axi2_wid => s_axi_wi(2).wid,
	    s_axi2_wdata => s_axi_wi(2).wdata,
	    s_axi2_wstrb => s_axi_wi(2).wstrb,
	    s_axi2_wlast => s_axi_wi(2).wlast,
	    s_axi2_wvalid => s_axi_wi(2).wvalid,
	    s_axi2_wready => s_axi_wo(2).wready,
	    s_axi2_wcount => s_axi_wo(2).wcount,
	    --
	    s_axi2_bid => s_axi_wo(2).bid,
	    s_axi2_bresp => s_axi_wo(2).bresp,
	    s_axi2_bvalid => s_axi_wo(2).bvalid,
	    s_axi2_bready => s_axi_wi(2).bready,
	    --
	    s_axi3_aclk => s_axi_aclk(3),
	    s_axi3_areset_n => s_axi_areset_n(3),
	    --
	    s_axi3_arid => s_axi_ri(3).arid,
	    s_axi3_araddr => s_axi_ri(3).araddr,
	    s_axi3_arburst => s_axi_ri(3).arburst,
	    s_axi3_arlen => s_axi_ri(3).arlen,
	    s_axi3_arsize => s_axi_ri(3).arsize,
	    s_axi3_arprot => s_axi_ri(3).arprot,
	    s_axi3_arvalid => s_axi_ri(3).arvalid,
	    s_axi3_arready => s_axi_ro(3).arready,
	    s_axi3_racount => s_axi_ro(3).racount,
	    --
	    s_axi3_rid => s_axi_ro(3).rid,
	    s_axi3_rdata => s_axi_ro(3).rdata,
	    s_axi3_rlast => s_axi_ro(3).rlast,
	    s_axi3_rvalid => s_axi_ro(3).rvalid,
	    s_axi3_rready => s_axi_ri(3).rready,
	    s_axi3_rcount => s_axi_ro(3).rcount,
	    --
	    s_axi3_awid => s_axi_wi(3).awid,
	    s_axi3_awaddr => s_axi_wi(3).awaddr,
	    s_axi3_awburst => s_axi_wi(3).awburst,
	    s_axi3_awlen => s_axi_wi(3).awlen,
	    s_axi3_awsize => s_axi_wi(3).awsize,
	    s_axi3_awprot => s_axi_wi(3).awprot,
	    s_axi3_awvalid => s_axi_wi(3).awvalid,
	    s_axi3_awready => s_axi_wo(3).awready,
	    s_axi3_wacount => s_axi_wo(3).wacount,
	    --
	    s_axi3_wid => s_axi_wi(3).wid,
	    s_axi3_wdata => s_axi_wi(3).wdata,
	    s_axi3_wstrb => s_axi_wi(3).wstrb,
	    s_axi3_wlast => s_axi_wi(3).wlast,
	    s_axi3_wvalid => s_axi_wi(3).wvalid,
	    s_axi3_wready => s_axi_wo(3).wready,
	    s_axi3_wcount => s_axi_wo(3).wcount,
	    --
	    s_axi3_bid => s_axi_wo(3).bid,
	    s_axi3_bresp => s_axi_wo(3).bresp,
	    s_axi3_bvalid => s_axi_wo(3).bvalid,
	    s_axi3_bready => s_axi_wi(3).bready );


    clk_100 <= ps_fclk(0);

    -- cmv_sys_res_n <= '1';


    --------------------------------------------------------------------
    -- CMV PLL
    --------------------------------------------------------------------

    cmv_pll_inst : entity work.cmv_pll (RTL_300MHZ)
	port map (
	    ref_clk_in => clk_100,
	    --
	    pll_locked => cmv_pll_locked,
	    --
	    lvds_clk => cmv_lvds_clk,
	    dly_clk => cmv_dly_clk,
	    cmv_clk => cmv_cmd_clk,
	    spi_clk => cmv_spi_clk,
	    axi_clk => cmv_axi_clk );

        --cmv_clk <= cmv_cmd_clk;

    --------------------------------------------------------------------
    -- AXI3 CMV Interconnect
    --------------------------------------------------------------------

    axi_lite_inst0 : entity work.axi_lite
	port map (
	    s_axi_aclk => m_axi0_aclk,
	    s_axi_areset_n => m_axi0_areset_n,

	    s_axi_ro => m_axi0_ri,
	    s_axi_ri => m_axi0_ro,
	    s_axi_wo => m_axi0_wi,
	    s_axi_wi => m_axi0_wo,

	    m_axi_ro => m_axi0l_ro,
	    m_axi_ri => m_axi0l_ri,
	    m_axi_wo => m_axi0l_wo,
	    m_axi_wi => m_axi0l_wi );

        m_axi0_aclk <= clk_100;
        
    axi_split_inst0 : entity work.axi_split8
    generic map (
        SPLIT_BIT0 => 20,
        SPLIT_BIT1 => 21,
        SPLIT_BIT2 => 22 )        
    port map (
        s_axi_aclk => m_axi0_aclk,
        s_axi_areset_n => m_axi0_areset_n,
        --
        s_axi_ro => m_axi0l_ri,
        s_axi_ri => m_axi0l_ro,
        s_axi_wo => m_axi0l_wi,
        s_axi_wi => m_axi0l_wo,
        --
        m_axi_aclk => m_axi0a_aclk,
        m_axi_areset_n => m_axi0a_areset_n,
        --
        m_axi_ri => m_axi0a_ri,
        m_axi_ro => m_axi0a_ro,
        m_axi_wi => m_axi0a_wi,
        m_axi_wo => m_axi0a_wo );                 
            
    --------------------------------------------------------------------
    -- CMV SPI Interface
    --------------------------------------------------------------------

    reg_spi_inst : entity work.reg_spi
	port map (
	    s_axi_aclk => m_axi0a_aclk(0),
	    s_axi_areset_n => m_axi0a_areset_n(0),
	    --
	    s_axi_ro => m_axi0a_ri(0),
	    s_axi_ri => m_axi0a_ro(0),
	    s_axi_wo => m_axi0a_wi(0),
	    s_axi_wi => m_axi0a_wo(0),
	    --
	    spi_clk_in => cmv_spi_clk,
	    --
	    spi_clk => spi_clk,
	    spi_in => spi_in,
	    spi_out => spi_out,
	    spi_en => spi_en);
	 
    --------------------------------------------------------------------
    -- CMV 12000 Sensor
    --------------------------------------------------------------------
        
    CMV12K : entity work.CMV12k(Behavioral)
        port map(
            SPI_EN    => spi_en, 
            SPI_CLK   => spi_clk, 
            --
            LVDS_CLK  => cmv_lvds_clk, 
            SYS_RES_N => emio_gpio_o(0),
            --
            SPI_IN    => spi_in,
            SPI_OUT   => spi_out);	    

end RTL;