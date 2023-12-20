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
    input_data : in Matrix(0 to 3, 0 to 3);
    output_data : out Matrix(0 to 3, 0 to 3)
);end ShiftRows;

architecture Behavioral of ShiftRows is

begin   
    -- Shifting process
    shifting : process(input_data)
        variable output_matrix : Matrix(0 to 3, 0 to 3) := (
            (x"00", x"00", x"00", x"00"),
            (x"00", x"00", x"00", x"00"),
            (x"00", x"00", x"00", x"00"),
            (x"00", x"00", x"00", x"00")
          );
    begin
        for row in 0 to 3 loop
            for col in 0 to 3 loop
                if row = 0 then
                    output_matrix(row,col) := input_data(row,col);
                elsif row = 1 then
                    if col = 0 then
                        output_matrix(row,3) := input_data(row,col);
                    else
                        output_matrix(row,col-1) := input_data(row,col);
                    end if;
                elsif row = 2 then
                    if col = 0 then
                        output_matrix(row,2) := input_data(row,col);
                    elsif col = 1 then
                        output_matrix(row,3) := input_data(row,col);
                    else
                        output_matrix(row,col-2) := input_data(row,col);
                    end if;
                elsif row = 3 then
                    if col = 3 then
                        output_matrix(row,0) := input_data(row,col);
                    else
                        output_matrix(row,col+1) := input_data(row,col);
                    end if;                      
                end if;
            end loop;        
        end loop;
        output_data <= output_matrix;
    end process shifting;       
    
end architecture Behavioral;