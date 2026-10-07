/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005bf660 */

undefined4 * __fastcall FUN_005bf660(undefined4 *param_1)

{
  undefined4 *puVar1;
  int iVar2;
  
  param_1[1] = 0;
  *param_1 = &PTR_DAT_006e97e4;
  *(undefined1 *)((int)param_1 + 0x128e) = 0;
  param_1[2] = &PTR_FUN_006ecc20;
  FUN_005433c0((int)param_1 + 0x1037e,(int)param_1 + 0x2837e,(int)param_1 + 0x2867e,0x30,0x200);
  param_1[2] = &PTR_FUN_006f77b8;
  *(undefined ***)((int)param_1 + 0x2945e) = &PTR_LAB_006f7780;
  *(undefined ***)((int)param_1 + 0x3f996) = &PTR_LAB_006f7750;
  puVar1 = (undefined4 *)((int)param_1 + 0x3fdc6);
  iVar2 = 0x30;
  do {
    *puVar1 = &PTR_LAB_006eccf0;
    puVar1 = puVar1 + 3;
    iVar2 = iVar2 + -1;
  } while (iVar2 != 0);
  puVar1 = (undefined4 *)((int)param_1 + 0x40006);
  iVar2 = 0x30;
  do {
    *puVar1 = &PTR_LAB_006eccf0;
    puVar1 = puVar1 + 3;
    iVar2 = iVar2 + -1;
  } while (iVar2 != 0);
  *(undefined ***)((int)param_1 + 0x3f996) = &PTR_FUN_006f7710;
  *(undefined ***)((int)param_1 + 0x40a56) = &PTR_LAB_006f76e0;
  puVar1 = (undefined4 *)((int)param_1 + 0x40a7b);
  iVar2 = 0xc;
  do {
    *puVar1 = &PTR_LAB_006eccf0;
    puVar1 = puVar1 + 3;
    iVar2 = iVar2 + -1;
  } while (iVar2 != 0);
  *(undefined ***)((int)param_1 + 0x40b13) = &PTR_LAB_006eccf0;
  *(undefined ***)((int)param_1 + 0x40a56) = &PTR_LAB_006f76a0;
  puVar1 = (undefined4 *)((int)param_1 + 0x449a6);
  iVar2 = 0x1a;
  do {
    *(undefined ***)((int)puVar1 + 0x36) = &PTR_LAB_006eccf0;
    *(undefined ***)((int)puVar1 + 0x42) = &PTR_LAB_006eccf0;
    *(undefined ***)((int)puVar1 + 0x4e) = &PTR_LAB_006eccf0;
    *(undefined ***)((int)puVar1 + 0x5a) = &PTR_LAB_006eccf0;
    *puVar1 = &PTR_LAB_006ecd38;
    puVar1 = (undefined4 *)((int)puVar1 + 0x247);
    iVar2 = iVar2 + -1;
  } while (iVar2 != 0);
  *param_1 = &PTR_FUN_006f7690;
  FUN_005bf760();
  return param_1;
}


