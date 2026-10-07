/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004172e0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 __thiscall FUN_004172e0(int param_1_00,int param_1)

{
  int iVar1;
  double dVar2;
  char cVar3;
  int iVar4;
  int iVar5;
  float10 fVar6;
  
  iVar4 = FUN_004f5970(param_1);
  if (((iVar4 != 0) && (iVar1 = *(int *)(iVar4 + 0x5ae), iVar1 != 0)) &&
     (_DAT_006ea514 <= *(float *)(iVar1 + 0x44))) {
    cVar3 = FUN_005354b0(iVar1);
    if (cVar3 == '\0') {
      iVar5 = FUN_004f5970(param_1);
      cVar3 = FUN_00535510(*(undefined4 *)(iVar5 + 0x5ae));
      if ((cVar3 == '\0') && (cVar3 = FUN_00535530(iVar1), cVar3 == '\0')) {
        return 0;
      }
    }
    dVar2 = *(double *)(param_1_00 + 0x45c + param_1 * 8) + _DAT_006e9808;
    fVar6 = (float10)FUN_00509a20();
    if (fVar6 <= (float10)dVar2) {
      if ((*(char *)(iVar4 + 0x59b) != '\0') && (cVar3 = FUN_0052ab90(iVar4), cVar3 != '\0')) {
        return 0;
      }
      return 1;
    }
  }
  return 0;
}


