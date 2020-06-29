library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use ieee.std_logic_unsigned.all;

entity top is
   Port (  LVDS_CLK  : in  std_logic;
           SPI_CLK  : in  std_logic; 
           SYS_RES_N : in  std_logic;
           LVDS_OUT   : out std_logic_vector(15 downto 0)
           );
end top;

architecture Behavioral of top is
    
    signal SPI_WnR      : std_logic;
    signal ADDR         : std_logic_vector(6 downto 0);
    signal TEMP_DATA_IN : std_logic_vector(15 downto 0);
    signal DATA_OUT     : std_logic_vector(15 downto 0);
    
    signal DATA_REQ     : std_logic;
    signal LVDS_ADDR    : std_logic_vector(6 downto 0);
    signal LVDS_IN      : std_logic_vector(15 downto 0);
    signal TEMP_DATA_OUT: std_logic_vector(15 downto 0);
    signal addr_count   : std_logic_vector(6 downto 0) := (others =>'0');
    
begin
    
    
    REG : entity work.Sequencer(Behavioral)
        port map (
           SPI_CLK   => SPI_CLK,
           SPI_WnR   => SPI_WnR,
           SPI_ADDR  => ADDR,
           DATA_IN   => TEMP_DATA_OUT,
           DATA_OUT  => DATA_OUT,
           
           LVDS_CLK    => LVDS_CLK,
           LVDS_WnR    => SYS_RES_N,
           LVDS_ADDR   => addr_count,
           LVDS_IN     => LVDS_IN,
           LVDS_OUT    => LVDS_OUT);
    
    INIT : entity work.Seq_Initializer(Behavioral)
        port map (
           LVDS_CLK    => LVDS_CLK,
           SYS_RES_N   => SYS_RES_N,
           ADDR        => addr_count,
           REG_DATA    => LVDS_IN);           
           
        

end Behavioral;
