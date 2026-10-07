/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00570080 */

undefined4 FUN_00570080(int param_1)

{
  char cVar1;
  uint uVar2;
  
  cVar1 = FUN_005f8da0(&DAT_00c69104);
  if ((cVar1 != '\0') && (param_1 != 0)) {
    uVar2 = FUN_006c5c1a(param_1);
    if (uVar2 < 0x400) {
      FUN_006c5ac2(&DAT_00c6fb68,param_1);
      FUN_005f8e20(&DAT_00c69104);
      return 1;
    }
  }
  return 0;
}


