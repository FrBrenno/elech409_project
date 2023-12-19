----------------------------------------------------------------------------------
-- Update : 15-12-2023
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library work;
use work.matrix_pkg.all;

entity ShiftRows is
Port ( 
    input_matrix : in Matrix(0 to 3, 0 to 3);
    output_matrix : out Matrix(0 to 3, 0 to 3)
);end ShiftRows;

architecture Behavioral of ShiftRows is

begin   
    -- Shifting process
    shifting : process(input_matrix)
        variable output_data : Matrix(0 to 3, 0 to 3) := (
            (x"00", x"00", x"00", x"00"),
            (x"00", x"00", x"00", x"00"),
            (x"00", x"00", x"00", x"00"),
            (x"00", x"00", x"00", x"00")
          );
    begin
        for row in 0 to 3 loop
            for col in 0 to 3 loop
                if row = 0 then
                    output_data(row,col) := input_Matrix(row,col);
                elsif row = 1 then
                    if col = 0 then
                        output_data(row,3) := input_Matrix(row,col);
                    else
                        output_data(row,col-1) := input_Matrix(row,col);
                    end if;
                elsif row = 2 then
                    if col = 0 then
                        output_data(row,2) := input_Matrix(row,col);
                    elsif col = 1 then
                        output_data(row,3) := input_Matrix(row,col);
                    else
                        output_data(row,col-2) := input_Matrix(row,col);
                    end if;
                elsif row = 3 then
                    if col = 3 then
                        output_data(row,0) := input_Matrix(row,col);
                    else
                        output_data(row,col+1) := input_Matrix(row,col);
                    end if;                      
                end if;
            end loop;        
        end loop;
        output_matrix <= output_data;
    end process shifting;       
    
end architecture Behavioral;