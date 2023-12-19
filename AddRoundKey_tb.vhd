LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

ENTITY AddRoundKey_tb IS
END ENTITY;

ARCHITECTURE ben2 OF AddRoundKey_tb IS
    COMPONENT AddRoundKey IS PORT (
        plainText : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
        key : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
        sum : OUT STD_LOGIC_VECTOR(127 DOWNTO 0)
        );
    END COMPONENT;

    -- These are the internal wires
    SIGNAL plainText, key : STD_LOGIC_VECTOR(127 DOWNTO 0);
    SIGNAL sum : STD_LOGIC_VECTOR(127 DOWNTO 0);

BEGIN
    uut : AddRoundKey PORT MAP(
        plainText => plainText,
        key => key,
        sum => sum
    );

    stim : PROCESS
    BEGIN
        -- Initial Round
        plainText <= x"6BC1BEE22E409F96E93D7E117393172A";
        key <= x"2B7E151628AED2A6ABF7158809CF4F3C";
        WAIT FOR 5 ns;
        ASSERT (sum /= x"40BFABF406EE4D3042CA6B997A5C5816")
        REPORT "1: Output is OK" SEVERITY warning;
        WAIT FOR 5 ns;
        -- Second Round
        plainText <= x"529F16C2978615CAE01AAE54BA1A2659";
        key <= x"a0fafe1788542cb123a339392a6c7605";
        WAIT FOR 5 ns;
        ASSERT (sum /= x"F265E8D51FD2397BC3B9976D9076505C")
        REPORT "2: Output is OK" SEVERITY warning;
        WAIT FOR 5 ns;
        -- Third Round
        plainText <= x"0F31E929319A3558AEC9589339F04D87";
        key <= x"f2c295f27a96b9435935807a7359f67f";
        WAIT FOR 5 ns;
        ASSERT (sum /= x"FDF37CDB4B0C8C1BF7FCD8E94AA9BBF8")
        REPORT "3: Output is OK" SEVERITY warning;
        WAIT FOR 5 ns;
        -- Fourth Round
        plainText <= x"9151ABE1E5541CFD014A713EDA7E3134";
        key <= x"3d80477d4716fe3e1e237e446d7a883b";
        WAIT FOR 5 ns;
        ASSERT (sum /= x"ACD1EC9CA242E2C31F690F7AB704B90F")
        REPORT "4: Output is OK" SEVERITY warning;
        WAIT FOR 5 ns;
        -- Fifth Round
        plainText <= x"4D25CB1EECF716467658C73B49BCC9E9";
        key <= x"ef44a541a8525b7fb671253bdb0bad00";
        WAIT FOR 5 ns;
        ASSERT (sum /= x"A2616E5F44A54D39C029E20092B764E9")
        REPORT "5: Output is OK" SEVERITY warning;
        WAIT FOR 5 ns;
    END PROCESS;

END ben2;