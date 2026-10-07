/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00578050 */

void __fastcall FUN_00578050(int *param_1)

{
  int iVar1;
  int iVar2;
  float local_c;
  float local_8;
  float local_4;
  
  iVar1 = (int)param_1 + 10;
  iVar2 = *(int *)(*param_1 + 0x14);
  if (iVar2 != 0) {
    FUN_005f6d20(&local_c,iVar1,iVar2);
    local_c = *(float *)((int)param_1 + 0x2e) + local_c;
    local_8 = *(float *)((int)param_1 + 0x32) + local_8;
    local_4 = *(float *)((int)param_1 + 0x36) + local_4;
    (**(code **)(**(int **)(param_1[1] + 8) + 0xc))
              (iVar1,&local_c,*(undefined4 *)(*(int *)(*param_1 + 0xc) + 0xec));
    DAT_00d358f4 = iVar1;
    FUN_005778a0();
    return;
  }
  (**(code **)(**(int **)(param_1[1] + 8) + 0xc))
            (iVar1,(int)param_1 + 0x2e,*(undefined4 *)(*(int *)(*param_1 + 0xc) + 0xec));
  DAT_00d358f4 = iVar1;
  FUN_005778a0();
  return;
}


