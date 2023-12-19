
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SubBytes3_tb is
end entity SubBytes3_tb;

architecture arch_SubBytes3_tb of SubBytes3_tb is
    component SubBytes3 is port(
        input_data: in std_logic_vector(127 downto 0);
        output_data: out std_logic_vector(127 downto 0)
    ); end component;

    signal plain_text : std_logic_vector(127 downto 0); 
    signal cipher_text : std_logic_vector(127 downto 0);

    
begin
    SubBytes_instance: SubBytes3 port map(
        input_data => plain_text,
        output_data => cipher_text
    );

    simulation_rounds: process
    begin

        plain_text <= x"40BFABF406EE4D3042CA6B997A5C5816";
        WAIT FOR 5 ns;
        ASSERT (cipher_text /= x"090862BF6F28E3042C747FEEDA4A6A47") 
        REPORT "1: Output is OK" SEVERITY warning;
        WAIT FOR 5 ns;

        plain_text <= x"F265E8D51FD2397BC3B9976D9076505C";
        WAIT FOR 5 ns;
        ASSERT (cipher_text /= x"894D9B03C0B512212E56883C6038534A") 
        REPORT "2: Output is OK" SEVERITY warning;
        WAIT FOR 5 ns;

        plain_text <= x"FDF37CDB4B0C8C1BF7FCD8E94AA9BBF8";
        WAIT FOR 5 ns;
        ASSERT (cipher_text /= x"540D10B9B3FE64AF68B0611ED6D3EA41") 
        REPORT "3: Output is OK" SEVERITY warning;
        WAIT FOR 5 ns;

        plain_text <= x"ACD1EC9CA242E2C31F690F7AB704B90F";
        WAIT FOR 5 ns;
        ASSERT (cipher_text /= x"913ECEDE3A2C982EC0F976DAA9F25676") 
        REPORT "4: Output is OK" SEVERITY warning;
        WAIT FOR 5 ns;

        plain_text <= x"A2616E5F44A54D39C029E20092B764E9";
        WAIT FOR 5 ns;
        ASSERT (cipher_text /= x"3AEF9FCF1B06E312BAA598634FA9431E") 
        REPORT "5: Output is OK" SEVERITY warning;
        WAIT FOR 5 ns;
    end process;
end architecture arch_SubBytes3_tb;
