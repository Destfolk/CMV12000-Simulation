----------------------------------------------------------------------------
--CMV12000-Simulation
--B32_Channels.vhd
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

entity B32_Channels is
    Port ( LVDS_CLK    : in  std_logic;
           --
           OutMode_EN  : in  std_logic;
           Channel_EN  : in  std_logic_vector(31 downto 0);
           --
           Bit_Mode    : in  std_logic_vector(1 downto 0);
           Output_Mode : in  std_logic_vector(4 downto 0);
           --
           DATA_IN     : in  senselx128(31 downto 0);
           DATA_OUT    : out std_logic_vector(31 downto 0)
         );
 
end B32_Channels;

architecture Behavioral of B32_Channels is
    
    signal OutMode_EN_B : std_logic;
    
begin
    OutMode_EN_B  <= not Output_Mode(0);
    
    B16_Channels_A : entity work.B16_Channels(Behavioral)
        port map (
            LVDS_CLK    => LVDS_CLK,
            --
            OutMode_EN  => OutMode_EN,
            Channel_EN  => Channel_EN(31 downto 16),
            --
            Bit_Mode    => Bit_Mode,
            Output_Mode => Output_Mode(4 downto 1),
            --
            DATA_IN     => DATA_IN(31 downto 16),
            DATA_OUT    => DATA_OUT(31 downto 16));
            
    B16_Channels_B : entity work.B16_Channels(Behavioral)
        port map (
            LVDS_CLK    => LVDS_CLK,
            --
            OutMode_EN  => OutMode_EN_B,
            Channel_EN  => Channel_EN(15 downto 0),
            --
            Bit_Mode    => Bit_Mode,
            Output_Mode => Output_Mode(4 downto 1),
            --
            DATA_IN     => DATA_IN(15 downto 0),
            DATA_OUT    => DATA_OUT(15 downto 0));            
    
end Behavioral;