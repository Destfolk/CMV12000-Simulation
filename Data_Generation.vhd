----------------------------------------------------------------------------
--CMV12000-Simulation
--Data_Generation.vhd
--
--Apertus AXIOM Beta
--
--Copyright (C) 2021 Seif Eldeen Emad Abdalazeem
--Email: destfolk@gmail.com
----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use ieee.std_logic_unsigned.all;

library work;
use work.Function_pkg.all;

entity Data_Generation is
    Port ( Word_Clk    : in  std_logic;
           Idle        : in  std_logic;
           OH          : in  std_logic;
           New_Row     : in  std_logic;
           DVAL        : in std_logic;
           LVAL        : in std_logic;
           Output_Mode : in  std_logic_vector(5  downto 0);
           FVAL        : out std_logic;
           Row         : out std_logic_vector(11 downto 0);
           gen_out     : out senselx128(64 downto 1)
           );
end Data_Generation;

architecture Behavioral of Data_Generation is

    signal Row_Count   : std_logic_vector(11 downto 0);
    signal Counter_Row : std_logic_vector(11 downto 0);
    signal Counter_Col : std_logic_vector(11 downto 0);
    
    signal Idle_Detect : std_logic;
    signal OH_Detect   : std_logic;
    signal New_Row_1   : std_logic;
    signal FVAL_Detect : std_logic;
    
    signal Data_Out    : senselx128(64 downto 1) := (others => (others => '0'));
    
begin

    Edge_Detect : process(Word_Clk)
    begin
        if rising_edge(Word_Clk) then
            Idle_Detect <= Idle;  
            OH_Detect   <= OH;
            New_Row_1   <= New_Row;
        end if;
    end process;
    
    Row_Counter : process(Word_Clk)
    begin
        if rising_edge(Word_Clk) then
            if (Idle = '1') then
                Row_Count <= (others => '0'); 
            elsif (LVAL = '0' and FVAL = '1') then 
                Row_Count <= Row_Count + 1; 
            end if;
        end if;    
    end process;
    
    Counter_R : process(Word_Clk)
    begin
        if rising_edge(Word_Clk) then
            if (Idle = '1') then
                Counter_Row <= "000000000010";
            elsif (DVAL = '1') then
                Counter_Row <= Counter_Row + 1;
            end if;
        end if;    
    end process;
    
    Counter_C : process(Word_Clk)
    begin
        if rising_edge(Word_Clk) then
            if (Idle = '1') then
                Counter_Col <= "000000000001";
            elsif (Counter_Col = 127) then
                Counter_Col <= (others => '0');
            elsif (DVAL = '1') then
                Counter_Col <= Counter_Col + 1;
            end if;
        end if;
    end process;
    
    FVAL_Detection : process(Word_Clk)
    begin
        if rising_edge(Word_Clk) then
            if (Idle = '1' or Row_Count > "101111111111") then
                    FVAL_Detect  <= '0';
            elsif (FVAL_Detect = '0') then
                if (New_Row = '1') then
                    FVAL        <= '1';
                    FVAL_Detect <= '1';
                else
                    FVAL        <= '0';
                end if;
            end if;
        end if;
    end process;
    
    Dat_generation : process(Word_Clk)
    begin
        if rising_edge(Word_Clk) then
            if (Idle_Detect = '0' and Idle = '1') then
                for x in 0 to 31 loop
                    Data_Out(x+1)    <= Data_Out(x+1)  + x*128;
                    Data_Out(x+33)   <= Data_Out(x+33) + x*128; 
                end loop;
            else
                case Output_mode is
                    when "000000" =>
                        if (DVAL = '1') then
                            for x in 64 downto 1 loop
                                Data_Out(x) <=  (x-1)*128 + Counter_Col;
                            end loop; 
                        end if;
                    when "000001" =>
                        if (New_row = '1' and New_row_1 = '0') then
                            for x in 64 downto 1 loop
                                Data_Out(x) <= (x-1)*128 + Counter_Col;
                            end loop;
                        elsif (DVAL = '1') then
                            for x in 64 downto 1 loop
                                Data_Out(x) <= (x-1)*128 + Counter_Row;
                            end loop;
                        end if;
                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;
    
    Row     <= Row_Count;
    gen_out <= Data_Out;
    
end Behavioral;