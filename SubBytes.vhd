-- SubBytes version with 16 S-boxes and no delay
-- 128-bits input is processed instantaneously
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY work;
USE work.matrix_pkg.ALL;

ENTITY SubBytes IS
    PORT (
        input_data : IN Matrix(0 TO 3, 0 TO 3);
        output_data : OUT Matrix(0 TO 3, 0 TO 3)
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
    SIGNAL temp : Matrix(0 TO 3, 0 TO 3);

BEGIN
    -- Generate statement to create multiple S_box instances
    gen_sboxes : FOR i IN 0 TO 15 GENERATE
        S_box_inst : S_box
        PORT MAP(
            BYTE_IN => input_data(i/4, i REM 4),
            BYTE_OUT => output_data(i/4, i REM 4)
        );
    END GENERATE;
END ARCHITECTURE arch_SubBytes;