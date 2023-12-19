
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SubBytes2_tb is
end entity SubBytes2_tb;

architecture arch_SubBytes2_tb of SubBytes2_tb is
    component SubBytes2 is port(
        input_data: in std_logic_vector(127 downto 0);
        output_data: out std_logic_vector(127 downto 0)
    ); end component;

    signal plain_text : std_logic_vector(127 downto 0); 
    signal cipher_text : std_logic_vector(127 downto 0);

    
begin
    SubBytes_instance: SubBytes2 port map(
        input_data => plain_text,
        output_data => cipher_text
    );

    simulation_rounds: process
    begin
        plain_text <= x"090862BF6F28E3042C747FEEDA4A6A47";
        WAIT FOR 5 ns;
        ASSERT (cipher_text /= x"09287F476F746ABF2C4A6204DA08E3EE")
        REPORT "1: Output is OK" SEVERITY note;
        ASSERT (cipher_text = x"09287F476F746ABF2C4A6204DA08E3EE")
        REPORT "1: Output is not correct" SEVERITY warning;
        WAIT FOR 5 ns;

        plain_text <= x"894D9B03C0B512212E56883C6038534A";
        WAIT FOR 5 ns;
        ASSERT (cipher_text /= x"89B5884AC05653032E389B21604D123C")
        REPORT "2: Output is OK" SEVERITY note;
        ASSERT (cipher_text = x"89B5884AC05653032E389B21604D123C")
        REPORT "2: Output is not correct" SEVERITY warning;
        WAIT FOR 5 ns;

        plain_text <= x"540D10B9B3FE64AF68B0611ED6D3EA41";
        WAIT FOR 5 ns;
        ASSERT (cipher_text /= x"54FE6141B3B0EAB968D310AFD60D641E")
        REPORT "3: Output is OK" SEVERITY note;
        ASSERT (cipher_text = x"54FE6141B3B0EAB968D310AFD60D641E")
        REPORT "3: Output is not correct" SEVERITY warning;
        WAIT FOR 5 ns;

        plain_text <= x"913ECEDE3A2C982EC0F976DAA9F25676";
        WAIT FOR 5 ns;
        ASSERT (cipher_text /= x"912C76763AF956DEC0F2CE2EA93E98DA")
        REPORT "4: Output is OK" SEVERITY note;
        ASSERT (cipher_text = x"912C76763AF956DEC0F2CE2EA93E98DA")
        REPORT "4: Output is not correct" SEVERITY warning;
        WAIT FOR 5 ns;

        plain_text <= x"3AEF9FCF1B06E312BAA598634FA9431E";
        WAIT FOR 5 ns;
        ASSERT (cipher_text /= x"3A06981E1BA543CFBAA99F124FEFE363")
        REPORT "5: Output is OK" SEVERITY note;
        ASSERT (cipher_text = x"3A06981E1BA543CFBAA99F124FEFE363")
        REPORT "5: Output is not correct" SEVERITY warning;
        WAIT FOR 5 ns;
    end process;
end architecture arch_SubBytes2_tb;
