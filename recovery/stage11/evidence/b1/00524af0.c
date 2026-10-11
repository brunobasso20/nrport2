/* NR2003.exe @ 00524af0 FUN_00524af0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00524af0(int param_1,int param_2)

{
  float fVar1;
  float10 fVar2;
  undefined4 *puVar3;
  undefined4 *puVar4;
  undefined4 uVar5;
  int iVar6;
  int iVar7;
  int iVar8;
  bool bVar9;
  float10 fVar10;
  
  iVar6 = param_2;
  iVar7 = param_1;
  if (param_2 != 0xff) {
    if (param_2 != *(int *)(&DAT_00bd0e28 + param_1 * 4)) {
      *(int *)(&DAT_00bd0e28 + param_1 * 4) = param_2;
      iVar8 = param_1 * 0x68;
      puVar3 = (undefined4 *)(&DAT_00bd64e8 + iVar8);
      puVar4 = (undefined4 *)FUN_00536280(param_2);
      fVar1 = (float)puVar4[2];
      FUN_005f5960(puVar3,*puVar4,puVar4[1],0);
      fVar10 = (float10)fpatan((float10)*(float *)(&DAT_00bd6520 + iVar8),
                               (float10)*(float *)(&DAT_00bd651c + iVar8));
      fVar10 = fVar10 + (float10)fVar1;
      fVar2 = (float10)_DAT_006ea454;
      *(float *)(&DAT_00bd6540 + iVar8) = (float)fVar10;
      if (fVar10 < fVar2 != (NAN(fVar10) || NAN(fVar2))) {
        do {
          fVar10 = fVar10 + (float10)_DAT_006ee484;
        } while (fVar10 < (float10)_DAT_006ea454 != (NAN(fVar10) || NAN((float10)_DAT_006ea454)));
        *(float *)(&DAT_00bd6540 + iVar8) = (float)fVar10;
      }
      fVar1 = *(float *)(&DAT_00bd6540 + iVar8);
      if (_DAT_006ee484 <= fVar1) {
        do {
          fVar1 = fVar1 - _DAT_006ee484;
        } while (_DAT_006ee484 <= fVar1);
        *(float *)(&DAT_00bd6540 + iVar8) = fVar1;
      }
      *(undefined4 *)(&DAT_00bd6544 + iVar8) = *puVar3;
      *(undefined4 *)(&DAT_00bd6548 + iVar8) = *(undefined4 *)(&DAT_00bd64ec + iVar8);
      *(undefined4 *)(&DAT_00bd654c + iVar8) = *(undefined4 *)(&DAT_00bd6540 + iVar8);
      uVar5 = FUN_00536180(iVar6,&param_1);
      iVar6 = FUN_00536260(uVar5);
      bVar9 = *(char *)(iVar6 + 8) == '\0';
      *(undefined4 *)(&DAT_00bd44ac + iVar8) = *puVar3;
      *(undefined4 *)(&DAT_00bd44a8 + iVar8) = 3;
      *(int *)(&DAT_00bd44d4 + iVar8) = iVar7;
      *(undefined4 *)(&DAT_00bd44b0 + iVar8) = *(undefined4 *)(&DAT_00bd64ec + iVar8);
      *(undefined4 *)(&DAT_00bd44b4 + iVar8) = *(undefined4 *)(&DAT_00bd64f0 + iVar8);
      *(undefined4 *)(&DAT_00bd44b8 + iVar8) = *(undefined4 *)(&DAT_00bd6540 + iVar8);
      *(undefined4 *)(&DAT_00bd44bc + iVar8) = *(undefined4 *)(&DAT_00bd650c + iVar8);
      *(undefined4 *)(&DAT_00bd44c0 + iVar8) = *(undefined4 *)(&DAT_00bd6510 + iVar8);
      *(undefined4 *)(&DAT_00bd44d8 + iVar8) = DAT_0074ba58;
      *(undefined4 *)(&DAT_00bd44c4 + iVar8) = *(undefined4 *)(&DAT_00bd6514 + iVar8);
      *(undefined4 *)(&DAT_00bd44c8 + iVar8) = 0;
      *(undefined4 *)(&DAT_00bd44cc + iVar8) = 0;
      *(undefined4 *)(&DAT_00bd44d0 + iVar8) = 1;
      if (bVar9) {
        *(undefined4 *)(&DAT_00bd44a8 + iVar8) = 7;
      }
      *(undefined4 *)(&DAT_00bd44dc + iVar8) = 1;
      *(int *)(&DAT_00bd4508 + iVar8) = iVar7;
      *(undefined4 *)(&DAT_00bd44e0 + iVar8) = *puVar3;
      *(undefined4 *)(&DAT_00bd44e4 + iVar8) = *(undefined4 *)(&DAT_00bd64ec + iVar8);
      *(undefined4 *)(&DAT_00bd44e8 + iVar8) = *(undefined4 *)(&DAT_00bd64f0 + iVar8);
      *(undefined4 *)(&DAT_00bd44ec + iVar8) = *(undefined4 *)(&DAT_00bd6540 + iVar8);
      *(undefined4 *)(&DAT_00bd44f0 + iVar8) = *(undefined4 *)(&DAT_00bd650c + iVar8);
      *(undefined4 *)(&DAT_00bd44f4 + iVar8) = *(undefined4 *)(&DAT_00bd6510 + iVar8);
      *(undefined4 *)(&DAT_00bd44f8 + iVar8) = *(undefined4 *)(&DAT_00bd6514 + iVar8);
      *(undefined4 *)(&DAT_00bd450c + iVar8) = DAT_0074ba5c;
      *(undefined4 *)(&DAT_00bd44fc + iVar8) = 0;
      *(undefined4 *)(&DAT_00bd4500 + iVar8) = 0;
      *(undefined4 *)(&DAT_00bd4504 + iVar8) = 0;
      if (bVar9) {
        *(undefined4 *)(&DAT_00bd44dc + iVar8) = 5;
      }
    }
    return;
  }
  *(undefined4 *)(&DAT_00bd0e28 + param_1 * 4) = 0xff;
  iVar7 = 2;
  puVar3 = (undefined4 *)(&DAT_00bd44a8 + param_1 * 0x68);
  do {
    *puVar3 = 0;
    puVar3 = puVar3 + 0xd;
    iVar7 = iVar7 + -1;
  } while (iVar7 != 0);
  return;
}

