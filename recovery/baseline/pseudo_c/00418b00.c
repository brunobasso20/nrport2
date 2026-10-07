/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00418b00 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_00418b00(int param_1)

{
  undefined4 *puVar1;
  undefined4 *puVar2;
  undefined4 uVar3;
  float10 fVar4;
  float fVar5;
  bool bVar6;
  bool bVar7;
  int iVar8;
  int iVar9;
  int iVar10;
  bool bVar11;
  int iVar12;
  float10 fVar13;
  float local_28;
  float local_24;
  float local_20;
  
  iVar12 = 0;
  iVar8 = FUN_00536160();
  if (0 < iVar8) {
    do {
      iVar8 = FUN_00509b60(0xffffffff);
      if (iVar8 == 3) {
        iVar8 = param_1 + iVar12 * 0xc;
        if ((((*(int *)(param_1 + 0xa1 + iVar12 * 0xc) == 0) &&
             (*(int *)(iVar8 + 0xa5) == -0x40100000)) ||
            ((*(int *)(iVar8 + 0xa1) == 0 && (*(int *)(iVar8 + 0xa5) == -0x40100000)))) ||
           ((fVar13 = (float10)(*(code *)**(undefined4 **)(iVar8 + 0x9d))(),
            (float10)*(double *)(iVar8 + 0xa1) < fVar13 ||
            (fVar13 = (float10)(*(code *)**(undefined4 **)(iVar8 + 0x9d))(),
            (float10)*(double *)(iVar8 + 0xa1) - fVar13 < (float10)_DAT_006ed018)))) {
          fVar13 = (float10)(*(code *)**(undefined4 **)(iVar8 + 0x9d))();
          *(double *)(iVar8 + 0xa1) = (double)(fVar13 + (float10)_DAT_006ed010);
        }
        *(undefined4 *)(param_1 + 0x4333 + iVar12 * 4) = 0;
      }
      else if ((*(int *)(param_1 + 0x3f54) == 7) ||
              ((iVar8 = FUN_005099b0(), iVar8 == 7 && (iVar8 = FUN_00509b60(0xffffffff), iVar8 == 6)
               ))) {
        puVar1 = (undefined4 *)(param_1 + 0xa1 + iVar12 * 0xc);
        if ((*(int *)(param_1 + 0xa1 + iVar12 * 0xc) != 0) || (puVar1[1] != -0x40100000)) {
          *puVar1 = 0;
          puVar1[1] = 0xbff00000;
        }
        *(undefined4 *)(param_1 + 0x4333 + iVar12 * 4) = 2;
      }
      else {
        iVar8 = param_1 + iVar12 * 0xc;
        puVar1 = (undefined4 *)(iVar8 + 0x9d);
        if ((*(int *)(iVar8 + 0xa1) == 0) && (*(int *)(iVar8 + 0xa5) == -0x40100000)) {
          fVar13 = (float10)_DAT_006ea4b8;
        }
        else {
          fVar13 = (float10)(**(code **)*puVar1)();
          if (fVar13 <= (float10)*(double *)(iVar8 + 0xa1)) {
            fVar13 = (float10)(**(code **)*puVar1)();
            fVar13 = (float10)*(double *)(iVar8 + 0xa1) - fVar13;
          }
          else {
            fVar13 = (float10)_DAT_006ea4b0;
          }
        }
        local_28 = (float)fVar13;
        fVar4 = (float10)_DAT_006ea454;
        if ((*(int *)(iVar8 + 0xa1) != 0) || (bVar7 = true, *(int *)(iVar8 + 0xa5) != -0x40100000))
        {
          bVar7 = false;
        }
        if (iVar12 == 1) {
          iVar9 = FUN_00536260(1);
          iVar10 = FUN_00536260(0);
          if (*(float *)(iVar10 + 0xb) <= *(float *)(iVar9 + 0xb)) goto LAB_00418ca2;
          iVar9 = 1;
        }
        else {
LAB_00418ca2:
          iVar9 = 0;
        }
        iVar10 = *(int *)(param_1 + 0x3f54) - iVar9;
        if ((iVar10 < 0) || (*(int *)(param_1 + 0x3f54) == iVar9)) {
          if ((bVar7) || (local_28 < _DAT_006ed00c)) {
            fVar13 = (float10)(**(code **)*puVar1)();
            *(double *)(iVar8 + 0xa1) = (double)(fVar13 + (float10)_DAT_006ed010);
          }
          *(undefined4 *)(param_1 + 0x4333 + iVar12 * 4) = 0;
        }
        else if ((iVar10 < 1) || (2 < iVar10)) {
          if (fVar13 != fVar4) {
            fVar13 = (float10)(**(code **)*puVar1)();
            *(double *)(iVar8 + 0xa1) = (double)fVar13;
          }
          *(undefined4 *)(param_1 + 0x4333 + iVar12 * 4) = 2;
        }
        else if ((bVar7) || (_DAT_006ea454 < local_28)) {
          bVar6 = false;
          local_20 = 999999.9;
          uVar3 = *(undefined4 *)(DAT_00760b38 + 0x186a);
          iVar9 = taskGetRate();
          fVar5 = (float)iVar9 * *(float *)(DAT_00760b38 + 0x1872);
          iVar9 = FUN_004fff70(iVar12);
          if (fVar5 <= _DAT_006e97d8) {
            local_24 = 999999.9;
            bVar11 = true;
          }
          else {
            fVar13 = (float10)FUN_00516daa(uVar3,*(undefined4 *)(iVar9 + 0x34));
            local_24 = (float)(fVar13 / (float10)fVar5);
            if (local_24 == _DAT_006ed008) {
              bVar11 = true;
            }
            else {
              bVar11 = false;
            }
          }
          if (((bVar7) || (_DAT_006ed004 < local_28 != bVar11)) ||
             ((_DAT_006ed004 >= local_28 &&
              ((_DAT_006e97d8 < local_28 && (_DAT_006e97d8 < ABS(local_24 - local_28))))))) {
            bVar6 = true;
            local_20 = local_24;
            local_28 = local_24;
          }
          if (iVar12 < 1) {
LAB_00418f6c:
            if (!bVar6) goto LAB_00418f82;
          }
          else {
            puVar2 = (undefined4 *)(param_1 + 0x9d);
            if ((*(int *)(param_1 + 0xa1) == 0) && (*(int *)(param_1 + 0xa5) == -0x40100000)) {
              fVar13 = (float10)_DAT_006ea4b8;
            }
            else {
              fVar13 = (float10)(**(code **)*puVar2)();
              if (fVar13 <= (float10)*(double *)(param_1 + 0xa1)) {
                fVar13 = (float10)(**(code **)*puVar2)();
                fVar13 = (float10)*(double *)(param_1 + 0xa1) - fVar13;
              }
              else {
                fVar13 = (float10)_DAT_006ea4b0;
              }
            }
            if ((fVar13 <= (float10)local_28) || (_DAT_006ea478 <= local_28)) goto LAB_00418f6c;
            if ((*(int *)(param_1 + 0xa1) == 0) && (*(int *)(param_1 + 0xa5) == -0x40100000)) {
              local_20 = (float)_DAT_006ea4b8;
            }
            else {
              fVar13 = (float10)(**(code **)*puVar2)();
              if (fVar13 <= (float10)*(double *)(param_1 + 0xa1)) {
                fVar13 = (float10)(**(code **)*puVar2)();
                local_20 = (float)((float10)*(double *)(param_1 + 0xa1) - fVar13);
              }
              else {
                local_20 = (float)_DAT_006ea4b0;
              }
            }
          }
          fVar13 = (float10)(**(code **)*puVar1)();
          *(double *)(iVar8 + 0xa1) = (double)(fVar13 + (float10)local_20);
        }
        else {
          iVar8 = *(int *)(param_1 + 0x4333 + iVar12 * 4);
          if (iVar8 == 0) {
            FUN_00538ab0();
            iVar8 = FUN_005398d0();
            *(uint *)(param_1 + 0x4333 + iVar12 * 4) = 2 - (uint)(iVar8 != 5);
          }
          else if (iVar8 < 2) {
            uVar3 = *(undefined4 *)(DAT_00760b38 + 0x186a);
            iVar8 = taskGetRate();
            fVar5 = (float)iVar8 * *(float *)(DAT_00760b38 + 0x1872);
            iVar8 = FUN_004fff70(iVar12);
            if ((_DAT_006e97d8 < fVar5) &&
               (fVar13 = (float10)FUN_00516daa(uVar3,*(undefined4 *)(iVar8 + 0x34)),
               fVar13 / (float10)fVar5 < (float10)_DAT_006ea62c)) {
              *(undefined4 *)(param_1 + 0x4333 + iVar12 * 4) = 2;
            }
          }
        }
      }
LAB_00418f82:
      iVar12 = iVar12 + 1;
      iVar8 = FUN_00536160();
    } while (iVar12 < iVar8);
  }
  return;
}


