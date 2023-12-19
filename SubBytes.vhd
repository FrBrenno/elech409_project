-- SubBytes version with 16 S-boxes and no delay
-- 128-bits input is processed instantaneously
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY work;
USE work.matrix_pkg.ALL;

ENTITY SubBytes IS
    PORT (
        input_data : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
        output_data : OUT STD_LOGIC_VECTOR(127 DOWNTO 0)
    );
END ENTITY SubBytes;

ARCHITECTURE arch_SubBytes OF SubBytes IS
    -- Component declaration
    COMPONENT S_box IS
        PORT (
            BYTE_IN : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            BYTE_OUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;

    -- Signal declaration
    SIGNAL input_matrix : Matrix(0 TO 3, 0 TO 3);
    SIGNAL temp : Matrix(0 TO 3, 0 TO 3);

BEGIN
    -- Convert input data to matrix
    input_matrix <= hexaToMatrix(input_data);

    -- Generate statement to create multiple S_box instances
    gen_sboxes : FOR i IN 0 TO 15 GENERATE
        S_box_inst : S_box
        PORT MAP(
            BYTE_IN => input_matrix(i/4, i REM 4),
            BYTE_OUT => temp(i/4, i REM 4)
        );
    END GENERATE;

    -- Convert matrix to output data
    output_data <= matrixToHexa(temp);
END ARCHITECTURE arch_SubBytes;