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
        plain_text <= x"40BFABF406EE4D3042CA6B997A5C5816";
        wait for 20 ns;
        plain_text <= x"F265E8D51FD2397BC3B9976D9076505C";
        wait for 20 ns;
        plain_text <= x"FDF37CDB4B0C8C1BF7FCD8E94AA9BBF8";
        wait for 20 ns;
        plain_text <= x"ACD1EC9CA242E2C31F690F7AB704B90F";
        wait for 20 ns;
        plain_text <= x"A2616E5F44A54D39C029E20092B764E9";
        wait for 20 ns;
        plain_text <= x"2C4AF31432C3EFC9C8A9B87B252ECDA7";
        wait for 20 ns;
        plain_text <= x"CD4DC0137EB3BA1993B939FF2BD3BCF7";
        wait for 20 ns;
        plain_text <= x"E26DBB7D40D22134E3B7FDA26B9B077C";
        wait for 20 ns;
        plain_text <= x"41D7C6537D669140DD2F179D02ACC51B";
        wait for 20 ns;       
    end process;
end architecture arch_SubBytes2_tb;
