----------------------------------------------------------------------------
--CMV12000-Simulation
--Testbench.vhd
--
--Apertus AXIOM Beta
--
--Copyright (C) 2020 Seif Eldeen Emad Abdalazeem
--Email: destfolk@gmail.com
----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity Testbench is
end Testbench;

architecture Behavioral of Testbench is
    
    Constant T2 : time  := 3.3333 ns;
    Constant T  : time  := 33.333 ns;
    
    signal SPI_EN    : std_logic;
    signal SPI_CLK   : std_logic;
    
    signal SYS_RES_N : std_logic;
    signal LVDS_CLK  : std_logic;
    
    signal SPI_IN    : std_logic;
    signal SPI_OUT   : std_logic;

begin
    CMV12K : entity work.CMV12k(Behavioral)
        port map(
            SPI_EN    => SPI_EN, 
            SPI_CLK   => SPI_CLK, 
            --
            LVDS_CLK  => LVDS_CLK, 
            SYS_RES_N => SYS_RES_N,
            --
            SPI_IN    => SPI_IN,
            SPI_OUT   => SPI_OUT);

    process
    begin
        SPI_CLK <= '1';
        wait for T/2;
   
        SPI_CLK <= '0';
        wait for T/2;   
    end process; 
    
    process
    begin
        LVDS_CLK <= '1';
        wait for T2/2;
   
        LVDS_CLK <= '0';
        wait for T2/2;   
    end process; 
    
    process
    begin
    
        -------------------------------
        -- Startup Sequence
        -------------------------------
    
        SPI_EN <= '0';
        SPI_IN <= '0';
        SYS_RES_N <= '0';
        
        wait for T;
        
        SYS_RES_N <= '1';
        
        wait for 1 us;
        
        SYS_RES_N <= '0';
        
        wait for 0.5*T;
        
        SPI_EN <= '1';
        
        -------------------------------
        --       SPI Write
        -- Register 42 "0101010"
        -- Data "1010101010101010"
        -------------------------------
        
        SPI_IN <= '1';
        wait for T;
        
        -- Address --
        
        SPI_IN <= '0';
        wait for T;
        
        SPI_IN <= '1';
        wait for T;
        SPI_IN <= '0';
        wait for T;
        
        SPI_IN <= '1';
        wait for T;
        SPI_IN <= '0';
        wait for T;
        
        SPI_IN <= '1';
        wait for T;
        SPI_IN <= '0';
        wait for T;
        
        -- Data --
        
        SPI_IN <= '1';
        wait for T;
        SPI_IN <= '0';
        wait for T;
        
        SPI_IN <= '1';
        wait for T;
        SPI_IN <= '0';
        wait for T;
        
        SPI_IN <= '1';
        wait for T;
        SPI_IN <= '0';
        wait for T;
        
        SPI_IN <= '1';
        wait for T;
        SPI_IN <= '0';
        wait for T;
        
        SPI_IN <= '1';
        wait for T;
        SPI_IN <= '0';
        wait for T;
        
        SPI_IN <= '1';
        wait for T;
        SPI_IN <= '0';
        wait for T;
        
        SPI_IN <= '1';
        wait for T;
        SPI_IN <= '0';
        wait for T;
        
        SPI_IN <= '1';
        wait for T;
        SPI_IN <= '0';
        wait for T;
        
        -------------------------------
        --       SPI Write
        -- Register 43 "0101011"
        -- Data "1100110011001100"
        -------------------------------
        
        SPI_IN <= '1';
        wait for T;
        
        -- Address --
        
        SPI_IN <= '0';
        wait for T;
        
        SPI_IN <= '1';
        wait for T;
        SPI_IN <= '0';
        wait for T;
        
        SPI_IN <= '1';
        wait for T;
        SPI_IN <= '0';
        wait for T;
        
        SPI_IN <= '1';
        wait for T;
        SPI_IN <= '1';
        wait for T;
        
        -- Data --
        
        SPI_IN <= '1';
        wait for T;
        SPI_IN <= '1';
        wait for T;
        
        SPI_IN <= '0';
        wait for T;
        SPI_IN <= '0';
        wait for T;
        
        SPI_IN <= '1';
        wait for T;
        SPI_IN <= '1';
        wait for T;
        
        SPI_IN <= '0';
        wait for T;
        SPI_IN <= '0';
        wait for T;
        
        SPI_IN <= '1';
        wait for T;
        SPI_IN <= '1';
        wait for T;
        
        SPI_IN <= '0';
        wait for T;
        SPI_IN <= '0';
        wait for T;
        
        SPI_IN <= '1';
        wait for T;
        SPI_IN <= '1';
        wait for T;
        
        SPI_IN <= '0';
        wait for T;
        SPI_IN <= '0';
        wait for T;
        
        -------------------------------
        -- SPI Disable
        -------------------------------

        SPI_IN <= '0';
        wait for 0.5*T;
        SPI_EN <= '0';
        wait for 3.5*T;
        
        -------------------------------
        -- SPI Enable
        -------------------------------
        
        SPI_EN <= '1';
        
        -------------------------------
        --       SPI Read
        -- Register 42 "0101010"
        -------------------------------
        
        SPI_IN <= '0';
        wait for T;
        
        -- Address --
        
        SPI_IN <= '0';
        wait for T;
        
        SPI_IN <= '1';
        wait for T;
        SPI_IN <= '0';
        wait for T;
        
        SPI_IN <= '1';
        wait for T;
        SPI_IN <= '0';
        wait for T;
        
        SPI_IN <= '1';
        wait for T;
        SPI_IN <= '0';
        --addition
       -- wait for T;
        --SPI_IN <= '0';
        
        wait for 17.5*T;
        
        -------------------------------
        -- SPI Disable
        -------------------------------
        
        SPI_IN <= '0';
        SPI_EN <= '0'; 
        
        -------------------------------
        -- System Reset
        -------------------------------
        
        SYS_RES_N <= '1';
        wait for 1 us;
        SYS_RES_N <= '0';
        
        -------------------------------
        -- SPI Enable
        -------------------------------
        
        wait for 1.5*T;
        
        SPI_EN <= '1';
        
        -------------------------------
        --       SPI Read
        -- Register 88 "1011000"
        -------------------------------
        
        SPI_IN <= '0';
        wait for T;
        
        -- Address --
        
        SPI_IN <= '1';
        wait for T;
        
        SPI_IN <= '0';
        wait for T;
        SPI_IN <= '1';
        wait for T;
        
        SPI_IN <= '1';
        wait for T;
        SPI_IN <= '0';
        wait for T;
        
        SPI_IN <= '0';
        wait for T;
        SPI_IN <= '0';
        wait for 17.5*T;
        
        -------------------------------
        -- SPI Disable
        -------------------------------
        
        SPI_IN <= '0';
        SPI_EN <= '0';
        
        -------------------------------
        
        wait for 20*T;
    
    end process;            

end Behavioral;
