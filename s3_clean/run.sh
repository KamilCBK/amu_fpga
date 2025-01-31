ghdl -a --std=08 alu.vhd
ghdl -a --std=08 cpu.vhd
ghdl -a --std=08 mem_for_sim.vhd
ghdl -a --std=08 cpu_tb.vhd
ghdl -e --std=08 cpu_tb
ghdl -r --std=08 cpu_tb --wave=wave.ghw
gtkwave wave.ghw
