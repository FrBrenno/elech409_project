library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity ShiftRowns_tb is
end entity;

architecture ben2 of ShiftRowns_tb is
component ShiftRowns is port(
    inputMatrix : in std_logic_vector (127 downto 0);
    input_vector : out std_logic_vector (7 downto 0);
    output_vector : out std_logic_vector (7 downto 0);
    outputMatrix : out std_logic_vector(127 downto 0)    
    );end component;

    -- These are the internal wires
    signal inputMatrix,outputMatrix : std_logic_vector(127 downto 0);
    signal output_vector,input_vector : std_logic_vector(7 downto 0) := (others => '0');
    
    begin
        uut : ShiftRowns port map (inputMatrix => inputMatrix,input_vector=>input_vector,output_vector=>output_vector ,outputMatrix => outputMatrix);
        
        stim : process
        begin
            inputMatrix <= x"6BC1BEE22E409F96E93D7E117393172A";
            wait for 3ns;
        end process;
end ben2;