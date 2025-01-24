## Run the code ##
`./run.sh`

## Exercise ##

Change the counter module into timer module.

Following specification is expected:

REQ-01: 
- resolution of timer module is defined by 8bit unsigned prescaler, 
- dynamic re-confiugration of prescaler (i.e. it's input port, not generic),

Example, for 100MHz clock (10ns period), when prescaler (whatever the exact encoding) 
is equal to 100, the effective resolution of timer is 1000ns 

REQ-02:
- 32bit timer output in decremental mode

REQ-03:
- start from zero on overflow

REQ-04:
- load, clear and hold commands