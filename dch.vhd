library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use ieee.std_logic_unsigned.all;

library work;
use work.Function_pkg.all;

entity dch is
    Port ( LVDS_CLK    : in  std_logic;
           IDLE        : in  std_logic;
           OH          : in  std_logic;
           Output_mode : in  std_logic_vector(5 downto 0);
           ch_in       : in  senselx128(1 downto 0);
           ch_out      : out senselx128(64 downto 1) );
end dch;

architecture Behavioral of dch is

    signal Detect  : std_logic := '0';
    signal counter : std_logic_vector(3 downto 0);
    signal reg     :senselx128(1 downto 0);
    
begin

    process(LVDS_CLK)
    begin
        
        if rising_edge(LVDS_CLK) then
            Detect <= OH;
            reg <= ch_in;
            
            if (IDLE = '1') then
                counter <= (others => '0');
            elsif (Detect = '1' and OH = '0') then
                case Output_mode is
                    when "000000" =>
                        ch_out <= reg;
                    when "000001" =>
                        ch_out <= reg;
                    when "000011" =>
                        ch_out <= reg;
                    when "000111" =>
                        ch_out <= reg;
                    when "001111" =>
                        ch_out <= reg;
                    when "011111" =>
                        ch_out <= reg;
                    -- 1 side output
                    when "100000" =>
                        ch_out <= reg;
                    when "100001" =>
                        ch_out <= reg;
                    when "100011" =>
                        ch_out <= reg;
                    when "100111" =>
                        ch_out <= reg;
                    when "101111" =>
                        ch_out <= reg;
                    when "111111" =>
                        ch_out <= reg;
                end case;
            end if;
        end if;
    end process;

end Behavioral;
