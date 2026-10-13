/* rend_dxg.dll @ 1002cf00 FUN_1002cf00 */

undefined4 __fastcall FUN_1002cf00(int param_1)

{
  int iVar1;
  int iVar2;
  int iVar3;
  undefined4 uVar4;
  undefined4 local_4;

  iVar3 = FUN_1002cad0(1);
  if (iVar3 == 1) {
    iVar3 = *(int *)(param_1 + 0x5c);
    iVar1 = *(int *)(iVar3 + 0x1c);
    iVar2 = *(int *)(iVar3 + 8 + iVar1 * 4);
    if (*(int *)(iVar3 + 0xec) == 0) {
      *(undefined4 *)(iVar2 + 0x2c) = 0;
      *(undefined4 *)(iVar2 + 0x1c) = 0;
      *(undefined4 *)(iVar2 + 0x20) = 1;
    }
    else {
      *(undefined4 *)(iVar2 + 0x2c) = 1;
      *(undefined4 *)(iVar2 + 0x1c) = 1;
      *(undefined4 *)(iVar2 + 0x20) = 0xd2;
      *(undefined4 *)(iVar2 + 0x30) = 5;
      *(undefined4 *)(iVar2 + 0x34) = 6;
    }
    local_4 = 0;
    if ((*(uint *)(param_1 + 0xc) & 4) == 0) {
      if ((*(uint *)(param_1 + 0xc) & 2) == 0) {
        *(undefined4 *)(iVar2 + 8) = 2;
        local_4 = 1;
      }
      else {
        *(undefined4 *)(iVar2 + 8) = 1;
      }
    }
    else {
      *(undefined4 *)(iVar2 + 8) = 0;
    }
    iVar3 = DAT_100b6be4;
    *(undefined4 *)(iVar2 + 0xc) = 1;
    *(int *)(iVar2 + 0x28) = iVar1 + iVar3;
    *(undefined4 *)(iVar2 + 0x18) = 1;
    *(undefined4 *)(iVar2 + 0x24) = 4;
    *(undefined4 *)(iVar2 + 0xbd) = 4;
    *(undefined4 *)(iVar2 + 0xc1) = 2;
    *(undefined4 *)(iVar2 + 0xc5) = 1;
    *(undefined4 *)(iVar2 + 0xc9) = 3;
    *(undefined4 *)(iVar2 + 0xcd) = 2;
    *(undefined4 *)(iVar2 + 0xd1) = 1;
    *(undefined4 *)(iVar2 + 0x7c) = 2;
    *(undefined4 *)(iVar2 + 0x80) = 2;
    *(undefined4 *)(iVar2 + 0x84) = 0;
    *(undefined4 *)(iVar2 + 0x88) = 2;
    *(undefined4 *)(iVar2 + 0x8c) = 2;
    *(undefined4 *)(iVar2 + 0x90) = 0;
    uVar4 = FUN_1002ceb0(2,4,0x10,local_4);
    return uVar4;
  }
  return 0;
}
