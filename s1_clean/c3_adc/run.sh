
# echo "Compiling UVVM Utility Library..." 
# ghdl -a --std=08 -frelaxed-rules -Wno-hide -Wno-shared --work=uvvm_util ../UVVM/uvvm_util/src/types_pkg.vhd
# ghdl -a --std=08 -frelaxed-rules -Wno-hide -Wno-shared --work=uvvm_util ../UVVM/uvvm_util/src/adaptations_pkg.vhd
# ghdl -a --std=08 -frelaxed-rules -Wno-hide -Wno-shared --work=uvvm_util ../UVVM/uvvm_util/src/string_methods_pkg.vhd
# ghdl -a --std=08 -frelaxed-rules -Wno-hide -Wno-shared --work=uvvm_util ../UVVM/uvvm_util/src/protected_types_pkg.vhd
# ghdl -a --std=08 -frelaxed-rules -Wno-hide -Wno-shared --work=uvvm_util ../UVVM/uvvm_util/src/global_signals_and_shared_variables_pkg.vhd
# ghdl -a --std=08 -frelaxed-rules -Wno-hide -Wno-shared --work=uvvm_util ../UVVM/uvvm_util/src/hierarchy_linked_list_pkg.vhd
# ghdl -a --std=08 -frelaxed-rules -Wno-hide -Wno-shared --work=uvvm_util ../UVVM/uvvm_util/src/alert_hierarchy_pkg.vhd
# ghdl -a --std=08 -frelaxed-rules -Wno-hide -Wno-shared --work=uvvm_util ../UVVM/uvvm_util/src/license_pkg.vhd
# ghdl -a --std=08 -frelaxed-rules -Wno-hide -Wno-shared --work=uvvm_util ../UVVM/uvvm_util/src/methods_pkg.vhd
# ghdl -a --std=08 -frelaxed-rules -Wno-hide -Wno-shared --work=uvvm_util ../UVVM/uvvm_util/src/bfm_common_pkg.vhd
# ghdl -a --std=08 -frelaxed-rules -Wno-hide -Wno-shared --work=uvvm_util ../UVVM/uvvm_util/src/generic_queue_pkg.vhd
# ghdl -a --std=08 -frelaxed-rules -Wno-hide -Wno-shared --work=uvvm_util ../UVVM/uvvm_util/src/data_queue_pkg.vhd
# ghdl -a --std=08 -frelaxed-rules -Wno-hide -Wno-shared --work=uvvm_util ../UVVM/uvvm_util/src/data_fifo_pkg.vhd
# ghdl -a --std=08 -frelaxed-rules -Wno-hide -Wno-shared --work=uvvm_util ../UVVM/uvvm_util/src/data_stack_pkg.vhd
# ghdl -a --std=08 -frelaxed-rules -Wno-hide -Wno-shared --work=uvvm_util ../UVVM/uvvm_util/src/uvvm_util_context.vhd

# echo "Compiling FMF Library..."
# ghdl -a --std=08 -frelaxed-rules -Wno-hide -Wno-shared --work=fms --no-vital-checks ../fmf/utilities/gen_utils.vhd
# ghdl -a --std=08 -frelaxed-rules -Wno-hide -Wno-shared --work=fms --no-vital-checks ../fmf/utilities/conversions.vhd
# ghdl -a --std=08 -frelaxed-rules -Wno-hide -Wno-shared --work=fms --no-vital-checks ../fmf/adc/adc.vhd
# ghdl -a --std=08 -frelaxed-rules -Wno-hide -Wno-shared --work=fms --no-vital-checks ../fmf/fmf/adc/adc128s102.vhd


# echo "Compiling ADC Example..."
# ghdl -a --std=08 -frelaxed-rules adc_ctrl.vhd
# ghdl -a --std=08 -frelaxed-rules adc_ctrl_tb.vhd
# ghdl -e --std=08 -frelaxed-rules adc_ctrl_tb
# ghdl -r --std=08 -frelaxed-rules adc_ctrl_tb --wave=wave.ghw
# gtkwave wave.ghw


echo "Compiling UVVM Utility Library..." 
vlib uvvm_util
vmap work uvvm_util
vcom -suppress 1346,1236 -2008 -work uvvm_util ../UVVM/uvvm_util/src/types_pkg.vhd
vcom -suppress 1346,1236 -2008 -work uvvm_util ../UVVM/uvvm_util/src/adaptations_pkg.vhd
vcom -suppress 1346,1236 -2008 -work uvvm_util ../UVVM/uvvm_util/src/string_methods_pkg.vhd
vcom -suppress 1346,1236 -2008 -work uvvm_util ../UVVM/uvvm_util/src/protected_types_pkg.vhd
vcom -suppress 1346,1236 -2008 -work uvvm_util ../UVVM/uvvm_util/src/global_signals_and_shared_variables_pkg.vhd
vcom -suppress 1346,1236 -2008 -work uvvm_util ../UVVM/uvvm_util/src/hierarchy_linked_list_pkg.vhd
vcom -suppress 1346,1236 -2008 -work uvvm_util ../UVVM/uvvm_util/src/alert_hierarchy_pkg.vhd
vcom -suppress 1346,1236 -2008 -work uvvm_util ../UVVM/uvvm_util/src/license_pkg.vhd
vcom -suppress 1346,1236 -2008 -work uvvm_util ../UVVM/uvvm_util/src/methods_pkg.vhd
vcom -suppress 1346,1236 -2008 -work uvvm_util ../UVVM/uvvm_util/src/bfm_common_pkg.vhd
vcom -suppress 1346,1236 -2008 -work uvvm_util ../UVVM/uvvm_util/src/generic_queue_pkg.vhd
vcom -suppress 1346,1236 -2008 -work uvvm_util ../UVVM/uvvm_util/src/data_queue_pkg.vhd
vcom -suppress 1346,1236 -2008 -work uvvm_util ../UVVM/uvvm_util/src/data_fifo_pkg.vhd
vcom -suppress 1346,1236 -2008 -work uvvm_util ../UVVM/uvvm_util/src/data_stack_pkg.vhd
vcom -suppress 1346,1236 -2008 -work uvvm_util ../UVVM/uvvm_util/src/uvvm_util_context.vhd

echo "Compiling FMF Library..."
vlib fmf
vmap work fmf
vcom -novitalcheck -2008 -work fmf ../fmf/utilities/gen_utils.vhd
vcom -novitalcheck -2008 -work fmf ../fmf/utilities/conversions.vhd
vcom -novitalcheck -2008 -work fmf ../fmf/adc/adc.vhd
vcom -novitalcheck -2008 -work fmf ../fmf/adc/adc128s102.vhd


echo "Compiling ADC Example..."
vlib work
vmap work
# vcom -2008 +coverage -work work ../../hdl_examples/mux.vhd
vcom -2008 +coverage -work work adc_ctrl.vhd
vcom -2008 -work work adc_ctrl_tb.vhd

vsim -wlf wave.wlf -L work -t 1ps -debugDB -assertdebug -fsmdebug -coverage -voptargs=+acc work.adc_ctrl_tb
# vsim -wlf wave.wlf -L work -t 1ps -debugDB -assertdebug -fsmdebug -coverage -voptargs=+acc work.mux