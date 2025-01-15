# ghdl -a --std=08 --work=uvvm_util ../UVVM/uvvm_util/src/types_pkg.vhd
# ghdl -a --std=08 --work=uvvm_util ../UVVM/uvvm_util/src/adaptations_pkg.vhd
# ghdl -a --std=08 --work=uvvm_util ../UVVM/uvvm_util/src/string_methods_pkg.vhd
# ghdl -a --std=08 --work=uvvm_util ../UVVM/uvvm_util/src/protected_types_pkg.vhd
# ghdl -a --std=08 --work=uvvm_util ../UVVM/uvvm_util/src/global_signals_and_shared_variables_pkg.vhd
# ghdl -a --std=08 --work=uvvm_util ../UVVM/uvvm_util/src/hierarchy_linked_list_pkg.vhd
# ghdl -a --std=08 --work=uvvm_util ../UVVM/uvvm_util/src/alert_hierarchy_pkg.vhd
# ghdl -a --std=08 --work=uvvm_util ../UVVM/uvvm_util/src/license_pkg.vhd
# ghdl -a --std=08 --work=uvvm_util ../UVVM/uvvm_util/src/methods_pkg.vhd
# ghdl -a --std=08 --work=uvvm_util ../UVVM/uvvm_util/src/bfm_common_pkg.vhd
# ghdl -a --std=08 --work=uvvm_util ../UVVM/uvvm_util/src/generic_queue_pkg.vhd
# ghdl -a --std=08 --work=uvvm_util ../UVVM/uvvm_util/src/data_queue_pkg.vhd
# ghdl -a --std=08 --work=uvvm_util ../UVVM/uvvm_util/src/data_fifo_pkg.vhd
# ghdl -a --std=08 --work=uvvm_util ../UVVM/uvvm_util/src/data_stack_pkg.vhd
# ghdl -a --std=08 --work=uvvm_util ../UVVM/uvvm_util/src/uvvm_util_context.vhd

echo "Compiling UVVM Utility Library..."
ghdl -a --std=08 -frelaxed-rules -Wno-hide -Wno-shared --work=uvvm_util ../UVVM/uvvm_util/src/types_pkg.vhd
ghdl -a --std=08 -frelaxed-rules -Wno-hide -Wno-shared --work=uvvm_util ../UVVM/uvvm_util/src/adaptations_pkg.vhd
ghdl -a --std=08 -frelaxed-rules -Wno-hide -Wno-shared --work=uvvm_util ../UVVM/uvvm_util/src/string_methods_pkg.vhd
ghdl -a --std=08 -frelaxed-rules -Wno-hide -Wno-shared --work=uvvm_util ../UVVM/uvvm_util/src/protected_types_pkg.vhd
ghdl -a --std=08 -frelaxed-rules -Wno-hide -Wno-shared --work=uvvm_util ../UVVM/uvvm_util/src/global_signals_and_shared_variables_pkg.vhd
ghdl -a --std=08 -frelaxed-rules -Wno-hide -Wno-shared --work=uvvm_util ../UVVM/uvvm_util/src/hierarchy_linked_list_pkg.vhd
ghdl -a --std=08 -frelaxed-rules -Wno-hide -Wno-shared --work=uvvm_util ../UVVM/uvvm_util/src/alert_hierarchy_pkg.vhd
ghdl -a --std=08 -frelaxed-rules -Wno-hide -Wno-shared --work=uvvm_util ../UVVM/uvvm_util/src/license_pkg.vhd
ghdl -a --std=08 -frelaxed-rules -Wno-hide -Wno-shared --work=uvvm_util ../UVVM/uvvm_util/src/methods_pkg.vhd
ghdl -a --std=08 -frelaxed-rules -Wno-hide -Wno-shared --work=uvvm_util ../UVVM/uvvm_util/src/bfm_common_pkg.vhd
ghdl -a --std=08 -frelaxed-rules -Wno-hide -Wno-shared --work=uvvm_util ../UVVM/uvvm_util/src/generic_queue_pkg.vhd
ghdl -a --std=08 -frelaxed-rules -Wno-hide -Wno-shared --work=uvvm_util ../UVVM/uvvm_util/src/data_queue_pkg.vhd
ghdl -a --std=08 -frelaxed-rules -Wno-hide -Wno-shared --work=uvvm_util ../UVVM/uvvm_util/src/data_fifo_pkg.vhd
ghdl -a --std=08 -frelaxed-rules -Wno-hide -Wno-shared --work=uvvm_util ../UVVM/uvvm_util/src/data_stack_pkg.vhd
ghdl -a --std=08 -frelaxed-rules -Wno-hide -Wno-shared --work=uvvm_util ../UVVM/uvvm_util/src/uvvm_util_context.vhd

echo "Compiling PWM Example..."
ghdl -a --std=08 -frelaxed-rules pwm.vhd
ghdl -a --std=08 -frelaxed-rules pwm_tb.vhd
ghdl -e --std=08 -frelaxed-rules pwm_tb
ghdl -r --std=08 -frelaxed-rules pwm_tb --wave=wave.ghw
gtkwave wave.ghw
