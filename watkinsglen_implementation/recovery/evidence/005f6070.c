/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005f6070 */

void FUN_005f6070(undefined4 *param_1,undefined4 *param_2)

{
  int iVar1;
  undefined4 *puVar2;

  puVar2 = param_1;
  for (iVar1 = 0x26; iVar1 != 0; iVar1 = iVar1 + -1) {
    *puVar2 = *param_2;
    param_2 = param_2 + 1;
    puVar2 = puVar2 + 1;
  }
  FUN_005f5f10(param_1);
  param_1[0x58] = 0;
  param_1[0x59] = 0;
  param_1[0x5a] = 0;
  param_1[0x5b] = 0;
  param_1[0x5c] = 0;
  param_1[0x5d] = 0;
  return;
}
