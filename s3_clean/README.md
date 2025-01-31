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
   4. "0011" - load input IN into reg a1
   5. "0101" - load mem from address a1 into i1
   6. "0110" - load mem from address a1 into i2
   7. "0111" - store r1 to mem at address a1
   8. "1001" - add i1 and i2, result in r1
   9. "1010" - sub i2 from i1, result in r1
   10. "1011" - mul i1 and i2, result in r1
   11. "1101" - copy a1 to i1
   12. "1110" - load r1 to a1 