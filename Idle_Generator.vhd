----------------------------------------------------------------------------
--CMV12000-Simulation
--Idle_Generator.vhd
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

entity Idle_Generator is
    Port ( LVDS_CLK   : in  std_logic;
           --FRAME_REQ  : in  std_logic;
           T_EXP1     : in  std_logic;
        /*   T_EXP2     : in  std_logic;
           Bit_mode   : in  std_logic_vector(1 downto 0);
           FOT        : out std_logic;
           INTE1      : out std_logic;
           INTE2      : out std_logic;*/
           Row        : out  std_logic_vector(11 downto 0);
           z       : out std_logic;
           Idle       : out std_logic := '1'
           );
end Idle_Generator;

architecture Behavioral of Idle_Generator is

    signal x : std_logic := '0';
    signal y : std_logic := '0';  
    --signal z : std_logic := '0';     
begin

    process(LVDS_CLK)
    begin
        if rising_edge(LVDS_CLK) then
            if (x = '0') then
                if (T_EXP1 = '1') then
                    Idle <= '0';
                    x    <= '1';
                else
                    Idle <= '1';
                end if;
            elsif (Row > 3073) then
                    x    <= '0';
            end if;
        end if;
    end process;
    
        process(LVDS_CLK)
    begin
        if rising_edge(LVDS_CLK) then
            if (z = '0') then
                if (T_EXP1 = '1') then
                    z    <= '1';
                    y    <= '1';
                else
                    y    <= '0';
                end if;
            end if;
        end if;
    end process;
    
end Behavioral;
