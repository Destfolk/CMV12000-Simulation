----------------------------------------------------------------------------
--CMV12000-Simulation
--Function_pkg.vhd
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

package Function_pkg is
        
    function bra (
        N : natural;
        M : natural )
        return natural;
        
    function index (
        val : std_logic_vector )
        return natural;
    
    type senselx128 is array (natural range <>) of std_logic_vector(11 downto 0);
        
end Function_pkg;

package body Function_pkg is

    function bra (
        N : natural;
        M : natural )
        return natural is
    begin
        return  128*N+M;
    end bra;
    
    function index (
        val : std_logic_vector )
        return natural is
    begin
        return to_integer(unsigned(val));
    end index;            
    
end package body;