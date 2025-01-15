library ieee;
use ieee.std_logic_1164.all;

entity dff is
    port(
        i_clk   : in std_logic;
        i_X     : in std_logic;
        o_Y     : out std_logic
    );
end entity;

architecture behavioral of dff is
begin
    proc_seq: process(i_clk)
    begin
        if rising_edge(i_clk) then 
        -- if i_clk'event and i_clk = '1' then 
            o_Y <= i_X;
        end if;
    end process;
end architecture;