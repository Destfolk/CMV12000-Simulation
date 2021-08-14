library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Shift_Reg is
    Generic ( Size : natural := 6
    );
    Port ( Clk     : in  std_logic;
           Rst     : in  std_logic;
           Out_Bit : out std_logic
          );
end Shift_Reg;

architecture Behavioral of Shift_Reg is

    signal sh_reg : std_logic_vector(Size - 1 downto 0) := (0 => '1', others => '0');
    
begin
    
    process(Clk)
    begin
        if rising_edge(Clk) then
            if (Rst = '1') then
                sh_reg    <= (others => '0');
                sh_reg(0) <= '1';
            else
                sh_reg    <= sh_reg(Size - 2 downto 0) & sh_reg(Size - 1);
            end if;
        end if;
    end process;
    
    Out_Bit <= sh_reg(Size - 1);
    
end Behavioral;
