library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity AddRoundKey_tb is
end entity;

architecture ben2 of AddRoundKey_tb is
component AddRoundKey is port(
        plainText : in std_logic_vector(127 downto 0);
        key : in std_logic_vector(127 downto 0);
        sum : out std_logic_vector(127 downto 0)      
    );end component;

    -- These are the internal wires
    signal plainText,key : std_logic_vector(127 downto 0);
    signal sum : std_logic_vector(127 downto 0);
    
    begin
        uut : AddRoundKey port map (plainText => plainText, key => key,sum=>sum);
        
        stim : process
        begin
            -- Initial Round
            plainText <= x"6BC1BEE22E409F96E93D7E117393172A";
            key <= x"2B7E151628AED2A6ABF7158809CF4F3C";
            wait for 10 ns;
            -- Second Round
            plainText <= x"529F16C2978615CAE01AAE54BA1A2659";
            key <= x"a0fafe1788542cb123a339392a6c7605";
            wait for 10 ns;
            -- Third Round
            plainText <= x"0F31E929319A3558AEC9589339F04D87";
            key <= x"f2c295f27a96b9435935807a7359f67f";
            wait for 10 ns;
            -- Fourth Round
            plainText <= x"9151ABE1E5541CFD014A713EDA7E3134";
            key <= x"3d80477d4716fe3e1e237e446d7a883b";
            wait for 10 ns;
            -- Fifth Round
            plainText <= x"4D25CB1EECF716467658C73B49BCC9E9";
            key <= x"ef44a541a8525b7fb671253bdb0bad00";
            wait for 10 ns;
            -- Sixth Round
            plainText <= x"F89B35EC4E40724E025B00C734D7D81B";
            key <= x"d4d1c6f87c839d87caf2b8bc11f915bc";
            wait for 10 ns;
            -- Seventh Round
            plainText <= x"A0C563696FB884E44840BFBEE1D32F0A";
            key <= x"6d88a37a110b3efddbf98641ca0093fd";
            wait for 10 ns;
            -- Eighth Round
            plainText <= x"AC394C731F8DE8C76711B210253DDB33";
            key <= x"4e54f70e5f5fc9f384a64fb24ea6dc4f";
            wait for 10 ns;
            -- Ninth Round
            plainText <= x"AB05B572C8EB2B92EC04E2FD7D21EC34";
            key <= x"ead27321b58dbad2312bf5607f8d292f";
            wait for 10 ns;
            -- TenthRound
            plainText <= x"1741A11891C991688C36386F23AD82AA";
            key <= x"ac7766f319fadc2128d12941575c006e";
            wait for 10 ns;
            -- Eleventh Round
            plainText <= x"EAC3821CC49413E949A1C63B9205E331";
            key <= x"d014f9a8c9ee2589e13f0cc8b6630ca6";
            wait for 10 ns;
        end process;
        
end ben2;