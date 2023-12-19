----------------------------------------------------------------------------------
-- Update : 15-12-2023
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity AddRoundKey is
Port (
    clk : in std_logic;
    plainText, key : in std_logic_vector(127 downto 0);
    sum : out std_logic_vector(127 downto 0)
);end AddRoundKey;

architecture Behavioral of AddRoundKey is

    --- Creation of the matrix ---
    
    type Matrix is array (0 to 3, 0 to 3) of std_logic_vector(7 downto 0);
    signal plain_text_matrix, key_matrix : Matrix;
    
    signal sum_matrix : Matrix := (
                                (x"00", x"00", x"00", x"00"),
                                (x"00", x"00", x"00", x"00"),
                                (x"00", x"00", x"00", x"00"),
                                (x"00", x"00", x"00", x"00")
                              );
    
    --- Creation of the signals ---
    signal add1 : std_logic_vector (7 downto 0);
    signal add2 : std_logic_vector (7 downto 0);
    
    
    function hexaToMatrix(hexa_text : std_logic_vector(127 downto 0)) return Matrix is
        variable result : Matrix := (
                                (x"00", x"00", x"00", x"00"),
                                (x"00", x"00", x"00", x"00"),
                                (x"00", x"00", x"00", x"00"),
                                (x"00", x"00", x"00", x"00")
                              );
        variable index : integer := 0;    
        begin
            for col in 0 to 3 loop
                for row in 0 to 3 loop   
                    if index < hexa_text'length then
                        result(row,col) := std_logic_vector(unsigned(hexa_text(127-(index*8) downto 127-(7+index*8))));
                        index := index + 1;
                    end if;
                end loop;
            end loop;
        return result;    
    end hexaToMatrix;
    
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
    end process;
    
    output_vector_verification : process(sum_matrix,clk)
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