library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity testbench is
end testbench;

architecture Behavioral of testbench is
    
    Constant T2: time  := 3.3333 ns;
    Constant T: time := 33.333 ns;
    
    signal SPI_EN : std_logic;
    signal SPI_CLK : std_logic;
    
    signal SYS_RES_N : std_logic;
    signal LVDS_CLK : std_logic;
    
    signal SPI_IN  : std_logic;
    signal SPI_OUT : std_logic;
    
    --signal Data_in   : std_logic_vector(31 downto 0);
    --signal Data_out  : std_logic_vector(31 downto 0);

begin
    test : entity work.SPI_Interface(Behavioral)
        port map(
            SPI_EN  => SPI_EN, 
            SPI_CLK => SPI_CLK, 
            --
            LVDS_CLK  => LVDS_CLK, 
            SYS_RES_N => SYS_RES_N,
            --
            SPI_IN  => SPI_IN,
            SPI_OUT => SPI_OUT);

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
        SPI_EN <= '0';
        SPI_IN <= '0';
        SYS_RES_N <= '0';
        wait for 4*T;
        SPI_EN <= '1';
        SYS_RES_N <= '1';
        wait for 0.5*T;
        
        -------------------------------
        
        SPI_IN <= '0';
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
        
        SPI_IN <= '0';
        wait for 0.5*T;
        SPI_EN <= '0';
        wait for 3*T;
        SPI_EN <= '1';
        -------------------------------
        
        -------------------------------
        
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
        wait for 17*T;
        wait for 0.5*T;
        
        -------------------------------
        
        SPI_IN <= '0';
        wait for 0.5*T;
        SPI_EN <= '0';
        
        -------------------------------
        
        wait for 20*T;
    
    end process;            

end Behavioral;
