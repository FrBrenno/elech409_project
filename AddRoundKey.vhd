----------------------------------------------------------------------------------
-- Update : 15-12-2023
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity AddRoundKey is
Port ( 
    -- plain_text : in std_logic_vector(127 downto 0);
    clk : in std_logic;
    hexa_text, key : in std_logic_vector(127 downto 0);
    sum : out std_logic_vector(127 downto 0)
);end AddRoundKey;

architecture Behavioral of AddRoundKey is

    --- Creation of the matrix ---
    type Matrix_k is array (0 to 3, 0 to 3) of std_logic_vector(7 downto 0);
    signal key_matrix : Matrix_k;
    
    type Matrix_a is array (0 to 3, 0 to 3) of std_logic_vector(7 downto 0);
    signal plain_text_matrix : Matrix_a;
    
    type Matrix_b is array (0 to 3, 0 to 3) of std_logic_vector(7 downto 0);
    signal sum_matrix : Matrix_b := (
                                (x"00", x"00", x"00", x"00"),
                                (x"00", x"00", x"00", x"00"),
                                (x"00", x"00", x"00", x"00"),
                                (x"00", x"00", x"00", x"00")
                              );
    
    --- Creation of the signals ---
    signal add1 : std_logic_vector (7 downto 0);
    signal add2 : std_logic_vector (7 downto 0);
    
    

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
                        result_k(row_k,col_k) := std_logic_vector(unsigned(key(127-(index_k*8) downto 127-(7+index_k*8))));
                        index_k := index_k + 1;
                    end if;
                end loop;
            end loop;
        return result_k;    
    end hexaToMatrix;
    
    function hexaToMatrix_a(hexa_text : std_logic_vector(127 downto 0)) return Matrix_a is
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
                    if index_a < hexa_text'length then
                        result_a(row_a,col_a) := std_logic_vector(unsigned(hexa_text(127-(index_a*8) downto 127-(7+index_a*8))));
                        index_a := index_a + 1;
                    end if;
                end loop;
            end loop;
        return result_a;    
    end hexaToMatrix_a;
    
begin
    plain_text_matrix <= hexaToMatrix_a(hexa_text);
    key_matrix <= hexaToMatrix(key);
    
    Xored : process(add1,add2, plain_text_matrix, key_matrix, sum_matrix, hexa_text)
    begin                
        for col in 0 to 3 loop
            for row in 0 to 3 loop
                add1 <= plain_text_matrix(row,col);
                add2 <= key_matrix(row,col); 
                sum_matrix(row,col) <= plain_text_matrix(row,col) xor key_matrix(row,col);                                    
            end loop;
        end loop;
    end process;
    
    output_vector_verification : process(hexa_text,sum_matrix,clk)
    begin  
        if rising_edge(clk) then
            sum(127 downto 120) <= sum_matrix(0,0);
            sum(119 downto 112) <= sum_matrix(1,0);
            sum(111 downto 104) <= sum_matrix(2,0);
            sum(103 downto 96) <= sum_matrix(3,0);
            sum(95 downto 88) <= sum_matrix(0,1);
            sum(87 downto 80) <= sum_matrix(1,1);
            sum(79 downto 72) <= sum_matrix(2,1);
            sum(71 downto 64) <= sum_matrix(3,1);
            sum(63 downto 56) <= sum_matrix(0,2);
            sum(55 downto 48) <= sum_matrix(1,2);
            sum(47 downto 40) <= sum_matrix(2,2);
            sum(39 downto 32) <= sum_matrix(3,2);
            sum(31 downto 24) <= sum_matrix(0,3);
            sum(23 downto 16) <= sum_matrix(1,3);
            sum(15 downto 8) <= sum_matrix(2,3);
            sum(7 downto 0) <= sum_matrix(3,3);
        end if;        
    end process;
    
end architecture Behavioral;