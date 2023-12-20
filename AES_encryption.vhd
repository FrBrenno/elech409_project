LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

library work;
use work.matrix_pkg.all;

ENTITY AES_encryption IS
    PORT (
        plain_text, key : IN std_logic_vector(127 DOWNTO 0);
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        cipher_text : OUT STD_LOGIC_VECTOR(127 DOWNTO 0);
        done: OUT STD_LOGIC
    );
END AES_encryption;

ARCHITECTURE arch_aes_encryption OF AES_encryption IS
    -- Component declarations
    component addRoundKey is port (
        plain_text_matrix, key_matrix : in Matrix(0 to 3, 0 to 3);
        sum_matrix : out Matrix(0 to 3, 0 to 3)
    ); end component;
    component subBytes is port (
        input_data : in Matrix(0 to 3, 0 to 3);
        output_data : out Matrix(0 to 3, 0 to 3)
    ); end component;
    component shiftRows is port (
        input_data : in Matrix(0    to 3, 0 to 3);
        output_data : out Matrix(0 to 3, 0 to 3)
    ); end component;
    component mixColumn is port (
        input_data : in Matrix(0 to 3, 0 to 3);
        output_data : out Matrix(0 to 3, 0 to 3)
    ); end component;

    -- Signal declarations
    SIGNAL currentRound : INTEGER RANGE 0 TO 10 := 0; 

    SIGNAL addroundkey_out : Matrix(0 to 3, 0 to 3);
    SIGNAL subbytes_out : Matrix(0 to 3, 0 to 3);
    SIGNAL shiftrows_out : Matrix(0 to 3, 0 to 3);
    SIGNAL mixcolumns_out : Matrix(0 to 3, 0 to 3);

    SIGNAL input_matrix : Matrix(0 to 3, 0 to 3);
    SIGNAL key_matrix : Matrix(0 to 3, 0 to 3);
    SIGNAL output_matrix : Matrix(0 to 3, 0 to 3);

    -- function declarations
    function zeroMatrix return Matrix is
        variable zero : Matrix(0 to 3, 0 to 3);
    begin
        for i in 0 to 3 loop
            for j in 0 to 3 loop
                zero(i, j) := (others => '0');
            end loop;
        end loop;
        return zero;
    end function;
    
BEGIN
    -- Each step should take 1 clock cycle
    -- Instantiate components
    addroundkey_proc : addRoundKey port map (
        plain_text_matrix => input_matrix,
        key_matrix => key_matrix,
        sum_matrix => addroundkey_out
    );
    subbytes_proc : subBytes port map (
        input_data => addroundkey_out,
        output_data => subbytes_out
    );
    shiftrows_proc : shiftRows port map (
        input_data => subbytes_out,
        output_data => shiftrows_out
    );
    mixcolumns_proc : mixColumn port map (
        input_data => shiftrows_out,
        output_data => mixcolumns_out
    );

    process (clk, rst)
    begin
        if rst = '1' then
            currentRound <= 0; -- Reset the round counter
            input_matrix <= zeroMatrix;
            key_matrix <= zeroMatrix;
            output_matrix <= zeroMatrix;
        elsif rising_edge(clk) then
            -- Execute the current round
            case currentRound is
                when 0 =>
                    input_matrix <= hexaToMatrix(plain_text);
                    key_matrix <= hexaToMatrix(key);
                when 1 =>
                    input_matrix <= addroundkey_out;
                when 2 =>
                    input_matrix <= subbytes_out;
                when 3 =>
                    input_matrix <= shiftrows_out;
                when 4 =>
                    input_matrix <= mixcolumns_out;
                when 5 =>
                    input_matrix <= addroundkey_out;
                when 6 =>
                    input_matrix <= subbytes_out;
                when 7 =>
                    input_matrix <= shiftrows_out;
                when 8 =>
                    input_matrix <= mixcolumns_out;
                when 9 =>
                    input_matrix <= addroundkey_out;
                when 10 =>
                    input_matrix <= subbytes_out;
            end case;
            currentRound <= currentRound + 1;
            -- Output the result in the final round
            if currentRound = 10 then
                output_matrix <= input_matrix;
            end if;
        end if;
    end process;

    -- Assign the final result to the cipher_text
    cipher_text <= matrixToHexa(output_matrix);
    -- Assertion for completion (modify as needed)
    done <= '1' WHEN currentRound = 10 ELSE '0';
END arch_aes_encryption;