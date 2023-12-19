library ieee, work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.matrix_pkg.all;

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
    signal input_Matrix : Matrix(0 to 3, 0 to 3);
    signal col_a : std_logic_vector(31 downto 0) := (others => '0');
    signal col_2a : std_logic_vector(31 downto 0) := (others => '0');
    signal col_3a : std_logic_vector(31 downto 0) := (others => '0');

begin
    gen_lut_mul2: for i in 0 to 3 generate
    mul2_inst: LUT_mul2 port map (
        byte_in => col_a(i*8+7 downto i*8),
        byte_out => col_2a(i*8+7 downto i*8)
        );
    end generate gen_lut_mul2;
        
    gen_lut_mul3: for i in 0 to 3 generate
    mul3_inst: LUT_mul3 port map (
        byte_in => col_a(i*8+7 downto i*8),
        byte_out => col_3a(i*8+7 downto i*8)
        );
        end generate gen_lut_mul3;
            
    col_a_process: process
        variable output_matrix : Matrix := (
            (x"00", x"00", x"00", x"00"),
            (x"00", x"00", x"00", x"00"),
            (x"00", x"00", x"00", x"00"),
            (x"00", x"00", x"00", x"00")
        );
    begin
        wait on input_data;
        input_Matrix <= hexaToMatrix(input_data);
        -- Column 0
        for i in 0 to 3 loop
            wait for 1 ps;
            col_a <= getColumn(input_Matrix, i);
            wait for 1 ps;
            output_matrix(0, i) := getElement(col_2a, 0) xor getElement(col_3a, 1) xor getElement(col_a, 2) xor getElement(col_a, 3);
            output_matrix(1, i) := getElement(col_a, 0) xor getElement(col_2a, 1) xor getElement(col_3a, 2) xor getElement(col_a, 3);
            output_matrix(2, i) := getElement(col_a, 0) xor getElement(col_a, 1) xor getElement(col_2a, 2) xor getElement(col_3a, 3);
            output_matrix(3, i) := getElement(col_3a, 0) xor getElement(col_a, 1) xor getElement(col_a, 2) xor getElement(col_2a, 3);
        end loop;
        output_data <= matrixToHexa(output_matrix);
    end process col_a_process;

    
end architecture arch_MixColumn;
