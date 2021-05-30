library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use ieee.std_logic_unsigned.all;

entity Control_Channel is
    Port ( LVDS_CLK : in  std_logic;
           IDLE     : in  std_logic;
           DVAL     : in  std_logic;
           LVAL     : in  std_logic;
           FVAL     : in  std_logic;
           FOT      : in  std_logic;
           INTE1    : in  std_logic;
           INTE2    : in  std_logic;
           BIT_MODE : in  std_logic_vector(1 downto 0);
           CTR_OUT  : out std_logic
          );
end Control_Channel;

architecture Behavioral of Control_Channel is

    signal Ready   : std_logic := '0';
    signal Detect  : std_logic := '0';
    signal CTR     : std_logic_vector(0 to 11);
    signal Counter : std_logic_vector(3 downto 0);
    
begin
    
    CD_Counter : process(LVDS_CLK)
    begin  
        if rising_edge(LVDS_CLK) then
            if (IDLE = '1') then
                Ready   <= '0';
                Counter <= (others => '0');
            else
                Ready   <= '0';
                Counter <= Counter + 1;
            
                case BIT_MODE is
                    when "00" =>   
                        if (Counter = "1011") then
                            Counter <= (others => '0');
                            Ready <= '1';
                        end if; 
                    when "01" =>
                        if (Counter = "1001") then
                            Counter <= (others => '0');
                            Ready <= '1';
                        end if; 
                    when "10" =>
                        if (Counter = "0111") then
                            Counter <= (others => '0');
                            Ready <= '1';
                        end if; 
                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;
    
    Control_Data : process(LVDS_CLK)
    begin
        if rising_edge(LVDS_CLK) then
            Detect <= IDLE;
            
            if (Detect = '0' and IDLE = '1') then
                CTR <= "000000010000";
            elsif ((Detect = '1' and IDLE = '0') or ready = '1') then
                CTR <= DVAL & LVAL & FVAL & FOT & INTE1 & INTE2 & "010000";
            else     
                case BIT_MODE is
                        when "00" =>
                                CTR <= CTR(1 to 11) & CTR(0);
                        when "01" =>
                                CTR(0 to 9) <= CTR(1 to 9) & CTR(0);
                        when "10" =>
                                CTR(0 to 7) <= CTR(1 to 7) & CTR(0);
                        when others =>
                            null;
                end case;
            end if;
        end if;
    end process;
    
    CTR_OUT <= CTR(0);
    
end Behavioral;