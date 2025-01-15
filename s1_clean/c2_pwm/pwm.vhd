--------------------------------------------------------------------------------
-- #file                    : pwm.vhd
-- #entity                  : pwm
-- #author                  : Kamil Ber
-- #company                 :
-- #current version         : 1.0
-- #revision                : Version 1.0, Kamil Ber : (2024/11/16) initial
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm is
    generic (
        GC_SBITS            : integer range 2 to 8 := 4             -- Scaler size in bits.
    );
    port (
        i_clk               : in std_logic;                         -- Main clock.
        i_rst_n             : in std_logic;                         -- Active low, asynchronous reset.
        i_scaler            : in std_logic_vector(GC_SBITS-1 downto 0); -- Scaler input;
        i_duty              : in std_logic_vector(7 downto 0);      -- Duty cycle.
        i_en                : in std_logic;                         -- Generator enable, active high.
        o_pwm               : out std_logic                         -- Generated PWM.
    );
end entity;

architecture bech of pwm is

    type t_pwm_type is record
        pwm_out     : std_logic;
        scaler      : unsigned(GC_SBITS-1 downto 0);
        cnt         : unsigned(7 downto 0);
        tick        : std_logic;
    end record;
    signal r, rin   : t_pwm_type;

begin

    P_SEQ: process(i_clk, i_rst_n)
    begin
        if (i_rst_n = '0') then
            r.scaler    <= (others => '0');
            r.cnt       <= (others => '0');
            r.tick      <= '0';
            r.pwm_out   <= '0';
        elsif (i_clk'event and i_clk = '1') then
            r           <= rin;
        end if;
    end process;

    P_CMB: process (r, i_en, i_scaler, i_duty)
        variable v_r    : t_pwm_type;
    begin
        v_r := r;

        if i_en = '1' then
            v_r.scaler  := r.scaler-1;
            v_r.tick    := '0';
            if r.scaler = 0 then
                v_r.scaler  := unsigned(i_scaler);
                v_r.tick    := '1';
            end if;
            if r.tick = '1' then
                v_r.cnt     := r.cnt-1;
            end if;
        else
            v_r.scaler  := unsigned(i_scaler);
            v_r.tick    := '1';
            v_r.cnt     := (others => '0');
        end if;

        
        if r.cnt > unsigned(i_duty) then
            v_r.pwm_out  := '0';
        else
            v_r.pwm_out  := i_en;
        end if;

        rin <= v_r;
    end process;
    o_pwm      <= r.pwm_out;

end architecture;