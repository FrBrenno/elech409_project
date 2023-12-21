LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

PACKAGE matrix_pkg IS
    -- Type declaration for your matrix
    TYPE Matrix IS ARRAY (NATURAL RANGE <>, NATURAL RANGE <>) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    -- Function to convert a std_logic_vector to Matrix
    FUNCTION hexaToMatrix(hexa_text : STD_LOGIC_VECTOR) RETURN Matrix;
    -- Function to convert a Matrix to std_logic_vector
    FUNCTION matrixToHexa(matrix : Matrix) RETURN STD_LOGIC_VECTOR;
    -- Function to get a column from a Matrix
    FUNCTION getColumn(matrix : Matrix; col : INTEGER) RETURN STD_LOGIC_VECTOR;
    -- Function to get an element from a std_logic_vector
    FUNCTION getElement(vector : STD_LOGIC_VECTOR; index : INTEGER) RETURN STD_LOGIC_VECTOR;
    -- Procedure to replace a column in a Matrix
    PROCEDURE replaceColumn(matrix : INOUT Matrix; col : INTEGER; vector : STD_LOGIC_VECTOR);
END PACKAGE matrix_pkg;


PACKAGE BODY matrix_pkg IS
    FUNCTION hexaToMatrix(hexa_text : STD_LOGIC_VECTOR) RETURN Matrix IS
        VARIABLE result : Matrix(0 to 3, 0 to 3) := (
            (x"00", x"00", x"00", x"00"),
            (x"00", x"00", x"00", x"00"),
            (x"00", x"00", x"00", x"00"),
            (x"00", x"00", x"00", x"00")
        );
        VARIABLE index : INTEGER := 0;
    BEGIN
        FOR col IN 0 TO 3 LOOP
            FOR row IN 0 TO 3 LOOP
                IF index < hexa_text'length THEN
                    result(row, col) := hexa_text(127 - (index * 8) DOWNTO 127 - (7 + index * 8));
                    index := index + 1;
                END IF;
            END LOOP;
        END LOOP;
        RETURN result;
    END FUNCTION;

    FUNCTION matrixToHexa(matrix : Matrix) RETURN STD_LOGIC_VECTOR IS
        VARIABLE result : STD_LOGIC_VECTOR(127 DOWNTO 0) := (OTHERS => '0');
        VARIABLE index : INTEGER := 0;
    BEGIN
        FOR col IN 0 TO 3 LOOP
            FOR row IN 0 TO 3 LOOP
                result(127 - (index * 8) DOWNTO 127 - (7 + index * 8)) := matrix(row, col);
                index := index + 1;
            END LOOP;
        END LOOP;
        RETURN result;
    END FUNCTION;

    FUNCTION getColumn(matrix : Matrix; col : INTEGER) RETURN STD_LOGIC_VECTOR IS
        VARIABLE result : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    BEGIN
        FOR i IN 0 TO 3 LOOP
            result(31 - (i * 8) DOWNTO 24 - (i * 8)) := matrix(i, col);
        END LOOP;
        RETURN result;
    END getColumn;

    FUNCTION getElement(vector : STD_LOGIC_VECTOR; index : INTEGER) RETURN STD_LOGIC_VECTOR IS
        VARIABLE result : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    BEGIN
        result := vector(31 - (index * 8) DOWNTO 24 - (index * 8));
        RETURN result;
    END getElement;

    PROCEDURE replaceColumn(matrix : INOUT Matrix; col : INTEGER; vector : STD_LOGIC_VECTOR) IS
    BEGIN
        FOR i IN 0 TO 3 LOOP
            matrix(i, col) := vector(31 - (i * 8) DOWNTO 24 - (i * 8));
        END LOOP;
    END replaceColumn;
END PACKAGE BODY;