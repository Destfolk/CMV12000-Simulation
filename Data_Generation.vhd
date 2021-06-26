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
    Port ( LVDS_CLK    : in  std_logic;
           IDLE        : in  std_logic;
           OH          : in  std_logic;
           New_row     : in  std_logic;
           Output_mode : in  std_logic_vector(5  downto 0);
           FVAL        : out std_logic;
           gen_out     : out senselx128(64 downto 1)
           );
end Data_Generation;

architecture Behavioral of Data_Generation is

    signal Row         : integer   :=  0;
    signal OH_Detect   : std_logic := '0';
    signal IDLE_Detect : std_logic := '0';
    signal Data_out    : senselx128(64 downto 1) := (others => (others => '0'));
    
    signal FVAL_Detect1   : std_logic_vector(11 downto 0):= (others => '0');
    signal FVAL_Detect2   : std_logic := '0';
    signal FVAL_Detect3   : std_logic;
    
begin

    Edge_Detect : process(LVDS_CLK)
    begin
        if rising_edge(LVDS_CLK) then
            OH_Detect   <= OH;
            IDLE_Detect <= IDLE;  
            
            if (FVAL_Detect2 = '0')then
                FVAL_Detect1 <= FVAL_Detect1(10 downto 0) & New_Row;
                if(FVAL_Detect1(11) = '1') then FVAL_Detect2 <= '1'; end if;   
            end if;
            
        end if;
    end process;
    
    Dat_generation : process(LVDS_CLK)
    begin
        if rising_edge(LVDS_CLK) then
            if (IDLE_Detect = '0' and IDLE = '1') then
                Row <= 0;
                for x in 0 to 31 loop
                    Data_out(x+1)    <= Data_out(x+1)  + x*128;
                    Data_out(x+33)   <= Data_out(x+33) + x*128; 
                end loop;
            elsif (Row > 3073) then
                Data_out <= (others => (others => '0'));
            elsif (FVAL_Detect3 = '1') then
                case Output_mode is
                    when "000000" =>
                        Row <= Row + 2;
                        for x in 64 downto 1 loop
                            Data_out(x) <= Data_out(x) + 128;
                        end loop;
                    when "000001" =>
                        if (New_row = '1') then
                            Row <= Row + 1;
                            for x in 64 downto 1 loop
                                Data_out(x) <= Data_out(x) + 128*x;
                            end loop;
                        else
                            for x in 64 downto 1 loop
                                Data_out(x) <= Data_out(x) + 128;
                            end loop;
                        end if;
                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;
    
    FVAL_Detect3 <= '1' when FVAL_Detect1(11) = '1' and Row < 3073  else '0';
    FVAL         <= FVAL_Detect3;
    gen_out      <= Data_out;
    
end Behavioral;
