----------------------------------------------------------------------------
--CMV12000-Simulation
--OH_Generator.vhd
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

entity OH_Generator is
    Port ( LVDS_CLK : in  std_logic;
           IDLE     : in  std_logic;
           Bit_mode : in  std_logic_vector(1 downto 0);
           OH       : out std_logic
           );
end OH_Generator;

architecture Behavioral of OH_Generator is

    signal Mode_Count   : std_logic_vector(3 downto 0) := (others => '1');
    signal OH_Counter   : std_logic_vector(3 downto 0) := (others => '0');
    signal Data_Counter : std_logic_vector(6 downto 0) := (others => '1');
    
begin

    Mode_Adjustment : process(LVDS_CLK)
    begin
        if rising_edge(LVDS_CLK) then
            case Bit_mode is
                when "00" =>
                        Mode_Count <= "1100";
                when "01" =>
                        Mode_Count <= "1010";
                when "10" =>
                        Mode_Count <= "1000";
                when others =>
                    null;
            end case;
        end if;
    end process;
    
    Data_Count : process(LVDS_CLK)
    begin
        if rising_edge(LVDS_CLK) then
            if (IDLE = '1') then
                Data_Counter <= (others => '1');
            elsif (OH_Counter = Mode_Count or Data_Counter < "1111111") then
                Data_Counter <= Data_Counter + 1;
            end if;
        end if;
    end process;
    
    OH_Count : process(LVDS_CLK)
    begin
        if rising_edge(LVDS_CLK) then
            if (IDLE = '1' or OH_Counter = Mode_Count) then
                OH         <= '0';
                OH_Counter <= (others => '0');
            elsif (Data_Counter = "1111111") then
                OH         <= '1';
                OH_Counter <= OH_Counter + 1;
            end if;
        end if;
    end process;
    
end Behavioral;