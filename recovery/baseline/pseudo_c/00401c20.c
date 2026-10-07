/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00401c20 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_00401c20(void)

{
  undefined4 uVar1;
  
  FUN_00415210();
  uVar1 = FUN_00417fc0();
  switch(uVar1) {
  case 0:
  case 1:
  case 2:
    return (float10)_DAT_006e9838;
  case 3:
  case 4:
    return (float10)_DAT_006e9830;
  case 5:
    return (float10)_DAT_006e9808;
  default:
    return (float10)0.0;
  }
}


