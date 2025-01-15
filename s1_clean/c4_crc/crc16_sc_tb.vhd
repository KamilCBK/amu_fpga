library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

library std;
    use std.textio.all;
    use std.env.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity crc16_sc_tb is
    generic (runner_cfg : string);
end entity;

architecture behavioral of crc16_sc_tb is

    constant C_CLKPERIOD    : time := 10 ns;
    
    type t_byte_array is array(natural range <>) of std_logic_vector(7 downto 0);

    signal i_clk            : std_logic := '0';
    signal i_rst            : std_logic := '0';
    signal i_clr            : std_logic := '0';
    signal i_go             : std_logic := '0';
    signal i_data           : std_logic_vector(7 downto 0);
    signal o_crc            : std_logic_vector(15 downto 0);

begin

    P_CLK: process
    begin
        i_clk   <= '0';
        Wait for C_CLKPERIOD/2;
        i_clk   <= '1';
        Wait for C_CLKPERIOD/2;
    end process;

    --i_clk <= not i_clk after C_CLKPERIOD/2;

    P_STIMULUS: process
        variable v_crc : std_logic_vector(15 downto 0);


    procedure encode_crc(
        constant bytes  : t_byte_array;
        variable crc    : out std_logic_vector(15 downto 0)
    ) is
    begin
        for i in bytes'range loop
            wait until rising_edge(i_clk);
            i_data      <= bytes(i);
            i_go        <= '1';
        end loop;
        wait until rising_edge(i_clk);
        i_go        <= '0';
        wait until rising_edge(i_clk);
        crc         := o_crc;
    end procedure;

    begin
        test_runner_setup(runner, runner_cfg);
        i_rst       <= '1';
        i_data      <= x"00";
        i_clr       <= '0';
        i_go        <= '0';
        wait until rising_edge(i_clk);
        -----------------------------------------------------------
        -- report "Starting TB CRC16 module";
        info("Starting TB CRC16 module");
        i_rst       <= '0';
        wait until rising_edge(i_clk);
        -----------------------------------------------------------
        while test_suite loop
            if run("test_ecss_1") then
                info("test_ecss_1");
                encode_crc((x"00", x"00"), v_crc);
                check(v_crc = x"1D0F", "CRC Check");
                info("CRC = 0x" & to_hstring(v_crc));
            elsif run("test_ecss_2") then
                info("test_ecss_2");
                encode_crc((x"00", x"00", x"00"), v_crc);
                check(v_crc = x"CC9C", "CRC Check");
                info("CRC = 0x" & to_hstring(v_crc));
            elsif run("test_ecss_3") then
                info("test_ecss_3");
                encode_crc((x"AB", x"CD", x"EF", x"01"), v_crc);
                check(v_crc = x"04A2", "CRC Check");
                info("CRC = 0x" & to_hstring(v_crc));
            elsif run("test_ecss_4") then
                info("test_ecss_4");
                encode_crc((x"14", x"56", x"F8", x"9A", x"00", x"01"), v_crc);
                check(v_crc = x"7FD5", "CRC Check");
                info("CRC = 0x" & to_hstring(v_crc));
            end if;
        end loop;
        wait until rising_edge(i_clk);

        test_runner_cleanup(runner);
        --report "Simulation ended normally." severity note;
        --std.env.finish;
    end process;

-----------------------------------------------------------------------------
-- Instantiate DUT
-----------------------------------------------------------------------------
    I_DUT: entity work.crc16_sc
    generic map (
        GC_CORR_VER     => 0
    )
    port map(
        i_clk           => i_clk,
        i_rst           => i_rst,
        i_clr           => i_clr,
        i_go            => i_go,
        i_data          => i_data,
        o_crc           => o_crc
    );

end architecture;

