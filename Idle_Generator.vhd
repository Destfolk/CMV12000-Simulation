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
    Port ( Word_Clk2  : in  std_logic;
           --FRAME_REQ  : in  std_logic;
           T_EXP1     : in  std_logic;
         /*T_EXP2     : in  std_logic;
           Bit_mode   : in  std_logic_vector(1 downto 0);
           FOT        : out std_logic;
           INTE1      : out std_logic;
           INTE2      : out std_logic;*/
           Row        : in  std_logic_vector(11 downto 0);
           Idle       : out std_logic := '1'
           );
end Idle_Generator;

architecture Behavioral of Idle_Generator is

    signal Edge_Detect : std_logic := '0';
    
begin

    Idle_Detect : process(Word_Clk2)
    begin
        if rising_edge(Word_Clk2) then
            if (Edge_Detect = '0') then
                if (T_EXP1 = '1') then
                    Idle <= '0';
                    Edge_Detect    <= '1';
                else
                    Idle <= '1';
                end if;
            elsif (Row > "101111111111") then
                    Edge_Detect    <= '0';
            end if;
        end if;
    end process;
    
end Behavioral;
