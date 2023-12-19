----------------------------------------------------------------------------------
-- Update : 15-12-2023
----------------------------------------------------------------------------------
library IEEE, work;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.matrix_pkg.all;

entity ShiftRows is
Port ( 
    input_vector : in std_logic_vector (127 downto 0);
    output_vector : out std_logic_vector (127 downto 0)
);end ShiftRows;

architecture Behavioral of ShiftRows is

    --- Creation of the matrix ---    
    signal input_Matrix : Matrix(0 to 3, 0 to 3);
    signal output_Matrix : Matrix(0 to 3, 0 to 3) := (
                                (x"00", x"00", x"00", x"00"),
                                (x"00", x"00", x"00", x"00"),
                                (x"00", x"00", x"00", x"00"),
                                (x"00", x"00", x"00", x"00")
                              );
begin   
    -- Conversion of the input vector into a matrix
    input_Matrix <= hexaToMatrix(input_vector);

    -- Shifting process
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
                        output_Matrix(row,2) <= input_Matrix(row,col);
                    elsif col = 1 then
                        output_Matrix(row,3) <= input_Matrix(row,col);
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
        output_vector <= matrixToHexa(output_Matrix);
    end process shifting;       
    
end architecture Behavioral;