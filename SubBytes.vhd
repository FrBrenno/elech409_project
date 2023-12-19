-- SubBytes version with 16 S-boxes and no delay
-- 128-bits input is processed instantaneously
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SubBytes is
    port (
        input_data: in std_logic_vector(127 downto 0);
        output_data: out std_logic_vector(127 downto 0)
    );
end entity SubBytes;

architecture arch_SubBytes of SubBytes is
    -- Component declaration
    component S_box is
        port (
            BYTE_IN : in std_logic_vector(7 downto 0);
            BYTE_OUT : out std_logic_vector(7 downto 0)
        ); end component;
    
    -- Signal declaration
    signal temp: std_logic_vector(127 downto 0);

begin
    -- Generate statement to create multiple S_box instances
    gen_sboxes: for i in 0 to 15 generate
        S_box_inst: S_box
            port map (
                BYTE_IN  => input_data(8*i + 7 downto 8*i),
                BYTE_OUT => temp(8*i + 7 downto 8*i)
            );
    end generate;
    output_data <= temp;

end architecture arch_SubBytes;
