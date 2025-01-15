LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY std;
USE std.textio.ALL;
USE std.env.finish;

ENTITY cnt_tb IS
END cnt_tb;
 
ARCHITECTURE behavior OF cnt_tb IS

    -- counter size
    CONSTANT C_DATA_WIDTH   : integer := 16;
    -- Clock period definitions
    constant C_CLK_PERIOD : time := 10 ns;

    --signals
    signal i_clk       : std_logic;
    signal i_clr       : std_logic;
    signal i_load      : std_logic;
    signal iv_cnt      : std_logic_vector (C_DATA_WIDTH-1 DOWNTO 0);
    signal ov_cnt      : std_logic_vector (C_DATA_WIDTH-1 DOWNTO 0);

    ------------------------------------ PSL ASSERTIONS -----------------------------------------------
    -- @ 100 MHz (10 ns)
    -- PSL default clock is rising_edge(i_clk);
    -- psl A_clr    : assert always ({i_clr} |=> {ov_cnt = 0});
    -- psl A_load   : assert always ({i_load} |=> {ov_cnt = iv_cnt}) abort (i_clr);
    -- psl A_neg    : assert never (ov_cnt = 1);
   
BEGIN
        
    uut: ENTITY work.cnt(Behavioral)	
    GENERIC MAP(
        G_DATA_WIDTH        => C_DATA_WIDTH
    )
    PORT MAP(
        i_clk               => i_clk,
        i_clr               => i_clr,
        i_load              => i_load,
        iv_cnt              => iv_cnt,
        ov_cnt              => ov_cnt
    );
    
    
    -- Clock process definitions
    P_CLK_PROCESS :process
    begin
        i_clk <= '0';
        wait for C_CLK_PERIOD/2;
        i_clk <= '1';
        wait for C_CLK_PERIOD/2;
    end process;
     
    -- Stimulus process
    P_STIMULIL: process
	
	procedure TestProc(
        constant testVal 	: in    integer;
        constant testVal2  	: in    boolean;
        variable testVal3  	: out   boolean) is
    begin
		report "AAAAA";
    end procedure;
	
    begin	
        FOR I IN 1 TO 72 LOOP
            i_clr <= '1';
            i_load <= '0';
            iv_cnt  <= std_logic_vector(to_unsigned(0, C_DATA_WIDTH));
            wait for 100 ns;
            i_clr <= '0';
            wait for 1000 ns;
            wait until rising_edge(i_clk);
            iv_cnt  <= std_logic_vector(to_unsigned(1234, C_DATA_WIDTH));
            i_load  <= '1';
            wait until rising_edge(i_clk);
            i_load  <= '0';
            wait for 100 ns;
        END LOOP;
        report "Simulation ended";
        std.env.finish;
    end process;
    
END;
