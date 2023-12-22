LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY work;
USE work.matrix_pkg.ALL;

ENTITY AES_encryption IS
    PORT (
        plain_text: IN STD_LOGIC_VECTOR(127 DOWNTO 0);
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        cipher_text : OUT STD_LOGIC_VECTOR(127 DOWNTO 0);
        done : OUT STD_LOGIC
    );
END AES_encryption;

ARCHITECTURE arch_aes_encryption OF AES_encryption IS
    -- Component declarations
    COMPONENT addRoundKey IS PORT (
        plain_text_matrix, key_matrix : IN Matrix(0 TO 3, 0 TO 3);
        sum_matrix : OUT Matrix(0 TO 3, 0 TO 3)
        );
    END COMPONENT;
    COMPONENT subBytes IS PORT (
        input_data : IN Matrix(0 TO 3, 0 TO 3);
        output_data : OUT Matrix(0 TO 3, 0 TO 3)
        );
    END COMPONENT;
    COMPONENT shiftRows IS PORT (
        input_data : IN Matrix(0 TO 3, 0 TO 3);
        output_data : OUT Matrix(0 TO 3, 0 TO 3)
        );
    END COMPONENT;
    COMPONENT mixColumn IS PORT (
        input_data : IN Matrix(0 TO 3, 0 TO 3);
        output_data : OUT Matrix(0 TO 3, 0 TO 3)
        );
    END COMPONENT;

    -- Signal declarations
    TYPE Step IS (subbytes_step, shiftrows_step, mixcolumns_step, addroundkey_step);
    SIGNAL currentStep : Step := subbytes_step;

    signal addroundkey_in : Matrix(0 TO 3, 0 TO 3);
    SIGNAL addroundkey_out : Matrix(0 TO 3, 0 TO 3);
    SIGNAL subbytes_out : Matrix(0 TO 3, 0 TO 3);
    SIGNAL shiftrows_out : Matrix(0 TO 3, 0 TO 3);
    SIGNAL mixcolumns_out : Matrix(0 TO 3, 0 TO 3);

    SIGNAL input_round : Matrix(0 TO 3, 0 TO 3);
    SIGNAL output_round : Matrix(0 TO 3, 0 TO 3);
    SIGNAL key_matrix : Matrix(0 TO 3, 0 TO 3);
    SIGNAL output_matrix : Matrix(0 TO 3, 0 TO 3);

    SIGNAL round_count : INTEGER := 0;

    type hexa_array is array (0 to 10) of std_logic_vector(127 downto 0);
    signal keys : hexa_array  := (
        (x"2B7E151628AED2A6ABF7158809CF4F3C"),
        (x"a0fafe1788542cb123a339392a6c7605"),
        (x"f2c295f27a96b9435935807a7359f67f"),
        (x"3d80477d4716fe3e1e237e446d7a883b"),
        (x"ef44a541a8525b7fb671253bdb0bad00"),
        (x"d4d1c6f87c839d87caf2b8bc11f915bc"),
        (x"6d88a37a110b3efddbf98641ca0093fd"),
        (x"4e54f70e5f5fc9f384a64fb24ea6dc4f"),
        (x"ead27321b58dbad2312bf5607f8d292f"),
        (x"ac7766f319fadc2128d12941575c006e"),
        (x"d014f9a8c9ee2589e13f0cc8b6630ca6")
    );

    -- function declarations
    FUNCTION zeroMatrix RETURN Matrix IS
        VARIABLE zero : Matrix(0 TO 3, 0 TO 3);
    BEGIN
        FOR i IN 0 TO 3 LOOP
            FOR j IN 0 TO 3 LOOP
                zero(i, j) := (OTHERS => '0');
            END LOOP;
        END LOOP;
        RETURN zero;
    END FUNCTION;

BEGIN
    -- Each step should take 1 clock cycle
    -- Instantiate components
    addroundkey_proc : addRoundKey PORT MAP(
        plain_text_matrix => addroundkey_in,
        key_matrix => key_matrix,
        sum_matrix => addroundkey_out
    );

    subbytes_round_proc : subBytes PORT MAP(
        input_data => input_round,
        output_data => subbytes_out
    );
    shiftrows_round_proc : shiftRows PORT MAP(
        input_data => subbytes_out,
        output_data => shiftrows_out
    );
    mixcolumns_round_proc : mixColumn PORT MAP(
        input_data => shiftrows_out,
        output_data => mixcolumns_out
    );
    addroundkey_round_proc : addRoundKey PORT MAP(
        plain_text_matrix => mixcolumns_out,
        key_matrix => key_matrix,
        sum_matrix => output_round
    );

    -- State machine process
    process(clk, rst)
    begin
        if rst = '1' then
            currentStep <= subbytes_step;
            round_count <= 0;
        elsif rising_edge(clk) then
            if round_count = 0 then -- first round
                done <= '0';
                addroundkey_in <= hexaToMatrix(plain_text);
                key_matrix <= hexaToMatrix(keys(round_count));
                round_count <= round_count + 1;
            elsif round_count = 11 then -- last round
                case currentStep is
                    when subbytes_step =>
                        currentStep <= shiftrows_step;
                        output_matrix <= output_round;
                    when shiftrows_step =>
                        addroundkey_in <= shiftrows_out;
                        currentStep <= addroundkey_step;
                        output_matrix <= subbytes_out;
                    when addroundkey_step =>
                        output_matrix <= addroundkey_out;
                        done <= '1';
                        round_count <= 0;
                    when others =>
                        null;
                end case;
            else -- intermediate rounds
                case currentStep is
                    when subbytes_step =>
                        if round_count = 1 then
                            input_round <= addroundkey_out;
                            output_matrix <= addroundkey_out;
                        else
                            input_round <= output_round;
                            output_matrix <= output_round;
                        end if;
                        currentStep <= shiftrows_step;
                    when shiftrows_step =>
                        currentStep <= mixcolumns_step;
                        output_matrix <= subbytes_out;
                    when mixcolumns_step =>
                        currentStep <= addroundkey_step;
                        output_matrix <= shiftrows_out;
                    when addroundkey_step =>
                        currentStep <= subbytes_step;
                        key_matrix <= hexaToMatrix(keys(round_count));
                        round_count <= round_count + 1;   
                        output_matrix <= mixcolumns_out;               
                end case;
            end if;
        end if;
    END PROCESS;

    -- Assign the final result to the cipher_text
    cipher_text <= matrixToHexa(output_matrix);

END arch_aes_encryption;