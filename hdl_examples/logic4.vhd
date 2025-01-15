library ieee;
use ieee.std_logic_1164.all;

entity logic4 is
    port(
        i_A     : in std_logic;
        i_B     : in std_logic;
        i_C     : in std_logic;
        i_D     : in std_logic;
        o_Y     : out std_logic
    );
end entity;

architecture behavioral of logic4 is
begin
    o_Y <= (i_A and i_B) xor (i_C and i_D);
end architecture;