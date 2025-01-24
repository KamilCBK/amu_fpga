CPU description:

1. 16bit data and addresses
2. implements 4 registers
   1. i1 - input operand
   2. i2 - input operand
   3. r1 - result or load to mem
   4. a1 - addr for load/store
3. implements following operations
   1. "0000" - NOP (do nothing)
   2. "0001" - load input IN into reg i1
   3. "0010" - load input IN into reg i2
   4. "0101" - load mem from address a1 into i1
   5. "0110" - load mem from address a1 into i2
   6. "0111" - store r1 to mem at address a1
   7. "1001" - add i1 and i2, result in r1
   8. "1010" - sub i2 from i1, result in r1