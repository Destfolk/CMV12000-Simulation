----------------------------------------------------------------------------
--CMV12000-Simulation
--CMV12k.vhd
--
--Apertus AXIOM Beta
--
--Copyright (C) 2021 Seif Eldeen Emad Abdalazeem
--Email: destfolk@gmail.com
----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use ieee.std_logic_unsigned.all;

library work;
use work.Function_pkg.all;

entity CMV12k is
    Port ( SPI_CLK   : in  std_logic;
           SPI_EN    : in  std_logic;
           --
           LVDS_CLK  : in  std_logic;
           SYS_RES_N : in  std_logic;
           --
           SPI_IN    : in  std_logic;
           SPI_OUT   : out std_logic;
           --
           Word_Clk  : in  std_logic;
           T_EXP1    : in  std_logic;
           tp  : out std_logic_vector (11 downto 0);
           par_ctrl  : out std_logic_vector (11 downto 0);
           par_data_top  : out senselx128 (32 downto 1);
           par_data_bot  : out senselx128 (32 downto 1)                    
           );
end CMV12k;

architecture Behavioral of CMV12k is
    
    --------------------------
    -- SPI Port Signals
    --------------------------
    
    signal SPI_WnR       : std_logic;
    signal SPI_ADDR      : std_logic_vector(7 downto 0);
    signal TEMP_DATA_IN  : std_logic_vector(15 downto 0);
    signal TEMP_DATA_OUT : std_logic_vector(15 downto 0);
    
    --------------------------
    -- LVDS Port Signals
    --------------------------
    
    signal LVDS_W      : std_logic := '0';
    signal LVDS_R      : std_logic := '0';
    signal LVDS_IN     : std_logic_vector(15 downto 0);
    signal LVDS_OUT    : std_logic_vector(15 downto 0);
    
    signal LVDS_ADDR   : std_logic_vector(7 downto 0) := "10000000";
    signal LVDS_R_ADDR : std_logic_vector(7 downto 0) := "10000000";
    signal LVDS_W_ADDR : std_logic_vector(7 downto 0) := (others =>'0');
    signal STATE_ADDR  : std_logic_vector(1 downto 0) := (others =>'0');
    
    
    signal Bit_mode             : std_logic_vector(1  downto 0);
    signal Output_mode          : std_logic_vector(5  downto 0);
    signal Training_pattern     : std_logic_vector(11 downto 0);
    signal Channel_en           : std_logic_vector(2  downto 0);
    signal Channel_en_bot       : std_logic_vector(31 downto 0);
    signal Channel_en_top       : std_logic_vector(31 downto 0);
    
begin
    tp <= Training_pattern;
     --Reg_Reset : entity work.Reg_Reset(Behavioral)
     --   port map (
     --       LVDS_CLK  => '0',--LVDS_CLK,
     --       SYS_RES_N => SYS_RES_N,
            --
     --       LVDS_OUT  => LVDS_OUT,
     --       LVDS_IN   => LVDS_IN,
            --
      --      LVDS_W    => LVDS_W,
       --     LVDS_R    => LVDS_R,
            --
      --      LVDS_ADDR => LVDS_ADDR);
           
    Registers : entity work.Sequencer(Behavioral)
        port map (
            -- SPI Port
            SPI_CLK   => SPI_CLK,
            SPI_WnR   => SPI_WnR,
            --
            SPI_ADDR  => SPI_ADDR,
            --
            DATA_IN   => TEMP_DATA_OUT,
            DATA_OUT  => TEMP_DATA_IN,
           
            -- LVDS Port
            LVDS_CLK  => LVDS_CLK,
            LVDS_W    => LVDS_W,
            LVDS_R    => LVDS_R,
            --
            LVDS_ADDR => LVDS_ADDR,
            --
            LVDS_IN   => LVDS_IN,
            LVDS_OUT  => LVDS_OUT);
           
    SPI_Interface : entity work.SPI_Interface(Behavioral)
        port map (
            SPI_CLK       => SPI_CLK,
            SPI_EN        => SPI_EN,
            --
            SPI_IN        => SPI_IN,
            SPI_OUT       => SPI_OUT,
            --
            W_not_R       => SPI_WnR,
            ADDR          => SPI_ADDR,
            --
            TEMP_DATA_IN  => TEMP_DATA_IN,
            TEMP_DATA_OUT => TEMP_DATA_OUT);
            
        Reg_dist : entity work.Reg_Distribution(Behavioral)
        port map(
            LVDS_CLK  => Word_Clk,
            --
            LVDS_R    => LVDS_R,
            LVDS_ADDR => LVDS_ADDR,
            --
            LVDS_OUT  => LVDS_OUT,
            --
            Bit_mode          => Bit_mode,
            Output_mode       => Output_mode,
            Training_pattern  => Training_pattern,
            --
            Channel_en        => Channel_en,
            Channel_en_bot    => Channel_en_bot,
            Channel_en_top    => Channel_en_top);
            
    Par_Data_Channels : entity work.Output_Channels(Behavioral)
        port map(
            Word_Clk          => Word_Clk,
            T_EXP1            => T_EXP1, 
            --
            Bit_mode          => Bit_mode,
            Output_mode       => Output_mode,
            Training_pattern  => Training_pattern,
            --
            Channel_en        => Channel_en,
            Channel_en_bot    => Channel_en_bot,
            Channel_en_top    => Channel_en_top,
            --
            Control_Channel   => par_ctrl,
            ch_out1           => par_data_top,
            ch_out2           => par_data_bot);
    
end Behavioral;