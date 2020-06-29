library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use ieee.std_logic_unsigned.all;
entity Seq_Initializer is
    Port ( LVDS_CLK  : in  std_logic;
           SYS_RES_N : in  std_logic;
           ADDR      : out  std_logic_vector(6  downto 0);
           --xxx  : in std_logic_vector(15 downto 0);
           REG_DATA  : out std_logic_vector(15 downto 0)
           );
end Seq_Initializer;

architecture Behavioral of Seq_Initializer is
    
    signal count : std_logic_vector(6 downto 0) := (others =>'0');
    signal temp : std_logic_vector(15 downto 0) := (others =>'0');
    
    type Array_16x128 is array (0 to 255) of std_logic_vector(15 downto 0);
    
    shared variable sequencer_registers : Array_16x128 :=(
        1   => "0000110000000000",
    
        67  => "0000000000000001",
        68  => "0000000000001001",
    
        71  => "0000011000000000",
        
        73  => "0000011000000000",
    
        79  => "0000000000000001",
        80  => "0000000000000001",
    
        82  => "0001011000110010",
        83  => "0001011100000101",
        84  => "0000000010000010",                                                  
        85  => "0000000010000010",                                                  
        86  => "0000000010000010",                                                   
        87  => "0000001100001100",                                                   
        88  => "0000001100001100",                                                   
        89  => "0000000001010101",
        90  => "1111111111111111",
        91  => "1111111111111111",
        92  => "1111111111111111",
        93  => "1111111111111111",
        94  => "0000000000000111",
        95  => "1111111111111111",
        96  => "1111111111111111",
                                                  
        98  => "1000100010001000",
        99  => "1000100010001000",
        
        102 => "0010000001000000",
        103 => "0000111111000000",
        104 => "0000000001000000",
        105 => "0010000001000000",
        106 => "0010000001000000",
        107 => "0011000001100000",
        108 => "0011000001100000",
        109 => "0011000001100000",
        110 => "0011000001100000",
        111 => "1000100010001000",
        
        113 => "0000001100001010",
        114 => "0000000001011111",
        
        116 => "0000000101111111",
        117 => "0000000000000100",
        118 => "0000000000000001",
        
        120 => "0000000000001001",
        121 => "0000000000000001",
        122 => "0000000000100000",
        
        124 => "0000000000000101",
        125 => "0000000000000010",
        126 => "0000001100000010",
        
        others => (others => '0'));
    
begin
    process(LVDS_CLK)
    begin
        if rising_edge(LVDS_CLK) then
            if (SYS_RES_N = '1') then
                count <= count +1;
                ADDR <= count;
                end if;
        end if;
    end process;
    
    process(LVDS_CLK)
    begin
        if rising_edge(LVDS_CLK) then
            if (SYS_RES_N = '1') then
            temp<=sequencer_registers(to_integer(unsigned(count)));
            REG_DATA <= temp;
        end if;
                end if;
    end process;
    
end Behavioral;
