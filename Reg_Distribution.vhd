----------------------------------------------------------------------------
--CMV12000-Simulation
--Reg_Distribution.vhd
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

entity Reg_Distribution is --take reset into account
    Port ( LVDS_CLK         : in  std_logic;
           --
           LVDS_R           : out std_logic;
           LVDS_ADDR        : out std_logic_vector(7  downto 0);
           --
           LVDS_OUT         : in  std_logic_vector(15 downto 0);
           --          
           Bit_Mode         : out std_logic_vector(1  downto 0);
           Output_Mode      : out std_logic_vector(5  downto 0);
           Training_Pattern : out std_logic_vector(11 downto 0);
           --
           Channel_en       : out std_logic_vector(2  downto 0);
           Channel_en_bot   : out std_logic_vector(31 downto 0);
           Channel_en_top   : out std_logic_vector(31 downto 0)
           );
end Reg_Distribution;

architecture Behavioral of Reg_Distribution is

    signal Counter   : std_logic_vector(0  downto 0) := (others => '0');
    signal Seq_Addr  : std_logic_vector(6  downto 0) := (others => '0');
    signal Seq_Addr2 : std_logic_vector(6  downto 0) := (others => '0');
    signal Seq_Addr3 : std_logic_vector(6  downto 0) := (others => '0');
    signal Reg_Data  : std_logic_vector(15 downto 0);
    
    
    signal Channel_en_bot1 : std_logic_vector(31  downto 0) := (others => '0');
    signal Channel_en_top1 : std_logic_vector(31  downto 0) := (others => '0');
    
begin


    Count : process(LVDS_CLK)
    begin
        if rising_edge(LVDS_CLK) then
            Counter <= Counter + 1;
    Channel_en_bot <= Channel_en_bot1;
    Channel_en_top <= Channel_en_top1;
        end if;
    end process;
    
    Seq_Read : process(LVDS_CLK)
    begin
        if rising_edge(LVDS_CLK) then
            if (Counter = "1") then
                LVDS_R    <= '1';
                Seq_Addr  <= Seq_Addr + 1;
                Seq_Addr2 <= Seq_Addr;
                Seq_Addr3 <= Seq_Addr2;
            else
                LVDS_R   <= '0';
                Reg_Data <= LVDS_OUT;
            end if;
        end if;
    end process;
    
    Data_Distribution : process(LVDS_CLK)
    begin
        if rising_edge(LVDS_CLK) then
            if (Counter = "0") then
                case Seq_Addr3 is
                    when "1010001" =>
                        Output_Mode      <= LVDS_OUT(5  downto 0);
                    when "1011001" =>
                        Training_Pattern <= LVDS_OUT(11 downto 0);
                    when "1011011" =>
                        Channel_en_bot1   <= LVDS_OUT(15 downto 0) & Reg_Data(15 downto 0);
                    when "1011101" =>
                        Channel_en_top1   <= LVDS_OUT(15 downto 0) & Reg_Data(15 downto 0);
                    when "1011110" =>
                        Channel_en       <= LVDS_OUT(2  downto 0);
                    when "1110110" =>
                        Bit_Mode         <= LVDS_OUT(1  downto 0);
                    when others =>
                        null;
                    end case;
            end if;
        end if;
    end process;
    
    LVDS_ADDR <= '0' & Seq_Addr;
    
end Behavioral;
