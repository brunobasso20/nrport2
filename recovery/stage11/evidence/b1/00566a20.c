/* NR2003.exe @ 00566a20 FUN_00566a20 */

bool FUN_00566a20(int *param_1)

{
  int *extraout_EDX;
  
  do {
    FUN_005669f0(param_1);
    if (*extraout_EDX == 0) break;
    param_1 = extraout_EDX;
  } while (*(char *)(*extraout_EDX + 0x59a) == '\0');
  return *extraout_EDX != 0;
}

