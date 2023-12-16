library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MixColumn is
    port (
        input_data: in std_logic_vector(127 downto 0);
        output_data: out std_logic_vector(127 downto 0)
    );
end entity MixColumn;

architecture arch_MixColumn of MixColumn is
    -- Component declaration
    component LUT_mul2 is port (
        byte_in: in std_logic_vector(7 downto 0);
        byte_out: out std_logic_vector(7 downto 0)
    );end component;
    component LUT_mul3 is port (
        byte_in: in std_logic_vector(7 downto 0);
        byte_out: out std_logic_vector(7 downto 0)
    );end component;  

    -- Signal declaration
    signal mul2_in: std_logic_vector(7 downto 0);
    signal mul2_out: std_logic_vector(7 downto 0);
    signal mul3_in: std_logic_vector(7 downto 0);
    signal mul3_out: std_logic_vector(7 downto 0);
    signal element_data: std_logic_vector(7 downto 0);

begin
    mul2_inst: LUT_mul2 port map (
        byte_in => element_data,
        byte_out => mul2_out
    );
    mul3_inst: LUT_mul3 port map (
        byte_in => element_data,
        byte_out => mul3_out
    );



    output_data <= temp;
end architecture arch_MixColumn;
