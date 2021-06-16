library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use ieee.std_logic_unsigned.all;

library work;
use work.Function_pkg.all;

entity dch is
    Port ( LVDS_CLK    : in  std_logic;
           IDLE        : in  std_logic;
           OH_Delayed          : in  std_logic; --delayed 1 clock cycle
           Bit_mode   : in  std_logic_vector(1  downto 0);
           Output_mode : in  std_logic_vector(5 downto 0);
           Training_pattern   : in  std_logic_vector(11 downto 0);
           Channel_en_bot : in  std_logic_vector(31 downto 0);
           Channel_en_top : in  std_logic_vector(31 downto 0);
           --ch_in       : in  senselx128(64 downto 1);
           ch_out      : out senselx128(64 downto 1));
end dch;

architecture Behavioral of dch is

    signal IDlE_Detect  : std_logic := '0';
    signal OH_Detect  : std_logic := '0';
    signal OH  : std_logic := '0';
    
    signal counter : std_logic_vector(3 downto 0);
    signal reg     :senselx128(1 downto 0);
    --
    signal gen_out     :senselx128(64 downto 1);
    --
    signal New_row  : std_logic := '0';
    signal TP_out        : std_logic_vector(11 downto 0);
    
begin

    Data_Generation : entity work.data_gen(Behavioral)
    port map(
        LVDS_CLK  => LVDS_CLK,
        IDLE      => IDLE, 
        OH        => OH_Delayed, 
        gen_out   => gen_out);
    
    Data_Training : entity work.Data_Training(Behavioral)
    port map(
        LVDS_CLK          => LVDS_CLK,
        New_row           => New_row, 
        Channel_en        => Channel_en_bot(0),
        Bit_mode          => Bit_mode,
        Training_pattern  => Training_pattern,
        TP_out            => TP_out);
    
    New_row <= OH_Delayed;
            
    process(LVDS_CLK)
    begin
        if rising_edge(LVDS_CLK) then
            IDlE_Detect <= IDLE;
            OH_Detect   <= OH_Delayed;
            OH          <= OH_Delayed;
            
            --reg <= ch_in;
            
            if (IDlE_Detect = '0' and IDLE = '1') then 
                ch_out  <= (others => TP_out);
                --counter <= (others => '0');
            elsif (OH_Delayed = '1') then
                ch_out  <= (others => TP_out);
            elsif (OH_Detect = '1' and OH_Delayed = '0') then
                case Output_mode is
                    when "000000" =>
                        ch_out <= gen_out;
                    when "000001" =>
                        ch_out <= gen_out;
                    when "000011" =>
                        ch_out <= gen_out;
                    when "000111" =>
                        ch_out <= gen_out;
                    when "001111" =>
                        ch_out <= gen_out;
                    when "011111" =>
                        ch_out <= gen_out;
                    -- 1 side output
                    when "100000" =>
                        ch_out <= gen_out;
                    when "100001" =>
                        ch_out <= gen_out;
                    when "100011" =>
                        ch_out <= gen_out;
                    when "100111" =>
                        ch_out <= gen_out;
                    when "101111" =>
                        ch_out <= gen_out;
                    when "111111" =>
                        ch_out <= gen_out;
                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;
end Behavioral;
