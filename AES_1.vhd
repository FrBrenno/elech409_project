 ----------------------------------------------------------------------------------
-- Update : 07-12-2023
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity AES_1 is
Port ( 
    plain_text : in std_logic_vector(127 downto 0);
    bMatrix : out std_logic_matrix(3 downto 0, 3 downto 0)
);
end AES_1;

architecture Behavioral of AES_1 is

    --
    -- Signals
    --

-- Creation of Matrix a
    type Matrix_a is array (0 to 3, 0 to 3) of std_logic_vector(7 downto 0);
    signal plain_text_matrix : Matrix_a; 
    
-- Creation of Matrix k
    type Matrix_k is array (0 to 3, 0 to 3) of std_logic_vector(7 downto 0);
    signal key_matrix : Matrix_k;
    
-- Key to encode
    signal key : std_logic_vector(127 downto 0) := x"2b7e151628aed2a6abf7158809cf4f3c"; 
    
-- Creation of Matrix b
    type Matrix_b is array (0 to 3, 0 to 3) of std_logic_vector(7 downto 0);
    signal AddroundKey_matrix : Matrix_b := (
                                (x"00", x"00", x"00", x"00"),
                                (x"00", x"00", x"00", x"00"),
                                (x"00", x"00", x"00", x"00"),
                                (x"00", x"00", x"00", x"00")
                              );
-- Creation of 2 signals to be able to sum 2 hexadecimal value                              
    signal key_val : std_logic_vector(7 downto 0);
    signal a_val : std_logic_vector(7 downto 0);
    
    --
    -- FUNCTIONS
    --
    
-- Function to convert caracter chain into bytes to fill Matrix a

    function stringToBytes(text : string) return Matrix_a is
        variable result_a : Matrix_a := (
                                (x"00", x"00", x"00", x"00"),
                                (x"00", x"00", x"00", x"00"),
                                (x"00", x"00", x"00", x"00"),
                                (x"00", x"00", x"00", x"00")
                              );
        variable index_a : integer := 0;
        begin
            for col_a in 0 to 3 loop
                for row_a in 0 to 3 loop
                    if index_a < text'length then
                        result_a(row_a,col_a) := std_logic_vector(to_unsigned(character'pos(text(index_a+1)),8)); -- character'pos va prendre le caract�re � la position indiqu�e et ainsi la convertir en sa correspondance hexad�cimale
                        index_a := index_a + 1;
                    end if;
                end loop;
            end loop;
      return result_a;
    end stringToBytes;  
    
-- Function to put key into Matrix k   
    
    function hexaToMatrix(key : std_logic_vector(127 downto 0)) return Matrix_k is
        variable result_k : Matrix_k := (
                                (x"00", x"00", x"00", x"00"),
                                (x"00", x"00", x"00", x"00"),
                                (x"00", x"00", x"00", x"00"),
                                (x"00", x"00", x"00", x"00")
                              );
        variable index_k : integer := 0;    
        begin
            for col_k in 0 to 3 loop
                for row_k in 0 to 3 loop   
                    if index_k < key'length then
                        result_k(row_k,col_k) := std_logic_vector(unsigned(key((7+index_k*7) downto (0+index_k*7))));
                        index_k := index_k + 1;
                    end if;
                end loop;
            end loop;
        return result_k;    
    end hexaToMatrix;
    
begin

    plain_text_matrix <= stringToBytes(plain_text);
    key_matrix <= hexaToMatrix(key);
    
    bMatrix : process    
    
    variable index : integer := 0;
    begin
        for col in 0 to 3 loop
            for row in 0 to 3 loop
                key_val <= key_matrix(col,row);
                a_val <= plain_text_matrix(col,row);
                -- convert hexadecimal values in integer to  be able to sum them afterward we convert them again in a, hexadecimal value
                AddroundKey_matrix(col,row) <= std_logic_vector(to_unsigned(to_integer(unsigned(key_val)) + to_integer(unsigned(a_val)),8)); 
            end loop;
        end loop; 
    end process;

end Behavioral;
