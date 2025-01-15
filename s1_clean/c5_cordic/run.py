import os
from vunit import VUnit

def add_test(design_set, tb_set):
    PATH = os.path.abspath(os.path.dirname(__file__))
    PATH_DUT = os.path.join(PATH, "src")
    PATH_TEST = os.path.join(PATH, "tb")

    design_set.update({os.path.join(PATH_DUT, "cordic_pkg.vhd"), os.path.join(PATH_DUT, "cordic.vhd")})
    tb_set.update({os.path.join(PATH_TEST, "cordic_tb.vhd")})

if __name__ == "__main__":
    vu = VUnit.from_argv()
    vu.add_vhdl_builtins()
    vu.enable_location_preprocessing()

    cordic_set = set()
    tb_set = set()
    add_test(cordic_set, tb_set)
    design_lib = vu.add_library("cordic")
    design_lib.add_source_files(list(cordic_set))

    tb_lib = vu.add_library("lib")
    tb_lib.add_source_files(list(tb_set))

    vu.main()
