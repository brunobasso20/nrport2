/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b4cc0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005b4cc0(float *param_1,float *param_2)

{
  char cVar1;
  float fVar2;
  char cVar3;
  char cVar4;
  int iVar5;
  float *pfVar6;
  
  pfVar6 = param_1;
  for (iVar5 = 0xe; fVar2 = _DAT_00ebbd80, iVar5 != 0; iVar5 = iVar5 + -1) {
    *pfVar6 = *param_2;
    param_2 = param_2 + 1;
    pfVar6 = pfVar6 + 1;
  }
  param_1[6] = (param_1[6] - param_1[3]) * _DAT_00ebbd80 + param_1[3];
  param_1[7] = (param_1[7] - param_1[4]) * fVar2 + param_1[4];
  param_1[8] = (param_1[8] - param_1[5]) * fVar2 + param_1[5];
  param_1[9] = (param_1[9] - *param_1) * fVar2 + *param_1;
  param_1[10] = (param_1[10] - param_1[1]) * fVar2 + param_1[1];
  param_1[0xb] = (param_1[0xb] - param_1[2]) * fVar2 + param_1[2];
  cVar4 = *(char *)((int)param_1 + 0x31);
  cVar3 = FUN_006c5018();
  cVar1 = *(char *)(param_1 + 0xc);
  *(char *)((int)param_1 + 0x32) = cVar3 + cVar4;
  cVar4 = FUN_006c5018();
  *(char *)((int)param_1 + 0x33) = cVar4 + cVar1;
  return;
}


