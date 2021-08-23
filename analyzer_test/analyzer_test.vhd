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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity analyzer_test is
    Port ( analyzer_d : out std_logic_vector (11 downto 0) );
end analyzer_test;

architecture Behavioral of analyzer_test is

    signal ps_fclk : std_logic_vector(3 downto 0);
    
begin

    Counter : entity work.Bit_Counter(Behavioral)
    Generic map (Size => 12)
    port map(
        CLK          => ps_fclk(0),
        Rst          => '0',
        Output_IOs   => analyzer_d(11 downto 0));
        
    ps7_stub_inst : entity work.ps7_stub
	port map (
	    ps_fclk => ps_fclk);
	    
end Behavioral;
