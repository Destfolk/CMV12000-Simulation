library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use ieee.std_logic_unsigned.all;

library work;
use work.Function_pkg.all;

entity data_gen is
    Port ( LVDS_CLK : in  std_logic;
           IDLE     : in  std_logic;
           OH       : in  std_logic;
           --gen_in   : in  senselx128(1 downto 0);
           gen_out  : out senselx128(64 downto 1) );
end data_gen;

architecture Behavioral of data_gen is

    signal row         : integer   :=  0;
    signal IDLE_Detect : std_logic := '0';
    signal OH_Detect   : std_logic := '0';
    signal dout        :senselx128(64 downto 1) := (others => (others => '0'));
    
begin
    
    gen_out <= dout;
    
    process(LVDS_CLK)
    begin
        IDLE_Detect <= IDLE;
        OH_Detect   <= OH;
        
        if rising_edge(LVDS_CLK) then   
            if (IDLE_Detect = '0' and IDLE = '1') then
                for x in 1 to 32 loop
                    dout(x)    <= dout(x) + x*128;
                    dout(x+32) <= dout(x+32) +(x+32)*128; 
                end loop;
            elsif (row > 3072) then
                dout <= (others => (others => '0'));
            elsif (OH_Detect = '0' and OH = '1') then
                row <= row + 2;
                for x in 64 downto 1 loop
                    dout(x) <= dout(x) + 128;
                end loop;
            end if;
        end if;
    end process;

end Behavioral;
