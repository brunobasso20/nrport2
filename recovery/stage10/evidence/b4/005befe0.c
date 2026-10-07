/* NR2003.exe @ 005befe0 FUN_005befe0 */

undefined4 * __fastcall FUN_005befe0(undefined4 *param_1)

{
  undefined4 uVar1;
  int iVar2;
  undefined4 *puVar3;
  
  puVar3 = param_1 + 0x12e;
  param_1[1] = 0;
  *param_1 = &PTR_DAT_006e97e4;
  param_1[4] = 0;
  param_1[3] = 0;
  FUN_004f67d0();
  uVar1 = FUN_004f6900();
  param_1[0x130] = uVar1;
  uVar1 = FUN_004f6900();
  *puVar3 = uVar1;
  uVar1 = FUN_004f6900();
  param_1[0x12f] = uVar1;
  FUN_004f68c0(param_1[0x130],4);
  *(undefined4 *)*puVar3 = *(undefined4 *)param_1[0x130];
  FUN_00425e80(param_1[0x12f],*puVar3,&DAT_00f72118,4);
  FUN_005f5870(param_1 + 0x131,0x20);
  FUN_004f6320();
  FUN_004f6560();
  *(undefined4 *)((int)param_1 + 0x1323) = 0xffffffff;
  *(undefined4 *)((int)param_1 + 0x1327) = 0xffffffff;
  puVar3 = (undefined4 *)((int)param_1 + 0x132f);
  for (iVar2 = 0x1a; iVar2 != 0; iVar2 = iVar2 + -1) {
    *puVar3 = 0;
    puVar3 = puVar3 + 1;
  }
  param_1[2] = &PTR_FUN_006f3dc4;
  *(undefined *)(param_1 + 0x887) = 0;
  *param_1 = &PTR_LAB_006f766c;
  *(undefined4 *)((int)param_1 + 0x1a7e) = 0;
  return param_1;
}

