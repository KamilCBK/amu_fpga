--------------------------------------------------------------------------------
-- #file                    : crc16.vhd
-- #entity                  : crc16
-- #author                  : Kamil Ber
-- #company                 : 
-- #current version         : 0
-- #revision                : Version 0, Kamil Ber : (2024/11/18) initial
---------------------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity crc16 is 
    generic (
        GC_CORR_VER  : natural := 1  -- not implemented
    );
    port (
        i_clk       : in std_logic;         -- main clock
        i_rst       : in std_logic;         -- main, synchronouse reset
        i_clr       : in std_logic;         -- reset syndrome, should be asserted for at least on cycle prior to new encoding session
        i_go        : in std_logic;         -- go pulse for new data byte
        i_data      : in std_logic_vector(7 downto 0);  -- data byte to be encoded
        o_busy      : out std_logic;                    -- busy flag, active high
        o_crc       : out std_logic_vector(15 downto 0) -- encoded cyndrome
    );

end entity;

architecture arch of crc16 is

    -- function encode(data : std_logic_vector; syndrome : std_logic_vector ) 
    -- return std_logic_vector is
    --     variable result : std_logic;
    -- begin
    --     result := '0';
    --     if (data'left > data'right) then  -- downto
    --         for I in data'left downto data'right loop
    --             result := result xor data(I);
    --         end loop;
    --     else
    --         for I in data'left to data'right loop
    --             result := result xor data(I);
    --         end loop;
    --     end if;
    --     return result;
    -- end function;

    -- function correct(data, syndrome : std_logic_vector; sec : std_logic) return std_logic_vector is 
    --     variable data_cor : std_logic_vector(data'left to data'right);
    -- begin
    --     data_cor    := data;
    --     data_cor(to_integer(unsigned(syndrome))) := sec xor data_cor(to_integer(unsigned(syndrome))); 
    --     return data_cor;
    -- end function;


    -- constant C_K_BITS   : integer := DATA_BITS(GC_BITS);
    -- constant C_M_BITS   : integer := EDAC_BITS(GC_BITS);

    signal shift_reg    : std_logic_vector(15 downto 0);
    signal bit_cnt      : unsigned(2 downto 0);
    signal busy         : std_logic;

begin

-------------------------------------------------------------------------------
------------ encoder
-------------------------------------------------------------------------------
    P_SEC: process(i_clk)
    begin
        if rising_edge(i_clk) then
            if i_rst = '1' then
                shift_reg   <= (others => '1');
                bit_cnt     <= (others => '1');
                busy        <= '0';
            else
                if i_clr = '1' then
                    shift_reg   <= (others => '1');
                    bit_cnt     <= (others => '1');
                    busy        <= '0';
                elsif i_go = '1' or busy = '1' then
                    bit_cnt     <= bit_cnt - 1;

                    -- shift register with OR gate at poly coeffs
                    for i in 0 to 15 loop
                        if i = 0 then
                            shift_reg(0)    <= i_data(to_integer(bit_cnt)) xor shift_reg(15);
                        elsif i = 5 then
                            shift_reg(5)    <= i_data(to_integer(bit_cnt)) xor shift_reg(15) xor shift_reg(4);
                        elsif i = 12 then
                            shift_reg(12)   <= i_data(to_integer(bit_cnt)) xor shift_reg(15) xor shift_reg(11);
                        else
                            shift_reg(i)    <= shift_reg(i-1);
                        end if;
                    end loop;

                    if bit_cnt = 0 then
                        busy        <= '0';
                    else
                        busy        <= '1';
                    end if;
                end if;
            end if;
        end if;
    end process;
 
    o_busy  <= busy;
    o_crc  <= shift_reg;
 
end architecture;
