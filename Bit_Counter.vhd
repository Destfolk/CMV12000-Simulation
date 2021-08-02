----------------------------------------------------------------------------
--CMV12000-Simulation
--Bit_Counter.vhd
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

entity Bit_Counter is
    Generic ( Size : natural := 8
    );
    Port ( CLK        : in  std_logic;
           Rst        : in  std_logic;
           Output_IOs : out std_logic_vector(Size - 1 downto 0)
    );
end Bit_Counter;

architecture Behavioral of Bit_Counter is
    signal int_count      : std_logic_vector(22 downto 0);
    signal Output_IOs_reg : std_logic_vector(Size - 1 downto 0) := (others => '0');
    
begin
    Internal_Counter : process(CLK)
    begin
        if rising_edge(CLK) then
            if (Rst = '1') then
                int_count <= (others => '0');
            else
                int_count <= int_count + 1;
            end if;
        end if;
    end process;
    
    Output_Counter : process(CLK)
    begin
        if rising_edge(CLK) then
            if (Rst = '1') then
                Output_IOs_reg <= (others => '0');
            elsif(int_count = (others => '0')) then
                Output_IOs_reg <= Output_IOs_reg + 1;
            end if;
        end if;
    end process;

    Output_IOs <= Output_IOs_reg;
    
end Behavioral;
