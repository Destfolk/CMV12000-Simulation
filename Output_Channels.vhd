----------------------------------------------------------------------------
--CMV12000-Simulation
--Output_Channels.vhd
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

entity Output_Channels is
    Port ( Word_Clk         : in  std_logic;
           Word_Clk2        : in  std_logic;
           T_EXP1           : in  std_logic;
           --
           Bit_Mode         : in  std_logic_vector(1  downto 0);
           Output_Mode      : in  std_logic_vector(5  downto 0);
           Training_Pattern : in  std_logic_vector(11 downto 0);
           --
           Channel_en       : in  std_logic_vector(2  downto 0);
           Channel_en_bot   : in  std_logic_vector(31 downto 0);
           Channel_en_top   : in  std_logic_vector(31 downto 0);
           --
           Control_Channel  : out std_logic_vector(11 downto 0);
           patt             : out std_logic_vector(11 downto 0);
           ch_out1          : out std_logic_vector(11 downto 0);
           ch_out2          : out std_logic_vector(11 downto 0);
           ch_out           : out senselx128(32 downto 1);
           --
           DVALx             : out  std_logic;
           LVALx             : out  std_logic;
           FVALx             : out  std_logic;
           OHx               : out  std_logic;
           New_Rowx          : out  std_logic
           );
end Output_Channels;

architecture Behavioral of Output_Channels is 
    
    -----------------------------------------------------
    -- Signal Detection
    -----------------------------------------------------
    signal Idle             : std_logic;
    signal Idle_Detect      : std_logic := '0';
    signal Idle_Detect_2    : std_logic := '0';
    signal Idle_Detect_3    : std_logic := '0';
    signal Idle_Detection_2 : std_logic := '0';
    signal Idle_Detection_3 : std_logic := '0';
    
    signal OH               : std_logic := '0';
    signal OH_Detect        : std_logic := '0';
    signal OH_Detect_2      : std_logic := '0';
    signal OH_Detect_3      : std_logic := '0';
    
    signal New_Row          : std_logic := '0';
    signal New_Row_1        : std_logic := '0';
    signal New_Row_2        : std_logic := '0';
    
    -----------------------------------------------------
    -- 
    -----------------------------------------------------
    signal Train_Enable     : std_logic := '0';
    signal Counter          : std_logic_vector(4  downto 0);
    signal Row              : std_logic_vector(11 downto 0);
    signal Enable           : std_logic_vector(31 downto 0);
    
    -----------------------------------------------------
    -- Control Signals
    -----------------------------------------------------
    signal DVAL             : std_logic := '0';
    signal LVAL             : std_logic := '0';
    signal FVAL             : std_logic := '0';
    signal FOT              : std_logic := '0';
    signal INTE1            : std_logic := '0';
    signal INTE2            : std_logic := '0';
    
    -----------------------------------------------------
    -- Output Signals
    -----------------------------------------------------
    signal TP_Idle          : std_logic_vector(11 downto 0);
    signal TP_Out           : std_logic_vector(11 downto 0);
    signal gen_out          : senselx128(64 downto 1);
    signal ch_out_bot       : senselx128(32 downto 1);
    signal ch_out_top       : senselx128(32 downto 1);
    
begin  

    Idle_Generator : entity work.Idle_Generator(Behavioral)
    port map(
        Word_Clk2  => Word_Clk2,
        T_EXP1     => T_EXP1,
        Row        => Row, 
        Idle       => Idle);
        
    OH_Generator : entity work.OH_Generator(Behavioral)
    port map(
        Word_Clk => Word_Clk,
        Idle     => Idle,
        Bit_Mode => Bit_Mode, 
        OH       => OH );
        
    Data_Training : entity work.Data_Training(Behavioral)
    port map(
        Word_Clk          => Word_Clk,
        New_Row           => New_Row, 
        Train_Enable      => Train_Enable,
        Bit_Mode          => Bit_Mode,
        Training_Pattern  => Training_Pattern,
        TP_Out            => TP_Out);
        
    Data_Generation : entity work.Data_Generation(Behavioral)
    port map(
        Word_Clk    => Word_Clk,
        Idle        => Idle, 
        OH          => OH, 
        New_Row     => New_Row_2,
        DVAL        => DVAL, 
        LVAL        => LVAL, 
        Output_Mode => Output_Mode,
        FVAL        => FVAL, 
        Row         => Row, 
        gen_out     => gen_out);
    
    Edge_Detect : process(Word_Clk)
    begin
        if rising_edge(Word_Clk) then
            IDLE_Detect   <= IDLE;
            IDLE_Detect_2 <= IDLE_Detect;
            IDLE_Detect_3 <= IDLE_Detect_2;
            
            OH_Detect     <= OH;
            OH_Detect_2   <= OH_Detect;
            OH_Detect_3   <= OH_Detect_2;
            
            New_Row_1     <= New_Row;
            New_Row_2     <= New_Row_1;
            
            TP_Idle       <= Training_pattern;
        end if;
    end process;
    
    OH_Counter : process(Word_Clk)
    begin
        if rising_edge(Word_Clk) then
            if (Idle_Detect = '0' and Idle = '1') then 
                Counter <= (others => '0');
            elsif (OH_Detect = '1' and OH = '0') then
                case Output_mode(4 downto 0) is
                    when "00001" =>
                        Counter <= Counter + 1;
                        if (Counter = "0001") then
                            Counter <= (others => '0');
                        end if;
                    when "00011" =>
                        Counter <= Counter + 1;
                        if (Counter = "0011") then
                            Counter <= (others => '0');
                        end if;
                    when "00111" =>
                        Counter <= Counter + 1;
                        if (Counter = "0111") then
                            Counter <= (others => '0');
                        end if;
                    when "01111" =>
                        Counter <= Counter + 1;
                        if (Counter = "1111") then
                            Counter <= (others => '0');
                        end if;
                    when "11111" =>
                        Counter <= Counter + 1;
                        if (Counter = "11111") then
                            Counter <= (others => '0');
                        end if;
                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;
    
    Output_Channels : process(Word_Clk)
    begin
        if rising_edge(Word_Clk) then
            ch_out_bot <= (others => TP_Idle);
            ch_out_top <= (others => TP_Idle);
            
            case Output_mode(4 downto 0) is
                when "00000" =>
                    for x in 0 to 31 loop
                        if (Idle_Detection_2 = '0' and OH_Detect= '0') then
                            ch_out_bot(x+1) <= gen_out(x+1);
                            ch_out_top(x+1) <= gen_out(x+33);
                        else
                            ch_out_bot(x+1) <= TP_out;
                            ch_out_top(x+1) <= TP_out;
                        end if;
                    end loop;
                when "00001" =>
                    for x in 0 to 15 loop
                        if (Idle_Detection_2 = '0' and OH_Detect= '0') then
                            ch_out_bot(2*x+1) <= gen_out(2*x+1);
                            ch_out_top(2*x+1) <= gen_out(2*x+33);
                        else
                            ch_out_bot(2*x+1) <= TP_out;
                            ch_out_top(2*x+1) <= TP_out;
                        end if;
                    end loop;
                when "00011" =>
                    for x in 0 to 7 loop
                        if (Idle_Detection_2 = '0' and OH_Detect= '0') then
                            ch_out_bot(4*x+1) <= gen_out(4*x+1);
                            ch_out_top(4*x+1) <= gen_out(4*x+33);
                        else
                            ch_out_bot(4*x+1) <= TP_out;
                            ch_out_top(4*x+1) <= TP_out;
                        end if;
                    end loop;
                when "00111" =>
                    for x in 0 to 3 loop
                        if (Idle_Detection_2 = '0' and OH_Detect= '0') then
                            ch_out_bot(8*x+1) <= gen_out(8*x+1);
                            ch_out_top(8*x+1) <= gen_out(8*x+33);
                        else
                            ch_out_bot(8*x+1) <= TP_out;
                            ch_out_top(8*x+1) <= TP_out;
                        end if;
                    end loop;
                when "01111" =>
                    for x in 0 to 1 loop
                        if (Idle_Detection_2 = '0' and OH_Detect= '0') then
                            ch_out_bot(16*x+1) <= gen_out(16*x+1);
                            ch_out_top(16*x+1) <= gen_out(16*x+33);
                        else
                            ch_out_bot(16*x+1) <= TP_out;
                            ch_out_top(16*x+1) <= TP_out;
                        end if;
                    end loop;
                when "11111" =>
                        if (Idle_Detection_2 = '0' and OH_Detect= '0') then
                            ch_out_bot(1) <= gen_out(1);
                            ch_out_top(1) <= gen_out(33);
                        else
                            ch_out_bot(1) <= TP_out;
                            ch_out_top(1) <= TP_out;
                        end if;
                when others =>
                    null;
            end case;
        end if;
    end process;
    
    -------------------
    -- Enable
    -------------------
    Enable           <= Channel_en_bot or Channel_en_bot;
    Idle_Detection_2 <= Idle or Idle_Detect or Idle_Detect_2;
    Idle_Detection_3 <= Idle or Idle_Detect or Idle_Detect_2 or Idle_Detect_3;
    
    Train_Enable <= '1' when Enable > 0        else '0';    
    New_Row      <= OH  when Counter = "00000" else '0';
    -------------------
    -- Control Channel
    -------------------
    DVAL    <= '1'                when not (Idle_Detection_3 or OH_Detect_2) = '1' else '0';
    LVAL    <= not New_Row_2      when      Idle_Detection_3                 = '0' else '0' ;
    
    Control_Channel(11 downto 6) <= "000010";
    Control_Channel(5  downto 3) <= FOT  & INTE1 & INTE2;
    Control_Channel(2  downto 0) <= FVAL & LVAL  & DVAL when Channel_en(1) = '1' and Enable > 0 else "000"; 
    
    -------------------
    -- Output Data
    -------------------
    patt    <= Training_pattern;
    ch_out2 <= ch_out_bot(2);
    ch_out1 <= ch_out_bot(1);
    ch_out  <= ch_out_bot ;     -- ch_out_top & ch_out_bot;
    
    -------------
  /*DVALx    <= DVAL;         
    LVALx    <= LVAL;       
    FVALx    <= FVAL;  
    OHx      <= OH;
    New_Rowx <= New_Row;*/
    -------------
    
end Behavioral;