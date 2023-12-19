-- Because of 'wait for 1 ps' in the process, in order to process the data,
-- it takes 8 ps to process all the data.
-- Strange behavior is that it only takes 8 ps for the first 128 bits, then it is instantaneous.
LIBRARY ieee, work;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.matrix_pkg.ALL;

ENTITY MixColumn IS
    PORT (
        input_data : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
        output_data : OUT STD_LOGIC_VECTOR(127 DOWNTO 0)
    );
END ENTITY MixColumn;

ARCHITECTURE arch_MixColumn OF MixColumn IS
    -- Component declaration
    COMPONENT LUT_mul2 IS PORT (
        byte_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        byte_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT LUT_mul3 IS PORT (
        byte_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        byte_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;

    -- Signal declaration
    SIGNAL input_Matrix : Matrix(0 TO 3, 0 TO 3);
    SIGNAL col_a : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL col_2a : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL col_3a : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');

BEGIN
    gen_lut_mul2 : FOR i IN 0 TO 3 GENERATE
        mul2_inst : LUT_mul2 PORT MAP(
            byte_in => col_a(i * 8 + 7 DOWNTO i * 8),
            byte_out => col_2a(i * 8 + 7 DOWNTO i * 8)
        );
    END GENERATE gen_lut_mul2;

    gen_lut_mul3 : FOR i IN 0 TO 3 GENERATE
        mul3_inst : LUT_mul3 PORT MAP(
            byte_in => col_a(i * 8 + 7 DOWNTO i * 8),
            byte_out => col_3a(i * 8 + 7 DOWNTO i * 8)
        );
    END GENERATE gen_lut_mul3;

    col_a_process : PROCESS
        VARIABLE output_matrix : Matrix(0 to 3, 0 to 3) := (
            (x"00", x"00", x"00", x"00"),
            (x"00", x"00", x"00", x"00"),
            (x"00", x"00", x"00", x"00"),
            (x"00", x"00", x"00", x"00")
        );
    BEGIN
        WAIT ON input_data;
        input_Matrix <= hexaToMatrix(input_data);
        -- Column 0
        FOR i IN 0 TO 3 LOOP
            WAIT FOR 1 ps;
            col_a <= getColumn(input_Matrix, i);
            WAIT FOR 1 ps;
            output_matrix(0, i) := getElement(col_2a, 0) XOR getElement(col_3a, 1) XOR getElement(col_a, 2) XOR getElement(col_a, 3);
            output_matrix(1, i) := getElement(col_a, 0) XOR getElement(col_2a, 1) XOR getElement(col_3a, 2) XOR getElement(col_a, 3);
            output_matrix(2, i) := getElement(col_a, 0) XOR getElement(col_a, 1) XOR getElement(col_2a, 2) XOR getElement(col_3a, 3);
            output_matrix(3, i) := getElement(col_3a, 0) XOR getElement(col_a, 1) XOR getElement(col_a, 2) XOR getElement(col_2a, 3);
        END LOOP;
        output_data <= matrixToHexa(output_matrix);
    END PROCESS col_a_process;
END ARCHITECTURE arch_MixColumn;