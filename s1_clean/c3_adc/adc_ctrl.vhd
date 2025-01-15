---------------------------------------------------------------------------------------
-- #file                    : adc_ctrl.vhd
-- #entity                  : adc_ctrl
-- #author                  : Kamil Ber
-- #company                 : Space Research Centre of Polish Academy of Sciences
-- #revision                : Version 0, Kamil Ber : (2018/06/01) initial
--                          : Version 1, Kamil Ber : (2018/12/01) sequence fix, description added.
--                          : Version 2, Kamil Ber : (2022/02/19) added frequency control + new coding styl.
--
-- (c) Copyright     :  Space Research Centre of Polish Academy of Sciences
--                      all rights reserved.
--
---------------------------------------------------------------------------------
-- #brief :
-- ADC128S102 controller.
-- #end
-- #desc :
-- ADC_CTRL allows to perform readout (voltage level) of ADC128S102 chip.
-- Timing constraints defined in \ref{ADC-DS} are met as long as frequency of produced 
-- ADC clock (\textbf{o_sclk}) is not greater than 10MHz.
-- #end
-- #oper :
-- Whenever \textbf{i_go} is asserted (active high) new programming sequence is started: 
-- \begin{itemize}[noitemsep]
-- \item \textbf{o_sclk} goes high,
-- \item after \textbf{i_clk_div}+2 \textbf{i_clk} cycles \textbf{o_cs} goes active,
-- \item 16 pulses are produced on \textbf{o_sclk}, (pulse is started with falling edge, 50% duty cycle, 
-- period 2*(\textbf{i_clk_div}+1) \textbf{i_clk} cycles ), on each of falling edge new value of \textbf{oDout} is driven out
-- (16 bit vector is built as follows "00" & \textbf{i_addr} & "00000000000", bits are sent from MSB to LSB),
-- \item \textbf{o_cs} goes to inactive state,
-- \item after \textbf{i_clk_div}+1 \textbf{i_clk} cycles \textbf{o_sclk} goes low. 
-- \end{itemize}
-- \textbf{o_busy} is held high during programming sequence and all new command pulses are then ignored.
-- Collected data word can be read on \textbf{o_data_val}.
-- #end
---------------------------------------------------------------------------------
-- Todo: none
---------------------------------------------------------------------------------
-- Constraints:
-- assumption made for input or output signals
-- known bugs not corrected yet

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adc_ctrl is
    generic (
        -- Polarization of \textbf{o_cs} output.
        -- #range 0 : \textbf{o_cs} active state is low, #end
        -- #range 1 : \textbf{o_cs} active state is high. #end
        GC_CS_POL           : integer := 0;
        -- Divider size in bits.
        -- #range 2-8 : Divider bits. #end
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
end entity adc_ctrl;

architecture bech of adc_ctrl is

    constant C_CS_POL_STD : std_logic := std_logic(to_unsigned(GC_CS_POL, 1)(0));

    type adc_ctrl_state is (s_idle, s_sync1, s_sync2, s_sclk0, s_sclk1, s_end);

    type adc_ctrl_type is record
        state       : adc_ctrl_state;
        data_out    : std_logic_vector(7 downto 0);
        data_in     : std_logic_vector(15 downto 0);
        cs          : std_logic;
        sclk        : std_logic;
        count       : unsigned(3 downto 0);
        busy        : std_logic;

        clk_cnt     : unsigned(GC_DBITS-1 downto 0);
        clk_stb     : std_logic;
    end record;

    signal r, rin   :   adc_ctrl_type;

begin

    SEQ: process(i_clk, i_rst_n)
    begin
        if (i_rst_n = '0') then
            r.state         <= s_idle;
            r.data_out      <= (others => '0');
            r.data_in       <= (others => '0');
            r.cs            <= not C_CS_POL_STD;
            r.sclk          <= '0';
            r.count         <= (others => '0');
            r.busy          <= '0';

            r.clk_cnt       <= (others => '0');
            r.clk_stb       <= '0';
        elsif (i_clk'event and i_clk = '1') then
            r               <= rin;
        end if;
    end process SEQ;

    CMB: process (r, i_go, i_addr, i_dout, i_clk_div)
        variable vr      : adc_ctrl_type;
    begin
        vr := r;

-- clock divider
        if r.busy = '0' then
            vr.clk_cnt   := unsigned(i_clk_div);
            vr.clk_stb   := '0';
        else
            vr.clk_cnt   := r.clk_cnt - 1;
            vr.clk_stb   := '0';
            if r.clk_cnt = 0 then
                vr.clk_cnt   := unsigned(i_clk_div);
                vr.clk_stb   := '1';
            end if;
        end if;

-- control state machine
        case (r.state) is
            when s_idle =>
                vr.data_out  := "00" & i_addr & "000";
                vr.count    := "1111";
                vr.busy     := '0';
                vr.cs       := not C_CS_POL_STD;
                vr.sclk     := '0';

                if(i_go = '1') then
                    vr.state    := s_sync1;
                    vr.sclk     := '1';
                    vr.busy     := '1';
                end if;

            when s_sync1 =>
                if(r.clk_stb = '1') then
                    vr.state    := s_sync2;
                    vr.cs       := C_CS_POL_STD;
                end if;

            when s_sync2 =>
                if(r.clk_stb = '1') then
                    vr.state    := s_sclk0;
                    vr.sclk     := '0';
                end if;

            when s_sclk0 =>
                if(r.clk_stb = '1') then
                    vr.data_in  := r.data_in(14 downto 0) & i_dout;    -- data read on rising edge ((i_clk_div+1)*i_clk_T - tdACC (27ns) after data change)
                    vr.state    := s_sclk1;
                    vr.sclk     := '1';
                end if;

            when s_sclk1 =>
                if(r.clk_stb = '1') then
                    vr.data_out  := r.data_out(6 downto 0) & '0';     -- din change on falling edge ((i_clk_div+1)*i_clk_T tDH)
                    vr.count    := r.count - 1;
                   
                    if(r.count = 0) then
                        vr.state    := s_end;
                        vr.cs       := not C_CS_POL_STD;
                    else
                        vr.state    := s_sclk0;
                        vr.sclk     := '0';
                    end if;
                end if;
            
            when s_end => 
                if(r.clk_stb = '1') then
                    vr.sclk     := '0';
                    vr.state    := s_idle;
                end if;

            when others =>
                vr.state    := s_idle;
                vr.busy     := '0';
                vr.cs       := not C_CS_POL_STD;
                vr.sclk     := '0';

        end case;

        rin <= vr;
    end process CMB;

    o_busy      <= r.busy;
    o_din       <= r.data_out(7);
    o_data_val  <= r.data_in(11 downto 0);
    o_cs        <= r.cs;
    o_sclk      <= r.sclk;

end architecture;
