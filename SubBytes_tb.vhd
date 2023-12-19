
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY SubBytes_tb IS
END ENTITY SubBytes_tb;

ARCHITECTURE arch_SubBytes_tb OF SubBytes_tb IS
    COMPONENT SubBytes IS PORT (
        input_data : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
        output_data : OUT STD_LOGIC_VECTOR(127 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL plain_text : STD_LOGIC_VECTOR(127 DOWNTO 0);
    SIGNAL cipher_text : STD_LOGIC_VECTOR(127 DOWNTO 0);
BEGIN
    SubBytes_instance : SubBytes PORT MAP(
        input_data => plain_text,
        output_data => cipher_text
    );

    simulation_rounds : PROCESS
    BEGIN

        plain_text <= x"40BFABF406EE4D3042CA6B997A5C5816";
        WAIT FOR 5 ns;
        ASSERT (cipher_text /= x"090862BF6F28E3042C747FEEDA4A6A47")
        REPORT "1: Output is OK" SEVERITY warning;
        WAIT FOR 5 ns;

        plain_text <= x"F265E8D51FD2397BC3B9976D9076505C";
        WAIT FOR 5 ns;
        ASSERT (cipher_text /= x"894D9B03C0B512212E56883C6038534A")
        REPORT "2: Output is OK" SEVERITY warning;
        WAIT FOR 5 ns;

        plain_text <= x"FDF37CDB4B0C8C1BF7FCD8E94AA9BBF8";
        WAIT FOR 5 ns;
        ASSERT (cipher_text /= x"540D10B9B3FE64AF68B0611ED6D3EA41")
        REPORT "3: Output is OK" SEVERITY warning;
        WAIT FOR 5 ns;

        plain_text <= x"ACD1EC9CA242E2C31F690F7AB704B90F";
        WAIT FOR 5 ns;
        ASSERT (cipher_text /= x"913ECEDE3A2C982EC0F976DAA9F25676")
        REPORT "4: Output is OK" SEVERITY warning;
        WAIT FOR 5 ns;

        plain_text <= x"A2616E5F44A54D39C029E20092B764E9";
        WAIT FOR 5 ns;
        ASSERT (cipher_text /= x"3AEF9FCF1B06E312BAA598634FA9431E")
        REPORT "5: Output is OK" SEVERITY warning;
        WAIT FOR 5 ns;
    END PROCESS;
END ARCHITECTURE arch_SubBytes_tb;