/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00582320 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 __thiscall FUN_00582320(int *param_1_00,int *param_1,char param_2)

{
  float fVar1;
  int iVar2;
  int iVar3;
  float *pfVar4;
  
  fVar1 = _DAT_006efe54;
  if (*param_1_00 != 0) {
    *param_1 = *param_1_00;
    *param_1_00 = *(int *)(*param_1_00 + 0xa8);
    iVar2 = *param_1;
    param_1_00[1] = param_1_00[1] + 1;
    *(int *)(iVar2 + 0xa8) = param_1_00[2];
    *(undefined4 *)(iVar2 + 0xac) = 0;
    if (param_1_00[2] == 0) {
      param_1_00[3] = iVar2;
      param_1_00[2] = iVar2;
      return 1;
    }
    *(int *)(param_1_00[2] + 0xac) = iVar2;
    param_1_00[2] = iVar2;
    return 1;
  }
  if (param_2 != '\0') {
    pfVar4 = (float *)param_1_00[2];
    *param_1 = 0;
    if (pfVar4 != (float *)0x0) {
      do {
        if (*pfVar4 < fVar1) {
          fVar1 = *pfVar4;
          *param_1 = (int)pfVar4;
        }
        pfVar4 = (float *)pfVar4[0x2a];
      } while (pfVar4 != (float *)0x0);
      iVar2 = *param_1;
      if (iVar2 != 0) {
        iVar3 = *(int *)(iVar2 + 0x28);
        if ((0 < iVar3) && ((iVar3 < 3 || (iVar3 == 0x10)))) {
          FUN_00582450(iVar2);
        }
        return 1;
      }
    }
  }
  return 0;
}


