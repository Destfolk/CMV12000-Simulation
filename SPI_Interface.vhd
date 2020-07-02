library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use ieee.std_logic_unsigned.all;

entity SPI_Interface is
    Port ( SPI_EN        : in  std_logic;
           SPI_CLK       : in  std_logic;
           
           SPI_IN        : in  std_logic;
           SPI_OUT       : out std_logic;
           
           W_not_R       : out std_logic := '0';
           ADDR          : out std_logic_vector(7  downto 0);
           
           TEMP_DATA_IN  : in  std_logic_vector(15 downto 0);
           TEMP_DATA_OUT : out std_logic_vector(15 downto 0)
           );
end SPI_Interface;

architecture Behavioral of SPI_Interface is
    
    signal counter_W    : std_logic_vector (4 downto 0)  := "11000";
    signal counter_R    : std_logic_vector (4 downto 0)  := "10000";
    signal data_reg     : std_logic_vector (23 downto 0) := (others => '0');
    
    alias  WnR_bit      : std_logic is data_reg(23);
    
begin
    ADDR          <= '0' & data_reg(22 downto 16);
    TEMP_DATA_OUT <= data_reg(15 downto  0);
        
    Write_Counter : process(SPI_CLK)
    begin
        if falling_edge(SPI_CLK) then
            if (SPI_EN = '1') then
                if (counter_W > "00000") then
                    counter_W <= counter_W - 1;
                else
                    counter_W <= "10111";
                end if;
            else
                counter_W <= "11000";
            end if;                           
        end if;   
    end process;
    
    Write_TempReg : process(SPI_CLK)
    begin
        if rising_edge(SPI_CLK) and SPI_EN = '1' and counter_W /= "11000" then
                data_reg(to_integer(unsigned(counter_W))) <= SPI_IN;
        end if;
    end process;
    
    Write_reg : process(SPI_CLK)
    begin
        if falling_edge(SPI_CLK) then
            if (counter_W = "00001" and WnR_bit = '1') then
                W_not_R <= '1';
            else
                W_not_R <= '0';
            end if;
        end if;
    end process;
    
    Read_Counter : process(SPI_CLK)
    begin
        if rising_edge(SPI_CLK) then
            if (WnR_bit = '0' and counter_W <= "10001") then
                counter_R <= counter_R - 1;
            else
                counter_R <= "10000";
            end if;    
        end if;
    end process;
    
    Reading_reg : process(SPI_CLK)
    begin
        if falling_edge(SPI_CLK) then
            if (counter_R <= "01111") then
                SPI_OUT <= TEMP_DATA_IN(to_integer(unsigned(counter_R)));
            else
                SPI_OUT <= '0';    
            end if;                         
        end if;   
    end process;

end Behavioral;