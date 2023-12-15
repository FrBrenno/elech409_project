----------------------------------------------------------------------------------
-- Update : 15-12-2023
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity ShiftRowns is
Port ( 
    inputMatrix : in std_logic_vector (127 downto 0);
    input_vector : out std_logic_vector (7 downto 0);
    output_vector : out std_logic_vector (7 downto 0);
    outputMatrix : out std_logic_vector(127 downto 0)
);end ShiftRowns;

architecture Behavioral of ShiftRowns is

    --- Creation of the matrix ---    
    type Matrix is array (0 to 3, 0 to 3) of std_logic_vector(7 downto 0);
    signal input_Matrix : Matrix;
    signal output_Matrix : Matrix := (
                                (x"00", x"00", x"00", x"00"),
                                (x"00", x"00", x"00", x"00"),
                                (x"00", x"00", x"00", x"00"),
                                (x"00", x"00", x"00", x"00")
                              );
    
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
    
    input_Matrix <= hexaToMatrix(inputMatrix);
    
    shifting : process(input_Matrix, output_Matrix)
    begin
        for row in 0 to 3 loop
            for col in 0 to 3 loop
                if row = 0 then
                    output_Matrix(row,col) <= input_Matrix(row,col);
                elsif row = 1 then
                    if col = 0 then
                        output_Matrix(row,3) <= input_Matrix(row,col);
                    else
                        output_Matrix(row,col-1) <= input_Matrix(row,col);
                    end if;
                elsif row = 2 then
                    if col = 0 then
                        output_Matrix(row,2) <= input_matrix(row,col);
                    elsif col = 1 then
                        output_Matrix(row,3) <= input_matrix(row,col);
                    else
                        output_Matrix(row,col-2) <= input_Matrix(row,col);
                    end if;
                elsif row = 3 then
                    if col = 3 then
                        output_Matrix(row,0) <= input_Matrix(row,col);
                    else
                        output_Matrix(row,col+1) <= input_Matrix(row,col);
                    end if;                      
                end if;
            end loop;        
        end loop;
        -- test of the matrices 
--        input_vector <= input_Matrix(3,3);
--        output_vector <= output_Matrix(3,0);
    end process;       
    
    output_Verif : process(output_Matrix)    
    begin        
        outputMatrix(127 downto 120) <= output_Matrix(0,0);
        outputMatrix(119 downto 112) <= output_Matrix(1,0);
        outputMatrix(111 downto 104) <= output_Matrix(2,0);
        outputMatrix(103 downto 96) <= output_Matrix(3,0);
        outputMatrix(95 downto 88) <= output_Matrix(0,1);
        outputMatrix(87 downto 80) <= output_Matrix(1,1);
        outputMatrix(79 downto 72) <= output_Matrix(2,1);
        outputMatrix(71 downto 64) <= output_Matrix(3,1);
        outputMatrix(63 downto 56) <= output_Matrix(0,2);
        outputMatrix(55 downto 48) <= output_Matrix(1,2);
        outputMatrix(47 downto 40) <= output_Matrix(2,2);
        outputMatrix(39 downto 32) <= output_Matrix(3,2);
        outputMatrix(31 downto 24) <= output_Matrix(0,3);
        outputMatrix(23 downto 16) <= output_Matrix(1,3);
        outputMatrix(15 downto 8) <= output_Matrix(2,3);
        outputMatrix(7 downto 0) <= output_Matrix(3,3);
        
    end process;       
end architecture Behavioral;