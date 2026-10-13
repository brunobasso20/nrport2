/* rend_dxg.dll @ 1002ceb0 FUN_1002ceb0 */

undefined4 __thiscall
FUN_1002ceb0(int param_1_00,undefined4 param_1,undefined4 param_2,undefined4 param_3,
            undefined param_4)

{
  undefined4 *puVar1;
  int iVar2;

  iVar2 = *(int *)(param_1_00 + 0x5c);
  puVar1 = (undefined4 *)(iVar2 + 0x24 + *(int *)(iVar2 + 0x1c) * 0x1c);
  *(undefined *)(puVar1 + 2) = param_4;
  *puVar1 = param_3;
  puVar1[1] = 2;
  *(undefined *)((int)puVar1 + 9) = 0;
  puVar1[3] = param_1;
  puVar1[4] = param_2;
  *(int *)(iVar2 + 0x1c) = *(int *)(iVar2 + 0x1c) + 1;
  return 1;
}
