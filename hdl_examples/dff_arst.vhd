library ieee;
use ieee.std_logic_1164.all;

entity dff_arst is
    port(
        i_clk   : in std_logic;
        i_arst  : in std_logic;
        i_X     : in std_logic;
        o_Y     : out std_logic
    );
end entity;

architecture behavioral of dff_arst is
begin
    proc_seq: process(i_clk)
    begin
        if i_arst = '1' then 
            o_Y <= '0';
        elsif rising_edge(i_clk) then
            o_Y <= i_X;
        end if;
    end process;
end architecture;