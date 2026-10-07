/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0041f4a0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_0041f4a0(int *param_1_00,int param_1)

{
  undefined4 *puVar1;
  undefined4 *puVar2;
  double dVar3;
  char cVar4;
  int iVar5;
  uint uVar6;
  int unaff_EBX;
  int *piVar7;
  float10 fVar8;
  undefined4 local_c [2];
  
  iVar5 = FUN_004f5970(param_1);
  puVar2 = (undefined4 *)((int)param_1_00 + param_1 * 4 + 0xf7);
  switch(*puVar2) {
  case 0:
    cVar4 = FUN_005365c0(*(undefined4 *)(iVar5 + 0x5ae),local_c);
    if (cVar4 != '\0') {
      iVar5 = FUN_00538ae0();
      dVar3 = *(double *)(iVar5 + 0x45c + param_1 * 8);
      fVar8 = (float10)FUN_00509a20();
      if (fVar8 - (float10)dVar3 < (float10)_DAT_006ea668) {
        fVar8 = (float10)(*(code *)**(undefined4 **)((int)param_1_00 + param_1 * 0xc + 0x277))();
        *(double *)((int)param_1_00 + param_1 * 0xc + 0x27b) =
             (double)(fVar8 + (float10)_DAT_006e9830);
        *(undefined4 *)((int)param_1_00 + param_1 * 4 + 0x1b7) = local_c[0];
        *puVar2 = 1;
        return;
      }
    }
    break;
  case 1:
    if ((*(int *)((int)param_1_00 + param_1 * 0xc + 0x27b) != 0) ||
       (*(int *)((int)param_1_00 + param_1 * 0xc + 0x27f) != -0x40100000)) {
      fVar8 = (float10)(*(code *)**(undefined4 **)((int)param_1_00 + param_1 * 0xc + 0x277))();
      if (((float10)*(double *)((int)param_1_00 + param_1 * 0xc + 0x27b) < fVar8) ||
         (fVar8 = (float10)(*(code *)**(undefined4 **)((int)param_1_00 + param_1 * 0xc + 0x277))(),
         (float10)*(double *)((int)param_1_00 + param_1 * 0xc + 0x27b) - fVar8 ==
         (float10)_DAT_006ea4b0)) {
        *(undefined4 *)((int)param_1_00 + param_1 * 0xc + 0x27f) = 0xbff00000;
        *(undefined4 *)((int)param_1_00 + param_1 * 0xc + 0x4bf) = 0xbff00000;
        *(undefined4 *)((int)param_1_00 + param_1 * 0xc + 0x27b) = 0;
        *(undefined4 *)((int)param_1_00 + param_1 * 0xc + 0x4bb) = 0;
        *puVar2 = 2;
        *(undefined1 *)(param_1 + 0x6f7 + (int)param_1_00) = 0;
        return;
      }
    }
    cVar4 = FUN_005365c0(*(undefined4 *)(iVar5 + 0x5ae),0);
    if (cVar4 != '\0') {
      iVar5 = FUN_00538ae0();
      dVar3 = *(double *)(iVar5 + 0x45c + param_1 * 8);
      fVar8 = (float10)FUN_00509a20();
      if (fVar8 - (float10)dVar3 <= (float10)_DAT_006ea668) {
        return;
      }
    }
    *puVar2 = 0;
    return;
  case 2:
    puVar1 = *(undefined4 **)(iVar5 + 0x5ae);
    cVar4 = FUN_00536510(puVar1[0xf],*(undefined4 *)((int)param_1_00 + param_1 * 4 + 0x1b7));
    if (cVar4 == '\0') {
      cVar4 = FUN_00536470(puVar1[0xf],*(undefined4 *)((int)param_1_00 + param_1 * 4 + 0x1b7));
      if (cVar4 != '\0') {
        *(undefined1 *)(param_1 + 0x6f7 + (int)param_1_00) = 1;
        cVar4 = FUN_0041f220(puVar1);
        if (cVar4 == '\0') {
          iVar5 = FUN_00538ae0();
          dVar3 = *(double *)(iVar5 + 0x45c + param_1 * 8);
          fVar8 = (float10)FUN_00509a20();
          if ((float10)_DAT_006ea668 < fVar8 - (float10)dVar3) goto LAB_0041f89d;
          piVar7 = param_1_00 + param_1 * 3;
          if (((*(int *)((int)piVar7 + 0x4bb) != 0) ||
              (*(int *)((int)piVar7 + 0x4bf) != -0x40100000)) &&
             ((fVar8 = (float10)(*(code *)**(undefined4 **)((int)piVar7 + 0x4b7))(),
              (float10)*(double *)((int)piVar7 + 0x4bb) < fVar8 ||
              (fVar8 = (float10)(*(code *)**(undefined4 **)((int)piVar7 + 0x4b7))(),
              (float10)*(double *)((int)piVar7 + 0x4bb) - fVar8 == (float10)_DAT_006ea4b0)))) {
            *(undefined4 *)((int)piVar7 + 0x4bb) = 0;
            *(undefined4 *)((int)piVar7 + 0x4bf) = 0xbff00000;
          }
        }
        else {
LAB_0041f89d:
          piVar7 = param_1_00 + param_1 * 3;
          fVar8 = (float10)(*(code *)**(undefined4 **)((int)piVar7 + 0x4b7))();
          *(double *)((int)piVar7 + 0x4bb) = (double)(fVar8 + (float10)_DAT_006ecfd0);
        }
        cVar4 = FUN_005354b0(puVar1);
        if (((cVar4 == '\0') && (cVar4 = FUN_005354d0(puVar1), cVar4 == '\0')) &&
           (cVar4 = FUN_005354f0(puVar1), cVar4 == '\0')) {
          if ((*(int *)((int)piVar7 + 0x4bb) != 0) || (*(int *)((int)piVar7 + 0x4bf) != -0x40100000)
             ) {
            fVar8 = (float10)(*(code *)**(undefined4 **)((int)piVar7 + 0x4b7))();
            if ((fVar8 <= (float10)*(double *)((int)piVar7 + 0x4bb)) &&
               (fVar8 = (float10)(*(code *)**(undefined4 **)((int)piVar7 + 0x4b7))(),
               (float10)_DAT_006ea4b0 < (float10)*(double *)((int)piVar7 + 0x4bb) - fVar8))
            goto LAB_0041f986;
          }
          if ((*(int *)((int)piVar7 + 0x27b) == 0) && (*(int *)((int)piVar7 + 0x27f) == -0x40100000)
             ) {
            fVar8 = (float10)(*(code *)**(undefined4 **)((int)piVar7 + 0x277))();
            fVar8 = fVar8 + (float10)_DAT_006e9830;
            goto LAB_0041f9f2;
          }
          goto LAB_0041f9f8;
        }
        goto LAB_0041f986;
      }
      cVar4 = FUN_00536380(puVar1[0xf],*(undefined4 *)((int)param_1_00 + param_1 * 4 + 0x1b7));
      if (cVar4 == '\0') {
        *(undefined4 *)((int)param_1_00 + param_1 * 0xc + 0x27b) = 0;
        *puVar2 = 0;
        *(undefined4 *)((int)param_1_00 + param_1 * 0xc + 0x27f) = 0xbff00000;
        return;
      }
      piVar7 = param_1_00 + param_1 * 3;
      if ((*(int *)((int)piVar7 + 0x27b) == 0) && (*(int *)((int)piVar7 + 0x27f) == -0x40100000)) {
        fVar8 = (float10)(*(code *)**(undefined4 **)((int)piVar7 + 0x277))();
        fVar8 = fVar8 + (float10)_DAT_006e9808;
        goto LAB_0041f9f2;
      }
    }
    else {
      cVar4 = FUN_0041fbd0(puVar1);
      if (cVar4 == '\0') {
        iVar5 = FUN_00538ae0();
        dVar3 = *(double *)(iVar5 + 0x45c + param_1 * 8);
        fVar8 = (float10)FUN_00509a20();
        if ((float10)_DAT_006ea668 < fVar8 - (float10)dVar3) goto LAB_0041f713;
        piVar7 = param_1_00 + param_1 * 3;
        if (((*(int *)((int)piVar7 + 0x4bb) != 0) || (*(int *)((int)piVar7 + 0x4bf) != -0x40100000))
           && ((fVar8 = (float10)(*(code *)**(undefined4 **)((int)piVar7 + 0x4b7))(),
               (float10)*(double *)((int)piVar7 + 0x4bb) < fVar8 ||
               (fVar8 = (float10)(*(code *)**(undefined4 **)((int)piVar7 + 0x4b7))(),
               (float10)*(double *)((int)piVar7 + 0x4bb) - fVar8 == (float10)_DAT_006ea4b0)))) {
          *(undefined4 *)((int)piVar7 + 0x4bb) = 0;
          *(undefined4 *)((int)piVar7 + 0x4bf) = 0xbff00000;
        }
      }
      else {
LAB_0041f713:
        piVar7 = param_1_00 + param_1 * 3;
        fVar8 = (float10)(*(code *)**(undefined4 **)((int)piVar7 + 0x4b7))();
        *(double *)((int)piVar7 + 0x4bb) = (double)(fVar8 + (float10)_DAT_006ed050);
      }
      cVar4 = FUN_005365c0(puVar1,0);
      if (cVar4 == '\0') {
        if ((*(int *)((int)piVar7 + 0x4bb) != 0) || (*(int *)((int)piVar7 + 0x4bf) != -0x40100000))
        {
          fVar8 = (float10)(*(code *)**(undefined4 **)((int)piVar7 + 0x4b7))();
          if ((fVar8 <= (float10)*(double *)((int)piVar7 + 0x4bb)) &&
             (fVar8 = (float10)(*(code *)**(undefined4 **)((int)piVar7 + 0x4b7))(),
             (float10)_DAT_006ea4b0 < (float10)*(double *)((int)piVar7 + 0x4bb) - fVar8))
          goto LAB_0041f986;
        }
        if ((*(int *)((int)piVar7 + 0x27b) == 0) && (*(int *)((int)piVar7 + 0x27f) == -0x40100000))
        {
          fVar8 = (float10)(*(code *)**(undefined4 **)((int)piVar7 + 0x277))();
          fVar8 = fVar8 + (float10)_DAT_006ed050;
LAB_0041f9f2:
          *(double *)((int)piVar7 + 0x27b) = (double)fVar8;
        }
      }
      else {
LAB_0041f986:
        *(undefined4 *)((int)piVar7 + 0x27b) = 0;
        *(undefined4 *)((int)piVar7 + 0x27f) = 0xbff00000;
      }
    }
LAB_0041f9f8:
    if (*(char *)(DAT_00bdb9d8 + 0x3cd + param_1) != '\0') {
      *(undefined4 *)((int)piVar7 + 0x27b) = 0;
      *(undefined4 *)((int)piVar7 + 0x27f) = 0xbff00000;
      return;
    }
    if (((*(int *)((int)piVar7 + 0x27b) != 0) || (*(int *)((int)piVar7 + 0x27f) != -0x40100000)) &&
       ((fVar8 = (float10)(*(code *)**(undefined4 **)((int)piVar7 + 0x277))(),
        (float10)*(double *)((int)piVar7 + 0x27b) < fVar8 ||
        (fVar8 = (float10)(*(code *)**(undefined4 **)((int)piVar7 + 0x277))(),
        (float10)*(double *)((int)piVar7 + 0x27b) - fVar8 == (float10)_DAT_006ea4b0)))) {
      (**(code **)(*param_1_00 + 0x44))(param_1);
      uVar6 = (**(code **)(*param_1_00 + 0x30))(param_1);
      param_1_00[param_1 + 1] = (uVar6 & 1) << 0x11 ^ param_1_00[param_1 + 1] & 0xfffdffffU;
      *puVar1 = 3;
      *(undefined4 *)(unaff_EBX + 0x27b) = 0;
      *(undefined4 *)(unaff_EBX + 0x27f) = 0xbff00000;
      return;
    }
    break;
  case 3:
    cVar4 = FUN_00536510(*(undefined4 *)(*(int *)(iVar5 + 0x5ae) + 0x3c),
                         *(undefined4 *)((int)param_1_00 + param_1 * 4 + 0x1b7));
    if (cVar4 != '\0') {
      *(undefined4 *)((int)param_1_00 + param_1 * 0xc + 0x27b) = 0;
      *(undefined4 *)((int)param_1_00 + param_1 * 0xc + 0x27f) = 0xbff00000;
      return;
    }
    if ((*(int *)((int)param_1_00 + param_1 * 0xc + 0x27b) == 0) &&
       (*(int *)((int)param_1_00 + param_1 * 0xc + 0x27f) == -0x40100000)) {
      fVar8 = (float10)(*(code *)**(undefined4 **)((int)param_1_00 + param_1 * 0xc + 0x277))();
      *(double *)((int)param_1_00 + param_1 * 0xc + 0x27b) =
           (double)(fVar8 + (float10)_DAT_006e9830);
      return;
    }
    puVar1 = (undefined4 *)((int)param_1_00 + param_1 * 0xc + 0x277);
    if (((*(int *)((int)param_1_00 + param_1 * 0xc + 0x27b) != 0) ||
        (*(int *)((int)param_1_00 + param_1 * 0xc + 0x27f) != -0x40100000)) &&
       ((fVar8 = (float10)(**(code **)*puVar1)(),
        (float10)*(double *)((int)param_1_00 + param_1 * 0xc + 0x27b) < fVar8 ||
        (fVar8 = (float10)(**(code **)*puVar1)(),
        (float10)*(double *)((int)param_1_00 + param_1 * 0xc + 0x27b) - fVar8 ==
        (float10)_DAT_006ea4b0)))) {
      *puVar2 = 0;
    }
  }
  return;
}


