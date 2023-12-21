----------------------------------------------------------------------------------
-- Update : 15-12-2023
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library work;
use work.matrix_pkg.all;


entity AddRoundKey is
Port (
    plain_text_matrix, key_matrix : in Matrix(0 to 3, 0 to 3);
    sum_matrix : out Matrix(0 to 3, 0 to 3)
);end AddRoundKey;

architecture Behavioral of AddRoundKey is

    -- Signals declaration
    signal add1 : std_logic_vector (7 downto 0);
    signal add2 : std_logic_vector (7 downto 0);

    
begin    
    Xored : process(plain_text_matrix, key_matrix)
        variable output_matrix : Matrix(0 to 3, 0 to 3) := (
            (x"00", x"00", x"00", x"00"),
            (x"00", x"00", x"00", x"00"),
            (x"00", x"00", x"00", x"00"),
            (x"00", x"00", x"00", x"00")
        );
    begin                
        for col in 0 to 3 loop
            for row in 0 to 3 loop
                add1 <= plain_text_matrix(row,col);
                add2 <= key_matrix(row,col); 
                -- Take 1 element in each matrix to xor them
                output_matrix(row,col) := plain_text_matrix(row,col) xor key_matrix(row,col);                                    
            end loop;
        end loop;
        sum_matrix <= output_matrix;
    end process;
    
    
end architecture Behavioral;