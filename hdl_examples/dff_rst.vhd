library ieee;
use ieee.std_logic_1164.all;

entity dff_rst is
    port(
        i_clk   : in std_logic;
        i_rst   : in std_logic;
        i_X     : in std_logic;
        o_Y     : out std_logic
    );
end entity;

architecture behavioral of dff_rst is
begin
    proc_seq: process(i_clk)
    begin
        if rising_edge(i_clk) then
            if i_rst = '1' then 
                o_Y <= '0';
            else 
                o_Y <= i_X;
            end if;
        end if;
    end process;
end architecture;