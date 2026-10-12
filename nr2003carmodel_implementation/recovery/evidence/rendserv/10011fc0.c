/* NR2003.exe @ 10011fc0 recovered_10011fc0 */

void __fastcall recovered_10011fc0(uint param_1)

{
  undefined4 uVar1;
  int iVar2;
  undefined4 uStack_4;
  
  uStack_4 = param_1 & 0xffffff;
  uVar1 = FUN_100244d0(DAT_10042dcc,(float *)(param_1 + 0x10),(char *)((int)&uStack_4 + 3));
  if ((char)uVar1 != '\0') {
    iVar2 = FUN_10011ec0(param_1);
    if (-1 < iVar2) {
      (**(code **)(**(int **)(*(int *)(param_1 + 0x3c) + iVar2 * 4) + 0x10))();
    }
    DAT_10042ab4 = DAT_10042ab4 + -1;
    *(undefined *)((int)DAT_10042dcc + 0x20b0) = uStack_4._3_1_;
  }
  return;
}

