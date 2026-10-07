/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00509630 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00509630(int param_1)

{
  char cVar1;
  undefined4 uVar2;
  int iVar3;
  int *piVar4;
  int *piVar5;
  int iVar6;
  int *piVar7;
  float10 fVar8;
  undefined4 *puVar9;
  undefined4 *puStack_7c;
  float fStack_78;
  float fStack_74;
  uint uStack_70;
  undefined4 uStack_6c;
  int aiStack_68 [26];
  
  iVar6 = 0;
  if (param_1 == 0) {
    DAT_00b8f1f0 = 0;
  }
  DAT_00bebde9 = param_1;
  DAT_00bebded = FUN_00544bb0();
  DAT_00bebdf5 = 0;
  FUN_00509bd0(0);
  FUN_00544de0(FUN_00544c50);
  FUN_00544de0(FUN_00544c70);
  fStack_78 = (float)taskGetRate();
  piVar4 = &DAT_00b33090;
  DAT_00b32e1c = (float)(int)fStack_78;
  iVar3 = 0x30;
  DAT_00b32e18 = _DAT_006e97d8 / DAT_00b32e1c;
  do {
    FUN_0059fa90();
    *piVar4 = iVar6;
    piVar4[0x2e] = 5000;
    iVar6 = iVar6 + 1;
    piVar4 = piVar4 + 0xcb;
    iVar3 = iVar3 + -1;
  } while (iVar3 != 0);
  FUN_00551800();
  iVar6 = 0;
  piVar4 = &DAT_00acdd53;
  do {
    if ((*(char *)((int)piVar4 + -0xd89) != '\0') || (*(char *)((int)piVar4 + -0x1a1) != '\0')) {
      FUN_0054b3c0(*(undefined4 *)((int)piVar4 + -0xd71));
      piVar5 = aiStack_68;
      piVar7 = piVar4;
      for (iVar3 = 0x1a; piVar7 = piVar7 + 1, iVar3 != 0; iVar3 = iVar3 + -1) {
        *piVar7 = *piVar5;
        piVar5 = piVar5 + 1;
      }
      iVar3 = getIntCount();
      *piVar4 = iVar3;
      piVar4[-2] = 0;
      piVar4[-1] = 0;
      piVar4[-2] = -1;
      piVar4[-1] = -1;
      iVar3 = FUN_0055ab00();
      if (iVar6 == iVar3) {
        uVar2 = FUN_00562f70(iVar6);
        uVar2 = FUN_00592db0(uVar2,iVar6);
        FUN_00547ee0(uVar2);
      }
    }
    piVar4 = piVar4 + 0x885;
    iVar6 = iVar6 + 1;
  } while ((int)piVar4 < 0xb34113);
  puStack_7c = (undefined4 *)0x0;
  cVar1 = FUN_004f5f70(&puStack_7c);
  while (cVar1 != '\0') {
    (**(code **)*puStack_7c)();
    FUN_00433cb0(*(int *)((int)puStack_7c + 0x5b2),(int)puStack_7c + 0x58e,
                 &DAT_00b32eec + *(int *)((int)puStack_7c + 0x5b2) * 0x32c);
    puVar9 = puStack_7c;
    fStack_74 = *(float *)((int)puStack_7c + 0x586);
    iVar6 = FUN_00544bf0();
    uStack_6c = 0;
    uStack_70 = (*(uint *)(iVar6 + 0x50) & 3) + 1;
    fStack_78 = (float)uStack_70;
    fVar8 = (float10)FUN_00516e1a();
    puVar9[0x154] = 0;
    puVar9[0x153] =
         (float)(fVar8 * (float10)fStack_78 * (float10)fStack_74 * (float10)_DAT_006ea67c);
    cVar1 = FUN_004f5f70(&puStack_7c);
  }
  FUN_00578610();
  if ((&DAT_00bebda3)[param_1 * 4] == 5) {
    DAT_00c7e77c = 1;
  }
  FUN_00538ad0();
  puVar9 = &DAT_00be0d90;
  uVar2 = FUN_00544be0(&DAT_00be0d90);
  FUN_005a4100(param_1,uVar2,puVar9);
  FUN_00538cc0();
  FUN_0050f1c0();
  iVar6 = FUN_00544bf0();
  if (param_1 < *(int *)(iVar6 + 0x67) + -1) {
    uVar2 = FUN_00544bf0(param_1);
    cVar1 = FUN_0056e7b0(uVar2);
    if (cVar1 != '\0') {
      FUN_00509890();
      FUN_00509630(param_1 + 1);
    }
  }
  return;
}


