library ieee;
use ieee.std_logic_1164.all;

entity dff is
    port(
        clk   : in std_logic;
        A     : in std_logic;
        B     : in std_logic;
        Q     : out std_logic
    );
end entity;

architecture behavioral of dff is
    signal Y : std_logic;
begin
    proc_seq: process(clk)
    begin
        if rising_edge(clk) then 
            Q <= Y;    
        end if;
    end process;
    Y <= A xor B;
end architecture;