library ieee;
use ieee.std_logic_1164.all;

entity fsm is
    port (
        i_clk, i_rst, i_x: in std_logic;
        o_z : out std_logic_vector(1 downto 0)
    );
end entity;

architecture arch of fsm is

    type t_state is (S1, S2, S3, S4);
    signal state: t_state;

begin

    proc_fsm: process (i_clk)
        begin

        if rising_edge(i_clk) then
            if i_rst='1' then
                state <= S1;
            else
                case state is
                    when S1 =>
                        if i_x='0' then
                            state <= S1;
                        elsif i_x='1' then
                            state <= S2;
                        end if;
                    when S2 =>
                        if i_x='1' then
                            state <= S2;
                        elsif i_x='0' then
                            state <= S3;
                        end if;
                    when S3 =>
                        if i_x='1' then
                            state <= S4;
                        elsif i_x='0' then
                            state <= S1;
                        end if;
                    when S4 =>
                        if i_x='0' then
                            state <= S3;
                        elsif i_x='1' then
                            state <= S2;
                        end if;
                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;

o_z <= "00" when (state = S1 and i_x='0') else
    "01" when (state = S1 and i_x='1') else
    "00" when (state = S2 and i_x='1') else
    "00" when (state = S2 and i_x='0') else
    "00" when (state = S3 and i_x='1') else
    "00" when (state = S3 and i_x='0') else
    "00" when (state = S4 and i_x='0') else
    "10" when (state = S4 and i_x='1') else
    "11";

end arch;

 