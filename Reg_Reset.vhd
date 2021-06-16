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
            
            LVDS_W    : out std_logic;
            LVDS_R    : out std_logic;
            
            LVDS_ADDR : out std_logic_vector(7 downto 0) := "10000000"
            );
end Reg_Reset;

architecture Behavioral of Reg_Reset is

    signal Ready       : std_logic                    := '0';
    signal LVDS_R_ADDR : std_logic_vector(7 downto 0) := "10000000";
    signal LVDS_W_ADDR : std_logic_vector(7 downto 0) := (others =>'0');
    signal STATE_ADDR  : std_logic_vector(1 downto 0) := (others =>'0');
    
    signal SYS_RES_N_1 : std_logic;
    signal SYS_RES_N_2 : std_logic;
    signal SYS_RES_N_3 : std_logic;
    signal SYS_RES_N_4 : std_logic;
    
begin
    
    Synchronizer : process(LVDS_CLK)
        begin
            if rising_edge(LVDS_CLK) then
                SYS_RES_N_1 <= SYS_RES_N;
                SYS_RES_N_2 <= SYS_RES_N_1;
            end if;
        end process;
    
    Edge_Detect : process(LVDS_CLK)
        begin
            if rising_edge(LVDS_CLK) then
                SYS_RES_N_3 <= SYS_RES_N_2;
                SYS_RES_N_4 <= SYS_RES_N_3;
            end if;
        end process;
        
    Reset_Ready : process(LVDS_CLK)
        begin
            if rising_edge(LVDS_CLK) then
                if (SYS_RES_N_3 = '0' and SYS_RES_N_4 = '1') then
                    Ready   <= '1';
                elsif (LVDS_W_ADDR = "1111111") then 
                    Ready   <= '0'; 
                end if;
            end if;
        end process;
        
    Reg_Reset : process(LVDS_CLK)
        begin
            if rising_edge(LVDS_CLK) then
                if (Ready = '1') then
                    STATE_ADDR <= STATE_ADDR + 1;  
                       
                    if (STATE_ADDR = "00")then 
                        LVDS_W      <= '0';
                        LVDS_R      <= '1';
                        LVDS_R_ADDR <= LVDS_R_ADDR + 1;
                    elsif (STATE_ADDR = "01") then
                        LVDS_W      <= '1';
                    elsif (STATE_ADDR = "10")then 
                        LVDS_R      <= '0';
                        LVDS_W_ADDR <= LVDS_W_ADDR + 1;
                    elsif (STATE_ADDR = "11")then
                        LVDS_W      <= '0'; 
                        LVDS_R_ADDR <= LVDS_R_ADDR + 1;
                        LVDS_W_ADDR <= LVDS_W_ADDR + 1;
                    end if;
                else
                    LVDS_W      <= '0';
                    LVDS_R      <= '0';
                    LVDS_R_ADDR <= "10000000";
                    LVDS_W_ADDR <= (others =>'0');
                    STATE_ADDR  <= (others =>'0');
                end if;
        end if;                            
    end process; 
            
    LVDS_ADDR <= "10000000"         when Ready = '0' 
    else         LVDS_W_ADDR        when STATE_ADDR = "10" or STATE_ADDR = "11" 
    else         LVDS_R_ADDR ;  

    LVDS_IN   <= LVDS_OUT;    
        
end Behavioral;
