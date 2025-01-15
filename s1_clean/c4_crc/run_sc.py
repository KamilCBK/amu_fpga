from vunit import VUnit

vu = VUnit.from_argv()
lib = vu.add_library("lib")
lib.add_source_files("crc16_sc.vhd")
lib.add_source_files("crc16_sc_tb.vhd")

vu.main()
