--------------------------------------------------------------------------------
-- #file                    : cordic.vhd
-- #entity                  : cordic
-- #author                  : Kamil Ber
-- #company                 :
-- #current version         : 1.0
-- #revision                : Version 1.0, Kamil Ber : (2024/11/16) initial
---------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.FIXED_pkg.ALL;

LIBRARY work;
USE work.CORDIC_PKG.ALL;

ENTITY cordic IS
    GENERIC (
        G_ITERS             : integer range 16 to 32 := 32
    );
    PORT (
        i_clk               : IN  std_logic;
        i_clr               : IN  std_logic;                        -- active high
        i_go                : IN  std_logic;                        -- active high
        o_busy              : OUT  std_logic;                       -- active high
        iv_rad              : IN  std_logic_vector(31 DOWNTO 0);    -- sfixed (8, 24)
        ov_sin              : OUT  std_logic_vector(31 DOWNTO 0);   -- sfixed (8, 24)
        ov_cos              : OUT  std_logic_vector(31 DOWNTO 0)    -- sfixed (8, 24)
    );
END cordic;

ARCHITECTURE Behavioral OF cordic IS

    TYPE t_cordic IS RECORD 
        theta   : sfixed(7 downto -24);
        x       : sfixed(7 downto -24);
        y       : sfixed(7 downto -24);
        p2i     : sfixed(7 downto -24);
        busy    : std_logic;
        iter    : unsigned(4 downto 0);
    END RECORD;

    signal r, rin : t_cordic := (
        to_sfixed(0, 7, -24),
        to_sfixed(1, 7, -24),
        to_sfixed(0, 7, -24),
        to_sfixed(1, 7, -24),
        '0',
        to_unsigned(0, 5)
    ); 

BEGIN

    P_SEQ: PROCESS(i_clk)
    BEGIN
        IF rising_edge(i_clk) THEN
            r <= rin;
        END IF;
    END PROCESS;

    P_COMB: PROCESS(r, i_clr, i_go, iv_rad)
        variable vr: t_cordic;
        variable alpha : sfixed(7 downto -24);
        variable sigma : sfixed(7 downto -24);
    BEGIN
        vr  := r;
        alpha := to_sfixed(iv_rad, 7, -24);

        -- start new iteration
        IF i_go = '1' AND r.busy = '0' THEN 
            vr.theta    := to_sfixed(0, 7, -24);
            vr.x        := to_sfixed(1, 7, -24);
            vr.y        := to_sfixed(0, 7, -24);
            vr.p2i      := to_sfixed(1, 7, -24);
            vr.iter     := to_unsigned(0, 5);
            vr.busy     := '1';
        END IF;

        if r.busy = '1' then 
            -- last iteration
            if r.iter = G_ITERS-1 then 
                vr.busy     := '0';
            end if;
            if r.theta < alpha then 
                sigma       := to_sfixed(1, 7, -24);
            else
                sigma       := to_sfixed(-1, 7, -24);
            end if;
            vr.theta    := resize(r.theta + sigma * C_TANGENT_TABLE_SFIXED(to_integer(r.iter)), 7, -24);
            vr.x        := resize(r.x - sigma * r.y * r.p2i, 7, -24);
            vr.y        := resize(r.y + sigma * r.p2i * r.x, 7, -24);
            vr.p2i      := r.p2i srl 1;
            vr.iter     := r.iter + 1;
        end if;

        -- sync reset, highest priority
        IF i_clr = '1' THEN
            vr.theta    := to_sfixed(0, 7, -24);
            vr.x        := to_sfixed(1, 7, -24);
            vr.y        := to_sfixed(0, 7, -24);
            vr.p2i      := to_sfixed(1, 7, -24);
            vr.iter     := to_unsigned(0, 5);
            vr.busy     := '0';   
        END IF;
        
        rin <= vr;
    END PROCESS;
    
    o_busy  <= r.busy; 
    ov_sin  <= to_slv(r.y); 
    ov_cos  <= to_slv(r.x); 

END Behavioral;
pwm