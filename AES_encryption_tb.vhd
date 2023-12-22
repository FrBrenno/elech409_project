LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY AES_encryption_tb IS
END AES_encryption_tb;

ARCHITECTURE tb_arch OF AES_encryption_tb IS
    COMPONENT AES_encryption
        PORT (
            plain_text : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            cipher_text : OUT STD_LOGIC_VECTOR(127 DOWNTO 0);
            done : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL plain_text, cipher_text_output : STD_LOGIC_VECTOR(127 DOWNTO 0) := (OTHERS => '0');
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL rst : STD_LOGIC := '1';
    SIGNAL done : STD_LOGIC;

BEGIN
    uut : AES_encryption
    PORT MAP(
        plain_text => plain_text,
        clk => clk,
        rst => rst,
        cipher_text => cipher_text_output,
        done => done
    );

    clk_process : PROCESS
    BEGIN
        clk <= NOT clk;
        WAIT FOR 5 ns;
    END PROCESS;

    reset_process : PROCESS
    BEGIN
        rst <= NOT rst;
        WAIT FOR 1760 ns;
    END PROCESS;

    stimulus : PROCESS
    BEGIN
        plain_text <= x"6BC1BEE22E409F96E93D7E117393172A";
        WAIT UNTIL done = '1';
        ASSERT (cipher_text_output = x"3AD77BB40D7A3660A89ECAF32466EF97")
        REPORT "1: INCORRECT OUTPUT\n" SEVERITY note;
        WAIT FOR 10 ns;

        plain_text <= x"AE2D8A571E03AC9C9EB76FAC45AF8E51";
        WAIT UNTIL done = '1';
        ASSERT (cipher_text_output = x"F5D3D58503B9699DE785895A96FDBAAF")
        REPORT "2: INCORRECT OUTPUT\n" SEVERITY note;
        WAIT FOR 10 ns;

        plain_text <= x"30C81C46A35CE411E5FBC1191A0A52EF";
        WAIT UNTIL done = '1';
        ASSERT (cipher_text_output = x"43B1CD7F598ECE23881B00E3ED030688")
        REPORT "3: INCORRECT OUTPUT\n" SEVERITY note;
        WAIT FOR 10 ns;

        plain_text <= x"F69F2445DF4F9B17AD2B417BE66C3710";
        WAIT UNTIL done = '1';
        ASSERT (cipher_text_output = x"7B0C785E27E8AD3F8223207104725DD4")
        REPORT "4: INCORRECT OUTPUT\n" SEVERITY note;
        WAIT FOR 10 ns;
    END PROCESS;

END tb_arch;