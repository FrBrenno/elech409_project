-- SubBytes version with 16 S-boxes and no delay
-- 128-bits input is processed instantaneously
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY SubBytes3 IS
    PORT (
        input_data : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
        output_data : OUT STD_LOGIC_VECTOR(127 DOWNTO 0)
    );
END ENTITY SubBytes3;

ARCHITECTURE arch_SubBytes3 OF SubBytes3 IS
    -- Component declaration
    COMPONENT S_box IS
        PORT (
            BYTE_IN : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            BYTE_OUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;

    -- Signal declaration
    SIGNAL temp : STD_LOGIC_VECTOR(127 DOWNTO 0);

BEGIN
    -- Generate statement to create multiple S_box instances
    gen_sboxes : FOR i IN 0 TO 15 GENERATE
        S_box_inst : S_box
        PORT MAP(
            BYTE_IN => input_data(8 * i + 7 DOWNTO 8 * i),
            BYTE_OUT => temp(8 * i + 7 DOWNTO 8 * i)
        );
    END GENERATE;
    output_data <= temp;

END ARCHITECTURE arch_SubBytes3;