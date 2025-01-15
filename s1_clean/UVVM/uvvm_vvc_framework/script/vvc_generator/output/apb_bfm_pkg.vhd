--==========================================================================================
-- This VVC was generated with Bitvis VVC Generator
--==========================================================================================


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library uvvm_util;
context uvvm_util.uvvm_util_context;

--==========================================================================================
--==========================================================================================
package apb_bfm_pkg is

  --==========================================================================================
  -- Types and constants for APB BFM 
  --==========================================================================================
  constant C_SCOPE : string := "APB BFM";

  -- Optional interface record for BFM signals
  -- type t_apb_if is record
    --<USER_INPUT> Insert all BFM signals here
    -- Example:
    -- cs      : std_logic;          -- to dut
    -- addr    : unsigned;           -- to dut
    -- rena    : std_logic;          -- to dut
    -- wena    : std_logic;          -- to dut
    -- wdata   : std_logic_vector;   -- to dut
    -- ready   : std_logic;          -- from dut
    -- rdata   : std_logic_vector;   -- from dut
  -- end record;

  -- Configuration record to be assigned in the test harness.
  type t_apb_bfm_config is
  record
    id_for_bfm               : t_msg_id;
    id_for_bfm_wait          : t_msg_id;
    id_for_bfm_poll          : t_msg_id;
    --<USER_INPUT> Insert all BFM config parameters here
    -- Example:
    -- max_wait_cycles          : integer;
    -- max_wait_cycles_severity : t_alert_level;
    -- clock_period             : time;
  end record;

  -- Define the default value for the BFM config
  constant C_APB_BFM_CONFIG_DEFAULT : t_apb_bfm_config := (
    id_for_bfm               => ID_BFM,
    id_for_bfm_wait          => ID_BFM_WAIT,
    id_for_bfm_poll          => ID_BFM_POLL
    --<USER_INPUT> Insert defaults for all BFM config parameters here
    -- Example:
    -- max_wait_cycles          => 10,
    -- max_wait_cycles_severity => failure,
    -- clock_period             => -1 ns
  );


  --==========================================================================================
  -- BFM procedures 
  --==========================================================================================


  --<USER_INPUT> Insert BFM procedure declarations here, e.g. read and write operations
  -- It is recommended to also have an init function which sets the BFM signals to their default state


end package apb_bfm_pkg;


--==========================================================================================
--==========================================================================================

package body apb_bfm_pkg is


  --<USER_INPUT> Insert BFM procedure implementation here.


end package body apb_bfm_pkg;

