library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity Sequencer is
    Port ( -- SPI Port
           SPI_CLK  : in  std_logic;
           SPI_WnR  : in  std_logic;
           SPI_ADDR : in  std_logic_vector(6 downto  0);
           DATA_IN  : in  std_logic_vector(15 downto 0);
           DATA_OUT : out std_logic_vector(15 downto 0);
             
           -- LVDS Port
           LVDS_CLK  : in  std_logic;
           LVDS_WnR  : in  std_logic;
           LVDS_ADDR : in  std_logic_vector(6 downto  0);
           LVDS_IN   : in  std_logic_vector(15 downto 0);
           LVDS_OUT  : out std_logic_vector(15 downto 0)
            );
end Sequencer;

architecture Behavioral of Sequencer is
    
    type Array_16x128 is array (0 to 255) of std_logic_vector(15 downto 0);
    
    shared variable sequencer_registers : Array_16x128; 
begin
    SPI_Port : process(SPI_CLK)
    begin
        if falling_edge(SPI_CLK) then
            if (SPI_WnR = '1') then
                sequencer_registers(to_integer(unsigned(SPI_ADDR))) := DATA_IN;
            elsif (SPI_WnR = '0') then
                DATA_OUT <= sequencer_registers(to_integer(unsigned(SPI_ADDR)));
            end if; 
        end if;
    end process;
    
    LVDS_Port : process(LVDS_CLK)
    begin
        if falling_edge(LVDS_CLK) then
            if (LVDS_WnR = '1') then
                sequencer_registers(to_integer(unsigned(LVDS_ADDR))) := LVDS_IN;
            elsif (LVDS_WnR = '0') then
                LVDS_OUT <= sequencer_registers(to_integer(unsigned(LVDS_ADDR)));
            end if; 
        end if;
    end process;
    
end Behavioral;
