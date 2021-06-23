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
           --
           Bit_mode         : in  std_logic_vector(1  downto 0);
           Output_mode      : in  std_logic_vector(5  downto 0);
           Training_pattern : in  std_logic_vector(11 downto 0);
           --
           Channel_en       : in  std_logic_vector(2  downto 0);
           Channel_en_bot   : in  std_logic_vector(31 downto 0);
           Channel_en_top   : in  std_logic_vector(31 downto 0);
           --
           Control_Channel  : out std_logic_vector(11 downto 0);
           ch_out           : out senselx128(64 downto 1)
           );
end Output_Channels;

architecture Behavioral of Output_Channels is 

    signal TP_Idle      : std_logic_vector(11 downto 0);
    signal TP_out       : std_logic_vector(11 downto 0);
    signal gen_out      : senselx128(64 downto 1);
    signal ch_out_bot   : senselx128(32 downto 1);
    signal ch_out_top   : senselx128(32 downto 1);
    --
    signal FOT          : std_logic := '0';
    signal INTE1        : std_logic := '0';
    signal INTE2        : std_logic := '0';
    signal FVAL         : std_logic := '0';
    signal LVAL         : std_logic := '0';
    signal DVAL         : std_logic := '0';
    --
    signal OH           : std_logic := '0';
    signal OH_Detect    : std_logic := '0';
    signal IDLE_Detect  : std_logic := '0';
    signal New_row      : std_logic := '0';
    signal Train_enable : std_logic := '0';
    signal Counter      : std_logic_vector(4  downto 0);
    signal Enable       : std_logic_vector(31 downto 0);
    
begin  

    OH_Generator : entity work.OH_Generator(Behavioral)
    port map(
        LVDS_CLK => LVDS_CLK,
        IDLE     => IDLE,
        Bit_mode => Bit_mode, 
        OH       => OH );
        
    Data_Training : entity work.Data_Training(Behavioral)
    port map(
        LVDS_CLK          => LVDS_CLK,
        New_row           => New_row, 
        Train_enable      => Train_enable,
        Bit_mode          => Bit_mode,
        Training_pattern  => Training_pattern,
        TP_out            => TP_out);
        
    Data_Generation : entity work.Data_Generation(Behavioral)
    port map(
        LVDS_CLK    => LVDS_CLK,
        IDLE        => IDLE, 
        OH          => OH, 
        New_row     => New_row,
        Output_mode => Output_mode,
        FVAL        => FVAL, 
        gen_out     => gen_out);
    
    Edge_Detect : process(LVDS_CLK)
    begin
        if rising_edge(LVDS_CLK) then
            OH_Detect   <= OH;
            IDLE_Detect <= IDLE;
            TP_Idle     <= Training_pattern;
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
    
    Bot_Channels : process(Channel_en_bot, Output_mode, OH, IDLE, TP_Idle, TP_out, gen_out)
    begin
        for x in 1 to 32 loop
            if (Channel_en_bot(x - 1) = '0') then
                ch_out_bot(x) <= (others => '0');
            else
                case Output_mode(4 downto 0) is
                    when "00000" =>
                        if ((OH or IDLE) = '1') then
                            ch_out_bot(x) <= TP_out;
                        else
                            ch_out_bot(x) <= gen_out(x);
                        end if;
                    when "00001" =>
                        if (x = 1 or x = 3 or x = 5 or x = 7 or x = 9 or x = 11 or x = 13 or x = 15 or
                            x = 17 or x = 19 or x = 21 or x = 23 or x = 25 or x = 27 or x = 29 or x = 31) then
                            if ((OH or IDLE) = '1') then
                                ch_out_bot(x) <= TP_out;
                            else 
                                ch_out_bot(x) <= gen_out(x);
                            end if;
                        else
                            ch_out_bot(x) <= TP_Idle;
                        end if;
                    when "00011" =>
                        if (x = 1 or x = 5 or x = 9 or x = 13 or x = 17 or x = 21 or x = 25 or x = 29) then
                            if ((OH or IDLE) = '1') then
                                ch_out_bot(x) <= TP_out;
                            else 
                                ch_out_bot(x) <= gen_out(x);
                            end if;
                        else
                            ch_out_bot(x) <= TP_Idle;
                        end if;
                    when "00111" =>
                        if (x = 1 or x = 9 or x = 17 or x = 25) then
                            if ((OH or IDLE) = '1') then
                                ch_out_bot(x) <= TP_out;
                            else 
                                ch_out_bot(x) <= gen_out(x);
                            end if;
                        else
                            ch_out_bot(x) <= TP_Idle;
                        end if;
                    when "01111" =>
                        if (x = 1 or x = 17) then
                            if ((OH or IDLE) = '1') then
                                ch_out_bot(x) <= TP_out;
                            else 
                                ch_out_bot(x) <= gen_out(x);
                            end if;
                        else
                            ch_out_bot(x) <= TP_Idle;
                        end if;
                    when "11111" =>
                        if (x = 1) then
                            if ((OH or IDLE) = '1') then
                                ch_out_bot(x) <= TP_out;
                            else 
                                ch_out_bot(x) <= gen_out(x);
                            end if;
                        else
                            ch_out_bot(x) <= TP_Idle;
                        end if;
                    when others =>
                        null;
                end case;
            end if;
        end loop;   
    end process;
    
    Top_Channels : process(Channel_en_top, Output_mode, OH, IDLE, TP_Idle, TP_out, gen_out)
    begin
        for x in 1 to 32 loop
            if (Channel_en_top(x - 1) = '0') then
                ch_out_top(x) <= (others => '0');
            else
                case Output_mode(4 downto 0) is
                    when "00000" =>
                        if ((OH or IDLE) = '1') then
                            ch_out_top(x) <= TP_out;
                        else
                            ch_out_top(x) <= gen_out(x + 32);
                        end if;
                    when "00001" =>
                        if (x = 1 or x = 3 or x = 5 or x = 7 or x = 9 or x = 11 or x = 13 or x = 15 or
                            x = 17 or x = 19 or x = 21 or x = 23 or x = 25 or x = 27 or x = 29 or x = 31) then
                            if ((OH or IDLE) = '1') then
                                ch_out_top(x) <= TP_out;
                            else 
                                ch_out_top(x) <= gen_out(x + 32);
                            end if;
                        else
                            ch_out_top(x) <= TP_Idle;
                        end if;
                    when "00011" =>
                        if (x = 1 or x = 5 or x = 9 or x = 13 or x = 17 or x = 21 or x = 25 or x = 29) then
                            if ((OH or IDLE) = '1') then
                                ch_out_top(x) <= TP_out;
                            else 
                                ch_out_top(x) <= gen_out(x + 32);
                            end if;
                        else
                            ch_out_top(x) <= TP_Idle;
                        end if;
                    when "00111" =>
                        if (x = 1 or x = 9 or x = 17 or x = 25) then
                            if ((OH or IDLE) = '1') then
                                ch_out_top(x) <= TP_out;
                            else 
                                ch_out_top(x) <= gen_out(x + 32);
                            end if;
                        else
                            ch_out_top(x) <= TP_Idle;
                        end if;
                    when "01111" =>
                        if (x = 1 or x = 17) then
                            if ((OH or IDLE) = '1') then
                                ch_out_top(x) <= TP_out;
                            else 
                                ch_out_top(x) <= gen_out(x + 32);
                            end if;
                        else
                            ch_out_top(x) <= TP_Idle;
                        end if;
                    when "11111" =>
                        if (x = 1) then
                            if ((OH or IDLE) = '1') then
                                ch_out_top(x) <= TP_out;
                            else 
                                ch_out_top(x) <= gen_out(x + 32);
                            end if;
                        else
                            ch_out_top(x) <= TP_Idle;
                        end if;
                    when others =>
                        null;
                end case;
            end if;
        end loop;   
    end process;
    
    Enable       <= Channel_en_bot or Channel_en_bot;
    Train_enable <= '1' when Enable > 0 else '0';
    
    New_row <= OH                 when Counter = "00000"      else '0';
    DVAL    <= '1'                when not (OH or IDLE) = '1' else '0';
    LVAL    <= not New_row        when IDLE = '0'             else '0' ;
    
    Control_Channel(11 downto 6) <= "000010";
    Control_Channel(5  downto 3) <= FOT  & INTE1 & INTE2;
    Control_Channel(2  downto 0) <= FVAL & LVAL  & DVAL when Channel_en(1) = '1' and Enable > 0 else "000"; 
    
    ch_out  <= ch_out_top & ch_out_bot;
    
end Behavioral;
