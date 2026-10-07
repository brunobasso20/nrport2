/* NR2003.exe @ 00558530 FUN_00558530 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 __thiscall
FUN_00558530(int param_1_00,int param_1,char param_3,float param_4,float param_5)

{
  short *psVar1;
  float fVar2;
  int iVar3;
  int iVar4;
  undefined4 uVar5;
  
  psVar1 = *(short **)((int)&DAT_00c05152 + param_1 * 6);
  fVar2 = (float)(**(code **)(psVar1 + 0xb))(*(undefined4 *)(param_1_00 + param_1 * 4));
  if (*psVar1 == 3) {
    iVar3 = ((int)fVar2 - *(int *)(psVar1 + 1)) / *(int *)(psVar1 + 5);
  }
  else {
    iVar3 = (int)ROUND((fVar2 - *(float *)(psVar1 + 1)) / *(float *)(psVar1 + 5) + _DAT_006ea4cc);
  }
  iVar4 = iVar3 + 1;
  if (param_3 == '\0') {
    iVar4 = iVar3 + -1;
  }
  if (*psVar1 == 4) {
    fVar2 = (float)iVar4 * *(float *)(psVar1 + 5) + *(float *)(psVar1 + 1);
  }
  else {
    fVar2 = (float)(*(int *)(psVar1 + 5) * iVar4 + *(int *)(psVar1 + 1));
  }
  if (((int)fVar2 < (int)param_4) || (param_4 = param_5, (int)param_5 < (int)fVar2)) {
    fVar2 = param_4;
  }
  if (*psVar1 == 3) {
    iVar4 = ((int)fVar2 - *(int *)(psVar1 + 1)) / *(int *)(psVar1 + 5);
  }
  else {
    iVar4 = (int)ROUND((fVar2 - *(float *)(psVar1 + 1)) / *(float *)(psVar1 + 5) + _DAT_006ea4cc);
  }
  if (iVar4 != iVar3) {
    uVar5 = (**(code **)(psVar1 + 9))(fVar2);
    *(undefined4 *)(param_1_00 + param_1 * 4) = uVar5;
    return 1;
  }
  return 0;
}

