library ieee;
    use ieee.std_logic_1164.all;
    use ieee.vital_timing.ALL;
    USE ieee.vital_primitives.ALL;
    USE IEEE.numeric_std.ALL;   		--KAMIL
    USE IEEE.std_logic_unsigned.ALL;	--KAMIL
    USE IEEE.VITAL_timing.ALL;
    USE IEEE.VITAL_primitives.ALL;
    USE STD.textio.ALL;


library fmf;
use fmf.gen_utils.all;
use fmf.conversions.all;

package adc is
    component adc128s102 IS
        GENERIC (
            -- Interconnect path delays
            tipd_SCLK           : VitalDelayType01  := VitalZeroDelay01;
            tipd_CSNeg          : VitalDelayType01  := VitalZeroDelay01;
            tipd_DIN            : VitalDelayType01  := VitalZeroDelay01;
            -- Propagation delays
            tpd_SCLK_DOUT       : VitalDelayType01Z := UnitDelay01Z;
            tpd_CSNeg_DOUT      : VitalDelayType01Z := UnitDelay01Z;
            -- Setup/hold violation
            tsetup_CSNeg_SCLK   : VitalDelayType    := UnitDelay;
            tsetup_DIN_SCLK     : VitalDelayType    := UnitDelay;
            thold_CSNeg_SCLK    : VitalDelayType    := UnitDelay;
            thold_DIN_SCLK      : VitalDelayType    := UnitDelay;
            -- Puls width checks
            tpw_SCLK_posedge    : VitalDelayType    := UnitDelay;
            tpw_SCLK_negedge    : VitalDelayType    := UnitDelay;
            -- Period checks
            tperiod_SCLK_posedge: VitalDelayType    := UnitDelay;
            -- generic control parameters
            InstancePath        : STRING            := DefaultInstancePath;
            TimingChecksOn      : BOOLEAN           := DefaultTimingChecks;
            MsgOn               : BOOLEAN           := DefaultMsgOn;
            XOn                 : BOOLEAN           := DefaultXon;
            -- For FMF SDF technology file usage
            TimingModel         : STRING            := DefaultTimingModel
            );

        PORT (
            SCLK  : IN  std_ulogic := 'U';
            CSNeg : IN  std_ulogic := 'U';
            DIN   : IN  std_ulogic := 'U';
            VA    : IN  real       := 2.7;
            IN0   : IN  real       := 0.0;
            IN1   : IN  real       := 0.0;
            IN2   : IN  real       := 0.0;
            IN3   : IN  real       := 0.0;
            IN4   : IN  real       := 0.0;
            IN5   : IN  real       := 0.0;
            IN6   : IN  real       := 0.0;
            IN7   : IN  real       := 0.0;
            DOUT  : OUT std_ulogic := 'U'
            );
    END component adc128s102;
end adc;
