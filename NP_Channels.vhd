----------------------------------------------------------------------------
--CMV12000-Simulation
--NP_Channels.vhd
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

entity NP_Channels is
    Port ( LVDS_CLK       : in  std_logic;
           --
           Channel_en_bot : in  std_logic_vector(31 downto 0);
           Channel_en_top : in  std_logic_vector(31 downto 0);
           --
           Bit_Mode       : in  std_logic_vector(1 downto 0);
           Output_Mode    : in  std_logic_vector(5 downto 0);
           --
           DATA_IN        : in  senselx128(63 downto 0);
           DATA_OUT       : out std_logic_vector(63 downto 0)
         );
 
end NP_Channels;

architecture Behavioral of NP_Channels is
    
    signal Top_EN : std_logic;
    
begin
    Top_EN <= not Output_Mode(5);
    
    B32_Channels : entity work.B32_Channels(Behavioral)
        port map(
            LVDS_CLK    => LVDS_CLK,
            --
            OutMode_EN  => '1',
            Channel_EN  => Channel_en_bot,
            --
            Bit_Mode    => Bit_Mode,
            Output_Mode => Output_Mode(4 downto 0),
            --
            DATA_IN     => DATA_IN(63 downto 32),
            DATA_OUT    => DATA_OUT(63 downto 32));

    T32_Channels : entity work.T32_Channels(Behavioral)
        port map(
            LVDS_CLK    => LVDS_CLK,
            --
            OutMode_EN  => Top_EN,
            Channel_EN  => Channel_en_top,
            --
            Bit_Mode    => Bit_Mode,
            Output_Mode => Output_Mode(4 downto 0),
            --
            DATA_IN     => DATA_IN(31 downto 0),
            DATA_OUT    => DATA_OUT(31 downto 0));            

end Behavioral;