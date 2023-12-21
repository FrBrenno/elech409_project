library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
entity Display is Port (
    CLK_100MHZ : in std_logic;
    btnC : in std_logic;
    btnR: in std_logic;
    led0 : out std_logic;
    led1 : out std_logic;
    SEG_OUT0 : out std_logic;
    SEG_OUT1 : out std_logic;
    SEG_OUT2 : out std_logic;
    SEG_OUT3 : out std_logic;
    SEG_OUT4 : out std_logic;
    SEG_OUT5 : out std_logic;
    SEG_OUT6 : out std_logic;
    ANODE_ACT0: out std_logic;
    ANODE_ACT1: out std_logic;
    ANODE_ACT2: out std_logic;
    ANODE_ACT3: out std_logic
); end Display;

architecture Behavioral of Display is

    signal SEG_OUT : std_logic_vector(6 downto 0);
    signal SEG_BCD : std_logic_vector(3 downto 0);
    signal ANODE_ACT : std_logic_vector(3 downto 0);
    -- counter of 10.5ms
    signal refresh_counter: std_logic_vector(19 downto 0);
    signal SEG_active_Count: std_logic_vector(1 downto 0);    
    
    signal counter : std_logic_vector(19 downto 0);
    signal RST : std_logic := '0';
    signal activation : std_logic := '0';

begin

    process(CLK_100MHZ,activation,RST)
    begin   
     
        if RST = '1' then
            activation <= '0';
            RST <= '0';
            
        elsif rising_edge(CLK_100MHZ) then
            led0 <= btnC;
            led1 <= btnR;
                        
            if activation = '0' then
                activation <= btnC;
            end if;
            
            if RST = '0' then
                RST <= btnR;
            end if;
        end if;                   
    end process;
    
    process(SEG_BCD)
    begin
        case SEG_BCD is
            when "0000" => SEG_OUT <= "1000000"; -- "0"
            when "0001" => SEG_OUT <= "1111001"; -- "1"
            when "0010" => SEG_OUT <= "0100100"; -- "2"
            when "0011" => SEG_OUT <= "0110000"; -- "3"
            when "0100" => SEG_OUT <= "0011001"; -- "4"            
            when "0101" => SEG_OUT <= "0100100"; -- "S"
            when "0110" => SEG_OUT <= "1000010"; -- "6"
            when "0111" => SEG_OUT <= "1111000"; -- "7"
            when "1000" => SEG_OUT <= "0000000"; -- "8"
            when "1001" => SEG_OUT <= "0010000"; -- "9"              
            when "1010" => SEG_OUT <= "0001000"; -- "A"
            when "1011" => SEG_OUT <= "0000011"; -- b
            when "1100" => SEG_OUT <= "1000110"; -- C
            when "1101" => SEG_OUT <= "1000010"; -- d  
            when "1110" => SEG_OUT <= "0110000"; -- "E"
            when "1111" => SEG_OUT <= "1111111"; -- " " ==> Nothing
        end case;
        (SEG_OUT0,SEG_OUT1,SEG_OUT2,SEG_OUT3,SEG_OUT4,SEG_OUT5,SEG_OUT6) <= SEG_OUT;
    end process;

    process(CLK_100MHZ)
    begin
        if(rising_edge(CLK_100MHZ)) then
            refresh_counter <= refresh_counter + 1;
        end if;
    end process;
    
    SEG_active_Count <= refresh_counter(19 downto 18);
    
    process(SEG_active_Count,activation)
    begin
    
        if activation = '1' then
            case SEG_active_Count is
                when "00" => ANODE_ACT <= "0111";
                -- S --
                SEG_BCD <= "0101";
    
                when "01" => ANODE_ACT <= "1011";
                -- E --
                SEG_BCD <= "1110";
    
                when "10" => ANODE_ACT <= "1101";
                -- A --
                SEG_BCD <= "1010";
    
                when "11" => ANODE_ACT <= "1110";
                -- Nothing --
                SEG_BCD <= "1111";
            end case;
        else
            ANODE_ACT <= "1111";
            SEG_BCD <= "1111";
        end if;
        (ANODE_ACT0,ANODE_ACT1,ANODE_ACT2,ANODE_ACT3) <= ANODE_ACT;
    end process;   

end Behavioral;