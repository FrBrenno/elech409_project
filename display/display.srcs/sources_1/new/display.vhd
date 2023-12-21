-- fpga4student.com: FPGA projects, Verilog projects, VHDL projects
-- VHDL code for seven-segment display on Basys 3 FPGA
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
entity seven_segment_display_VHDL is
    Port ( clock_100Mhz : in STD_LOGIC;-- 100Mhz clock on Basys 3 FPGA board
           reset : in STD_LOGIC; -- reset
           Anode_Activate : out STD_LOGIC_VECTOR (3 downto 0);-- 4 Anode signals
           LED_out : out STD_LOGIC_VECTOR (6 downto 0));-- Cathode patterns of 7-segment display
end seven_segment_display_VHDL;

architecture Behavioral of seven_segment_display_VHDL is
signal one_second_counter: STD_LOGIC_VECTOR (27 downto 0);
-- counter for generating 1-second clock enable
signal one_second_enable: std_logic;
-- one second enable for counting numbers
signal displayed_number: STD_LOGIC_VECTOR (15 downto 0);
-- counting decimal number to be displayed on 4-digit 7-segment display
signal LED_BCD: STD_LOGIC_VECTOR (3 downto 0);
signal refresh_counter: STD_LOGIC_VECTOR (19 downto 0);
-- creating 10.5ms refresh period
signal LED_activating_counter: std_logic_vector(1 downto 0);
-- the other 2-bit for creating 4 LED-activating signals
-- count         0    ->  1  ->  2  ->  3
-- activates    LED1    LED2   LED3   LED4
-- and repeat
begin
-- VHDL code for BCD to 7-segment decoder
-- Cathode patterns of the 7-segment LED display 
process(LED_BCD)
begin
    case LED_BCD is
    when "1010" => LED_out <= "0000010"; -- A
    when "1110" => LED_out <= "0110000"; -- E
    when "0101" => LED_out <= "0100100"; -- "S"     
    when "1111" => LED_out <= "1111111"; -- 
    end case;
end process;
-- 7-segment display controller
-- generate refresh period of 10.5ms
process(clock_100Mhz,reset)
begin 
    if(reset='1') then
        refresh_counter <= (others => '0');
    elsif(rising_edge(clock_100Mhz)) then
        refresh_counter <= refresh_counter + 1;
    end if;
end process;
 LED_activating_counter <= refresh_counter(19 downto 18);
-- 4-to-1 MUX to generate anode activating signals for 4 LEDs 
process(LED_activating_counter)
begin
    case LED_activating_counter is
    when "00" =>
        Anode_Activate <= "0111"; 
        -- activate LED1 and Deactivate LED2, LED3, LED4
        LED_BCD <= "1010";
        -- Display A
    when "01" =>
        Anode_Activate <= "1011"; 
        -- activate LED2 and Deactivate LED1, LED3, LED4
        LED_BCD <= "1110";
        -- Display E
    when "10" =>
        Anode_Activate <= "1101"; 
        -- activate LED3 and Deactivate LED2, LED1, LED4
        LED_BCD <= "0101";
        -- Display S
    when "11" =>
        Anode_Activate <= "1110"; 
        -- activate LED4 and Deactivate LED2, LED3, LED1
        LED_BCD <= "1111";
        -- Display nothing  
    end case;
end process;
-- Counting the number to be displayed on 4-digit 7-segment Display 
-- on Basys 3 FPGA board
process(clock_100Mhz, reset)
begin
        if(reset='1') then
            one_second_counter <= (others => '0');
        elsif(rising_edge(clock_100Mhz)) then
            if(one_second_counter>=x"5F5E0FF") then
                one_second_counter <= (others => '0');
            else
                one_second_counter <= one_second_counter + "0000001";
            end if;
        end if;
end process;
one_second_enable <= '1' when one_second_counter=x"5F5E0FF" else '0';
process(clock_100Mhz, reset)
begin
        if(reset='1') then
            displayed_number <= (others => '0');
        elsif(rising_edge(clock_100Mhz)) then
             if(one_second_enable='1') then
                displayed_number <= displayed_number + x"0001";
             end if;
        end if;
end process;
end Behavioral;