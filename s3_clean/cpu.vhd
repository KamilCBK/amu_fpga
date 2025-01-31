library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std.all;

entity cpu is
    port(
        i_clk           : in std_logic;
        i_rst           : in std_logic;
        -- memory interface
        o_mem_wr        : out std_logic;
        o_mem_rd        : out std_logic;
        o_mem_addr      : out std_logic_vector(15 downto 0);
        o_mem_data      : out std_logic_vector(15 downto 0);
        i_mem_data      : in  std_logic_vector(15 downto 0);
        -- opcode: i_go - command pulse, rejected wjen o_busy = '1'
        i_go            : in  std_logic;
        i_opcode        : in  std_logic_vector(3 downto 0);
        i_in            : in  std_logic_vector(15 downto 0);
        o_busy          : out std_logic
    );
end entity;

architecture behavioral of cpu is

    type cpu_state is ( 
        st_idle,
        st_write,
        st_read
    );

    signal state    : cpu_state;
    signal reg_i1   : std_logic_vector(15 downto 0);
    signal reg_i2   : std_logic_vector(15 downto 0);
    signal reg_r1   : std_logic_vector(15 downto 0);
    signal reg_a1   : std_logic_vector(15 downto 0);
    signal mem_wr   : std_logic;
    signal mem_rd   : std_logic;
    signal mem_addr : std_logic_vector(15 downto 0);
    signal mem_data : std_logic_vector(15 downto 0);
    signal busy     : std_logic;
    signal reg      : std_logic;

begin
 
    proc_alu: process(i_clk)
    begin    
        if(i_rst = '1') then 
            state   <= st_idle;
            reg_i1  <= (others => '0');
            reg_i2  <= (others => '0');
            reg_r1  <= (others => '0');
            reg_a1  <= (others => '0');
            mem_wr  <= '0';
            mem_rd  <= '0';
            busy    <= '0';
            reg     <= '0';  
        else 
            case (state) is
                when st_idle =>
                    if i_opcode = "0001" then 
                        reg_i1 <= i_in;
                    elsif i_opcode = "0010" then
                        reg_i2 <= i_in;
                    elsif i_opcode = "0011" then
                        reg_a1 <= i_in;
                    elsif i_opcode = "0101" then
                        -- load mem from a1 to i1
                        state       <= st_read;
                        mem_addr    <= reg_a1;
                        mem_rd      <= '1';
                        busy        <= '1';
                        reg         <= '0';
                    elsif i_opcode = "0110" then
                        -- load mem from a1 to i2
                    elsif i_opcode = "0111" then
                        -- store r1 at address from a1
                    elsif i_opcode = "1001" then
                        -- add i1 and i2
                    elsif i_opcode = "1010" then
                        -- sub i2 from i1
                    elsif i_opcode = "1011" then
                        -- mul i1 and i2
                    elsif i_opcode = "1101" then
                        -- copy a1 to i1
                    elsif i_opcode = "1110" then
                        -- load r1 to a1
                    else 
                        -- nop
                    end if;
                when st_write => 
                    -- write data
                when st_read =>
                    state   <= st_idle;
                    mem_rd  <= '0';
                    if reg = '0' then 
                        reg_i1  <= i_mem_data;
                    else
                        reg_i1  <= i_mem_data;
                    end if;
                when others =>
                    report "error" severity error; 
            end case; 
        end if;
    end process;

    o_mem_wr    <= mem_wr;
    o_mem_rd    <= mem_rd;
    o_mem_addr  <= mem_addr;
    o_mem_data  <= mem_data;
    o_busy      <= busy;
   
end architecture behavioral;