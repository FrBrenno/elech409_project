LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

LIBRARY work;
USE work.matrix_pkg.ALL;

ENTITY ShiftRows_tb IS
END ENTITY;

ARCHITECTURE ben2 OF ShiftRows_tb IS
    COMPONENT ShiftRows IS PORT (
        input_matrix : IN Matrix(0 TO 3, 0 TO 3);
        output_matrix : OUT Matrix(0 TO 3, 0 TO 3)
        );
    END COMPONENT;

    -- These are the internal wires
    SIGNAL plain_text : STD_LOGIC_VECTOR(127 DOWNTO 0);
    SIGNAL cipher_text : STD_LOGIC_VECTOR(127 DOWNTO 0);
    SIGNAL output_data : Matrix(0 TO 3, 0 TO 3);

BEGIN
    uut : ShiftRows PORT MAP(
        input_matrix => hexaToMatrix(plain_text),
        output_matrix => output_data
    );

    stim : PROCESS
    BEGIN
        plain_text <= x"090862BF6F28E3042C747FEEDA4A6A47";
        WAIT ON output_data;
        cipher_text <= matrixToHexa(output_data);
        WAIT FOR 1 ps;
        ASSERT (cipher_text = x"09287F476F746ABF2C4A6204DA08E3EE")
        REPORT "1: INCORRECT OUTPUT" SEVERITY warning;
        WAIT FOR 5 ns;

        plain_text <= x"894D9B03C0B512212E56883C6038534A";
        WAIT ON output_data;
        cipher_text <= matrixToHexa(output_data);
        WAIT FOR 1 ps;
        ASSERT (cipher_text = x"89B5884AC05653032E389B21604D123C")
        REPORT "2: INCORRECT OUTPUT" SEVERITY warning;
        WAIT FOR 5 ns;

        plain_text <= x"540D10B9B3FE64AF68B0611ED6D3EA41";
        WAIT ON output_data;
        cipher_text <= matrixToHexa(output_data);
        WAIT FOR 1 ps;
        ASSERT (cipher_text = x"54FE6141B3B0EAB968D310AFD60D641E")
        REPORT "3: INCORRECT OUTPUT" SEVERITY warning;
        WAIT FOR 5 ns;

        plain_text <= x"913ECEDE3A2C982EC0F976DAA9F25676";
        WAIT ON output_data;
        cipher_text <= matrixToHexa(output_data);
        WAIT FOR 1 ps;
        ASSERT (cipher_text = x"912C76763AF956DEC0F2CE2EA93E98DA")
        REPORT "4: INCORRECT OUTPUT" SEVERITY warning;
        WAIT FOR 5 ns;

        plain_text <= x"3AEF9FCF1B06E312BAA598634FA9431E";
        WAIT ON output_data;
        cipher_text <= matrixToHexa(output_data);
        WAIT FOR 1 ps;
        ASSERT (cipher_text = x"3A06981E1BA543CFBAA99F124FEFE363")
        REPORT "5: INCORRECT OUTPUT" SEVERITY warning;
        WAIT FOR 5 ns;
    END PROCESS;
END ben2;