----------------------------------------------------------------------------
--CMV12000-Simulation
--SPI_Interface.vhd
--
--Apertus AXIOM Beta
--
--Copyright (C) 2020 Seif Eldeen Emad Abdalazeem
--Email: destfolk@gmail.com
----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use ieee.std_logic_unsigned.all;

entity SPI_Interface is
    Port ( SPI_EN    : in  std_logic;
           SPI_CLK   : in  std_logic;
           LVDS_CLK  : in  std_logic;
           SYS_RES_N : in  std_logic;
           SPI_IN    : in  std_logic;
           SPI_OUT   : out std_logic
           );
end SPI_Interface;

architecture Behavioral of SPI_Interface is

    type Array_16x128 is array (0 to 127) of std_logic_vector(15 downto 0);
    
    signal sequencer_register : Array_16x128;
    
    signal Address    : integer;
    signal CountW_int : integer;
    signal CountR_int : integer;
    signal counter_W  : std_logic_vector (4 downto 0)  := "11000";
    signal counter_R  : std_logic_vector (4 downto 0)  := "10000";
    signal data_reg   : std_logic_vector (23 downto 0) := (others => '0');

begin
    CountR_int <= to_integer(unsigned(counter_R));
    CountW_int <= to_integer(unsigned(counter_W));
    Address    <= to_integer(unsigned(data_reg(22 downto 16)));
    
    process(LVDS_CLK, SPI_CLK)
    begin
        if falling_edge(LVDS_CLK) then
            if (SYS_RES_N = '0') then
                sequencer_register(0)              <= (others => '0');
                sequencer_register(1)              <= "0000110000000000";
                --sequencer_register(66 downto 0)    <= (others => (others => '0'));
                sequencer_register(67)             <= "0000000000000001";
                sequencer_register(68)             <= "0000000000001001";
               -- sequencer_register(70 downto 69)   <= (others => (others => '0'));
                sequencer_register(71)             <= "0000011000000000";
                sequencer_register(72)             <= (others => '0');
                sequencer_register(73)             <= "0000011000000000";
                --sequencer_register(78 downto 74)   <= (others => (others => '0'));
                sequencer_register(79)             <= "0000000000000001";
                sequencer_register(80)             <= "0000000000000001";
                sequencer_register(81)             <= (others => '0');
                sequencer_register(82)             <= "0001011000110010";
                sequencer_register(83)             <= "0001011100000101";
                sequencer_register(84)             <= "0000000010000010";
                sequencer_register(85)             <= "0000000010000010";
                sequencer_register(86)             <= "0000000010000010";
                sequencer_register(87)             <= "0000001100001100";
                sequencer_register(88)             <= "0000001100001100";
                sequencer_register(89)             <= "0000000001010101";
                sequencer_register(90)             <= "1111111111111111";
                sequencer_register(91)             <= "1111111111111111";
                sequencer_register(92)             <= "1111111111111111";
                sequencer_register(93)             <= "1111111111111111";
                sequencer_register(94)             <= "0000000000000111";
                sequencer_register(95)             <= "1111111111111111";
                sequencer_register(96)             <= "1111111111111111";
                sequencer_register(97)             <= (others => '0');
                sequencer_register(98)             <= "1000100010001000";
                sequencer_register(99)             <= "1000100010001000";
                --sequencer_register(101 downto 100) <= (others => (others => '0'));
                sequencer_register(102)            <= "0010000001000000";
                sequencer_register(103)            <= "0000111111000000";
                sequencer_register(104)            <= "0000000001000000";
                sequencer_register(105)            <= "0010000001000000";
                sequencer_register(106)            <= "0010000001000000";
                sequencer_register(107)            <= "0011000001100000";
                sequencer_register(108)            <= "0011000001100000";
                sequencer_register(109)            <= "0011000001100000";
                sequencer_register(110)            <= "0011000001100000";
                sequencer_register(111)            <= "1000100010001000";
                sequencer_register(112)            <= (others => '0');
                sequencer_register(113)            <= "0000001100001010";
                sequencer_register(114)            <= "0000000001011111";
                sequencer_register(115)            <= (others => '0');
                sequencer_register(116)            <= "0000000101111111";
                sequencer_register(117)            <= "0000000000000100";
                sequencer_register(118)            <= "0000000000000001";
                sequencer_register(119)            <= (others => '0');
                sequencer_register(120)            <= "0000000000001001";
                sequencer_register(121)            <= "0000000000000001";
                sequencer_register(122)            <= "0000000000100000";
                sequencer_register(123)            <= (others => '0');
                sequencer_register(124)            <= "0000000000000101";
                sequencer_register(125)            <= "0000000000000010";
                sequencer_register(126)            <= "0000001100000010";
                sequencer_register(127)            <= (others => '0');
            end if;    
        end if;
        
        if falling_edge(SPI_CLK) then
            if (counter_W = "00000") then
                sequencer_register(Address) <= data_reg(15 downto 0);
            end if;
        end if;
    end process;
    
    process(SPI_CLK)
    begin
        if rising_edge(SPI_CLK) and SPI_EN = '1' and counter_W /= "11000" then
                data_reg(CountW_int) <= SPI_IN;
        end if;
    end process;                                        
                    
    process(SPI_CLK)
    begin
        if falling_edge(SPI_CLK) then
            if (SPI_EN = '1' and counter_W > "00000") then
                counter_W <= counter_W - 1;
            elsif (counter_W = "00000") then
                counter_W <= "10111";
            elsif (SPI_EN = '0') then
                counter_W <= "11000";
            end if;                           
        end if;   
    end process;
    
    process(SPI_CLK)
    begin
        if rising_edge(SPI_CLK) then
            if (data_reg(23) = '1' and counter_W <= "10001") then
                counter_R <= counter_R - 1;
            else
                counter_R <= "10000";
            end if;    
        end if;
    end process;
    
    process(SPI_CLK)
    begin
        if falling_edge(SPI_CLK) then
            if (counter_R <= "01111") then
                SPI_OUT <= sequencer_register(Address)(CountR_int);
            else
                SPI_OUT <= '0';    
            end if;                         
        end if;   
    end process;

end Behavioral;
               
