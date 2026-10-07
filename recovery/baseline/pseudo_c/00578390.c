/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00578390 */

void __fastcall FUN_00578390(int *param_1)

{
  int iVar1;
  int iVar2;
  float *pfVar3;
  int *piVar4;
  undefined4 uVar5;
  float local_c;
  float local_8;
  float local_4;
  
  iVar1 = *(int *)(*param_1 + 0x14);
  iVar2 = *(int *)(*param_1 + 0xc);
  if (iVar1 == 0) {
    uVar5 = *(undefined4 *)(iVar2 + 0xec);
    pfVar3 = (float *)(iVar2 + 0x98);
    piVar4 = *(int **)(param_1[1] + 8);
  }
  else {
    FUN_005f6d20(&local_c,iVar2 + 0xf0,iVar1);
    iVar1 = *(int *)(*param_1 + 0xc);
    local_c = *(float *)(iVar1 + 0x98) + local_c;
    local_8 = *(float *)(iVar1 + 0x9c) + local_8;
    local_4 = *(float *)(iVar1 + 0xa0) + local_4;
    piVar4 = *(int **)(param_1[1] + 8);
    uVar5 = *(undefined4 *)(*(int *)(*param_1 + 0xc) + 0xec);
    pfVar3 = &local_c;
  }
  (**(code **)(*piVar4 + 0xc))((int)param_1 + 10,pfVar3,uVar5);
  DAT_00d358f4 = (int)param_1 + 10;
  FUN_00577a20();
  return;
}


