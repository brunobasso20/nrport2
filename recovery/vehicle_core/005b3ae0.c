/* Ghidra pseudo-C; NR2003.exe @ 005b3ae0 */

void FUN_005b3ae0(int param_1,int param_2,undefined4 param_3)

{
  uint uVar1;
  int iVar2;
  
  uVar1 = *(uint *)(param_1 + 0x40);
  if (((uVar1 & 0x18) == 0) && ((int)(((int)uVar1 >> 7 & 7U) - 1) < 3)) {
    if ((uVar1 & 0x20) != 0) {
      (**(code **)PTR_PTR_0074fe4c)(&DAT_00e84614,&PTR_DAT_0074fd80);
      FUN_005b7df0(&DAT_00e84608,&PTR_DAT_0074fd90,param_2 + 0xc);
      FUN_005b7df0(&DAT_00e84608,param_3,&DAT_00e84608);
      FUN_005b9660(&DAT_00e84608,param_1 + 0x275,&DAT_00e84608);
      iVar2 = param_1 + 0x35d;
      FUN_005b9620(iVar2,param_1 + 0x275,&DAT_00e84608);
      FUN_005b9590(iVar2);
      FUN_005b8920(param_1 + 0x2d9,iVar2);
      FUN_005b8260(param_1 + 0x339,param_1 + 0x309,param_1 + 0x2d9);
      return;
    }
  }
  else {
    iVar2 = FUN_005b3c60(param_1);
    if (iVar2 == 0) {
      iVar2 = (*(int *)(param_1 + 0x40) >> 3 & 3U) - 1;
      (**(code **)(PTR_PTR_0074fe48 + 0xc))(&DAT_00e84448,param_3,param_2 + 0xc + iVar2 * 4);
      (**(code **)(PTR_PTR_0074fe48 + 4))(param_1 + 0x35d,param_1 + 0x275,&DAT_00e84448);
    }
    else {
      iVar2 = (*(int *)(param_1 + 0x40) >> 7 & 7U) - 4;
    }
    if ((*(byte *)(param_1 + 0x40) & 0x40) == 0) {
      FUN_005b8b50(param_1 + 0x2d9,iVar2,param_1 + 0x35d);
      FUN_005b8260(param_1 + 0x339,param_1 + 0x309,param_1 + 0x2d9);
      return;
    }
  }
  FUN_005b8180(param_1 + 0x2d9,&PTR_DAT_006f74a8);
  FUN_005b8180(param_1 + 0x339,param_1 + 0x309);
  return;
}

