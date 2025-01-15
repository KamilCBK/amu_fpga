LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
USE ieee.fixed_pkg.all;

LIBRARY VUNIT_LIB;
CONTEXT VUNIT_LIB.VUNIT_CONTEXT;

LIBRARY CORDIC;

ENTITY cordic_tb IS
    GENERIC (runner_cfg : string);
END ENTITY;

ARCHITECTURE tb OF cordic_tb IS
    CONSTANT C_CLK_PERIOD   : time                              := 10 ns;
    CONSTANT C_RST_CLKS     : natural                           := 2;
    CONSTANT C_ITERS        : natural                           := 16;
    SIGNAL clk              : std_logic                         := '1';
    SIGNAL rst              : std_logic                         := '0';
    SIGNAL go               : std_logic                         := '0';
    SIGNAL busy             : std_logic;
    SIGNAL sinx             : std_logic_vector(31 DOWNTO 0)     := (others => '0');
    SIGNAL cosx             : std_logic_vector(31 DOWNTO 0)     := (others => '0');
    SIGNAL alpha            : std_logic_vector(31 downto 0)     := (others => '0');

BEGIN

    DUT : entity cordic.cordic(Behavioral)
    GENERIC MAP(
        G_ITERS => C_ITERS
    )
    PORT MAP(
        i_clk   => clk,
        i_clr   => rst,
        i_go    => go,
        o_busy  => busy,
        iv_rad  => alpha,
        ov_sin  => sinx,
        ov_cos  => cosx
    );
    clk <= NOT clk AFTER C_CLK_PERIOD / 2;

    P_STIMULI : PROCESS
        variable v_pi    : real := 3.14159;
    BEGIN
        test_runner_setup(runner, runner_cfg);

        IF run("test_main") THEN
            info("------------------------------------------");
            info("TEST CASE MAIN: Check if result is correct");
            info("------------------------------------------");
            rst <= '1';
            WAIT FOR C_RST_CLKS * C_CLK_PERIOD;
            rst <= '0';


            FOR I IN 0 TO 16 LOOP
                wait until rising_edge(clk);
                alpha   <= to_slv(to_sfixed(real(I) * v_pi/16.0, 7, -24));
                go      <= '1';
                wait until rising_edge(clk);
                go      <= '0';
                
                wait until rising_edge(busy);
                wait until falling_edge(busy);
                info( "I=" & integer'image(I) & ", alpha=" & real'image(real(I) * v_pi/16.0) & ", sin=" & real'image(0.6072529350088814*to_real(to_sfixed(sinx, 7,-24))) & ", cos=" & real'image(0.6072529350088814*to_real(to_sfixed(cosx, 7,-24))) );
            END LOOP;
            info("==== TEST CASE MAIN finished ====");
        END IF;
        
        test_runner_cleanup(runner);
    END PROCESS;

END ARCHITECTURE;
