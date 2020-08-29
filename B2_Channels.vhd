----------------------------------------------------------------------------
--CMV12000-Simulation
--B2_Channels.vhd
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

entity B2_Channels is
    Port ( LVDS_CLK    : in  std_logic;
           --
           OutMode_EN  : in  std_logic;
           Channel_EN  : in  std_logic_vector(1 downto 0);
           --
           Bit_Mode    : in  std_logic_vector(1 downto 0);
           Output_Mode : in  std_logic;
           --
           DATA_IN     : in  senselx128(1 downto 0);
           DATA_OUT    : out std_logic_vector(1 downto 0)
         );
 
end B2_Channels;

architecture Behavioral of B2_Channels is

    signal OutMode_EN_B : std_logic;
    
begin
    OutMode_EN_B  <= not Output_Mode;
    
    B1_Channel_A : entity work.Data_Channel(Behavioral)
        port map (
            LVDS_CLK    => LVDS_CLK,
            --
            OutMode_EN  => OutMode_EN,
            Channel_EN  => Channel_EN(1),
            --
            Bit_Mode    => Bit_Mode,
            --
            DATA_IN     => DATA_IN(1),
            DATA_OUT    => DATA_OUT(1));
            
    B1_Channel_B : entity work.Data_Channel(Behavioral)
        port map (
            LVDS_CLK    => LVDS_CLK,
            --
            OutMode_EN  => OutMode_EN_B,
            Channel_EN  => Channel_EN(0),
            --
            Bit_Mode    => Bit_Mode,
            --
            DATA_IN     => DATA_IN(0),
            DATA_OUT    => DATA_OUT(0));            
    
end Behavioral;