library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use ieee.std_logic_unsigned.all;

entity Control_Channel is
    Port ( LVDS_CLK       : in  std_logic;
           IDLE           : in  std_logic;
           OH             : in  std_logic; -- needs to lead by 0.5*T
           Output_mode    : in  std_logic_vector(5  downto 0);
           Channel_en     : in  std_logic_vector(2  downto 0);
           Channel_en_bot : in  std_logic_vector(31 downto 0);
           Channel_en_top : in  std_logic_vector(31 downto 0);
           CC_out         : out std_logic_vector(11 downto 0)
          );
end Control_Channel;

architecture Behavioral of Control_Channel is

    signal Detect  : std_logic := '0';
    signal CC      : std_logic_vector(2  downto 0);
    signal Counter : std_logic_vector(5  downto 0) := (others => '0');
    signal Enable  : std_logic_vector(31 downto 0);
    
begin

    Enable <= Channel_en_bot and Channel_en_bot;
    CC_out(11 downto 3) <= "000010000";
    CC_out(2  downto 0) <= CC;   
     
    process(LVDS_CLK)
    begin
        if rising_edge(LVDS_CLK) then
            Detect <= OH;
            
            if (IDLE = '1') then
                Counter <= (others => '0');
            elsif (Detect = '1' and OH = '0') then
                Counter <= Counter + 1;
                
                case Output_mode(4 downto 0) is
                    when "00000" =>
                        if (Counter = "000001") then
                            Counter <= "000001";
                        end if;
                    when "00001" =>
                        if (Counter = "000010") then
                            Counter <= "000001";
                        end if;
                    when "00011" =>
                        if (Counter = "000100") then
                            Counter <= "000001";
                        end if;
                    when "00111" =>
                        if (Counter = "001000") then
                            Counter <= "000001";
                        end if;
                    when "01111" =>
                        if (Counter = "010000") then
                            Counter <= "000001";
                        end if;
                    when "11111" =>
                        if (Counter = "100000") then
                            Counter <= "000001";
                        end if;
                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;
    
    process(LVDS_CLK)
    begin
        if rising_edge(LVDS_CLK) then
            if (Channel_en(1) = '0' or Enable = 0) then
                CC <= "000";
            elsif (IDLE = '1') then
                CC <= "000";
            elsif (OH = '1') then
            
                case Output_mode(4 downto 0) is
                    when "00000" =>
                        if (Counter = "000000") then
                            CC <= "000";
                        else
                            CC <= "100";
                        end if;
                    when "00001" =>
                        if (Counter = "000000") then
                            CC <= "000";
                        elsif (Counter = "000010") then
                            CC <= "100";
                        else
                            CC <= "110";
                        end if;
                    when "00011" =>
                        if (Counter = "000000") then
                            CC <= "000";
                        elsif (Counter = "000100") then
                            CC <= "100";
                        else 
                            CC <= "110";
                        end if;
                    when "00111" =>
                        if (Counter = "000000") then
                            CC <= "000";
                        elsif (Counter = "001000") then
                            CC <= "100";
                        else 
                            CC <= "110";
                        end if;
                    when "01111" =>
                        if (Counter = "000000") then
                            CC <= "000";
                        elsif (Counter = "010000") then
                            CC <= "100";
                        else 
                            CC <= "110";
                        end if;
                    when "11111" =>
                        if (Counter = "000000") then
                            CC <= "000";
                        elsif (Counter = "100000") then
                            CC <= "100";
                        else 
                            CC <= "110";
                        end if;
                    when others =>
                        null;
                end case;
            else
                CC <= "111";
            end if;
        end if;
    end process;
    
end Behavioral;
