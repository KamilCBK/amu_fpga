library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

library std;
    use std.textio.all;
    use std.env.all;

library uvvm_util;
    context uvvm_util.uvvm_util_context;

entity pwm_tb is 
    generic (
        GC_SIM_DATE                 : string := ""
    );
end entity;

architecture behavioral of pwm_tb is

    constant C_SCOPE            : string  := C_TB_SCOPE_DEFAULT;    
    constant C_CLKPERIOD        : natural := 10;                    -- Main clock period in ns, main clock is connected to DUT's input
    constant C_SBITS            : natural := 4;

    signal i_clk                : std_logic := '0';                 -- Main clock.
    signal i_rst_n              : std_logic;                        -- Active low, asynchronous reset.
    signal i_scaler             : std_logic_vector(C_SBITS-1 downto 0); -- Scaler input;
    signal i_duty               : std_logic_vector(7 downto 0);     -- Duty cycle.
    signal i_en                 : std_logic;                        -- Generator enable, active high.
    signal o_pwm                : std_logic;                        -- Generated PWM.
    
begin

    i_clk <= not i_clk after (C_CLKPERIOD/2) * ns;
    
    P_STIMULUS: process
    begin
        -- Disable stoping simulation on error
        set_alert_stop_limit(ERROR, 0);
        disable_log_msg(ALL_MESSAGES);
        enable_log_msg(ID_LOG_HDR);
        enable_log_msg(ID_SEQUENCER);
        
        i_rst_n     <= '0';
        i_en        <= '0';
        i_scaler    <= (others => '0');
        i_duty      <= (others => '0');
        
        ------------------------------------------------------------
        log(ID_LOG_HDR, "Starting simulation of TB for PWM_GEN", C_SCOPE);
        -----------------------------------------------------------
        wait for 356 ns;
        i_rst_n <= '1';
        wait for 1 us;
        
        log(ID_LOG_HDR, "SCALER = 0, DUTY = 0", C_SCOPE);
        i_en            <= '1';
        i_scaler        <= (others => '0');
        i_duty          <= (others => '0');
        wait for 1 ms;
        
        log(ID_LOG_HDR, "SCALER = 0, DUTY = 255", C_SCOPE);
        i_en            <= '1';
        i_scaler        <= (others => '0');
        i_duty          <= (others => '1');
        wait for 1 ms;
        
        log(ID_LOG_HDR, "SCALER = 2, DUTY = 100", C_SCOPE);
        i_en            <= '1';
        i_scaler        <= std_logic_vector(to_unsigned(2, C_SBITS));
        i_duty          <= std_logic_vector(to_unsigned(100, 8));
        wait for 1 ms;
        
        log(ID_LOG_HDR, "DISABLE", C_SCOPE);
        i_en            <= '0';
        i_scaler        <= std_logic_vector(to_unsigned(2, C_SBITS));
        i_duty          <= std_logic_vector(to_unsigned(100, 8));
        wait for 1 ms;
        
        report_alert_counters(FINAL); 
        log(ID_LOG_HDR, "SIMULATION COMPLETED", C_SCOPE);

        report "Simulation ended normally." severity note;
        std.env.finish;
    end process;

-----------------------------------------------------------------------------
-- Instantiate DUT
-----------------------------------------------------------------------------
    I_DUT: entity work.pwm
    generic map (
        GC_SBITS        => C_SBITS
    )
    port map(
        i_clk           => i_clk,       
        i_rst_n         => i_rst_n,     
        i_scaler        => i_scaler,    
        i_duty          => i_duty,
        i_en            => i_en,    
        o_pwm           => o_pwm
    );
    
end architecture;

