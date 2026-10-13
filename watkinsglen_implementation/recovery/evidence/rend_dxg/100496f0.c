/* FUN_100496f0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

int FUN_100496f0(int param_1)

{
  int iVar1;
  float fVar2;
  int iVar3;
  success sVar4;
  int iVar5;
  float *pfVar6;
  int iVar7;
  int iVar8;
  int iVar9;
  float10 fVar10;
  float10 fVar11;
  undefined local_a8 [4];
  float local_a4;
  void *pvStack_a0;
  void *local_9c;
  float fStack_98;
  float fStack_94;
  float fStack_90;
  float fStack_8c;
  float fStack_88;
  float fStack_84;
  float fStack_80;
  float fStack_7c;
  float fStack_78;
  float fStack_74;
  float fStack_70;
  float fStack_6c;
  float local_68;
  float local_64;
  undefined auStack_60 [32];
  float fStack_40;

  sVar4 = _memAlloc(&local_9c,0x34);
  if ((sVar4 != 0) && (local_9c != (void *)0x0)) {
    iVar5 = FUN_10049660();
    if (iVar5 != 0) {
      if (((*(int *)(param_1 + 0xc) != 0) && (*(int *)(param_1 + 0x38) != 0)) &&
         (*(int *)(param_1 + 0x3c) != 0)) {
        (**(code **)(DAT_100b5aa0 + 8))
                  (&local_64,&local_68,&local_a4,local_a8,local_a8,local_a8,local_a8,local_a8,
                   local_a8,local_a8,local_a8,(float)*(double *)(param_1 + 0x10),
                   (float)*(double *)(param_1 + 0x18),0);
        fStack_98 = (float)*(double *)(param_1 + 0x28) * (float)_DAT_1009aad8;
        fStack_90 = local_a4;
        fStack_78 = local_a4;
        fStack_94 = (float)*(double *)(param_1 + 0x20) * (float)_DAT_1009aad8;
        fStack_6c = local_a4;
        fStack_84 = local_a4;
        iVar8 = 4;
        fStack_8c = (float)*(double *)(param_1 + 0x28) * (float)_DAT_100953d0;
        fStack_88 = fStack_94;
        fStack_80 = fStack_8c;
        fStack_7c = (float)*(double *)(param_1 + 0x20) * (float)_DAT_100953d0;
        fStack_74 = fStack_98;
        fStack_70 = fStack_7c;
        fVar10 = (float10)fcos((float10)*(double *)(param_1 + 0x30));
        fVar11 = (float10)fsin((float10)*(double *)(param_1 + 0x30));
        pfVar6 = &fStack_94;
        do {
          fVar2 = pfVar6[-1];
          iVar8 = iVar8 + -1;
          pfVar6[-1] = (float)((fVar10 * (float10)pfVar6[-1] - fVar11 * (float10)*pfVar6) +
                              (float10)local_64);
          *pfVar6 = (float)(fVar10 * (float10)*pfVar6 + fVar11 * (float10)fVar2 + (float10)local_68)
          ;
          pfVar6 = pfVar6 + 3;
        } while (iVar8 != 0);
        pfVar6 = &fStack_98;
        pvStack_a0 = (void *)0x4;
        do {
          (**(code **)(DAT_100b5aa0 + 4))(auStack_60,pfVar6);
          fVar2 = fStack_40;
          pfVar6[2] = fStack_40;
          FUN_10026a40(*pfVar6,pfVar6[1],fVar2);
          pfVar6 = pfVar6 + 3;
          pvStack_a0 = (void *)((int)pvStack_a0 - 1);
        } while (pvStack_a0 != (void *)0x0);
        sVar4 = _memAlloc(&pvStack_a0,0x90);
        pfVar6 = (float *)(-(uint)(sVar4 != 0) & (uint)pvStack_a0);
        *(float **)(iVar5 + 0x2c) = pfVar6;
        if (pfVar6 != (float *)0x0) {
          *pfVar6 = fStack_98;
          pfVar6[1] = fStack_94;
          pfVar6[2] = fStack_90;
          (**(code **)(DAT_100b5aa0 + 0xc))
                    (local_a8,local_a8,local_a8,local_a8,local_a8,local_a8,pfVar6 + 3,pfVar6 + 4,
                     pfVar6 + 5,local_a8,local_a8,local_a8,local_a8,*pfVar6,pfVar6[1],fStack_90,0);
          iVar8 = *(int *)(iVar5 + 0x2c);
          *(float *)(iVar8 + 0x24) = fStack_8c;
          *(float *)(iVar8 + 0x28) = fStack_88;
          *(float *)(iVar8 + 0x2c) = fStack_84;
          (**(code **)(DAT_100b5aa0 + 0xc))
                    (local_a8,local_a8,local_a8,local_a8,local_a8,local_a8,iVar8 + 0x30,iVar8 + 0x34
                     ,iVar8 + 0x38,local_a8,local_a8,local_a8,local_a8,*(undefined4 *)(iVar8 + 0x24)
                     ,*(undefined4 *)(iVar8 + 0x28),fStack_84,0);
          iVar8 = *(int *)(iVar5 + 0x2c);
          *(float *)(iVar8 + 0x48) = fStack_74;
          *(float *)(iVar8 + 0x4c) = fStack_70;
          *(float *)(iVar8 + 0x50) = fStack_6c;
          (**(code **)(DAT_100b5aa0 + 0xc))
                    (local_a8,local_a8,local_a8,local_a8,local_a8,local_a8,iVar8 + 0x54,iVar8 + 0x58
                     ,iVar8 + 0x5c,local_a8,local_a8,local_a8,local_a8,*(undefined4 *)(iVar8 + 0x48)
                     ,*(undefined4 *)(iVar8 + 0x4c),fStack_6c,0);
          iVar8 = *(int *)(iVar5 + 0x2c);
          *(float *)(iVar8 + 0x6c) = fStack_80;
          *(float *)(iVar8 + 0x70) = fStack_7c;
          *(float *)(iVar8 + 0x74) = fStack_78;
          (**(code **)(DAT_100b5aa0 + 0xc))
                    (local_a8,local_a8,local_a8,local_a8,local_a8,local_a8,iVar8 + 0x78,iVar8 + 0x7c
                     ,iVar8 + 0x80,local_a8,local_a8,local_a8,local_a8,*(undefined4 *)(iVar8 + 0x6c)
                     ,*(undefined4 *)(iVar8 + 0x70),fStack_78,0);
          iVar8 = *(int *)(param_1 + 0x38);
          *(undefined4 *)(iVar5 + 0x30) = 4;
          iVar7 = 0;
          do {
            if (iVar7 == 2) {
              iVar9 = 3;
            }
            else {
              iVar9 = iVar7;
              if (iVar7 == 3) {
                iVar9 = 2;
              }
            }
            iVar1 = iVar7 * 8;
            iVar3 = *(int *)(iVar5 + 0x2c);
            iVar7 = iVar7 + 1;
            *(float *)(iVar3 + 0x1c + iVar9 * 0x24) = (float)*(double *)(iVar8 + iVar1);
            iVar3 = iVar3 + iVar9 * 0x24;
            *(float *)(iVar3 + 0x20) = (float)*(double *)(*(int *)(param_1 + 0x3c) + -8 + iVar7 * 8)
            ;
            *(undefined4 *)(iVar3 + 0x18) = 0xffffffff;
          } while (iVar7 < 4);
          iVar8 = FUN_10007060(*(undefined4 *)(param_1 + 0xc),1,0);
          if (iVar8 != 0) {
            (**(code **)(*(int *)(iVar8 + 0x34) + 4))(&local_9c);
            FUN_100073d0(iVar8);
            if (local_9c == (void *)0x0) {
              iVar8 = 0;
            }
            else {
              iVar8 = (int)local_9c + -0x34;
            }
            *(int *)(iVar5 + 0x28) = iVar8;
            if (iVar8 != 0) {
              return iVar5;
            }
          }
        }
      }
      FUN_100073d0(iVar5);
    }
  }
  return 0;
}
