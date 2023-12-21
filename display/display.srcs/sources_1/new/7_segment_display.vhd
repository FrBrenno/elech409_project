-- fpga4student.com: FPGA projects, Verilog projects, VHDL projects
-- VHDL code for seven-segment display on Basys 3 FPGA
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
entity seven_segment_display_VHDL is Port ( 
    CLK_100MHZ : in std_logic;
    BCD_SW: in std_logic_vector (15 downto 0);
    SEG_OUT: out std_logic_vector (6 downto 0);
    ANODE_ACT: out std_logic_vector (3 downto 0)-- Cathode patterns of 7-segment display
);end seven_segment_display_VHDL;

architecture Behavioral of seven_segment_display_VHDL is
    
    signal SEG_BCD: STD_LOGIC_VECTOR (3 downto 0);
    signal refresh_counter: STD_LOGIC_VECTOR (19 downto 0);
    -- creating 10.5ms refresh period
    signal SEG_active_Count: std_logic_vector(1 downto 0);

begin
-- VHDL code for BCD to 7-segment decoder
-- Cathode patterns of the 7-segment LED display 
process(SEG_BCD)
    begin
        case SEG_BCD is            
            when "1010" => SEG_OUT <= "0100000"; -- A
            when "1110" => SEG_OUT <= "0000110"; -- E
            when "0101" => SEG_OUT <= "0010010"; -- "S"
            when "1111" => SEG_OUT <= "1111111"; -- nothing
        end case;
end process;

process(CLK_100MHZ)
    begin
        if(rising_edge(CLK_100MHZ)) then
            refresh_counter <= refresh_counter + 1;
        end if;
end process;
SEG_active_Count <= refresh_counter(19 downto 18);
process(SEG_active_Count)
    begin
        case SEG_active_Count is
            when "00" => ANODE_ACT <= "0111";
            SEG_BCD <= "1010";
            when "01" => ANODE_ACT <= "1011";
            SEG_BCD <= "1110";
            when "10" => ANODE_ACT <= "1101";
            SEG_BCD <= "0101";
            when "11" => ANODE_ACT <= "1110";
            SEG_BCD <= "1111";
    end case;
end process;


end Behavioral;