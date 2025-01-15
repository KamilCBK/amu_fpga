ghdl -a --std=08 cnt.vhd
ghdl -a --std=08 cnt_tb.vhd
ghdl -e --std=08 cnt_tb
ghdl -r --std=08 cnt_tb --wave=wave.ghw
gtkwave wave.ghw
