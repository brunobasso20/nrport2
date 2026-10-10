/* NR2003.exe @ 005d0140 FUN_005d0140 */

void FUN_005d0140(int param_1,undefined4 *param_2)

{
  int iVar1;
  undefined4 *puVar2;
  
  if ((param_1 != 0) && (param_2 != (undefined4 *)0x0)) {
    puVar2 = &DAT_00f5c988;
    for (iVar1 = param_1; iVar1 != 0; iVar1 = iVar1 + -1) {
      *puVar2 = *param_2;
      param_2 = param_2 + 1;
      puVar2 = puVar2 + 1;
    }
  }
  (&DAT_00f5c988)[param_1] = 0;
  return;
}

