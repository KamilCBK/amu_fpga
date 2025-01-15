from vunit import VUnit

vu = VUnit.from_argv()
lib = vu.add_library("lib")
lib.add_source_files("crc16.vhd")
lib.add_source_files("crc16_tb.vhd")

vu.main()
