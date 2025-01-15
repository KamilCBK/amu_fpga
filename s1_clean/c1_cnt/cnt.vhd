--------------------------------------------------------------------------------
-- #file                    : cnt.vhd
-- #entity                  : cnt
-- #author                  : Kamil Ber
-- #company                 :
-- #current version         : 1.0
-- #revision                : Version 1.0, Kamil Ber : (2024/11/16) initial
---------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY cnt IS
    GENERIC (
        G_DATA_WIDTH        : integer := 16
    );
    PORT (
        i_clk               : IN  std_logic;
        i_clr               : IN  std_logic;
        i_load              : IN  std_logic;
        iv_cnt              : IN  std_logic_vector (G_DATA_WIDTH-1 DOWNTO 0);
        ov_cnt              : OUT  std_logic_vector (G_DATA_WIDTH-1 DOWNTO 0)
    );
END cnt;

ARCHITECTURE behavioral OF cnt IS

    SIGNAL cnt_int  : unsigned (G_DATA_WIDTH-1 DOWNTO 0) := (OTHERS => '0');

BEGIN
 
    P_MAIN: PROCESS(i_clk)
    BEGIN
        IF rising_edge(i_clk) THEN
            IF i_clr = '1' THEN
                cnt_int <= (others => '0');
            ELSE
                IF i_load = '1' then 
                    cnt_int <= unsigned(iv_cnt);
                ELSE
                    cnt_int <= cnt_int + 1;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    
    ov_cnt <= std_logic_Vector(cnt_int); 

END behavioral;
    