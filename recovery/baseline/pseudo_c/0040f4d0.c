/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0040f4d0 */

void __fastcall FUN_0040f4d0(int param_1)

{
  undefined4 uVar1;
  
  if (*(char *)(param_1 + 0xb42) != '\0') {
    if (*(char *)(param_1 + 0xf7) == '\0') {
      FUN_00520030(9,0);
      FUN_00520030(9,0);
      FUN_00520030(9,0);
      FUN_00520030(9,0);
      uVar1 = 9;
    }
    else {
      FUN_00520030(7,0);
      FUN_00520030(8,0);
      FUN_00520030(7,0);
      FUN_00520030(8,0);
      FUN_00520030(7,0);
      FUN_00520030(8,0);
      if (*(char *)(param_1 + 0xb43) == '\0') {
        FUN_00520030(3,0);
        uVar1 = 3;
      }
      else {
        FUN_00520030(7,0);
        FUN_00520030(8,0);
        FUN_00520030(7,0);
        uVar1 = 8;
      }
    }
    FUN_00520030(uVar1,0);
  }
  if (*(char *)(param_1 + 0xb44) != '\0') {
    FUN_00520030(9,0);
    FUN_00520030(9,0);
  }
  FUN_00520030(0x10,0);
  return;
}


