/* Ghidra pseudo-C; NR2003.exe @ 0057cd70 */

void FUN_0057cd70(undefined4 *param_1,undefined4 param_2,undefined4 *param_3)

{
  int iVar1;
  undefined4 *puVar2;
  undefined8 uVar3;
  
  iVar1 = FUN_0057c890(param_2);
  if (iVar1 != 0) {
    uVar3 = FUN_0057c8d0();
    puVar2 = (undefined4 *)((ulonglong)uVar3 >> 0x20);
    if ((int)uVar3 != 0) {
      FUN_0057d040(param_1,puVar2);
      return;
    }
    FUN_0057c990(param_1,*(float *)*puVar2 + *(float *)*param_3);
    FUN_0057ce40(*param_1);
    return;
  }
  uVar3 = FUN_0057c890(param_3);
  puVar2 = (undefined4 *)((ulonglong)uVar3 >> 0x20);
  if ((int)uVar3 == 0) {
    FUN_0057ca60(param_1,*(float *)*puVar2 + *(float *)*param_3);
    FUN_0057ce40(*param_1);
    return;
  }
  uVar3 = FUN_0057c8d0(puVar2);
  if ((int)uVar3 != 0) {
    FUN_0057d040(param_1,param_3);
    return;
  }
  FUN_0057c990(param_1,*(float *)*(undefined4 *)((ulonglong)uVar3 >> 0x20) + *(float *)*param_3);
  FUN_0057ce40(*param_1);
  return;
}

