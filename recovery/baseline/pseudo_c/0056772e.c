/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0056772e */

void FUN_0056772e(undefined2 *param_1)

{
  undefined2 in_FPUControlWord;
  undefined2 in_FPUStatusWord;
  undefined2 in_FPUTagWord;
  undefined2 in_FPULastInstructionOpcode;
  undefined4 in_FPUDataPointer;
  undefined4 in_FPUInstructionPointer;
  unkbyte10 in_ST0;
  unkbyte10 in_ST1;
  unkbyte10 in_ST2;
  unkbyte10 in_ST3;
  unkbyte10 in_ST4;
  unkbyte10 in_ST5;
  unkbyte10 in_ST6;
  unkbyte10 in_ST7;
  
  *param_1 = in_FPUControlWord;
  param_1[2] = in_FPUStatusWord;
  param_1[4] = in_FPUTagWord;
  *(undefined4 *)(param_1 + 10) = in_FPUDataPointer;
  *(undefined4 *)(param_1 + 6) = in_FPUInstructionPointer;
  param_1[9] = in_FPULastInstructionOpcode;
  *(unkbyte10 *)(param_1 + 0xe) = in_ST0;
  *(unkbyte10 *)(param_1 + 0x13) = in_ST1;
  *(unkbyte10 *)(param_1 + 0x18) = in_ST2;
  *(unkbyte10 *)(param_1 + 0x1d) = in_ST3;
  *(unkbyte10 *)(param_1 + 0x22) = in_ST4;
  *(unkbyte10 *)(param_1 + 0x27) = in_ST5;
  *(unkbyte10 *)(param_1 + 0x2c) = in_ST6;
  *(unkbyte10 *)(param_1 + 0x31) = in_ST7;
  return;
}


