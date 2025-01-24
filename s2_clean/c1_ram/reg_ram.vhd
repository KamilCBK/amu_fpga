--------------------------------------------------------------------------------
-- #file                    : reg_ram.vhd
-- #entity                  : reg_ram
-- #author                  : Kamil Ber
-- #company                 : Space Research Centre PAS
-- #currentversion          : 2
-- #revision                : Version 0, Kamil Ber  : (2017/09/01) init version.
--                          : Version 1, Kamil Ber  : (2017/09/01) reset, descripiton added.
--                          : Version 2, Kamil Ber  : (2021/10/02) adoption of new coding style.
--
-- (c) copyright PAS  : all right reserved.
--
---------------------------------------------------------------------------------
-- #brief :
-- Register based, memory for Microsemi's FPGAs.
-- #end
-- #desc :
-- This module utilizes sequential (registers) logic and builds internal memory array.
-- An optionally protection against data corruption can be added. A Triple Modular Redundancy
-- mechanism is offered.
-- #end
-- #oper : 
-- Each request is executed within one clock cycle. Module accepts simultaneously 
-- read and write requests (old data is presented on output and then new data is stored.)
-- #end 
-- 
---------------------------------------------------------------------------------
-- Todo: none
---------------------------------------------------------------------------------
-- Constraints:
-- assumption made for input or output signals
-- known bugs not corrected yet
--
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity reg_ram is 
    generic (
        -- Number of address bits, determines size of internal memory ($size = 2^GC_ABITS$ words). 
        -- #range 1-12 : Address bits. #end
        GC_ABITS            : integer := 4;
        -- Number of data bits, determines size of memory word. 
        -- #range 1-32 : Address bits. #end
        GC_DBITS            : integer := 16;
        -- Add logic for TMR protection.
        -- #range 0 : TMR disabled, #end
        -- #range 1 : TMR disabled. #end
        GC_TMR              : integer := 0
    );  
    port (  
        i_clk               : in std_logic;                                 -- Main clock.
        i_wd                : in std_logic;                                 -- Write command pulse, active high.
        i_rd                : in std_logic;                                 -- Read command pulse, active high.
        i_addr              : in std_logic_vector(GC_ABITS-1 downto 0);     -- Address.
        i_data              : in std_logic_vector(GC_DBITS-1 downto 0);     -- Data input.
        o_data              : out std_logic_vector(GC_DBITS-1 downto 0)     -- Data output.
    );
end entity;

architecture behavioral of reg_ram is
  
  type mem_type is array (2**GC_ABITS-1 downto 0) of std_logic_vector(GC_DBITS-1 downto 0);
  signal mem_array    : mem_type;
  signal mem_array2   : mem_type;
  signal mem_array3   : mem_type;
  
  signal read_data    : std_logic_vector(GC_DBITS-1 downto 0);
  
begin

G_NO_TMR: if GC_TMR = 0 generate
    P_SEQ: process (i_clk) begin
        if (i_clk'event and i_clk = '1') then
            if(i_rd = '1') then
                read_data  <=  mem_array(to_integer(unsigned(i_addr)));
            end if;    
            if(i_wd = '1') then
                mem_array(to_integer(unsigned(i_addr)))  <= i_data;
            end if;
        end if;
    end process;
end generate;
  
G_TMR: if GC_TMR /= 0 generate
    P_SEQ: process (i_clk) 
        variable data1  : std_logic_vector(GC_DBITS-1 downto 0);
        variable data2  : std_logic_vector(GC_DBITS-1 downto 0);
        variable data3  : std_logic_vector(GC_DBITS-1 downto 0);
    begin
        if (i_clk'event and i_clk = '1') then
            if(i_rd = '1') then
                data1       :=  mem_array(to_integer(unsigned(i_addr)));
                data2       :=  mem_array2(to_integer(unsigned(i_addr)));
                data3       :=  mem_array3(to_integer(unsigned(i_addr)));
                read_data   <=  (data1 and data2) or (data1 and data3) or (data2 and data3);
            end if;    
            if(i_wd = '1') then
                mem_array(to_integer(unsigned(i_addr)))     <= i_data;
                mem_array2(to_integer(unsigned(i_addr)))    <= i_data;
                mem_array3(to_integer(unsigned(i_addr)))    <= i_data;
            end if;
        end if;
    end process;
end generate;
  
  o_data <= read_data;
end architecture;

