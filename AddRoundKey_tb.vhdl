library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity AddRoundKey_tb is
end entity;

architecture ben2 of AddRoundKey_tb is
component AddRoundKey is port(
        clk : in std_logic;
        hexa_text : in std_logic_vector(127 downto 0);
        key : in std_logic_vector(127 downto 0);
        sum : out std_logic_vector(127 downto 0)      
    );end component;

    -- These are the internal wires
    signal clk : std_logic := '0';
    signal hexa_text,key : std_logic_vector(127 downto 0);
    signal sum : std_logic_vector(127 downto 0);
    
    begin
        uut : AddRoundKey port map (clk => clk, hexa_text => hexa_text, key => key,sum=>sum);
        
        stim : process
        begin
            hexa_text <= x"6BC1BEE22E409F96E93D7E117393172A";
            key <= x"2B7E151628AED2A6ABF7158809CF4F3C";
            wait for 3ns;
        end process;
        
        clock : process
        begin
             clk <= not clk;
             wait for 1 ns;         
        end process;
end ben2;