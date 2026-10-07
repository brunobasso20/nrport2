/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00522130 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_00522130(int param_1)

{
  bool bVar1;
  char cVar2;
  int *piVar3;
  undefined4 uVar4;
  int iVar5;
  float10 fVar6;
  undefined4 uVar7;
  undefined4 uStack_4;
  
  uStack_4 = param_1;
  if (*(char *)(param_1 + 0x8d) != '\0') {
    piVar3 = (int *)FUN_00538b40();
    (**(code **)(*piVar3 + 0x30))();
    FUN_00538b20();
    FUN_00540870();
  }
  if (*(char *)(param_1 + 0xd4) != '\0') {
    cVar2 = FUN_00521720();
    if (cVar2 == '\0') {
      bVar1 = false;
      uVar4 = (**(code **)(**(int **)(param_1 + 0x89) + 4))();
      if (*(char *)(param_1 + 0xfe) == '\0') {
        iVar5 = FUN_00548b90(uVar4,1);
        if (iVar5 < 2) {
          uVar7 = 3;
          goto LAB_005221b4;
        }
LAB_005221c2:
        bVar1 = true;
      }
      else {
        iVar5 = FUN_00548b90(uVar4,0);
        if (1 < iVar5) goto LAB_005221c2;
        uVar7 = 2;
LAB_005221b4:
        iVar5 = FUN_00548b90(uVar4,uVar7);
        if (1 < iVar5) goto LAB_005221c2;
      }
      uStack_4 = CONCAT13(1,(undefined3)uStack_4);
      if (*(char *)(param_1 + 0x8d) == '\0') {
        (**(code **)(*DAT_00bdb9d8 + 0x1c))
                  (*(undefined4 *)(*(int *)(param_1 + 0x89) + 0x5b2),(int)&uStack_4 + 3);
      }
      else {
        piVar3 = (int *)FUN_00538b40();
        (**(code **)(*piVar3 + 0x38))((int)&uStack_4 + 3);
      }
      if ((uStack_4._3_1_ != '\0') && (!bVar1)) {
        if (*(char *)(param_1 + 0xfe) == '\0') {
          FUN_00523520(0,1);
        }
        else {
          FUN_005234b0(0,1);
        }
        if (((*(char *)(param_1 + 0x8d) != '\0') && (*(char *)(param_1 + 0x10d) != '\0')) &&
           (*(char *)(param_1 + 0x111) != '\0')) {
          if (*(char *)(param_1 + 0xfe) == '\0') {
            FUN_0040ed10();
          }
          else {
            FUN_0040ed00();
          }
        }
      }
    }
  }
  FUN_00520260();
  if (*(char *)(param_1 + 0x8d) != '\0') {
    iVar5 = thunk_FUN_0055a730();
    if (3 < iVar5) {
      FUN_00538b40();
      cVar2 = FUN_0053e360();
      if (cVar2 == '\0') goto LAB_005222b2;
    }
    fVar6 = (float10)FUN_00520fb0();
    if ((float10)_DAT_006ecff8 < fVar6) {
      FUN_0040ed70();
    }
  }
LAB_005222b2:
  FUN_0040f620();
  *(undefined1 *)(param_1 + 0x8e) = 1;
  FUN_00521ee0(0);
  *(undefined4 *)(param_1 + 0x93) = 1;
  *(undefined1 *)(param_1 + 0xfc) = 0;
  *(undefined1 *)(param_1 + 0xfd) = 0;
  *(char *)(param_1 + 0xb3c) = *(char *)(param_1 + 0xb3c) + '\x01';
  *(undefined1 *)(param_1 + 0x100) = 0;
  *(undefined1 *)(param_1 + 0x101) = 0;
  *(undefined1 *)(param_1 + 0x102) = 0;
  *(undefined1 *)(param_1 + 0x103) = 0;
  *(undefined1 *)(param_1 + 0x87) = 0;
  return;
}


