/* NR2003.exe @ 005ace70 FUN_005ace70 */

void FUN_005ace70(undefined4 param_1,undefined4 param_2,int param_3)

{
  int iVar1;
  uint uVar2;
  int iVar3;
  undefined4 *puVar4;
  undefined4 *puVar5;
  
  iVar1 = FUN_005aa360(*(uint *)(param_3 + 4) & 0x7f);
  FUN_0054b3e0(param_3);
  uVar2 = *(uint *)(param_3 + 4) & 0x7f;
  if (*(char *)((int)&DAT_00e73464 + uVar2) == '\0') {
    puVar4 = (undefined4 *)(iVar1 + 0x1493);
    puVar5 = &DAT_00e71ec0 + uVar2 * 0x1a;
    for (iVar3 = 0x1a; iVar3 != 0; iVar3 = iVar3 + -1) {
      *puVar5 = *puVar4;
      puVar4 = puVar4 + 1;
      puVar5 = puVar5 + 1;
    }
    *(undefined *)((int)&DAT_00e73464 + (*(uint *)(param_3 + 4) & 0x7f)) = 1;
  }
  return;
}

