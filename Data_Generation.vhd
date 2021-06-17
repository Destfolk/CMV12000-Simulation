----------------------------------------------------------------------------
--CMV12000-Simulation
--Data_Generation.vhd
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

entity Data_Generation is
    Port ( LVDS_CLK : in  std_logic;
           IDLE     : in  std_logic;
           OH       : in  std_logic;
           gen_out  : out senselx128(64 downto 1)
           );
end Data_Generation;

architecture Behavioral of Data_Generation is

    signal Row         : integer   :=  0;
    signal OH_Detect   : std_logic := '0';
    signal IDLE_Detect : std_logic := '0';
    signal Data_out    : senselx128(64 downto 1) := (others => (others => '0'));
    
begin
    
    Edge_Detect : process(LVDS_CLK)
    begin
        if rising_edge(LVDS_CLK) then
            OH_Detect   <= OH;
            IDLE_Detect <= IDLE;   
        end if;
    end process;
    
    Data_generation : process(LVDS_CLK)
    begin
        if rising_edge(LVDS_CLK) then
            if (IDLE_Detect = '0' and IDLE = '1') then
                for x in 1 to 32 loop
                    Data_out(x)    <= Data_out(x) + x*128 - 2*128;
                    Data_out(x+32) <= Data_out(x+32) +(x+32)*128 - 2*128; 
                end loop;
            --elsif (Row = 3072) then
                --Data_out <= (others => (others => '0'));
            elsif (OH_Detect = '0' and OH = '1') then
                --Row <= Row + 2;
                for x in 64 downto 1 loop
                    Data_out(x) <= Data_out(x) + 128;
                end loop;
            end if;
        end if;
    end process;

    gen_out <= Data_out;
    
end Behavioral;
