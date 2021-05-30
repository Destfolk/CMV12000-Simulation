library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use ieee.std_logic_unsigned.all;

entity Data_Training is                         -- sends MSB first
    Port ( LVDS_CLK : in  std_logic;
           IDLE     : in  std_logic;
           OH       : in  std_logic;            -- needs to lag 0.5*LVDS_CLK or modify the code and use falling edge
           DVAL     : in  std_logic;
           LVAL     : in  std_logic;
           BIT_MODE : in  std_logic_vector(1  downto 0);
           TP1      : in  std_logic_vector(11 downto 0);
           TP_AVA   : out std_logic;
           TP_OUT   : out std_logic
          );
end Data_Training;

architecture Behavioral of Data_Training is

    signal TP12_EN     : std_logic;
    signal Detect_OH   : std_logic := '0';
    signal Detect_IDLE : std_logic := '0';
    signal Ready       : std_logic := '0';
    signal Counter     : std_logic_vector(3  downto 0);
    signal TP1_data    : std_logic_vector(11 downto 0);
    signal TP2_data    : std_logic_vector(11 downto 0);
     
begin
 
    TP12_EN <= OH and not (DVAL or LVAL);
    
    TP_OUT <= TP2_data(11) when ready = '1' 
    else      TP1_data(11) ;
    
    TP2_Counter : process(LVDS_CLK)
    begin  
        if rising_edge(LVDS_CLK) then
            if (IDLE = '1' or (Detect_OH = '0' and OH = '1')) then
                Ready   <= '0';
                Counter <= (others => '0');
            elsif (TP12_EN = '1') then
                Ready   <= '0';
                Counter <= Counter + 1;
            
                case BIT_MODE is
                    when "00" =>   
                        if (Counter = "1010") then
                            Counter <= (others => '0');
                            Ready <= '1';
                        end if; 
                    when "01" =>
                        if (Counter = "1000") then
                            Counter <= (others => '0');
                            Ready <= '1';
                        end if; 
                    when "10" =>
                        if (Counter = "0110") then
                            Counter <= (others => '0');
                            Ready <= '1';
                        end if; 
                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;
        
    Training_Data : process(LVDS_CLK)
    begin
        if rising_edge(LVDS_CLK) then
            Detect_IDLE <= IDLE;
            Detect_OH <= OH;
            
            if ((Detect_IDLE = '0' and IDLE = '1') or (Detect_IDLE = '1' and IDLE = '0'))  then
                TP_AVA   <= '1';
                TP1_data <= TP1;                
                TP2_data <= "0000" & not TP1(7 downto 0);
            elsif (IDLE = '1') then
                TP_AVA <= '1';
                
                case BIT_MODE is
                    when "00" =>
                        TP1_data(11 downto 0) <= TP1_data(10 downto 0) & TP1_data(11);
                    when "01" =>
                        TP1_data(9  downto 0) <= TP1_data(8  downto 0) & TP1_data(9);
                    when "10" =>
                        TP1_data(7  downto 0) <= TP1_data(6  downto 0) & TP1_data(7);
                    when others =>
                        null;
                end case;
            elsif (OH = '1') then
                TP_AVA <= '1';
                
                case BIT_MODE is
                    when "00" =>
                        if (ready = '1') then
                            TP2_data(11 downto 0) <= TP2_data(10 downto 0) & TP2_data(11);
                        else
                            TP1_data(11 downto 0) <= TP1_data(10 downto 0) & TP1_data(11);
                        end if;    
                    when "01" =>
                        if (ready = '1') then
                            TP2_data(9  downto 0) <= TP2_data(8  downto 0) & TP2_data(9);
                        else
                            TP1_data(9  downto 0) <= TP1_data(8  downto 0) & TP1_data(9);
                        end if;   
                    when "10" =>
                        if (ready = '1') then
                            TP2_data(7  downto 0) <= TP2_data(6  downto 0) & TP2_data(7);
                        else
                            TP1_data(7  downto 0) <= TP1_data(6  downto 0) & TP1_data(7);
                        end if;   
                    when others =>
                        null;
                end case;
            else
                TP_AVA <= '0';
            end if;
        end if;
    end process;
    
end Behavioral;
