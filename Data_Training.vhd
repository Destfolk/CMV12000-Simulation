library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use ieee.std_logic_unsigned.all;

entity Data_Training is                         
    Port ( LVDS_CLK   : in  std_logic;
           New_row    : in  std_logic;
           Channel_en : in  std_logic;
           Bit_mode   : in  std_logic_vector(1  downto 0);
           Training_pattern   : in  std_logic_vector(11 downto 0);
           TP_out     : out std_logic_vector(11 downto 0)
          );
end Data_Training;

architecture Behavioral of Data_Training is

    signal Ch_Detect   : std_logic := '0';
    signal Row_Detect  : std_logic := '0';
    
    signal edge_det  : std_logic := '0';
    
    signal TP1        : std_logic_vector(11 downto 0);
    signal TP2        : std_logic_vector(11 downto 0);
    
    signal tst        : std_logic_vector(11 downto 0);
    
    
begin
    edge_det <= not Row_Detect and New_row;
                tst <=  TP1(10 downto 0) & TP2(0);
    
    TP_out <= tst when New_row = '1' else TP1;
    
    process(LVDS_CLK)
    begin
        if rising_edge(LVDS_CLK) then
            if (Ch_Detect = '0' and Channel_en = '1') then
                TP1    <= Training_pattern;
                TP2    <= "0000" & not Training_pattern(7 downto 0);
            elsif (Row_Detect = '1' and New_row = '0') then
                --tst <=  TP1(10 downto 0) & TP2(0);
                case Bit_mode is
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
    
    process(LVDS_CLK)
    begin
        if rising_edge(LVDS_CLK) then
            Ch_Detect  <= Channel_en;
            Row_Detect <= New_row;
            
            if (Row_Detect = '0' and New_row = '1') then
                --TP_out <= TP1(10 downto 0) & TP2(0);
            else
                --TP_out <= TP1;
            end if;
        end if;
    end process;
end Behavioral;
