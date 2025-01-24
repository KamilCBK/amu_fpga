library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

library std;
    use std.textio.all;
    use std.env.all;

entity reg_ram_tb is 
    generic (
        SimDate                     : string := ""
    );
    
end entity;

architecture behavioral of reg_ram_tb is

    constant C_CLKPERIOD            : time := 25 ns;        --! Main clock period in ns, main clock is connected to DUT's input
    constant C_ABITS_MAX            : natural := 10;
    constant C_ABITS                : natural := 4;
    constant C_DBITS                : natural := 32;
    constant C_TMR                  : natural := 0;
    constant C_REG                  : natural := 0;
    
    type t_if_state is (stIdle, stAccess);
    type t_mem_type is array (2 downto 0, 2**C_ABITS_MAX-1 downto 0) of std_logic_vector(C_DBITS-1 downto 0);
    type t_slv_array is array (natural range <>) of std_logic_vector;
     
    signal memTbArray       : t_mem_type := (others => (others => (others => '0')));
    
    signal i_clk            : std_logic;
    signal i_wd             : std_logic := '1';
    signal i_rd             : std_logic := '0';
    signal o_busy           : std_logic_vector(2 downto 0);
    signal i_addr           : std_logic_vector(C_ABITS_MAX-1 downto 0) := (others => '0');
    signal i_data           : std_logic_vector(C_DBITS-1 downto 0) := (others => '0');
    signal o_data           : t_slv_array(2 downto 0)(C_DBITS-1 downto 0);
    
begin

    P_Clk: process
    begin
        i_clk <= '0';
        Wait for (C_CLKPERIOD/2);
        i_clk <= '1';
        Wait for (C_CLKPERIOD/2);
    end process;    
    
    P_Stimulus: process
    
        procedure ramOperation(
            constant wd             : in std_logic;
            constant rd             : in std_logic;
            constant backToBack     : in std_logic := '0'; -- force only back to back accesses
            constant address        : in std_logic_vector(C_ABITS_MAX-1 downto 0) := (others => '0');
            constant data           : in std_logic_vector(C_DBITS-1 downto 0) := (others => '0')
        ) is
        begin
            wait until rising_edge(iClK);
            -- TODO!!!
        end procedure ramOperation;
        
        procedure initializeMemory is
            variable vAddr :    std_logic_vector(C_ABITS_MAX-1 downto 0);
            variable vData :    std_logic_vector(C_DBITS-1 downto 0);
        begin 
            
            vAddr := (others => '0');
            vData := (others => '0');

            -- TODO
            
        end procedure initializeMemory;
        
        procedure testMemory (constant C_TESTNUMBER : integer := 256) is
            constant procedureName  : string := "T_memory";
            variable initialWARNINGCounter    : integer := 0;
        begin
            -- TODO:
        end procedure testMemory;
    begin
        
        initializeMemory;
        testMemory;
        
        wait for 10 us;
        report "Simulation ended normally." severity note;
        wait;
        
    end process;
-----------------------------------------------------------------------------
-- Instantiate DUT
-----------------------------------------------------------------------------
    I_DUT: entity work.reg_ram
    generic map(
        ABITS           => C_ABITS_0,
        DBITS           => C_DBITS,
        TMR             => C_TMR,  
        REG             => C_REG
    )
    port map(  
        i_clk           => i_clk,  
        i_wd            => i_wd, 
        i_rd            => i_rd,  
        o_busy          => o_busy,
        i_addr          => i_addr(C_ABITS - 1 downto 0),
        i_data          => i_data,
        o_data          => o_data
    );
        
end architecture;

