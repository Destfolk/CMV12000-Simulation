library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity Sequencer is
    Port ( -- SPI Port
           SPI_CLK  : in  std_logic;
           SPI_WnR  : in  std_logic;
           SPI_ADDR : in  std_logic_vector(7 downto  0);
           DATA_IN  : in  std_logic_vector(15 downto 0);
           DATA_OUT : out std_logic_vector(15 downto 0);
             
           -- LVDS Port
           LVDS_CLK  : in  std_logic;
           LVDS_WnR : in  std_logic;
           LVDS_ADDR : in  std_logic_vector(7 downto  0);
           LVDS_IN   : in  std_logic_vector(15 downto 0);
           LVDS_OUT  : out std_logic_vector(15 downto 0)
            );
end Sequencer;

architecture Behavioral of Sequencer is
    
    type Array_16x256 is array (0 to 255) of std_logic_vector(15 downto 0);
    
    shared variable sequencer_registers : Array_16x256 :=(
        129 => "0000110000000000",
    
        195 => "0000000000000001",
        196 => "0000000000001001",
    
        199 => "0000011000000000",
        
        201 => "0000011000000000",
    
        207 => "0000000000000001",
        208 => "0000000000000001",
    
        210 => "0001011000110010",
        211 => "0001011100000101",
        212 => "0000000010000010",                                                  
        213 => "0000000010000010",                                                  
        214 => "0000000010000010",                                                   
        215 => "0000001100001100",                                                   
        216 => "0000001100001100",                                                   
        217 => "0000000001010101",
        218 => "1111111111111111",
        219 => "1111111111111111",
        220 => "1111111111111111",
        221 => "1111111111111111",
        222 => "0000000000000111",
        223 => "1111111111111111",
        224 => "1111111111111111",
                                                  
        226 => "1000100010001000",
        227 => "1000100010001000",
        
        230 => "0010000001000000",
        231 => "0000111111000000",
        232 => "0000000001000000",
        233 => "0010000001000000",
        234 => "0010000001000000",
        235 => "0011000001100000",
        236 => "0011000001100000",
        237 => "0011000001100000",
        238 => "0011000001100000",
        239 => "1000100010001000",
        
        241 => "0000001100001010",
        242 => "0000000001011111",
        
        244 => "0000000101111111",
        245 => "0000000000000100",
        246 => "0000000000000001",
        
        248 => "0000000000001001",
        249 => "0000000000000001",
        250 => "0000000000100000",
        
        252 => "0000000000000101",
        253 => "0000000000000010",
        254 => "0000001100000010",
        
        others => (others => '0'));
     
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
