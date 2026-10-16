/* NR2003.exe @ 004eb1a0 FUN_004eb1a0 */

void __fastcall FUN_004eb1a0(int param_1)

{
  int iVar1;
  int iVar2;
  uint uVar3;

  uVar3 = (uint)(*(char *)(param_1 + 0x7c2) == '\0');
  iVar1 = uVar3 + (uint)(*(char *)(param_1 + 0x7c1) == '\0') * 2;
  iVar2 = param_1 + iVar1 * 0x44;
  *(undefined4 *)(param_1 + 0x794) = *(undefined4 *)(param_1 + 0x70 + iVar1 * 0x44);
  *(int *)(param_1 + 0x790) = iVar2 + 0x30;
  *(undefined4 *)(param_1 + 0x79c) = *(undefined4 *)(iVar2 + 0x180);
  *(int *)(param_1 + 0x798) = iVar2 + 0x140;
  *(undefined4 *)(param_1 + 0x7a4) = *(undefined4 *)(param_1 + 0x290 + uVar3 * 0x44);
  iVar1 = param_1 + uVar3 * 0x44;
  *(int *)(param_1 + 0x7a0) = iVar1 + 0x250;
  *(undefined4 *)(param_1 + 0x7ac) = *(undefined4 *)(iVar1 + 0x318);
  *(int *)(param_1 + 0x7a8) = iVar1 + 0x2d8;
  *(undefined4 *)(param_1 + 0x7b4) = *(undefined4 *)(iVar1 + 0x3a0);
  *(int *)(param_1 + 0x7b0) = iVar1 + 0x360;
  *(undefined4 *)(param_1 + 0x7bc) = *(undefined4 *)(iVar1 + 0x428);
  *(int *)(param_1 + 0x7b8) = iVar1 + 1000;
  return;
}
