/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00577fa0 */

void __fastcall FUN_00577fa0(int *param_1)

{
  float *pfVar1;
  int iVar2;
  int iVar3;
  undefined4 *puVar4;
  undefined4 *puVar5;
  
  if (*(int *)(param_1[1] + 0xc) != 0) {
    FUN_005f6c90((int)param_1 + 10,*(int *)(param_1[1] + 0xc) + 0xf0,*(int *)(*param_1 + 0xc) + 0xf0
                );
    iVar2 = *(int *)(param_1[1] + 0xc);
    iVar3 = *(int *)(*param_1 + 0xc);
    pfVar1 = (float *)((int)param_1 + 0x2e);
    *pfVar1 = *(float *)(iVar3 + 0x98) - *(float *)(iVar2 + 0x98);
    *(float *)((int)param_1 + 0x32) = *(float *)(iVar3 + 0x9c) - *(float *)(iVar2 + 0x9c);
    *(float *)((int)param_1 + 0x36) = *(float *)(iVar3 + 0xa0) - *(float *)(iVar2 + 0xa0);
    FUN_005f6dc0(pfVar1,*(int *)(param_1[1] + 0xc) + 0xf0,pfVar1);
    return;
  }
  iVar2 = *param_1;
  puVar4 = (undefined4 *)(*(int *)(iVar2 + 0xc) + 0xf0);
  puVar5 = (undefined4 *)((int)param_1 + 10);
  for (iVar3 = 9; iVar3 != 0; iVar3 = iVar3 + -1) {
    *puVar5 = *puVar4;
    puVar4 = puVar4 + 1;
    puVar5 = puVar5 + 1;
  }
  iVar2 = *(int *)(iVar2 + 0xc);
  *(undefined4 *)((int)param_1 + 0x2e) = *(undefined4 *)(iVar2 + 0x98);
  *(undefined4 *)((int)param_1 + 0x32) = *(undefined4 *)(iVar2 + 0x9c);
  *(undefined4 *)((int)param_1 + 0x36) = *(undefined4 *)(iVar2 + 0xa0);
  return;
}


