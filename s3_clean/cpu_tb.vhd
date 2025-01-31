LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY std;
USE std.textio.ALL;
USE std.env.finish;

ENTITY cpu_tb IS
END cpu_tb;
 
ARCHITECTURE behavior OF cpu_tb IS

    -- constants
    constant C_CLK_PERIOD : time := 10 ns;

    --signals
    signal clk          : std_logic;
    signal rst          : std_logic;
    signal mem_wr       : std_logic;
    signal mem_rd       : std_logic;
    signal mem_addr     : std_logic_vector(15 downto 0);
    signal mem_data_out : std_logic_vector(15 downto 0);
    signal mem_data_in  : std_logic_vector(15 downto 0);
    signal busy         : std_logic;
    signal reg          : std_logic;
    signal go           : std_logic;
    signal opcode       : std_logic_vector(3 downto 0);
    signal data_in      : std_logic_vector(15 downto 0);
    
BEGIN
        
    uut: ENTITY work.cpu(Behavioral)	
    PORT MAP(
        i_clk           => clk,
        i_rst           => rst,
        o_mem_wr        => mem_wr,        
        o_mem_rd        => mem_rd,        
        o_mem_addr      => mem_addr,      
        o_mem_data      => mem_data_out,      
        i_mem_data      => mem_data_in,
        i_go            => go,            
        i_opcode        => opcode,        
        i_in            => data_in,            
        o_busy          => busy
    );

    umem: ENTITY work.mem_for_sim(Behavioral)	
    PORT MAP(
        i_clk           => clk,
        i_wr            => mem_wr,        
        i_rd            => mem_rd,        
        i_addr          => mem_addr,      
        i_data          => mem_data_out,      
        o_data          => mem_data_in
    );
    
    -- Clock process definitions
    P_CLK_PROCESS :process
    begin
        clk <= '0';
        wait for C_CLK_PERIOD/2;
        clk <= '1';
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
        
        rst     <= '1';
        opcode  <= "0000";
        data_in <= x"0000";
        wait for 100 ns;
        rst     <= '1';
        
        --TB seqience
        
        report "Simulation ended";
        std.env.finish;
    end process;
    
END;
