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

    -- Signals to threat the signals of the segment and of the anode
    signal SEG_OUT : std_logic_vector(6 downto 0);
    signal SEG_BCD : std_logic_vector(3 downto 0);
    signal ANODE_ACT : std_logic_vector(3 downto 0);
    -- Counter of 10.5ms mandatory to display correctly of the screen
    signal refresh_counter: std_logic_vector(19 downto 0);
    signal SEG_active_Count: std_logic_vector(1 downto 0);    
    -- Signals to active the displaying and to reset the process
    signal RST : std_logic := '0';
    signal activation : std_logic := '0';

begin

    process(CLK_100MHZ,activation,RST)
        -- Process leading the reset mode and the activation 
        -- of the displaying once the encryption is done
    begin    
        if RST = '1' then
            activation <= '0';
            RST <= '0';
            
        elsif rising_edge(CLK_100MHZ) then
            -- This is a control to ensure the pressure on the button
            led0 <= btnC;
            led1 <= btnR;
                        
            if activation = '0' then
                -- Central button launch the encryption
                activation <= btnC;
            end if;
            
            if RST = '0' then
                -- Right button initialise the reset
                -- To rebegin the encryption after a reset
                -- We need to push again on the central button
                -- To start the encryption
                RST <= btnR;
            end if;
        end if;                   
    end process;
    
    process(SEG_BCD)
        -- This process lead the different caracter to display
        -- In this case we need only the A,E,S but I keep
        -- All the possibilities because I had a bug with the
        -- "when others" because it doesn't work and wanted
        -- All the possibilities 
        -- /!\ In this case /!\
        --      1 ==> OFF
        --      0 ==> ON
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
        -- This process lead the refreshing ratee of the screen
    begin
        if(rising_edge(CLK_100MHZ)) then
            refresh_counter <= refresh_counter + 1;
        end if;
    end process;
    
    SEG_active_Count <= refresh_counter(19 downto 18);
    
    process(SEG_active_Count,activation)
        -- This process lead the Anode displaying 
        -- The data (AES in our case)
        -- If activation is at 1 we display AES
        -- Otherwise we display nothing
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