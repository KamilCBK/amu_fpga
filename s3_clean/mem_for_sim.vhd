library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std.all;

entity mem_for_sim is
    generic (
        GC_ABITS        : natural := 16;    -- address bits
        GC_DBITS        : natural := 16     -- data bits
    );
    port(
        i_clk           : in std_logic;
        i_wr            : in std_logic;
        i_rd            : in std_logic;
        i_addr          : in std_logic_vector(GC_ABITS-1 downto 0);
        i_data          : in std_logic_vector(GC_DBITS-1 downto 0);
        o_data          : out std_logic_vector(GC_DBITS-1 downto 0)
    );
end entity;

architecture behavioral of mem_for_sim is

    type mem_type IS ARRAY (0 TO 2**(GC_ABITS-2)-1) OF std_logic_vector(GC_DBITS downto 0);
    signal memory   : mem_type := (others => (others => '0'));
----------------------------------------------------------------    
begin
 
    proc_mem: process(i_clk)
    begin    
        if i_wr = '1' then
            memory(to_integer(unsigned(i_addr))) <= i_data;
            o_data <= i_data;
        elsif i_rd = '1' then
            o_data <= memory(to_integer(unsigned(i_addr)));
        end if;
        
    end process;    
   
end architecture behavioral;