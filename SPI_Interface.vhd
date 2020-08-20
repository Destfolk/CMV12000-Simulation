----------------------------------------------------------------------------
--CMV12000-Simulation
--SPI_Interface.vhd
--
--Apertus AXIOM Beta
--
--Copyright (C) 2020 Seif Eldeen Emad Abdalazeem
--Email: destfolk@gmail.com
----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use ieee.std_logic_unsigned.all;

library work;
use work.Function_pkg.all;

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
    
    signal Read_EN   : std_logic := '0';
    signal Counter_W : std_logic_vector (4 downto 0)  := "10111";
    signal Counter_R : std_logic_vector (4 downto 0)  := "01111";
    signal Data_Reg  : std_logic_vector (23 downto 0) := (others => '0');
     
    alias  WnR_bit   : std_logic is data_reg(23);
    
begin
    ADDR          <= '0' & Data_Reg(22 downto 16);
    TEMP_DATA_OUT <= Data_Reg(15 downto  0);
    SPI_OUT       <= TEMP_DATA_IN(index(Counter_R)) when Read_EN = '1' else '0';
        
    Write_Counter : process(SPI_CLK)
    begin
        if rising_edge(SPI_CLK) then
            if (SPI_EN = '1') then
                if (Counter_W > "00000") then
                    Counter_W <= Counter_W - 1;
                else
                    Counter_W <= "10111";
                end if;
            else
                Counter_W <= "10111";
            end if;                           
        end if;   
    end process;
    
    Read_Counter : process(SPI_CLK)
    begin
        if falling_edge(SPI_CLK) then
            if (SPI_EN = '1') then
                if (Counter_W < "10000") then
                    Counter_R <= Counter_R - 1;
                else
                    Counter_R <= "10000";
                end if;
            else
                Counter_R <= "10000";
            end if;                           
        end if;   
    end process;
    
    Write_TempReg : process(SPI_CLK)
    begin
        if rising_edge(SPI_CLK) then
            if (SPI_EN = '1') then
                Data_Reg(index(Counter_W)) <= SPI_IN;
            else
                Data_Reg <= (others => '0');
            end if;
        end if;
    end process;
    
    Write_reg : process(SPI_CLK)
    begin
        if falling_edge(SPI_CLK) then
            if (Counter_W = "00001" and WnR_bit = '1') then
                W_not_R <= '1';
            else
                W_not_R <= '0';
            end if;
        end if;
    end process;
    
    Read_reg : process(SPI_CLK)
    begin
        if falling_edge(SPI_CLK) then
            if (Counter_W < "10000" and WnR_bit = '0') then
                Read_EN <= '1';
            else
                Read_EN <= '0';
            end if;
        end if;
    end process;
    
end Behavioral;
