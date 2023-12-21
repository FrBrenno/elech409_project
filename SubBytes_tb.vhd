LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY work;
USE work.matrix_pkg.ALL;

ENTITY SubBytes_tb IS
END ENTITY SubBytes_tb;

ARCHITECTURE arch_SubBytes_tb OF SubBytes_tb IS
    COMPONENT SubBytes IS PORT (
        input_data : IN Matrix(0 TO 3, 0 TO 3);
        output_data : OUT Matrix(0 TO 3, 0 TO 3)
        );
    END COMPONENT;

    SIGNAL plain_text : STD_LOGIC_VECTOR(127 DOWNTO 0);
    SIGNAL cipher_text : STD_LOGIC_VECTOR(127 DOWNTO 0);
    SIGNAL output_matrix : Matrix(0 TO 3, 0 TO 3);

BEGIN
    SubBytes_instance : SubBytes PORT MAP(
        input_data => hexaToMatrix(plain_text),
        output_data => output_matrix
    );

    simulation_rounds : PROCESS
    BEGIN
        plain_text <= x"40BFABF406EE4D3042CA6B997A5C5816";
        WAIT for 1 ps;
        cipher_text <= matrixToHexa(output_matrix);
        WAIT FOR 1 ps;
        ASSERT (cipher_text = x"090862BF6F28E3042C747FEEDA4A6A47")
        REPORT "1: INCORRECT OUTPUT" SEVERITY warning;
        WAIT FOR 5 ns;

        plain_text <= x"F265E8D51FD2397BC3B9976D9076505C";
        WAIT for 1 ps;
        cipher_text <= matrixToHexa(output_matrix);
        WAIT FOR 1 ps;
        ASSERT (cipher_text = x"894D9B03C0B512212E56883C6038534A")
        REPORT "2: INCORRECT OUTPUT" SEVERITY warning;
        WAIT FOR 5 ns;

        plain_text <= x"FDF37CDB4B0C8C1BF7FCD8E94AA9BBF8";
        WAIT for 1 ps;
        cipher_text <= matrixToHexa(output_matrix);
        WAIT FOR 1 ps;
        ASSERT (cipher_text = x"540D10B9B3FE64AF68B0611ED6D3EA41")
        REPORT "3: INCORRECT OUTPUT" SEVERITY warning;
        WAIT FOR 5 ns;

        plain_text <= x"ACD1EC9CA242E2C31F690F7AB704B90F";
        WAIT for 1 ps;
        cipher_text <= matrixToHexa(output_matrix);
        WAIT FOR 1 ps;
        ASSERT (cipher_text = x"913ECEDE3A2C982EC0F976DAA9F25676")
        REPORT "4: INCORRECT OUTPUT" SEVERITY warning;
        WAIT FOR 5 ns;

        plain_text <= x"A2616E5F44A54D39C029E20092B764E9";
        WAIT for 1 ps;
        cipher_text <= matrixToHexa(output_matrix);
        WAIT FOR 1 ps;
        ASSERT (cipher_text = x"3AEF9FCF1B06E312BAA598634FA9431E")
        REPORT "5: INCORRECT OUTPUT" SEVERITY warning;
        WAIT FOR 5 ns;
    END PROCESS;
END ARCHITECTURE arch_SubBytes_tb;