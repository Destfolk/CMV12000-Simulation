library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use ieee.std_logic_unsigned.all;

entity Data_Training is                         
    Port ( LVDS_CLK : in  std_logic;
           IDLE     : in  std_logic;
           DVAL     : in  std_logic;
           LVAL     : in  std_logic;
           fin_set  : in  std_logic;
           Bit_mode : in  std_logic_vector(1  downto 0);
           TP1_data : in  std_logic_vector(11 downto 0);
           TP_out   : out std_logic_vector(11 downto 0)
          );
end Data_Training;

architecture Behavioral of Data_Training is

    signal TP1_EN     : std_logic;
    signal TP2_EN     : std_logic;
    signal TP1        : std_logic_vector(11 downto 0);
    signal TP2        : std_logic_vector(11 downto 0);
    
begin
    TP1_EN <= not DVAL and LVAL;
    TP2_EN <= not (DVAL or LVAL);
    
    process(LVDS_CLK)
    begin
        if rising_edge(LVDS_CLK) then
            if (IDLE = '1') then
                TP1    <= TP1_data;
                TP2    <= "0000" & not TP1_data(7 downto 0);
                TP_out <= TP1;
            elsif (TP1_EN = '1') then
                TP_out <= TP1;
            elsif (TP2_EN = '1') then
                if (fin_set = '0') then
                    TP_out <= TP1;
                else
                    TP_out <= TP2(0) & TP1(10 downto 0);
                    
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
        end if;
    end process;
    
end Behavioral;
