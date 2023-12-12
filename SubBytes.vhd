library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SubBytes is
    port (
        aMatrix: in std_logic_vector(127 downto 0);
        bMatrix: out std_logic_vector(127 downto 0)
    );
end entity SubBytes;

architecture arch_SubBytes of SubBytes is

    -- Component declaration
    component S_box is
        port (
            BYTE_IN : in std_logic_vector(7 downto 0);
            BYTE_OUT : out std_logic_vector(7 downto 0)
        );
    end component;
    
    -- Type declaration
    type Matrix is array (0 to 3, 0 to 3) of std_logic_vector(7 downto 0);

    -- Signal declaration
    signal temp_byte : std_logic_vector(7 downto 0);
    signal byte_out : std_logic_vector(7 downto 0);
    
    -- Function declaration
    function hexaToMatrix(input_hex : std_logic_vector(127 downto 0)) return Matrix is
        variable result : Matrix := (
                                (x"00", x"00", x"00", x"00"),
                                (x"00", x"00", x"00", x"00"),
                                (x"00", x"00", x"00", x"00"),
                                (x"00", x"00", x"00", x"00")
                              );
        variable index : integer := 0;    
        begin
            for col_k in 0 to 3 loop
                for row_k in 0 to 3 loop   
                    if index < input_hex'length then
                        result(row_k,col_k) := std_logic_vector(unsigned(input_hex((7+index*7) downto (0+index*7))));
                        index := index + 1;
                    end if;
                end loop;
            end loop;
        return result;    
    end hexaToMatrix;

    function matrixToHexa(input_matrix : Matrix) return std_logic_vector is
        variable result : std_logic_vector(127 downto 0) := (others => '0');
        variable index : integer := 0;    
        begin
            for col_k in 0 to 3 loop
                for row_k in 0 to 3 loop   
                    result((7+index*7) downto (0+index*7)) := input_matrix(row_k,col_k);
                    index := index + 1;
                end loop;
            end loop;
        return result;    
    end matrixToHexa;
    

begin
    S_box_inst: S_box port map (
        BYTE_IN => temp_byte,
        BYTE_OUT => byte_out
    );

    subBytes_process: process
        variable row, col: integer;
        variable temp_matrix : Matrix := hexaToMatrix(aMatrix);
    begin
        for row in 0 to 3 loop
            for col in 0 to 3 loop
                temp_byte <= temp_matrix(row,col);
                wait for 5 ns;
                temp_matrix(row, col) := byte_out;
                wait for 5 ns;
            end loop;
        end loop;
        bMatrix <= matrixToHexa(temp_matrix);
    end process;
end architecture arch_SubBytes;
