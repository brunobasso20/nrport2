/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00536690 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00536690(undefined4 param_1,undefined4 *param_2,undefined4 param_3)

{
  int iVar1;
  undefined4 *puVar2;
  int iVar3;
  float10 fVar4;
  float local_8;
  int local_4;
  
  local_4 = -1;
  local_8 = 10.0;
  iVar3 = 0;
  iVar1 = FUN_00536170();
  if (0 < iVar1) {
    do {
      puVar2 = (undefined4 *)FUN_00536280(iVar3);
      fVar4 = (float10)FUN_00516d3a(*puVar2,*param_2);
      fVar4 = fVar4 * fVar4 +
              ((float10)(float)puVar2[1] - (float10)(float)param_2[1]) *
              ((float10)(float)puVar2[1] - (float10)(float)param_2[1]);
      if ((fVar4 < (float10)local_8) &&
         (local_8 = (float)fVar4, local_4 = iVar3, fVar4 < (float10)_DAT_006e97d8)) break;
      iVar3 = iVar3 + 1;
      iVar1 = FUN_00536170();
    } while (iVar3 < iVar1);
    if (-1 < local_4) {
      FUN_00536760(param_1,param_2,local_4,param_3);
      return;
    }
  }
  FUN_00536760(param_1,param_2,0xffffec78,param_3);
  return;
}


