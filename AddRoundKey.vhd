----------------------------------------------------------------------------------
-- Update : 15-12-2023
----------------------------------------------------------------------------------
library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.matrix_pkg.all;


entity AddRoundKey is
Port (
    plainText, key : in std_logic_vector(127 downto 0);
    sum : out std_logic_vector(127 downto 0)
);end AddRoundKey;

architecture Behavioral of AddRoundKey is

    --- Creation of the matrix ---
    
    signal plain_text_matrix, key_matrix : Matrix(0 to 3, 0 to 3);
    signal sum_matrix : Matrix(0 to 3, 0 to 3) := (
                                (x"00", x"00", x"00", x"00"),
                                (x"00", x"00", x"00", x"00"),
                                (x"00", x"00", x"00", x"00"),
                                (x"00", x"00", x"00", x"00")
                              );
    
    --- Creation of the signals ---
    signal add1 : std_logic_vector (7 downto 0);
    signal add2 : std_logic_vector (7 downto 0);

    
begin
    plain_text_matrix <= hexaToMatrix(plainText);
    key_matrix <= hexaToMatrix(key);
    
    Xored : process(add1,add2,plain_text_matrix,key_matrix,sum_matrix)
    begin                
        for col in 0 to 3 loop
            for row in 0 to 3 loop
                add1 <= plain_text_matrix(row,col);
                add2 <= key_matrix(row,col); 
                sum_matrix(row,col) <= plain_text_matrix(row,col) xor key_matrix(row,col);                                    
            end loop;
        end loop;
        sum <= matrixToHexa(sum_matrix);
    end process;
    
    
end architecture Behavioral;