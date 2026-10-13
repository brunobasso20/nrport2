/* rend_dxg.dll @ 1002d810 FUN_1002d810 */

undefined4 __fastcall FUN_1002d810(int param_1)

{
  int iVar1;
  int iVar2;
  undefined4 uVar3;

  iVar2 = FUN_1002cad0(0);
  if (iVar2 == 1) {
    iVar2 = *(int *)(*(int *)(param_1 + 0x5c) + 0x1c);
    iVar1 = *(int *)(*(int *)(param_1 + 0x5c) + 8 + iVar2 * 4);
    *(int *)(iVar1 + 0x28) = iVar2 + DAT_100b6be4;
    *(undefined4 *)(iVar1 + 0x9d) = 0x3f800000;
    *(undefined4 *)(iVar1 + 0x99) = 0x3f800000;
    *(undefined4 *)(iVar1 + 0x95) = 0x3f800000;
    *(undefined4 *)(iVar1 + 0xa1) = 0x3f800000;
    *(undefined4 *)(iVar1 + 8) = 0;
    *(undefined4 *)(iVar1 + 0x18) = 0;
    *(undefined4 *)(iVar1 + 0x24) = 4;
    *(undefined4 *)(iVar1 + 0xc) = 1;
    *(undefined4 *)(iVar1 + 0x7c) = 2;
    *(undefined4 *)(iVar1 + 0x80) = 2;
    *(undefined4 *)(iVar1 + 0x84) = 0;
    *(undefined4 *)(iVar1 + 0x88) = 2;
    *(undefined4 *)(iVar1 + 0x8c) = 2;
    *(undefined4 *)(iVar1 + 0x90) = 0;
    *(undefined4 *)(iVar1 + 0x1c) = 0;
    *(undefined4 *)(iVar1 + 0x20) = 1;
    *(undefined4 *)(iVar1 + 0x2c) = 1;
    *(undefined4 *)(iVar1 + 0x30) = 9;
    *(undefined4 *)(iVar1 + 0x34) = 1;
    *(undefined4 *)(iVar1 + 0x10) = 0;
    *(undefined4 *)(iVar1 + 0x14) = 0xffffffff;
    *(undefined *)(iVar1 + 0x94) = 1;
    uVar3 = FUN_1002ce60(4,2,0);
    return uVar3;
  }
  return 0;
}
