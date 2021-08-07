----------------------------------------------------------------------------
--CMV12000-Simulation
--Data_Training.vhd
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

entity Data_Training is                         
    Port ( Word_Clk         : in  std_logic; -- need to acount for Idle Signal
           New_Row          : in  std_logic;         
           Train_Enable     : in  std_logic;
           Bit_Mode         : in  std_logic_vector(1  downto 0);
           Training_Pattern : in  std_logic_vector(11 downto 0);
           TP_Out           : out std_logic_vector(11 downto 0)
          );
end Data_Training;

architecture Behavioral of Data_Training is

    signal Row_Detect    : std_logic := '0';
    signal Enable_Detect : std_logic := '0';
    
    signal TP1           : std_logic_vector(11 downto 0);
    signal TP2           : std_logic_vector(11 downto 0);
    
begin
    
    Edge_Detect : process(Word_Clk)
    begin
        if rising_edge(Word_Clk) then
            Row_Detect     <= New_Row;
            Enable_Detect  <= Train_Enable;
        end if;
    end process;
    
    Pattern : process(Word_Clk)
    begin
        if rising_edge(Word_Clk) then
            if (Enable_Detect = '0' and Train_Enable = '1') then
                TP1     <= Training_Pattern;
                TP2     <= "0000" & not Training_Pattern(7 downto 0);
            elsif (Row_Detect = '1' and New_Row = '0') then
                case Bit_Mode is
                    when "00" =>
                        TP1(11 downto 0) <= TP1(10 downto 0) & TP1(11);
                        TP2(11 downto 0) <= TP2(0) & TP2(11 downto 1);
                    when "01" =>
                        TP1(9  downto 0) <= TP1(8  downto 0) & TP1(9);
                        TP2(9  downto 0) <= TP2(0) & TP2(9 downto 1);
                    when "10" =>
                        TP1(7  downto 0) <= TP1(6  downto 0) & TP1(7);
                        TP2(7  downto 0) <= TP2(0) & TP2(7 downto 1);
                    when others =>
                        null;
                end case;
            end if; 
        end if;
    end process;   
    
    Output_Register : process(Word_Clk)
    begin
        if rising_edge(Word_Clk) then
            if (New_Row = '1') then
                TP_Out <= TP1(10 downto 0) & TP2(0);
            else
                TP_Out <= TP1;
            end if;
        end if;
    end process;
    
end Behavioral;