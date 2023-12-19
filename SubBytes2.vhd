-- SubBytes2 version with 1 S_box and 1 ps delay
-- Takes 16 ps to process 128 bits of data
-- without the 'wait for 1 ps' line, the process keeps running through the loop without giving
-- the S_box enough time to process the data, so the output is incorrect. 
-- In fact, the simulation can not run the S_box process because it is stuck in this loop.
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY SubBytes2 IS
    PORT (
        input_data : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
        output_data : OUT STD_LOGIC_VECTOR(127 DOWNTO 0)
    );
END ENTITY SubBytes2;

ARCHITECTURE arch_SubBytes2 OF SubBytes2 IS
    -- Component declaration
    COMPONENT S_box IS
        PORT (
            BYTE_IN : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            BYTE_OUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;

    -- Signal declaration
    SIGNAL temp_byte : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL byte_out : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN
    S_box_inst : S_box PORT MAP(
        BYTE_IN => temp_byte,
        BYTE_OUT => byte_out
    );

    PROCESS
    BEGIN
        FOR i IN 0 TO 15 LOOP
            temp_byte <= input_data(i * 8 + 7 DOWNTO i * 8);
            WAIT FOR 1 ps;
            output_data(i * 8 + 7 DOWNTO i * 8) <= byte_out;
        END LOOP;
    END PROCESS;

END ARCHITECTURE arch_SubBytes2;