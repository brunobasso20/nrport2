/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004f5f70 */

bool FUN_004f5f70(int *param_1)

{
  int *extraout_EDX;
  
  do {
    FUN_004f5f40(param_1);
    if (*extraout_EDX == 0) break;
    param_1 = extraout_EDX;
  } while (*(char *)(*extraout_EDX + 0x59a) == '\0');
  return *extraout_EDX != 0;
}


