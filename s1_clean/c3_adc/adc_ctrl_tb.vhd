library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

library fmf;
    use fmf.adc.all;

library uvvm_util;
    context uvvm_util.uvvm_util_context;

entity adc_ctrl_tb is
    generic (
        GC_SIMDATE          : string := ""
    );

end entity;

architecture behavioral of adc_ctrl_tb is

    component adc_ctrl is
        generic (
            GC_CS_POL           : integer := 0;
            GC_DBITS            : integer range 2 to 8 := 4
        );
        port (
            i_clk               : in std_logic;                         -- Main clock.
            i_rst_n             : in std_logic;                         -- Active low, asynchronous reset.
            -- Clock divider for ADC SCLK (\textbf{o_sclk}). Main clock is divided (i_clk_div+1)*2 times.
            i_clk_div           : in std_logic_vector(GC_DBITS-1 downto 0);
            i_go                : in std_logic;                         -- Readout start command pulse, active high.
            i_addr              : in std_logic_vector(2 downto 0);      -- Address for next conversion (for N+1, programmed during N).
            o_sclk              : out std_logic;                        -- Clock for ADC.
            o_cs                : out std_logic;                        -- Chip select signals to ADC.
            o_din               : out std_logic;                        -- Serial data to ADC.
            i_dout              : in std_logic;                         -- Serial data from ADC.
            o_data_val          : out std_logic_vector(11 downto 0);    -- Read ADC word.
            o_busy              : out std_logic                         -- Module busy flag, active high.
        );
    end component adc_ctrl;
    
    type adc_std_type is array(0 to 7) of std_logic_vector(11 downto 0);
    type adc_real_type is array (0 to 7) of real;

    constant C_SCOPE                : string := C_TB_SCOPE_DEFAULT;
    constant C_CLKPERIOD            : time := 10 ns;

    constant C_ADC_CS_POL           : integer := 0;
    constant C_ADC_CS_POL_STD       : std_logic := std_logic(to_unsigned(C_ADC_CS_POL, 1)(0));
    constant C_ADC_CLK_DIV          : integer := 9;
    constant C_CLK_PERIOD           : natural := 2*(C_ADC_CLK_DIV+1);   -- clock cycles for full ADC sclk period
    constant C_SPI_PERIOD_GOLD      : time := 1 us;
    constant GND                    : real := 0.0;
    constant VREF                   : real := 3.3;

    signal i_clk                    : std_logic; 
    signal i_rst_n                  : std_logic; 
    signal i_clk_div                : std_logic_vector(3 downto 0);
    signal i_go                     : std_logic; 
    signal i_addr                   : std_logic_vector(2 downto 0);
    signal o_sclk                   : std_logic;
    signal o_cs                     : std_logic;
    signal o_din                    : std_logic;
    signal i_dout                   : std_logic;
    signal o_data_val               : std_logic_vector(11 downto 0);    
    signal o_busy                   : std_logic;
    
    signal adc_real                 : adc_real_type := (others => GND);
    signal adc_std                  : adc_std_type := (others => (others => '0'));
    
    signal phase_name               : string (1 to 30) := "Uninitialized                 ";
    
     --frequency measure signals
    signal period_meas_valid_adc    : std_logic;
    signal period_meas_adc          : time;
    
begin

--------------------------------------------------------------------------------------------------
    P_CLK: process
    begin
        i_clk <= '0';
        Wait for (C_CLKPERIOD/2);
        i_clk <= '1';
        Wait for (C_CLKPERIOD/2);
    end process;

    P_FREQ_MEAS_ADC: process(o_sclk, o_cs)
        variable v_last_event   : time := 0 ns;
        variable v_period       : time := 0 ns;
        variable v_valid        : std_logic := '0';
    begin
        if(o_cs = not C_ADC_CS_POL_STD) then
            period_meas_valid_adc <= '0';
            v_valid := '0';
        elsif(rising_edge(o_sclk)) then
            v_period        := now - v_last_event;
            v_last_event    := now;
            period_meas_adc <= v_period;
            if(v_valid = '1') then
                period_meas_valid_adc <= '1';
            else
                period_meas_valid_adc <= '0';
            end if;
            v_valid := '1';
        end if;
    end process;

    P_Stimulus: process
        variable v_adc_errors  : integer := 0;
        variable v_adc_checks  : integer := 0;

        procedure generateAdcRandVal (
            constant minVal         : integer := 0;
            constant maxVal         : integer := 4095
        ) is
            constant procedureName  : string := "generateAdcRandVal";
            variable v_temp_val     : integer := 0;
        begin
            log(ID_LOG_HDR, procedureName & ": Random ADC data generation. Min: " & to_string(minVal) & ", Max: " & to_string(maxVal) , C_SCOPE);
            for I in adc_std'range loop
                v_temp_val  := random(minVal, maxVal);
                adc_std(I)  <= std_logic_vector(to_unsigned(v_temp_val, 12));
            end loop;
        end procedure;

    begin
        -- Disable stoping simulation on error
        set_alert_stop_limit(ERROR, 0);
        disable_log_msg(ALL_MESSAGES);
        enable_log_msg(ID_LOG_HDR);
        enable_log_msg(ID_SEQUENCER);
        
        i_rst_n     <= '0';
        i_clk_div   <= std_logic_vector(to_unsigned(C_ADC_CLK_DIV,4)); 
        i_go        <= '0';
        i_addr      <= (others => '0');

        ------------------------------------------------------------
        log(ID_LOG_HDR, "Starting simulation of TB for BsCtrl", C_SCOPE);
        ------------------------------------------------------------
        wait for 356 ns;
        i_rst_n <= '1';
        
        log(ID_LOG_HDR, "Test random", C_SCOPE);
        
        
        for I in 1 to 10 loop
            generateAdcRandVal(0, 4095);
            wait until rising_edge(i_clk);
            for J in 0 to 7 loop
                i_go    <= '1';
                i_addr  <= std_logic_vector(to_unsigned(J,i_addr'length));
                wait until rising_edge(i_clk);
                i_go    <= '0';
                wait until rising_edge(i_clk)  and o_busy = '0';
                -- TODO: add checks on data!
            end loop;
        end loop;
       
        report "Simulation ended normally." severity note;
        std.env.finish;
        Wait;

    end process;
-----------------------------------------------------------------------------
-- Instantiate DUT
-----------------------------------------------------------------------------
    I_DUT: adc_ctrl
    generic map(
        GC_CS_POL       => C_ADC_CS_POL,
        GC_DBITS        => 4
    )
    port map(
        i_clk           => i_clk,
        i_rst_n         => i_rst_n,
        i_clk_div       => i_clk_div,
        i_go            => i_go,
        i_addr          => i_addr,
        o_sclk          => o_sclk,
        o_cs            => o_cs,
        o_din           => o_din,
        i_dout          => i_dout,
        o_data_val      => o_data_val,
        o_busy          => o_busy
    );

    I_ADC: entity fmf.adc128s102
    generic map(
        tipd_SCLK               => (0.7 ns, 0.7 ns),
        tipd_CSNeg              => (0.7 ns, 0.7 ns),
        tipd_DIN                => (0.7 ns, 0.7 ns),
        tpd_SCLK_DOUT           => (27 ns, 27 ns, 27 ns, 27 ns, 27 ns, 27 ns),
        tpd_CSNeg_DOUT          => (30 ns, 30 ns, 20 ns, 30 ns, 20 ns, 30 ns),
        tsetup_CSNeg_SCLK       => 10 ns,
        tsetup_DIN_SCLK         => 10 ns,
        thold_CSNeg_SCLK        => 10 ns,
        thold_DIN_SCLK          => 10 ns,
        tpw_SCLK_posedge        => 35 ns,
        tpw_SCLK_negedge        => 35 ns,
        tperiod_SCLK_posedge    => 70 ns
    )
    port map (
        SCLK    => o_sclk,
        CSNeg   => o_cs,
        DIN     => o_din,
        VA      => VREF,
        IN0     => adc_real(0),
        IN1     => adc_real(1),
        IN2     => adc_real(2),
        IN3     => adc_real(3),
        IN4     => adc_real(4),
        IN5     => adc_real(5),
        IN6     => adc_real(6),
        IN7     => adc_real(7),
        DOUT    => i_dout
    );

    G_ADC_CONV: for I in 0 to 7 generate
        adc_real(I)     <= (real(to_integer(unsigned(adc_std(I)))) / 4095.0) * VREF;
    end generate G_ADC_CONV;

end architecture;

