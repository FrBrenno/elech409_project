LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY AES_encryption_tb IS
END AES_encryption_tb;

ARCHITECTURE tb_arch OF AES_encryption_tb IS
    COMPONENT AES_encryption
        PORT (
            plain_text, key : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            cipher_text : OUT STD_LOGIC_VECTOR(127 DOWNTO 0);
            done : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL plain_text, key, cipher_text_output : STD_LOGIC_VECTOR(127 DOWNTO 0) := (OTHERS => '0');
    SIGNAL clk: STD_LOGIC := '0';
    signal rst : STD_LOGIC := '1'; 
    SIGNAL done : STD_LOGIC;

BEGIN
    uut : AES_encryption
    PORT MAP(
        plain_text => plain_text,
        key => key,
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
        WAIT FOR 800 ns;
    END PROCESS;

    stimulus : PROCESS
    BEGIN
        plain_text <= x"6BC1BEE22E409F96E93D7E117393172A";
        key <= x"2B7E151628AED2A6ABF7158809CF4F3C";
        WAIT FOR 400 ns;
        ASSERT (cipher_text_output = x"85539F4136AD7E3A35407A244C60C16D")
        REPORT "1: INCORRECT OUTPUT\n" SEVERITY note;
        WAIT FOR 5 ns;
    END PROCESS;

END tb_arch;