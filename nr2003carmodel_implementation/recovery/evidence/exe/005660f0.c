/* NR2003.exe @ 005660f0 FUN_005660f0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005660f0(int param_1,undefined4 param_2)

{
  int iVar1;
  
  iVar1 = FUN_005ba130();
  (**(code **)**(undefined4 **)(param_1 + 0xf0))
            (*(undefined4 *)(param_1 + 0x22c),*(undefined4 *)(param_1 + 0x230),
             *(undefined4 *)(iVar1 + 0xd8));
  (**(code **)**(undefined4 **)(param_1 + 0xf8))
            (*(undefined4 *)(param_1 + 0x238),*(undefined4 *)(param_1 + 0x23c),
             *(undefined4 *)(iVar1 + 0xdc));
  (**(code **)(**(int **)(param_1 + 0xf0) + 8))
            (*(float *)(iVar1 + 0xbc) + _DAT_006f5e74,*(undefined4 *)(param_1 + 0x264),
             *(undefined4 *)(iVar1 + 0xe8));
  (**(code **)(**(int **)(param_1 + 0xf8) + 8))
            (*(float *)(iVar1 + 0xbc) + _DAT_006f5e74,*(undefined4 *)(param_1 + 0x270),
             *(undefined4 *)(iVar1 + 0xec));
  (**(code **)**(undefined4 **)(param_1 + 0x100))
            (*(undefined4 *)(param_1 + 0x244),*(undefined4 *)(param_1 + 0x248),
             *(undefined4 *)(iVar1 + 0xe0));
  (**(code **)**(undefined4 **)(param_1 + 0x108))
            (*(undefined4 *)(param_1 + 0x250),*(undefined4 *)(param_1 + 0x254),
             *(undefined4 *)(iVar1 + 0xe4));
  (**(code **)(**(int **)(param_1 + 0x100) + 8))
            (*(float *)(param_1 + 0x274) + _DAT_006f5e74,*(undefined4 *)(param_1 + 0x27c),
             *(undefined4 *)(iVar1 + 0xf0));
  (**(code **)(**(int **)(param_1 + 0x108) + 8))
            (*(float *)(param_1 + 0x280) + _DAT_006f5e74,*(undefined4 *)(param_1 + 0x288),
             *(undefined4 *)(iVar1 + 0xf4));
  FUN_00566240(param_1,param_2);
  return;
}

