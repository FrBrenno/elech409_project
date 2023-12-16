library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SubBytes is
    port (
        aMatrix: in std_logic_vector(127 downto 0);
        bMatrix: out std_logic_vector(127 downto 0)
    );
end entity SubBytes;

architecture arch_SubBytes of SubBytes is
    -- Component declaration
    component S_box is
        port (
            BYTE_IN : in std_logic_vector(7 downto 0);
            BYTE_OUT : out std_logic_vector(7 downto 0)
        );
    end component;
    
    -- Signal declaration
    signal temp_byte: std_logic_vector(7 downto 0);
    signal byte_out: std_logic_vector(7 downto 0);

begin
    S_box_inst: S_box port map(
        BYTE_IN => temp_byte,
        BYTE_OUT => byte_out
    );

    process
    begin
        for i in 0 to 15 loop
            temp_byte <= aMatrix(i*8+7 downto i*8);
            wait for 1 ps;
            bMatrix(i*8+7 downto i*8) <= byte_out;
        end loop;  
    end process;

end architecture arch_SubBytes;
