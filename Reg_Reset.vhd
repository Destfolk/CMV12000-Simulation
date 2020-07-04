----------------------------------------------------------------------------
--CMV12000-Simulation
--Reg_Reset.vhd
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

entity Reg_Reset is
    Port (  LVDS_CLK  : in  std_logic;
            SYS_RES_N : in  std_logic;
            
            LVDS_OUT  : in  std_logic_vector(15 downto 0);
            
            LVDS_IN   : out std_logic_vector(15 downto 0);
            LVDS_WnR  : out std_logic;
            LVDS_ADDR : out std_logic_vector(7 downto 0) := "10000000"
            );
end Reg_Reset;

architecture Behavioral of Reg_Reset is
    
    signal LVDS_R_ADDR : std_logic_vector(7 downto 0) := "10000000";
    signal LVDS_W_ADDR : std_logic_vector(7 downto 0) := (others =>'0');
    signal STATE_ADDR  : std_logic_vector(1 downto 0) := (others =>'0');
    
begin
    Reg_Reset : process(LVDS_CLK)
        begin
            if falling_edge(LVDS_CLK) then
                if (SYS_RES_N = '1') then
                        STATE_ADDR <= STATE_ADDR + 1;  
                        
                        if (STATE_ADDR = "00")then 
                            LVDS_WnR    <= '0';
                            LVDS_R_ADDR <= LVDS_R_ADDR + 1;
                        elsif (STATE_ADDR = "001")then
                            LVDS_WnR    <= '1';
                            LVDS_IN     <= LVDS_OUT;
                        elsif (STATE_ADDR = "10")then 
                            LVDS_WnR    <= '1';
                            LVDS_IN     <= LVDS_OUT;
                            LVDS_W_ADDR <= LVDS_W_ADDR + 1;
                            LVDS_R_ADDR <= LVDS_R_ADDR + 1;
                        elsif (STATE_ADDR = "11")then 
                            LVDS_WnR    <= '0';
                            LVDS_W_ADDR <= LVDS_W_ADDR + 1;
                            STATE_ADDR  <= "00";
                        end if;
                else
                    LVDS_WnR    <= '0';
                    LVDS_R_ADDR <= "10000000";
                    LVDS_W_ADDR <= (others =>'0');
                    STATE_ADDR  <= (others =>'0');
                end if;
            end if;                            
        end process; 
            
          LVDS_ADDR <= "10000000"         when SYS_RES_N = '0' 
          else         LVDS_W_ADDR        when STATE_ADDR = "10" or STATE_ADDR = "11" 
          else         LVDS_R_ADDR ;  
        

end Behavioral;
