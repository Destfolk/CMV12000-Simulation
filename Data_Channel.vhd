----------------------------------------------------------------------------
--CMV12000-Simulation
--Data_Channel.vhd
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

library work;
use work.Function_pkg.all;

entity Data_Channel is
    Port ( LVDS_CLK    : in  std_logic;
           --
           OutMode_EN  : in  std_logic;
           Channel_EN  : in  std_logic;
           --
           Bit_Mode    : in  std_logic_vector(1 downto 0);
           --
           DATA_IN     : in  std_logic_vector(1535 downto 0);
           DATA_OUT    : out std_logic
         );
 
end Data_Channel;

architecture Behavioral of Data_Channel is

    signal Done         : std_logic := '0';
    signal OH           : std_logic := '0';
    signal OH_Counter   : std_logic_vector(3  downto 0) := (others => '0');
    signal Data_Counter : std_logic_vector(10 downto 0) := (others => '0');
    
begin
    Data_Count : process(LVDS_CLK)
    begin
        if falling_edge(LVDS_CLK) then
            if (OutMode_EN = '1' and Channel_EN = '1') then
                Data_Counter <= Data_Counter + 1;
                
                if (Bit_Mode = "00" and Data_Counter = "11000000000") then
                    Done <= '1';
                    Data_Counter <= (others => '0');
                elsif (Bit_Mode = "01" and Data_Counter = "10100000000") then
                    Done <= '1';
                    Data_Counter <= (others => '0');
                elsif (Bit_Mode = "10" and Data_Counter = "10000000000") then
                    Done <= '1';
                    Data_Counter <= (others => '0');
                elsif( Done = '1' and OH_Counter = "0000") then
                    Done <= '0';
                end if;
            end if;
        end if;                                        
    end process;
    
    OH_Count : process(LVDS_CLK)
    begin
        if falling_edge(LVDS_CLK) then
            if (Done = '1') then
                OH_Counter <= OH_Counter + 1;
                
                if (Bit_Mode = "00" and OH_Counter = "1101") then
                    OH <= '0';
                    OH_Counter <= (others => '0');
                elsif (Bit_Mode = "01" and OH_Counter = "1011") then
                    OH <= '0';
                    OH_Counter <= (others => '0');
                elsif (Bit_Mode = "10" and OH_Counter = "1001") then
                    OH <= '0';
                    OH_Counter <= (others => '0');
                end if;
            end if;
        end if;         
    end process;
    
    Output_N : process(LVDS_CLK)
    begin
        if falling_edge(LVDS_CLK) then
            if (OutMode_EN = '1' and Channel_EN = '1') then
                DATA_OUT <= DATA_IN(index(Data_Counter));
            elsif (OH = '1') then
                DATA_OUT <= '0';
            end if;
        end if;                                        
    end process;
    
end Behavioral;