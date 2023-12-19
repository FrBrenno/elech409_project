LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

library work;
use work.matrix_pkg.all;

ENTITY AddRoundKey_tb IS
END ENTITY;

ARCHITECTURE ben2 OF AddRoundKey_tb IS
    COMPONENT AddRoundKey IS PORT (
        plain_text_matrix, key_matrix : IN Matrix(0 to 3, 0 to 3);
        sum_matrix : OUT Matrix(0 to 3, 0 to 3)
        );
    END COMPONENT;

    -- These are the internal wires
    SIGNAL plain_text, key : STD_LOGIC_VECTOR(127 DOWNTO 0);
    SIGNAL sum : STD_LOGIC_VECTOR(127 DOWNTO 0) := (OTHERS => '0');

    SIGNAL sum_matrix : Matrix(0 to 3, 0 to 3) := (
        (x"00", x"00", x"00", x"00"),
        (x"00", x"00", x"00", x"00"),
        (x"00", x"00", x"00", x"00"),
        (x"00", x"00", x"00", x"00")
    );

BEGIN
    uut : AddRoundKey PORT MAP(
        plain_text_matrix => hexaToMatrix(plain_text),
        key_matrix => hexaToMatrix(key),
        sum_matrix => sum_matrix
    );

    stim : PROCESS
    BEGIN
        -- Initial Round

        -- Setting hex values
        plain_text <= x"6BC1BEE22E409F96E93D7E117393172A";
        key <= x"2B7E151628AED2A6ABF7158809CF4F3C";
        wait for 1 ps;
        sum <= matrixToHexa(sum_matrix); -- Converting output back to hex
        wait for 1 ps;
        -- Checking if output is correct
        ASSERT (sum = x"40BFABF406EE4D3042CA6B997A5C5816")
        REPORT "1: INCORRECT OUTPUT\n" SEVERITY note;
        WAIT FOR 5 ns;

        -- Second Round
        plain_text <= x"529F16C2978615CAE01AAE54BA1A2659";
        key <= x"a0fafe1788542cb123a339392a6c7605";
        wait for 1 ps;
        sum <= matrixToHexa(sum_matrix);
        WAIT FOR 1 ps;
        ASSERT (sum = x"F265E8D51FD2397BC3B9976D9076505C")
        REPORT "2: INCORRECT OUTPUT\n" SEVERITY note;
        WAIT FOR 5 ns;

        -- Third Round
        plain_text <= x"0F31E929319A3558AEC9589339F04D87";
        key <= x"f2c295f27a96b9435935807a7359f67f";
        wait for 1 ps;
        sum <= matrixToHexa(sum_matrix);
        WAIT FOR 1 ps;
        ASSERT (sum = x"FDF37CDB4B0C8C1BF7FCD8E94AA9BBF8")
        REPORT "3: INCORRECT OUTPUT\n" SEVERITY note;
        WAIT FOR 5 ns;

        -- Fourth Round
        plain_text <= x"9151ABE1E5541CFD014A713EDA7E3134";
        key <= x"3d80477d4716fe3e1e237e446d7a883b";
        wait for 1 ps;
        sum <= matrixToHexa(sum_matrix);
        WAIT FOR 1 ps;
        ASSERT (sum = x"ACD1EC9CA242E2C31F690F7AB704B90F")
        REPORT "4: INCORRECT OUTPUT\n" SEVERITY note;
        WAIT FOR 5 ns;

        -- Fifth Round
        plain_text <= x"4D25CB1EECF716467658C73B49BCC9E9";
        key <= x"ef44a541a8525b7fb671253bdb0bad00";
        wait for 1 ps;
        sum <= matrixToHexa(sum_matrix);
        WAIT FOR 1 ps;
        ASSERT (sum = x"A2616E5F44A54D39C029E20092B764E9")
        REPORT "5: INCORRECT OUTPUT\n" SEVERITY note;
        WAIT FOR 5 ns;
    END PROCESS;

END ben2;