/* NR2003.exe @ 00527580 FUN_00527580 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall
FUN_00527580(int param_1_00,float param_1,float param_2,float param_3,float param_4,float *param_5,
            float *param_6,float *param_7)

{
  int iVar1;
  int iVar2;
  float10 fVar3;
  
  fVar3 = (float10)FUN_0051700a(param_1);
  iVar2 = (int)ROUND((float)((float10)_DAT_00bd7914 * fVar3)) * 0x40;
  iVar1 = (int)ROUND((float)((float10)_DAT_00bd7914 * fVar3)) * 0x1c;
  *param_5 = *(float *)(iVar2 + *(int *)(param_1_00 + 0x18) + 0xc) * param_4 +
             *(float *)(iVar2 + 4 + *(int *)(param_1_00 + 0x18)) * param_3 +
             *(float *)(iVar1 + 0x14 + *(int *)(param_1_00 + 0xc));
  iVar2 = iVar2 + *(int *)(param_1_00 + 0x18);
  *param_6 = *(float *)(iVar2 + 0x18) * param_4 + *(float *)(iVar2 + 0x14) * param_3 +
             *(float *)(iVar1 + 0xc + *(int *)(param_1_00 + 0xc));
  fVar3 = (float10)FUN_0051700a(param_2 * _DAT_006f50ec + param_1);
  iVar1 = (int)ROUND((float)((float10)_DAT_00bd7914 * fVar3)) * 0x40 + *(int *)(param_1_00 + 0x18);
  *param_7 = *(float *)(iVar1 + 0x20) * param_4 +
             *(float *)(iVar1 + 0x1c) * param_3 +
             *(float *)(*(int *)(param_1_00 + 0xc) + 0x10 +
                       (int)ROUND((float)((float10)_DAT_00bd7914 * fVar3)) * 0x1c);
  return;
}

