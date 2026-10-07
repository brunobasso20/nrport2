/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0055c4b0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0055c4b0(byte *param_1)

{
  char cVar1;
  int iVar2;
  undefined4 uVar3;
  
  if ((*param_1 & 0x40) != 0) {
    cVar1 = FUN_00501480();
    if (cVar1 != '\0') {
      FUN_00501ae0();
    }
    DAT_00c074c0 = getBGCount();
    iVar2 = FUN_0055a5c0();
    FUN_0055a4f0(5);
    FUN_0055a5b0(iVar2);
    if (iVar2 == 3) {
      iVar2 = FUN_0055a610();
      _DAT_00c07fe4 = *(undefined4 *)(iVar2 + 4);
    }
    uVar3 = 0;
    FUN_0055a610(0);
    FUN_00569270(uVar3);
    FUN_005d0910();
    return;
  }
  return;
}


