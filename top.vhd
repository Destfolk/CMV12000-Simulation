library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use ieee.std_logic_unsigned.all;

library work;
use work.Function_pkg.all;

entity top is
   Port (  SPI_EN    : in  std_logic;
           SPI_CLK   : in  std_logic;
           LVDS_CLK  : in  std_logic;
           SYS_RES_N : in  std_logic;
           SPI_IN    : in  std_logic;
           SPI_OUT   : out std_logic
           );
end top;

architecture Behavioral of top is
    
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
    
    signal LVDS_WnR    : std_logic := '0';
    signal LVDS_IN     : std_logic_vector(15 downto 0);
    signal LVDS_OUT    : std_logic_vector(15 downto 0);
    
    signal LVDS_ADDR   : std_logic_vector(7 downto 0) := "10000000";
    signal LVDS_R_ADDR : std_logic_vector(7 downto 0) := "10000000";
    signal LVDS_W_ADDR : std_logic_vector(7 downto 0) := (others =>'0');
    signal STATE_ADDR  : std_logic_vector(1 downto 0) := (others =>'0');
    
begin
    
    Reg_Reset : entity work.Reg_Reset(Behavioral)
        port map (
           LVDS_CLK  => LVDS_CLK,
           SYS_RES_N => SYS_RES_N,
           --
           LVDS_OUT  => LVDS_OUT,
           --
           LVDS_IN   => LVDS_IN,
           LVDS_WnR  => LVDS_WnR,
           LVDS_ADDR => LVDS_ADDR);
           
    SPI_Interface : entity work.SPI_Interface(Behavioral)
        port map (
           SPI_EN        => SPI_EN,
           SPI_CLK       => SPI_CLK,
           --
           SPI_IN        => SPI_IN,
           SPI_OUT       => SPI_OUT,
           --
           W_not_R       => SPI_WnR,
           ADDR          => SPI_ADDR,
           --
           TEMP_DATA_IN  => TEMP_DATA_IN,
           TEMP_DATA_OUT => TEMP_DATA_OUT);
    
    Registers : entity work.Sequencer(Behavioral)
        port map (
           SPI_CLK   => SPI_CLK,
           SPI_WnR   => SPI_WnR,
           SPI_ADDR  => SPI_ADDR,
           DATA_IN   => TEMP_DATA_OUT,
           DATA_OUT  => TEMP_DATA_IN,
           --
           LVDS_CLK  => LVDS_CLK,
           LVDS_WnR  => LVDS_WnR,
           LVDS_ADDR => LVDS_ADDR,
           LVDS_IN   => LVDS_IN,
           LVDS_OUT  => LVDS_OUT);      
    
end Behavioral;
