library ieee;
use ieee.std_logic_1164.all;
USE IEEE.NUMERIC_STD.ALL;

entity and_gate is
    port(
        i_A     : in std_logic_vector(3 downto 0);
        i_B     : in std_logic_vector(3 downto 0);
        o_Y     : out std_logic_vector(3 downto 0);
        o_Z     : out std_logic_vector(3 downto 0)
    );
end entity;

architecture behavioral of and_gate is
begin
    o_Y <= std_logic_vector(unsigned(i_A) + unsigned(i_B));
    o_Z <= i_A xor i_B;
end architecture;