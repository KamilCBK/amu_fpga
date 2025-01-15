--------------------------------------------------------------------------------
-- #file                    : crc16_sc.vhd
-- #entity                  : crc16_sc
-- #author                  : Kamil Ber
-- #company                 :
-- #current version         : 1.0
-- #revision                : Version 1.0, Kamil Ber : (2024/11/16) initial
---------------------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity crc16_sc is
    generic (
        GC_CORR_VER  : natural := 1  -- not implemented
    );
    port (
        i_clk       : in std_logic;         -- main clock
        i_rst       : in std_logic;         -- main, synchronouse reset
        i_clr       : in std_logic;         -- reset syndrome, should be asserted for at least on cycle prior to new encoding session
        i_go        : in std_logic;         -- go pulse for new data byte
        i_data      : in std_logic_vector(7 downto 0);  -- data byte to be encoded
        o_crc       : out std_logic_vector(15 downto 0) -- encoded cyndrome
    );

end entity;

architecture arch of crc16_sc is

    signal shift_reg    : std_logic_vector(15 downto 0);

begin

-------------------------------------------------------------------------------
------------ encoder
-------------------------------------------------------------------------------
    P_SEC: process(i_clk)
        variable v_shift_reg    : std_logic_vector(15 downto 0);
        variable v_shift_reg_r  : std_logic_vector(15 downto 0);
    begin
        if rising_edge(i_clk) then
            if i_rst = '1' then
                shift_reg   <= (others => '1');
            else
                if i_clr = '1' then
                    shift_reg   <= (others => '1');
                elsif i_go = '1' then
                    v_shift_reg := shift_reg;
                    for j in 0 to 7 loop
                        v_shift_reg_r   := v_shift_reg;
                        -- shift register with OR gate at poly coeffs
                        for i in 0 to 15 loop
                            if i = 0 then
                                v_shift_reg(0)  := i_data(7-j) xor v_shift_reg_r(15);
                            elsif i = 5 then
                                v_shift_reg(5)  := i_data(7-j) xor v_shift_reg_r(15) xor v_shift_reg_r(4);
                            elsif i = 12 then
                                v_shift_reg(12) := i_data(7-j) xor v_shift_reg_r(15) xor v_shift_reg_r(11);
                            else
                                v_shift_reg(i)  := v_shift_reg_r(i-1);
                            end if;
                        end loop;
                    end loop;
                    shift_reg   <= v_shift_reg;
                end if;
            end if;
        end if;
    end process;
 
    o_crc  <= shift_reg;
 
end architecture;
