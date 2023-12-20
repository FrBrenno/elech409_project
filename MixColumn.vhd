-- Because of 'wait for 1 ps' in the process, in order to process the data,
-- it takes 8 ps to process all the data.
-- Strange behavior is that it only takes 8 ps for the first 128 bits, then it is instantaneous.
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

library work;
USE work.matrix_pkg.ALL;

ENTITY MixColumn IS
    PORT (
        input_data : IN Matrix(0 to 3, 0 to 3);
        output_data : OUT Matrix(0 to 3, 0 to 3)
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
    SIGNAL matrix_2 : Matrix(0 to 3, 0 to 3);
    SIGNAL matrix_3 : Matrix(0 to 3, 0 to 3);

BEGIN
    gen_lut_mul2 : For i in 0 to 15 GENERATE
        mul2_inst : LUT_mul2 PORT MAP(
            byte_in => input_data(i / 4, i MOD 4),
            byte_out => matrix_2(i / 4, i MOD 4)
        );
    END GENERATE gen_lut_mul2;

    gen_lut_mul3 : FOR i IN 0 TO 15 GENERATE
        mul3_inst : LUT_mul3 PORT MAP(
            byte_in => input_data(i / 4, i MOD 4),
            byte_out => matrix_3(i / 4, i MOD 4)
        );
    END GENERATE gen_lut_mul3;

    process_matrix : PROCESS (matrix_2, matrix_3)
    begin
        for i in 0 to 3 loop
            output_data(0, i) <= matrix_2(0, i) XOR matrix_3(1, i) XOR input_data(2, i) XOR input_data(3, i);
            output_data(1, i) <= input_data(0, i) XOR matrix_2(1, i) XOR matrix_3(2, i) XOR input_data(3, i);
            output_data(2, i) <= input_data(0, i) XOR input_data(1, i) XOR matrix_2(2, i) XOR matrix_3(3, i);
            output_data(3, i) <= matrix_3(0, i) XOR input_data(1, i) XOR input_data(2, i) XOR matrix_2(3, i);
        end loop;
    end PROCESS process_matrix;
    
END ARCHITECTURE arch_MixColumn;