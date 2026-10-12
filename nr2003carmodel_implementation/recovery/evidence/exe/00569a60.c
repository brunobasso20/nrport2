/* NR2003.exe @ 00569a60 FUN_00569a60 */

int FUN_00569a60(int *param_1,undefined4 param_2)

{
  char cVar1;
  int iVar2;
  int iVar3;
  float *pfVar4;
  int local_4;
  
  local_4 = 0;
  iVar2 = *param_1;
  if (0 < iVar2) {
    iVar3 = 1;
    pfVar4 = (float *)(param_1 + 1);
    do {
      cVar1 = FUN_00569ad0(pfVar4[3] + *pfVar4,param_2,
                           *(float *)((int)param_1 + (iVar3 % iVar2) * 0x39 + 0x10) +
                           *(float *)((int)param_1 + (iVar3 % iVar2) * 0x39 + 4));
      if (cVar1 != '\0') {
        return local_4;
      }
      iVar2 = *param_1;
      local_4 = local_4 + 1;
      iVar3 = iVar3 + 1;
      pfVar4 = (float *)((int)pfVar4 + 0x39);
    } while (local_4 < iVar2);
  }
  return 0;
}

