/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0052bf80 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_0052bf80(int param_1_00,int param_1)

{
  undefined4 uVar1;
  float10 fVar2;
  
  uVar1 = (**(code **)(**(int **)(param_1 + 0x13b3) + 0x4c))(param_1);
  *(undefined4 *)(param_1_00 + 0x1bce) = uVar1;
  fVar2 = (float10)FUN_0051700a(_DAT_0074b308 * *(float *)(param_1_00 + 0x1872) +
                                *(float *)(param_1_00 + 0x186a));
  (**(code **)(**(int **)(param_1_00 + 0x1bce) + 0x10))
            (param_1,param_1_00 + 0x1bd2,param_1_00 + 0x1bd6,
             (int)ROUND((float)((float10)_DAT_00bd79d0 * fVar2)),
             _DAT_0074b320 * *(float *)(param_1_00 + 0x188a) + *(float *)(param_1_00 + 0x1886));
  return;
}


