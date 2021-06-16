----------------------------------------------------------------------------
--CMV12000-Simulation
--Output_Channels.vhd
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

entity Output_Channels is
    Port ( LVDS_CLK         : in  std_logic;
           IDLE             : in  std_logic;
           OH               : in  std_logic; 
           --
           Bit_mode         : in  std_logic_vector(1  downto 0);
           Output_mode      : in  std_logic_vector(5  downto 0);
           Training_pattern : in  std_logic_vector(11 downto 0);
           Channel_en_bot   : in  std_logic_vector(31 downto 0);
           Channel_en_top   : in  std_logic_vector(31 downto 0);
           --
           DVAL             : out  std_logic;
           LVAL             : out  std_logic;
           ch_out           : out senselx128(64 downto 1)
           );
end Output_Channels;

architecture Behavioral of Output_Channels is 

    signal TP_out      : std_logic_vector(11 downto 0);
    signal gen_out     : senselx128(64 downto 1);
    --
    signal OH_Detect   : std_logic := '0';
    signal IDlE_Detect : std_logic := '0';
    signal New_row     : std_logic := '0';
    signal Counter     : std_logic_vector(4 downto 0);
    
begin

    Data_Generation : entity work.Data_Generation(Behavioral)
    port map(
        LVDS_CLK  => LVDS_CLK,
        IDLE      => IDLE, 
        OH        => OH, 
        gen_out   => gen_out);
    
    Data_Training : entity work.Data_Training(Behavioral)
    port map(
        LVDS_CLK          => LVDS_CLK,
        New_row           => New_row, 
        Channel_en        => Channel_en_bot(0),
        Bit_mode          => Bit_mode,
        Training_pattern  => Training_pattern,
        TP_out            => TP_out);
        
    Edge_Detect : process(LVDS_CLK)
    begin
        if rising_edge(LVDS_CLK) then
            OH_Detect   <= OH;
            IDlE_Detect <= IDLE;
        end if;
    end process;
    
    OH_Counter : process(LVDS_CLK)
    begin
        if rising_edge(LVDS_CLK) then
            if (IDlE_Detect = '0' and IDLE = '1') then 
                Counter <= (others => '0');
            elsif (OH_Detect = '1' and OH = '0') then
                case Output_mode(4 downto 0) is
                    when "00001" =>
                        Counter <= Counter + 1;
                        if (Counter = "0001") then
                            Counter <= (others => '0');
                        end if;
                    when "00011" =>
                        Counter <= Counter + 1;
                        if (Counter = "0011") then
                            Counter <= (others => '0');
                        end if;
                    when "00111" =>
                        Counter <= Counter + 1;
                        if (Counter = "0111") then
                            Counter <= (others => '0');
                        end if;
                    when "01111" =>
                        Counter <= Counter + 1;
                        if (Counter = "1111") then
                            Counter <= (others => '0');
                        end if;
                    when "11111" =>
                        Counter <= Counter + 1;
                        if (Counter = "11111") then
                            Counter <= (others => '0');
                        end if;
                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;
    
    New_row <= OH                 when Counter = "00000"      else '0';
    DVAL    <= '1'                when not (OH or IDLE) = '1' else '0';
    LVAL    <= not New_row        when IDLE = '0'             else '0' ;
    ch_out  <= (others => TP_out) when (OH or IDLE) = '1'     else gen_out;
    
end Behavioral;
