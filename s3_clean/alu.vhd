library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std.all;

entity alu is
    generic (
        GC_DBITS        : natural := 16     -- data bits
    );
    port(
        i_oper          : in std_logic_vector(1 downto 0);
        i_a             : in std_logic_vector(GC_DBITS-1 downto 0);
        i_b             : in std_logic_vector(GC_DBITS-1 downto 0);
        o_y             : out std_logic_vector(GC_DBITS-1 downto 0)
    );
end entity;

architecture behavioral of alu is

    function add (
        a       : signed;
        b       : signed
    ) return signed is
        variable result : signed(a'range);
        variable cbit   : std_logic := '0';
    begin
        cbit := '0';
        for i in a'right to a'left loop
            result(i) := cbit xor a(i) xor b(i);
            cbit := (cbit and a(i)) or (cbit and b(i)) or (a(i) and b(i));
        end loop;
        -- if (a(a'left) = '0' and b(a'left) = '0' and result(a'left) = '1') or 
        -- (a(a'left) = '1' and b(a'left) = '1' and result(a'left) = '0') then 
        --     ov  := '1';
        -- else 
        --     ov  := '0';
        -- end if;
        return result;
    end function;

----------------------------------------------------------------    
begin
 
    proc_alu: process(i_oper, i_a, i_b)
        variable v_tmp : signed(i_a'range);
    begin    
        if i_oper = "00" then                           -- add
            o_y     <= std_logic_vector(add(signed(i_a), signed(i_b)));   
        elsif i_oper = "01" then                        -- sub
            v_tmp   := add(to_signed(1, i_a'length), signed(not i_b)); 
            o_y     <= std_logic_vector(add(signed(i_a), v_tmp));
        elsif i_oper = "10" then                        -- mul
            o_y     <= std_logic_vector(resize(signed(i_a) * signed(i_b), i_a'length)); 
        else                                            -- div
            o_y     <= std_logic_vector(signed(i_a) / signed(i_b)); 
        end if;
    end process;    
   
end architecture behavioral;