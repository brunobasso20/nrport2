/* NR2003.exe @ 0049fd30 FUN_0049fd30 */

void __fastcall FUN_0049fd30(int param_1)

{
  undefined4 uVar1;
  
  if (*(int *)(param_1 + 0x81) != 0) {
    FUN_0043ef20(*(undefined4 *)(*(int *)(param_1 + 0x81) + 0x9b5));
  }
  if (*(int *)(param_1 + 0x125) != 0) {
    FUN_0043f1a0(*(undefined4 *)(*(int *)(param_1 + 0x125) + 0x9b5));
  }
  if (*(int *)(param_1 + 0xd5) != 0) {
    FUN_0043ef80(*(undefined *)(param_1 + 0x132));
  }
  if (*(int **)(param_1 + 0xe5) != (int *)0x0) {
    uVar1 = (**(code **)(**(int **)(param_1 + 0xe5) + 0x84))();
    FUN_0043efc0(uVar1);
  }
  if (*(int **)(param_1 + 0xf5) != (int *)0x0) {
    uVar1 = (**(code **)(**(int **)(param_1 + 0xf5) + 0x84))();
    FUN_0043f010(uVar1);
  }
  if (*(int **)(param_1 + 0x105) != (int *)0x0) {
    uVar1 = (**(code **)(**(int **)(param_1 + 0x105) + 0x84))();
    FUN_0043f060(uVar1);
  }
  if (*(int **)(param_1 + 0x109) != (int *)0x0) {
    uVar1 = (**(code **)(**(int **)(param_1 + 0x109) + 0x84))();
    FUN_0043ef40(uVar1);
  }
  if (*(int *)(param_1 + 0x10d) != 0) {
    FUN_0043ef60(CONCAT31((int3)((uint)*(int *)(param_1 + 0x10d) >> 8),
                          *(int *)(param_1 + 0x143) != 0));
  }
  if (*(int *)(param_1 + 0x111) != 0) {
    FUN_00443000(*(int *)(param_1 + 0x147) != 0);
  }
  if (*(int *)(param_1 + 0x115) != 0) {
    FUN_00443020(CONCAT31((int3)((uint)*(int *)(param_1 + 0x14b) >> 8),
                          *(int *)(param_1 + 0x14b) != 0));
  }
  if (*(int *)(param_1 + 0x119) != 0) {
    FUN_00443040(CONCAT31((int3)((uint)*(int *)(param_1 + 0x119) >> 8),
                          *(int *)(param_1 + 0x14f) != 0));
  }
  if (*(int *)(param_1 + 0x11d) != 0) {
    FUN_00442fc0(*(undefined *)(param_1 + 0x156));
  }
  if (*(int *)(param_1 + 0x121) != 0) {
    FUN_00442fe0(*(undefined *)(param_1 + 0x155));
  }
  return;
}

