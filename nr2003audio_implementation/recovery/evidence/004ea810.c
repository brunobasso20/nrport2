/* NR2003.exe @ 004ea810 FUN_004ea810 */

undefined4 * __thiscall FUN_004ea810(undefined4 *param_1_00,undefined4 param_1)

{
  undefined4 *puVar1;
  undefined4 *puVar2;
  int iVar3;
  int iVar4;
  undefined4 *puVar5;

  FUN_004ecf90(0x3f800000,0);
  *param_1_00 = &PTR_FUN_006f38fc;
  param_1_00[10] = param_1;
  param_1_00[0x1e8] = 0;
  param_1_00[0x1e9] = 0;
  param_1_00[0x1ea] = 0;
  param_1_00[0x1eb] = 0;
  param_1_00[0x1ec] = 0;
  param_1_00[0x1ed] = 0;
  param_1_00[0x1ee] = 0;
  param_1_00[0x1ef] = 0;
  param_1_00[5] = 0;
  param_1_00[0x1e4] = 0;
  param_1_00[0x1e5] = 0;
  param_1_00[0x1e6] = 0;
  param_1_00[0x1e7] = 0;
  *(undefined *)((int)param_1_00 + 0x7c2) = 1;
  *(undefined *)((int)param_1_00 + 0x7c3) = 0;
  puVar1 = param_1_00 + 0x60;
  iVar4 = 2;
  do {
    iVar3 = 2;
    do {
      puVar1[-0x44] = 0;
      *puVar1 = 0;
      puVar1 = puVar1 + 0x11;
      iVar3 = iVar3 + -1;
    } while (iVar3 != 0);
    iVar4 = iVar4 + -1;
  } while (iVar4 != 0);
  puVar1 = param_1_00 + 0xc6;
  iVar4 = 2;
  do {
    puVar1[-0x22] = 0;
    *puVar1 = 0;
    puVar1[0x22] = 0;
    puVar1[0x44] = 0;
    puVar1 = puVar1 + 0x11;
    iVar4 = iVar4 + -1;
  } while (iVar4 != 0);
  puVar1 = param_1_00 + 0x184;
  puVar2 = param_1_00 + 0x11c;
  puVar5 = param_1_00 + 0x1a5;
  iVar4 = 0x20;
  do {
    *puVar5 = 0;
    *(undefined *)(puVar2 + 3) = 1;
    *puVar2 = 0x3f800000;
    puVar2[1] = 0xffffffff;
    puVar2[2] = 0x3f800000;
    *puVar1 = 0;
    puVar1 = puVar1 + 1;
    puVar5 = puVar5 + 2;
    puVar2 = (undefined4 *)((int)puVar2 + 0xd);
    iVar4 = iVar4 + -1;
  } while (iVar4 != 0);
  *(undefined *)(param_1_00 + 0x1f0) = 0;
  return param_1_00;
}
