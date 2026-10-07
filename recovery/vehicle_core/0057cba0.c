/* Ghidra pseudo-C; NR2003.exe @ 0057cba0 */

void FUN_0057cba0(undefined4 *param_1)

{
  undefined *puVar1;
  
  puVar1 = PTR_DAT_0074fd58 + 4;
  *(undefined4 *)PTR_DAT_0074fd58 = *(undefined4 *)*param_1;
  PTR_DAT_0074fd58 = puVar1;
  if (DAT_00d47d6c == 2) {
    FUN_005b9c10();
    return;
  }
  return;
}

