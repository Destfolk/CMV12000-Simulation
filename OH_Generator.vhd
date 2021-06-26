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

    signal OH_reg       : std_logic := '0';
    --
    signal IDLE_fall    : std_logic;
    signal IDLE_rise    : std_logic;
    signal IDlE_Detect  : std_logic := '1';
    --
    signal Mode_Count   : std_logic_vector(3 downto 0) := (others => '1');
    signal OH_Counter   : std_logic_vector(3 downto 0) := (others => '0');
    signal Data_Counter : std_logic_vector(6 downto 0) := (others => '1');
    
begin

    Edge_Detect : process(LVDS_CLK)
    begin
        if rising_edge(LVDS_CLK) then
            IDlE_Detect <= IDlE;
        end if;
    end process;
    
    Mode_Adjustment : process(LVDS_CLK)
    begin
        if rising_edge(LVDS_CLK) then
            case Bit_mode is
                when "00" =>
                    if (IDLE_fall = '1') then
                        Mode_Count <= "1011";
                    elsif(Data_Counter = "0000000") then
                        Mode_Count <= "1100";
                    end if;
                when "01" =>
                    if (IDLE_fall = '1') then
                        Mode_Count <= "1001";
                    elsif(Data_Counter = "0000000") then
                        Mode_Count <= "1010";
                    end if;
                when "10" =>
                    if (IDLE_fall = '1') then
                        Mode_Count <= "0111";
                    elsif(Data_Counter = "0000000") then
                        Mode_Count <= "1000";
                    end if;
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
            if (IDLE = '1') then
                OH_Counter <= (others => '0');
                OH_reg <= '0';
            elsif (Data_Counter = "1111111") then
                case Bit_mode is
                    when "00" =>
                        if (OH_Counter = Mode_Count) then
                            OH_reg <= '0';
                            OH_Counter <= (others => '0');
                        else
                            OH_reg <= '1';
                            OH_Counter <= OH_Counter + 1;
                        end if;
                    when "01" =>
                        if (OH_Counter = Mode_Count) then
                            OH_reg <= '0';
                            OH_Counter <= (others => '0');
                        else
                            OH_reg <= '1';
                            OH_Counter <= OH_Counter + 1;
                        end if;
                    when "10" =>
                        if (OH_Counter = Mode_Count) then
                            OH_reg <= '0';
                            OH_Counter <= (others => '0');
                        else
                            OH_reg <= '1';
                            OH_Counter <= OH_Counter + 1;
                        end if;
                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;

    IDLE_fall <= IDlE_Detect and not IDLE;
    IDLE_rise <= not IDlE_Detect and IDLE;
    
    OH <= not IDlE when IDLE_fall = '1'
    else  not IDlE when IDLE_rise = '1'
    else  '1'      when OH_reg    = '1' 
    else  '0';
    
end Behavioral;
