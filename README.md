## Simulation environment 

1. Create `fpga` dir in Your home directory

```
mkdir fpga
cd fpga
```

2. Create and activate python Virtual Environment

```
mkdir venv
python3 -m venv venv
source venv/bin/activate
```

3. Install Vunit

```
pip install vunit_hdl
```
4. Set GHDL as the default simulator

```
export VUNIT_SIMULATOR=ghdl
```

If following error is reported:
```
AssertionError: No known GHDL back-end could be detected from running 'ghdl --version'
```

Check version of ghdl:
```
ghdl --version
```

Output similar to one below should be printed:
```
GHDL 4.1.0 (Ubuntu 4.1.0+dfsg-0ubuntu2) [Dunoon edition]
 Compiled with GNAT Version: 13.2.0
 static elaboration, mcode JIT code generator
Written by Tristan Gingold.
```

Open file `venv/lib/pythonN.N/site-packages/vunit/sim_if/ghdl.py`

Find block of code:
```
mapping = {
    r"mcode code generator": "mcode",
    r"llvm (\d+\.\d+\.\d+ )?code generator": "llvm",
    r"GCC (back-end|\d+\.\d+\.\d+) code generator": "gcc",        
}
```

And modify so it matches output form `ghdl --version` e.g. :

```
mapping = {
    r"mcode JIT code generator": "mcode",
    r"llvm (\d+\.\d+\.\d+ )?code generator": "llvm",
    r"GCC (back-end|\d+\.\d+\.\d+) code generator": "gcc",        
}
```



