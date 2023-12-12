-- FILEPATH: /c:/Users/brenn/Vivado/elech409_project/SubBytes.vhd

library ieee;
use ieee.std_logic_1164.all;

entity SubBytes is
    port (
        aMatrix: in std_logic_matrix(3 downto 0, 3 downto 0);
        bMatrix: out std_logic_matrix(3 downto 0, 3 downto 0);
    );
end entity SubBytes;

architecture arch_SubBytes of SubBytes is
    --- Component definition
    component S_box is port(
        byte_in : in std_logic_vector(7 downto 0);
        byte_out : out std_logic_vector(7 downto 0)
    );end component;

    --- Function definition
    function SubBytesTransformation(input_byte: std_logic_vector) return std_logic_vector is
        variable output_byte: std_logic_vector(7 downto 0);
    begin
        S_box_instance: S_box port map(
            byte_in => input_byte,
            byte_out => output_byte
        );
        return output_byte;
    end function;

begin
    process
        variable row, col: integer;
    begin
        for row in 0 to 3 loop
            for col in 0 to 3 loop
                bMatrix(row, col) <= SubBytesTransformation(aMatrix(row, col));
            end loop;
        end loop;
    end process;
end architecture arch_SubBytes;
