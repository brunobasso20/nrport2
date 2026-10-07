/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005bfdd0 */

undefined4 * __fastcall FUN_005bfdd0(undefined4 *param_1)

{
  undefined4 *puVar1;
  int iVar2;
  
  param_1[1] = 0;
  *param_1 = &PTR_DAT_006e97e4;
  *(undefined1 *)((int)param_1 + 0x128e) = 0;
  param_1[2] = &PTR_FUN_006ecc20;
  iVar2 = 6;
  do {
    FUN_005c1f60();
    iVar2 = iVar2 + -1;
  } while (iVar2 != 0);
  FUN_00401fc0(param_1 + 0x291b2,0x1054,8,FUN_004e32d0);
  param_1[2] = &PTR_FUN_006f78d8;
  *(undefined ***)((int)param_1 + 0xac9aa) = &PTR_LAB_006ecdcc;
  *(undefined4 *)((int)param_1 + 0xad483) = 0;
  *(undefined4 *)((int)param_1 + 0xad487) = 0;
  *(undefined4 *)((int)param_1 + 0xb6c8b) = 0x8000;
  *(undefined ***)((int)param_1 + 0xaca92) = &PTR_FUN_006ece00;
  *(undefined ***)((int)param_1 + 0xb6d1a) = &PTR_LAB_006ece80;
  *(undefined ***)((int)param_1 + 0xb6c8f) = &PTR_LAB_006ecf68;
  puVar1 = (undefined4 *)((int)param_1 + 0xb6d2a);
  iVar2 = 0xc;
  do {
    *puVar1 = &PTR_LAB_006ece80;
    puVar1 = puVar1 + 3;
    iVar2 = iVar2 + -1;
  } while (iVar2 != 0);
  *(undefined ***)((int)param_1 + 0xb6dba) = &PTR_LAB_006ece80;
  *(undefined ***)((int)param_1 + 0xb6c8f) = &PTR_LAB_006f78a0;
  *(undefined ***)((int)param_1 + 0xb6df6) = &PTR_LAB_006f7860;
  *(undefined ***)((int)param_1 + 0xb70a5) = &PTR_LAB_006f7820;
  puVar1 = (undefined4 *)((int)param_1 + 0xb70c9);
  iVar2 = 0x1a;
  do {
    *(undefined ***)((int)puVar1 + 0x8b) = &PTR_LAB_006ece80;
    *puVar1 = &PTR_LAB_006ecf68;
    puVar1 = (undefined4 *)((int)puVar1 + 0x9b);
    iVar2 = iVar2 + -1;
  } while (iVar2 != 0);
  *param_1 = &PTR_FUN_006f7814;
  FUN_005bfee0();
  return param_1;
}


