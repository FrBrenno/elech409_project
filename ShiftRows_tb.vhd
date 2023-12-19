LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

ENTITY ShiftRows_tb IS
END ENTITY;

ARCHITECTURE ben2 OF ShiftRows_tb IS
    COMPONENT ShiftRows IS PORT (
        input_vector : IN STD_LOGIC_VECTOR (127 DOWNTO 0);
        output_vector : OUT STD_LOGIC_VECTOR (127 DOWNTO 0)
        );
    END COMPONENT;

    -- These are the internal wires
    SIGNAL plain_text : STD_LOGIC_VECTOR(127 DOWNTO 0);
    SIGNAL cipher_text : STD_LOGIC_VECTOR(127 DOWNTO 0);

BEGIN
    uut : ShiftRows PORT MAP(
        input_vector => plain_text,
        output_vector => cipher_text
    );

    stim : PROCESS
    BEGIN
        plain_text <= x"090862BF6F28E3042C747FEEDA4A6A47";
        WAIT FOR 5 ns;
        ASSERT (cipher_text /= x"09287F476F746ABF2C4A6204DA08E3EE")
        REPORT "1: Output is OK" SEVERITY note;
        ASSERT (cipher_text = x"09287F476F746ABF2C4A6204DA08E3EE")
        REPORT "1: Output is not correct" SEVERITY warning;
        WAIT FOR 5 ns;

        plain_text <= x"894D9B03C0B512212E56883C6038534A";
        WAIT FOR 5 ns;
        ASSERT (cipher_text /= x"89B5884AC05653032E389B21604D123C")
        REPORT "2: Output is OK" SEVERITY note;
        ASSERT (cipher_text = x"89B5884AC05653032E389B21604D123C")
        REPORT "2: Output is not correct" SEVERITY warning;
        WAIT FOR 5 ns;

        plain_text <= x"540D10B9B3FE64AF68B0611ED6D3EA41";
        WAIT FOR 5 ns;
        ASSERT (cipher_text /= x"54FE6141B3B0EAB968D310AFD60D641E")
        REPORT "3: Output is OK" SEVERITY note;
        ASSERT (cipher_text = x"54FE6141B3B0EAB968D310AFD60D641E")
        REPORT "3: Output is not correct" SEVERITY warning;
        WAIT FOR 5 ns;

        plain_text <= x"913ECEDE3A2C982EC0F976DAA9F25676";
        WAIT FOR 5 ns;
        ASSERT (cipher_text /= x"912C76763AF956DEC0F2CE2EA93E98DA")
        REPORT "4: Output is OK" SEVERITY note;
        ASSERT (cipher_text = x"912C76763AF956DEC0F2CE2EA93E98DA")
        REPORT "4: Output is not correct" SEVERITY warning;
        WAIT FOR 5 ns;

        plain_text <= x"3AEF9FCF1B06E312BAA598634FA9431E";
        WAIT FOR 5 ns;
        ASSERT (cipher_text /= x"3A06981E1BA543CFBAA99F124FEFE363")
        REPORT "5: Output is OK" SEVERITY note;
        ASSERT (cipher_text = x"3A06981E1BA543CFBAA99F124FEFE363")
        REPORT "5: Output is not correct" SEVERITY warning;
        WAIT FOR 5 ns;
    END PROCESS;
END ben2;