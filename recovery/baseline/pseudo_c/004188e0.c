/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004188e0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_004188e0(int param_1)

{
  float fVar1;
  undefined4 uVar2;
  char cVar3;
  int iVar4;
  bool bVar5;
  undefined4 *puVar6;
  int iVar7;
  float10 fVar8;
  float local_1c;
  
  iVar7 = 0;
  iVar4 = FUN_00536160();
  if (0 < iVar4) {
    puVar6 = (undefined4 *)(param_1 + 0x85);
    do {
      iVar4 = FUN_00509b60(0xffffffff);
      if ((((iVar4 == 3) && (*(int *)(DAT_00760b38 + 0x1a8a) < 1)) ||
          (*(int *)(param_1 + 0x3f54) == 7)) ||
         ((iVar4 = FUN_005099b0(), iVar4 == 7 && (iVar4 = FUN_00509b60(0xffffffff), iVar4 == 6)))) {
        if ((puVar6[1] != 0) || (puVar6[2] != -0x40100000)) {
          puVar6[1] = 0;
          puVar6[2] = 0xbff00000;
        }
      }
      else {
        uVar2 = *(undefined4 *)(DAT_00760b38 + 0x186a);
        iVar4 = taskGetRate();
        fVar1 = (float)iVar4 * *(float *)(DAT_00760b38 + 0x1872);
        iVar4 = FUN_00536260(iVar7);
        if (fVar1 <= _DAT_006e97d8) {
          local_1c = 999999.9;
        }
        else {
          fVar8 = (float10)FUN_00516daa(uVar2,*(undefined4 *)(iVar4 + 0xf));
          local_1c = (float)(fVar8 / (float10)fVar1);
        }
        if ((puVar6[1] == 0) && (puVar6[2] == -0x40100000)) {
          fVar8 = (float10)_DAT_006ea4b8;
        }
        else {
          fVar8 = (float10)(**(code **)*puVar6)();
          if (fVar8 <= (float10)*(double *)(puVar6 + 1)) {
            fVar8 = (float10)(**(code **)*puVar6)();
            fVar8 = (float10)*(double *)(puVar6 + 1) - fVar8;
          }
          else {
            fVar8 = (float10)_DAT_006ea4b0;
          }
        }
        fVar1 = (float)fVar8;
        bVar5 = _DAT_006ed004 < fVar1;
        if ((((puVar6[1] == 0) && (puVar6[2] == -0x40100000)) ||
            (bVar5 != (local_1c == _DAT_006ed008))) ||
           (((fVar1 == _DAT_006ea454 && (cVar3 = FUN_00418800(iVar7), cVar3 == '\0')) ||
            ((!bVar5 && ((_DAT_006e97d8 < fVar1 && (_DAT_006e97d8 < ABS(local_1c - fVar1))))))))) {
          fVar8 = (float10)(**(code **)*puVar6)();
          *(double *)(puVar6 + 1) = (double)(fVar8 + (float10)local_1c);
        }
      }
      iVar7 = iVar7 + 1;
      puVar6 = puVar6 + 3;
      iVar4 = FUN_00536160();
    } while (iVar7 < iVar4);
  }
  return;
}


