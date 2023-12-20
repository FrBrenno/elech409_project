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

    signal addroundkey_in : Matrix(0 to 3, 0 to 3);
    signal subbytes_in : Matrix(0 to 3, 0 to 3);
    signal shiftrows_in : Matrix(0 to 3, 0 to 3);
    signal mixcolumns_in : Matrix(0 to 3, 0 to 3);

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
        plain_text_matrix => addroundkey_in,
        key_matrix => key_matrix,
        sum_matrix => addroundkey_out
    );
    subbytes_proc : subBytes port map (
        input_data => subbytes_in,
        output_data => subbytes_out
    );
    shiftrows_proc : shiftRows port map (
        input_data => shiftrows_in,
        output_data => shiftrows_out
    );
    mixcolumns_proc : mixColumn port map (
        input_data => mixcolumns_in,
        output_data => mixcolumns_out
    );
    
    input_matrix <= hexaToMatrix(plain_text);
    key_matrix <= hexaToMatrix(key);
    
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
                    addroundkey_in <= input_matrix;
                when 1 =>
                    subbytes_in <= addroundkey_out;
                when 2 =>
                    shiftrows_in <= subbytes_out;
                when 3 =>
                    mixcolumns_in <= shiftrows_out;
                when 4 =>
                    addroundkey_in <= mixcolumns_out;
                when 5 =>
                    subbytes_in <= addroundkey_out;
                when 6 =>
                    shiftrows_in <= subbytes_out;
                when 7 =>
                    mixcolumns_in <= shiftrows_out;
                when 8 =>
                    addroundkey_in <= mixcolumns_out;
                when 9 =>
                    subbytes_in <= addroundkey_out;
                when 10 =>
                    shiftrows_in <= subbytes_out;
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