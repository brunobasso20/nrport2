/* rend_dxg.dll @ 10029f60 recovered_10029f60 */

void __fastcall recovered_10029f60(int param_1)

{
  uint uVar1;
  int iVar2;
  uint uVar3;
  int iVar4;
  char cVar5;

  if (*(char *)(param_1 + 0x94) == '\0') {
    FUN_10054a20();
    iVar4 = *(int *)PTR_DAT_100aaf3c;
    uVar1 = __ftol();
    uVar3 = __ftol();
    uVar3 = uVar1 & 0xff | (uVar3 | 0xffffff00) << 8;
    uVar1 = __ftol();
  }
  else {
    iVar4 = *(int *)PTR_DAT_100aaf3c;
    uVar1 = __ftol();
    iVar2 = __ftol();
    uVar3 = __ftol();
    uVar3 = (uVar1 & 0xff | iVar2 << 8) << 8 | uVar3 & 0xff;
    uVar1 = __ftol();
  }
  (**(code **)(iVar4 + 8))(0x22,uVar3 << 8 | uVar1 & 0xff);
  (**(code **)(*(int *)PTR_DAT_100aaf3c + 8))(0xf,*(undefined4 *)(param_1 + 0x1c));
  (**(code **)(*(int *)PTR_DAT_100aaf3c + 8))(0x18,*(undefined4 *)(param_1 + 0x20));
  (**(code **)(*(int *)PTR_DAT_100aaf3c + 8))(0xe,*(undefined4 *)(param_1 + 0x18));
  (**(code **)(*(int *)PTR_DAT_100aaf3c + 8))(0x17,*(undefined4 *)(param_1 + 0x24));
  (**(code **)(*(int *)PTR_DAT_100aaf3c + 8))(0x2f,*(undefined4 *)(param_1 + 0x28));
  (**(code **)(*(int *)PTR_DAT_100aaf3c + 8))(0x1b,*(undefined4 *)(param_1 + 0x2c));
  (**(code **)(*(int *)PTR_DAT_100aaf3c + 8))(0x13,*(undefined4 *)(param_1 + 0x30));
  (**(code **)(*(int *)PTR_DAT_100aaf3c + 8))(0x14,*(undefined4 *)(param_1 + 0x34));
  (**(code **)(*(int *)PTR_DAT_100aaf3c + 0xc))(0,1,*(undefined4 *)(param_1 + 0x7c));
  (**(code **)(*(int *)PTR_DAT_100aaf3c + 0xc))(0,2,*(undefined4 *)(param_1 + 0x80));
  (**(code **)(*(int *)PTR_DAT_100aaf3c + 0xc))(0,3,*(undefined4 *)(param_1 + 0x84));
  (**(code **)(*(int *)PTR_DAT_100aaf3c + 0xc))(0,4,*(undefined4 *)(param_1 + 0x88));
  cVar5 = '\0';
  (**(code **)(*(int *)PTR_DAT_100aaf3c + 0xc))(0,5,*(undefined4 *)(param_1 + 0x8c));
  (**(code **)(*(int *)PTR_DAT_100aaf3c + 0xc))(0,6,*(undefined4 *)(param_1 + 0x90));
  (**(code **)(*(int *)PTR_DAT_100aaf3c + 0x10))(param_1 + 0x38);
  if (DAT_100ab158 == '\0') {
    (**(code **)(*(int *)PTR_DAT_100aaf3c + 8))(0x89,0);
  }
  else if (*(int *)(param_1 + 8) == 0) {
    FUN_10054d30();
  }
  else {
    if (cVar5 == '\0') {
      (**(code **)(*(int *)PTR_DAT_100aaf3c + 0xc))(0,1,4);
    }
    if (*(int *)(param_1 + 8) == 1) {
      FUN_10054d70();
    }
    else {
      FUN_10054e50();
    }
  }
  if (1 < DAT_100b5c1c) {
    (**(code **)(*(int *)PTR_DAT_100aaf3c + 0xc))(1,1,1);
  }
  if (cVar5 != '\0') {
    (**(code **)(*(int *)PTR_DAT_100aaf3c + 8))(0x3c,0x8080ff);
    (**(code **)(*(int *)PTR_DAT_100aaf3c + 0xc))(1,1,4);
    (**(code **)(*(int *)PTR_DAT_100aaf3c + 0xc))(1,2,1);
    (**(code **)(*(int *)PTR_DAT_100aaf3c + 0xc))(1,3,0);
    (**(code **)(*(int *)PTR_DAT_100aaf3c + 0xc))(1,4,2);
    (**(code **)(*(int *)PTR_DAT_100aaf3c + 0xc))(1,5,1);
    (**(code **)(*(int *)PTR_DAT_100aaf3c + 0xc))(1,6,1);
    if (2 < DAT_100b5c20) {
      FUN_1003bd60(2);
      (**(code **)(*(int *)PTR_DAT_100aaf3c + 0xc))(2,1,1);
      (**(code **)(*(int *)PTR_DAT_100aaf3c + 0xc))(2,4,1);
    }
    if (3 < DAT_100b5c20) {
      FUN_1003bd60(3);
      (**(code **)(*(int *)PTR_DAT_100aaf3c + 0xc))(3,1,1);
      (**(code **)(*(int *)PTR_DAT_100aaf3c + 0xc))(3,4,1);
    }
  }
  if ((*(int *)(param_1 + 0x10) == 0) && ((DAT_100ab158 == '\0' || (*(int *)(param_1 + 8) == 0)))) {
    DAT_100b6be0 = 0;
  }
  else {
    DAT_100b6be0 = 1;
  }
  DAT_100aaca0 = *(undefined4 *)(param_1 + 0x14);
  (**(code **)(*(int *)PTR_DAT_100aaf3c + 0xc))(0,7,0);
  (**(code **)(*(int *)PTR_DAT_100aaf3c + 0xc))(0,8,0);
  (**(code **)(*(int *)PTR_DAT_100aaf3c + 0xc))(0,9,0);
  (**(code **)(*(int *)PTR_DAT_100aaf3c + 0xc))(0,10,0);
  (**(code **)(*(int *)PTR_DAT_100aaf3c + 0xc))(0,0x16,0);
  (**(code **)(*(int *)PTR_DAT_100aaf3c + 0xc))(0,0x17,0);
  return;
}
