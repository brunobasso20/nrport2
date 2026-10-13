/* FUN_100217b0 */

undefined4 * __thiscall FUN_100217b0(void *this,int param_1,int param_2)

{
  double dVar1;
  double dVar2;
  int iVar3;
  int iVar4;
  int iVar5;
  success sVar6;
  undefined4 *puVar7;
  int iVar8;
  char unaff_SI;
  undefined4 unaff_EDI;
  int iStack_38;
  float fStack_34;
  float fStack_30;
  void *pvStack_2c;
  undefined4 uStack_28;
  undefined4 uStack_24;
  int iStack_20;
  undefined4 uStack_1c;
  double dStack_18;
  double dStack_10;

  iVar4 = (**(code **)(**(int **)(*(int *)((int)this + 0x70) + 0x18) + 0x20))();
  iVar8 = *(int *)((int)this + 0x7c);
  dStack_10 = 0.0;
  dStack_18 = 0.0;
  iStack_20 = 0;
  uStack_1c = 0;
  uStack_28 = 0;
  uStack_24 = 0;
  switch(iVar8) {
  case 0:
    iStack_20 = *(int *)(iVar4 + 0x15);
    uStack_1c = *(undefined4 *)(iVar4 + 0x19);
    uStack_28 = *(undefined4 *)(iVar4 + 0x1d);
    uStack_24 = *(undefined4 *)(iVar4 + 0x21);
    dStack_10 = -*(double *)(iVar4 + 0x25);
    dStack_18 = -*(double *)(iVar4 + 0x2d);
    break;
  case 1:
    dStack_10 = *(double *)(iVar4 + 0x25);
    dStack_18 = *(double *)(iVar4 + 0x2d);
    iStack_20 = *(int *)(iVar4 + 0x15);
    uStack_1c = *(undefined4 *)(iVar4 + 0x19);
    uStack_28 = *(undefined4 *)(iVar4 + 0x1d);
    uStack_24 = *(undefined4 *)(iVar4 + 0x21);
    break;
  case 2:
    dStack_10 = *(double *)(iVar4 + 0x25);
    dStack_18 = *(double *)(iVar4 + 0x2d);
    goto LAB_100218bb;
  case 5:
    dStack_10 = -*(double *)(iVar4 + 0x25);
    dStack_18 = -*(double *)(iVar4 + 0x2d);
LAB_100218bb:
    iStack_20 = 0;
    uStack_1c = 0;
    uStack_28 = 0;
    uStack_24 = 0;
  }
  iStack_38 = FUN_10021d00((int)this);
  if (iVar8 == 5) {
    iVar8 = iStack_38;
  }
  if (iStack_38 == 5) {
    iStack_38 = iVar8;
  }
  iVar5 = *(int *)((int)this + 0x58);
  fStack_30 = 0.0;
  fStack_34 = 1.0;
  if (1 < iVar5) {
    iVar3 = *(int *)((int)this + 0x54);
    fStack_30 = (float)*(double *)(*(int *)(iVar4 + 0x5d) + 0x28 + iVar3 * 0x53a);
    pvStack_2c = (void *)(*(int *)(iVar4 + 0x5d) + iVar3 * 0x53a);
    iVar5 = *(int *)((int)this + 0x58);
    if (iVar3 < iVar5 + -1) {
      fStack_34 = (float)*(double *)((int)pvStack_2c + 0x562);
    }
    else {
      fStack_34 = 1.0;
    }
  }
  if ((iVar8 != 5) && (iStack_38 != 5)) {
    if (iVar5 < 2) {
      sVar6 = _memAlloc(&pvStack_2c,0x1a0);
      if ((sVar6 != 0) && (pvStack_2c != (void *)0x0)) {
        iVar5 = *(int *)((int)this + 0x54) * 0x53a;
                    /* WARNING: Load size is inaccurate */
        dVar1 = (double)(*(float *)(iVar4 + 0x10) + (float)dStack_18);
        puVar7 = FUN_1001cf60(pvStack_2c,*(undefined *)(iVar4 + 0x14),
                              (double)CONCAT44(SUB84(dVar1,0),
                                               (int)((ulonglong)
                                                     (double)(*(float *)(iVar4 + 0xc) +
                                                             (float)dStack_10) >> 0x20)),
                              (double)CONCAT44(*this,(int)((ulonglong)dVar1 >> 0x20)),
                              *(int *)(*(int *)(iVar4 + 0x5d) + 0x14 + iVar8 * 4 + iVar5),
                              *(int *)(*(int *)(iVar4 + 0x5d) + 0x14 + iStack_38 * 4 + iVar5),
                              param_1,param_2,iStack_20,(double)CONCAT44(uStack_24,uStack_28),
                              (double)CONCAT44(unaff_EDI,
                                               CONCAT31((int3)((uint)*(int *)(iVar4 + 0x45) >> 8),
                                                        *(int *)(iVar4 + 0x45) == 0)),unaff_SI);
        return puVar7;
      }
    }
    else {
      sVar6 = _memAlloc(&pvStack_2c,0x1a8);
      if ((sVar6 != 0) && (pvStack_2c != (void *)0x0)) {
        iVar5 = *(int *)((int)this + 0x54) * 0x53a;
                    /* WARNING: Load size is inaccurate */
        dVar1 = (double)(*(float *)(iVar4 + 0x10) + (float)dStack_18);
        dVar2 = (double)(*(float *)(iVar4 + 0xc) + (float)dStack_10);
        puVar7 = FUN_1001ce90(pvStack_2c,(double)fStack_30,(double)fStack_34,
                              *(undefined *)(iVar4 + 0x14),SUB84(dVar2,0),
                              (int)((ulonglong)dVar2 >> 0x20),SUB84(dVar1,0),
                              (int)((ulonglong)dVar1 >> 0x20),*this,
                              *(int *)(*(int *)(iVar4 + 0x5d) + 0x14 + iVar8 * 4 + iVar5),
                              *(int *)(*(int *)(iVar4 + 0x5d) + 0x14 + iStack_38 * 4 + iVar5),
                              param_1,param_2,iStack_20,uStack_1c,uStack_28,uStack_24,
                              *(int *)(iVar4 + 0x45) == 0);
        return puVar7;
      }
    }
  }
  return (undefined4 *)0x0;
}
