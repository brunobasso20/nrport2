/* FUN_10021340 */

undefined4 * __thiscall FUN_10021340(void *this,int param_1,int param_2)

{
  int *piVar1;
  double dVar2;
  double dVar3;
  int iVar4;
  int iVar5;
  int iVar6;
  success sVar7;
  undefined4 *puVar8;
  char unaff_SI;
  undefined4 unaff_EDI;
  float fStack_14;
  float fStack_10;
  void *apvStack_c [2];

  iVar6 = (**(code **)(**(int **)(*(int *)((int)this + 0x70) + 0x18) + 0x20))();
  iVar4 = *(int *)((int)this + 0x58);
  fStack_10 = 0.0;
  fStack_14 = 1.0;
  if (1 < iVar4) {
    iVar5 = *(int *)((int)this + 0x54);
    fStack_10 = (float)*(double *)(*(int *)(iVar6 + 0x5d) + 0x28 + iVar5 * 0x53a);
    if (iVar5 < iVar4 + -1) {
      fStack_14 = (float)*(double *)(*(int *)(iVar6 + 0x5d) + iVar5 * 0x53a + 0x562);
    }
    else {
      fStack_14 = 1.0;
    }
  }
  piVar1 = (int *)(*(int *)(iVar6 + 0x5d) + *(int *)((int)this + 0x54) * 0x53a);
  if (*piVar1 != 0) {
    if (iVar4 < 2) {
      sVar7 = _memAlloc(apvStack_c,0x1a0);
      if ((sVar7 != 0) && (apvStack_c[0] != (void *)0x0)) {
        iVar4 = *(int *)(*(int *)(iVar6 + 0x5d) + 0x14 + *(int *)((int)this + 0x54) * 0x53a);
                    /* WARNING: Load size is inaccurate */
        dVar2 = (double)(*(float *)(iVar6 + 0x10) - (float)*(double *)(iVar6 + 0x2d));
        puVar8 = FUN_1001cf60(apvStack_c[0],*(undefined *)(iVar6 + 0x14),
                              (double)CONCAT44(SUB84(dVar2,0),
                                               (int)((ulonglong)
                                                     (double)(*(float *)(iVar6 + 0xc) -
                                                             (float)*(double *)(iVar6 + 0x25)) >>
                                                    0x20)),
                              (double)CONCAT44(*this,(int)((ulonglong)dVar2 >> 0x20)),iVar4,iVar4,
                              param_1,param_2,0,0.0,(double)CONCAT44(unaff_EDI,1),unaff_SI);
        *(undefined4 *)((int)this + 0x7c) = 0;
        return puVar8;
      }
    }
    else {
      sVar7 = _memAlloc(apvStack_c,0x1a8);
      if ((sVar7 != 0) && (apvStack_c[0] != (void *)0x0)) {
        iVar4 = *(int *)(*(int *)(iVar6 + 0x5d) + 0x14 + *(int *)((int)this + 0x54) * 0x53a);
                    /* WARNING: Load size is inaccurate */
        dVar2 = (double)(*(float *)(iVar6 + 0x10) - (float)*(double *)(iVar6 + 0x2d));
        dVar3 = (double)(*(float *)(iVar6 + 0xc) - (float)*(double *)(iVar6 + 0x25));
        puVar8 = FUN_1001ce90(apvStack_c[0],(double)fStack_10,(double)fStack_14,
                              *(undefined *)(iVar6 + 0x14),SUB84(dVar3,0),
                              (int)((ulonglong)dVar3 >> 0x20),SUB84(dVar2,0),
                              (int)((ulonglong)dVar2 >> 0x20),*this,iVar4,iVar4,param_1,param_2,0,0,
                              0,0,'\x01');
        *(undefined4 *)((int)this + 0x7c) = 0;
        return puVar8;
      }
    }
    *(undefined4 *)((int)this + 0x7c) = 0;
    return (undefined4 *)0x0;
  }
  if (piVar1[1] == 0) {
    if (piVar1[2] != 0) {
      if (iVar4 < 2) {
        sVar7 = _memAlloc(apvStack_c,0x1a0);
        if ((sVar7 != 0) && (apvStack_c[0] != (void *)0x0)) {
          iVar4 = *(int *)(*(int *)(iVar6 + 0x5d) + 0x1c + *(int *)((int)this + 0x54) * 0x53a);
                    /* WARNING: Load size is inaccurate */
          dVar2 = (double)(*(float *)(iVar6 + 0x10) + (float)*(double *)(iVar6 + 0x2d));
          puVar8 = FUN_1001cf60(apvStack_c[0],*(undefined *)(iVar6 + 0x14),
                                (double)CONCAT44(SUB84(dVar2,0),
                                                 (int)((ulonglong)
                                                       (double)(*(float *)(iVar6 + 0xc) +
                                                               (float)*(double *)(iVar6 + 0x25)) >>
                                                      0x20)),
                                (double)CONCAT44(*this,(int)((ulonglong)dVar2 >> 0x20)),iVar4,iVar4,
                                param_1,param_2,*(int *)(iVar6 + 0x15),*(double *)(iVar6 + 0x1d),
                                (double)CONCAT44(unaff_EDI,
                                                 CONCAT31((int3)((uint)*(int *)(iVar6 + 0x45) >> 8),
                                                          *(int *)(iVar6 + 0x45) == 0)),unaff_SI);
          *(undefined4 *)((int)this + 0x7c) = 2;
          return puVar8;
        }
      }
      else {
        sVar7 = _memAlloc(apvStack_c,0x1a8);
        if ((sVar7 != 0) && (apvStack_c[0] != (void *)0x0)) {
          iVar4 = *(int *)(*(int *)(iVar6 + 0x5d) + 0x1c + *(int *)((int)this + 0x54) * 0x53a);
                    /* WARNING: Load size is inaccurate */
          dVar2 = (double)(*(float *)(iVar6 + 0x10) + (float)*(double *)(iVar6 + 0x2d));
          dVar3 = (double)(*(float *)(iVar6 + 0xc) + (float)*(double *)(iVar6 + 0x25));
          puVar8 = FUN_1001ce90(apvStack_c[0],(double)fStack_10,(double)fStack_14,
                                *(undefined *)(iVar6 + 0x14),SUB84(dVar3,0),
                                (int)((ulonglong)dVar3 >> 0x20),SUB84(dVar2,0),
                                (int)((ulonglong)dVar2 >> 0x20),*this,iVar4,iVar4,param_1,param_2,
                                *(undefined4 *)(iVar6 + 0x15),*(undefined4 *)(iVar6 + 0x19),
                                *(undefined4 *)(iVar6 + 0x1d),*(undefined4 *)(iVar6 + 0x21),
                                *(int *)(iVar6 + 0x45) == 0);
          *(undefined4 *)((int)this + 0x7c) = 2;
          return puVar8;
        }
      }
      *(undefined4 *)((int)this + 0x7c) = 2;
    }
    return (undefined4 *)0x0;
  }
  if (iVar4 < 2) {
    sVar7 = _memAlloc(apvStack_c,0x1a0);
    if ((sVar7 != 0) && (apvStack_c[0] != (void *)0x0)) {
      iVar4 = *(int *)(*(int *)(iVar6 + 0x5d) + 0x18 + *(int *)((int)this + 0x54) * 0x53a);
                    /* WARNING: Load size is inaccurate */
      dVar2 = (double)(*(float *)(iVar6 + 0x10) - (float)*(double *)(iVar6 + 0x2d));
      puVar8 = FUN_1001cf60(apvStack_c[0],*(undefined *)(iVar6 + 0x14),
                            (double)CONCAT44(SUB84(dVar2,0),
                                             (int)((ulonglong)
                                                   (double)(*(float *)(iVar6 + 0xc) -
                                                           (float)*(double *)(iVar6 + 0x25)) >> 0x20
                                                  )),
                            (double)CONCAT44(*this,(int)((ulonglong)dVar2 >> 0x20)),iVar4,iVar4,
                            param_1,param_2,*(int *)(iVar6 + 0x15),*(double *)(iVar6 + 0x1d),
                            (double)CONCAT44(unaff_EDI,
                                             CONCAT31((int3)((uint)*(int *)(iVar6 + 0x45) >> 8),
                                                      *(int *)(iVar6 + 0x45) == 0)),unaff_SI);
      *(undefined4 *)((int)this + 0x7c) = 1;
      return puVar8;
    }
  }
  else {
    sVar7 = _memAlloc(apvStack_c,0x1a8);
    if ((sVar7 != 0) && (apvStack_c[0] != (void *)0x0)) {
      iVar4 = *(int *)(*(int *)(iVar6 + 0x5d) + 0x18 + *(int *)((int)this + 0x54) * 0x53a);
                    /* WARNING: Load size is inaccurate */
      dVar2 = (double)(*(float *)(iVar6 + 0x10) - (float)*(double *)(iVar6 + 0x2d));
      dVar3 = (double)(*(float *)(iVar6 + 0xc) - (float)*(double *)(iVar6 + 0x25));
      puVar8 = FUN_1001ce90(apvStack_c[0],(double)fStack_10,(double)fStack_14,
                            *(undefined *)(iVar6 + 0x14),SUB84(dVar3,0),
                            (int)((ulonglong)dVar3 >> 0x20),SUB84(dVar2,0),
                            (int)((ulonglong)dVar2 >> 0x20),*this,iVar4,iVar4,param_1,param_2,
                            *(undefined4 *)(iVar6 + 0x15),*(undefined4 *)(iVar6 + 0x19),
                            *(undefined4 *)(iVar6 + 0x1d),*(undefined4 *)(iVar6 + 0x21),
                            *(int *)(iVar6 + 0x45) == 0);
      *(undefined4 *)((int)this + 0x7c) = 1;
      return puVar8;
    }
  }
  *(undefined4 *)((int)this + 0x7c) = 1;
  return (undefined4 *)0x0;
}
