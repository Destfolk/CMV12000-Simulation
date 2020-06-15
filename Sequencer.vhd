library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity Sequencer is
    Port ( SPI_CLK  :in  std_logic;
           LVDS_CLK :in  std_logic;
           
           Address : in std_logic_vector (7 downto 0);
           SPI_OUT : in std_logic_vector (15 downto 0);
           
           Sequencer_OUT : out std_logic_vector (15 downto 0)
           );
end Sequencer;

architecture Behavioral of Sequencer is
    
    type statetype is (idle, receive, send);
    
    signal state     : statetype; 
    signal nextstate : statetype;
    
    type Array_16x128 is array (0 to 127) of std_logic_vector(15 downto 0);
    
    signal sequencer_registers : Array_16x128;  
        
begin
    process(SPI_CLK)
    begin
        if rising_edge(SPI_CLK) then
                           
    end process;
    
  
end Behavioral;
