library ieee;
use ieee.std_logic_1164.all;

entity mux is
    port(
        i_A     : in std_logic;
        i_B     : in std_logic;
        i_C     : in std_logic;
        i_D     : in std_logic;
        i_Addr  : in std_logic_vector(1 downto 0);
        o_Y     : out std_logic
    );
end entity;

architecture behavioral of mux is
begin
    o_Y <=  i_A when i_Addr = "00" else
            i_B when i_Addr = "01" else
            i_C when i_Addr = "10" else 
            i_D;
end architecture;