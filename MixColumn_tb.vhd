
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MixColumn_tb is
end entity MixColumn_tb;

architecture arch_MixColumn_tb of MixColumn_tb is
    component MixColumn is port(
        input_data: in std_logic_vector(127 downto 0);
        output_data: out std_logic_vector(127 downto 0)
    ); end component;

    signal plain_text : std_logic_vector(127 downto 0); 
    signal cipher_text : std_logic_vector(127 downto 0);

    
begin
    MixColumn_instance: MixColumn port map(
        input_data => plain_text,
        output_data => cipher_text
    );

    simulation_rounds: process
    begin
        plain_text <= x"09287F476F746ABF2C4A6204DA08E3EE";
        wait for 10 ns;
        plain_text <= x"89B5884AC05653032E389B21604D123C";
        wait for 10 ns;
        plain_text <= x"54FE6141B3B0EAB968D310AFD60D641E";
        wait for 10 ns;
    end process;
end architecture arch_MixColumn_tb;
