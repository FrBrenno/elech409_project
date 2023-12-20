LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY work;
USE work.matrix_pkg.ALL;

ENTITY AES_encryption IS
    PORT (
        plain_text, key : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
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
    SIGNAL currentRound : INTEGER RANGE 0 TO 10 := 0;

    signal addroundkey_out : Matrix(0 TO 3, 0 TO 3);
    signal subbytes_out : Matrix(0 TO 3, 0 TO 3);
    signal shiftrows_out : Matrix(0 TO 3, 0 TO 3);
    signal mixcolumns_out : Matrix(0 TO 3, 0 TO 3);

    SIGNAL input_matrix : Matrix(0 TO 3, 0 TO 3);
    SIGNAL key_matrix : Matrix(0 TO 3, 0 TO 3);
    SIGNAL output_matrix : Matrix(0 TO 3, 0 TO 3);

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
    -- IDEA: create module AES_ROUND and AES_ENCRYPTION contains 10 AES_ROUND interconnected
    key_matrix <= hexaToMatrix(key);
    -- Each step should take 1 clock cycle
    -- Instantiate components
    addroundkey_proc : addRoundKey PORT MAP(
        plain_text_matrix => input_matrix,
        key_matrix => key_matrix,
        sum_matrix => addroundkey_out
    );
    subbytes_proc : subBytes PORT MAP(
        input_data => addroundkey_out,
        output_data => subbytes_out
    );
    shiftrows_proc : shiftRows PORT MAP(
        input_data => subbytes_out,
        output_data => shiftrows_out
    );
    mixcolumns_proc : mixColumn PORT MAP(
        input_data => shiftrows_out,
        output_data => mixcolumns_out
    );

    PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            currentRound <= 0; -- Reset the round counter
            input_matrix <= zeroMatrix;
            key_matrix <= zeroMatrix;
            output_matrix <= zeroMatrix;
        ELSIF rising_edge(clk) THEN
            -- Execute the current round
            CASE currentRound IS
                WHEN 0 =>
                    input_matrix <= hexaToMatrix(plain_text);
                    key_matrix <= hexaToMatrix(key);
                WHEN 10 =>
                    null;
                WHEN OTHERS =>
                    input_matrix <= mixcolumns_out;
            END CASE;
            currentRound <= currentRound + 1;
            -- Output the result in the final round
            IF currentRound = 10 THEN
                output_matrix <= addroundkey_out;
            END IF;
        END IF;
    END PROCESS;

    -- Assign the final result to the cipher_text
    cipher_text <= matrixToHexa(output_matrix);
    -- Assertion for completion (modify as needed)
    done <= '1' WHEN currentRound = 10 ELSE
        '0';
END arch_aes_encryption;