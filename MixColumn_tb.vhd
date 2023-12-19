
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY MixColumn_tb IS
END ENTITY MixColumn_tb;

ARCHITECTURE arch_MixColumn_tb OF MixColumn_tb IS
    COMPONENT MixColumn IS PORT (
        input_data : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
        output_data : OUT STD_LOGIC_VECTOR(127 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL plain_text : STD_LOGIC_VECTOR(127 DOWNTO 0) := (OTHERS => '0');
    SIGNAL cipher_text : STD_LOGIC_VECTOR(127 DOWNTO 0) := (OTHERS => '0');
BEGIN
    MixColumn_instance : MixColumn PORT MAP(
        input_data => plain_text,
        output_data => cipher_text
    );

    simulation_rounds : PROCESS
    BEGIN
        plain_text <= x"09287F476F746ABF2C4A6204DA08E3EE";
        WAIT FOR 5 ns;
        ASSERT (cipher_text /= x"529F16C2978615CAE01AAE54BA1A2659")
        REPORT "1: Output is OK" SEVERITY note;
        ASSERT (cipher_text /= x"529F16C2978615CAE01AAE54BA1A2659")
        REPORT "1: Output is INCORRECT" SEVERITY warning;
        WAIT FOR 5 ns;

        plain_text <= x"89B5884AC05653032E389B21604D123C";
        WAIT FOR 5 ns;
        ASSERT (cipher_text /= x"0F31E929319A3558AEC9589339F04D87")
        REPORT "2: Output is OK" SEVERITY note;
        ASSERT (cipher_text /= x"0F31E929319A3558AEC9589339F04D87")
        REPORT "2: Output is INCORRECT" SEVERITY warning;
        WAIT FOR 5 ns;

        plain_text <= x"54FE6141B3B0EAB968D310AFD60D641E";
        WAIT FOR 5 ns;
        ASSERT (cipher_text /= x"9151ABE1E5541CFD014A713EDA7E3134")
        REPORT "3: Output is OK" SEVERITY note;
        ASSERT (cipher_text /= x"9151ABE1E5541CFD014A713EDA7E3134")
        REPORT "3: Output is INCORRECT" SEVERITY warning;
        WAIT FOR 5 ns;

        plain_text <= x"912C76763AF956DEC0F2CE2EA93E98DA";
        WAIT FOR 5 ns;
        ASSERT (cipher_text /= x"4D25CB1EECF716467658C73B49BCC9E9")
        REPORT "4: Output is OK" SEVERITY note;
        ASSERT (cipher_text /= x"4D25CB1EECF716467658C73B49BCC9E9")
        REPORT "4: Output is INCORRECT" SEVERITY warning;
        WAIT FOR 5 ns;

        plain_text <= x"3A06981E1BA543CFBAA99F124FEFE363";
        WAIT FOR 5 ns;
        ASSERT (cipher_text /= x"F89B35EC4E40724E025B00C734D7D81B")
        REPORT "5: Output is OK" SEVERITY note;
        ASSERT (cipher_text /= x"F89B35EC4E40724E025B00C734D7D81B")
        REPORT "5: Output is INCORRECT" SEVERITY warning;
        WAIT FOR 5 ns;
    END PROCESS;
END ARCHITECTURE arch_MixColumn_tb;