library ieee;
use ieee.std_logic_1164.all;

entity and_gate is
    port(
        i_A     : in std_logic;
        i_B     : in std_logic;
        o_Y     : out std_logic
    );
end entity;

architecture behavioral of and_gate is
begin
    o_Y <= i_A and i_B;
end architecture;