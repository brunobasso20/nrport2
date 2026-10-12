/* NR2003.exe @ 100244d0 FUN_100244d0 */

undefined4 __thiscall FUN_100244d0(void *this,float *param_1,char *param_2)

{
  float fVar1;
  float fVar2;
  char cVar3;
  undefined4 in_EAX;
  undefined3 uVar5;
  uint uVar4;
  float *pfVar6;
  int iVar7;
  
  cVar3 = *(char *)((int)this + 0x20b0);
  uVar5 = (undefined3)((uint)in_EAX >> 8);
  *param_2 = cVar3;
  if (*(char *)(param_1 + 6) == '\0') {
    return CONCAT31(uVar5,1);
  }
  if (cVar3 != '\0') {
    return CONCAT31(uVar5,1);
  }
  iVar7 = 0;
  pfVar6 = (float *)(*(int *)((int)this + 0x2032) + 0x68);
  do {
    switch((((uint)pfVar6[1] >> 1 | (uint)*pfVar6 & 0xbfffffff) >> 1 | (uint)pfVar6[-1] & 0x9fffffff
           ) >> 0x1d) {
    case 0:
      fVar1 = param_1[1] * *pfVar6 + param_1[2] * pfVar6[1];
      fVar2 = *param_1;
      break;
    case 1:
      fVar1 = param_1[1] * *pfVar6 + param_1[5] * pfVar6[1];
      fVar2 = *param_1;
      break;
    case 2:
      fVar1 = param_1[2] * pfVar6[1] + param_1[4] * *pfVar6;
      fVar2 = *param_1;
      break;
    case 3:
      fVar1 = param_1[4] * *pfVar6 + param_1[5] * pfVar6[1];
      fVar2 = *param_1;
      break;
    case 4:
      fVar2 = param_1[2] * pfVar6[1];
      fVar1 = param_1[1];
      goto LAB_100245ad;
    case 5:
      fVar2 = param_1[5] * pfVar6[1];
      fVar1 = param_1[1];
      goto LAB_100245ad;
    case 6:
      fVar2 = param_1[4] * *pfVar6;
      fVar1 = param_1[2] * pfVar6[1];
      goto LAB_100245af;
    case 7:
      fVar2 = param_1[5] * pfVar6[1];
      fVar1 = param_1[4];
LAB_100245ad:
      fVar1 = fVar1 * *pfVar6;
LAB_100245af:
      fVar1 = fVar1 + fVar2;
      fVar2 = param_1[3];
      break;
    default:
      goto switchD_10024536_caseD_8;
    }
    fVar1 = fVar2 * pfVar6[-1] + fVar1;
    fVar2 = -pfVar6[2];
    if (fVar2 < fVar1 != (NAN(fVar2) || NAN(fVar1))) {
      *(undefined *)((int)this + 0x20b0) = 0;
      return (uint)(byte)(fVar2 < fVar1 |
                          (byte)((ushort)((ushort)(NAN(fVar2) || NAN(fVar1)) << 10) >> 8) |
                         (byte)((ushort)((ushort)(fVar2 == fVar1) << 0xe) >> 8)) << 8;
    }
switchD_10024536_caseD_8:
    iVar7 = iVar7 + 1;
    pfVar6 = pfVar6 + 5;
  } while (iVar7 < 6);
  iVar7 = 0;
  pfVar6 = (float *)(*(int *)((int)this + 0x2032) + 0x68);
  do {
    uVar4 = (((uint)pfVar6[1] >> 1 | (uint)*pfVar6 & 0xbfffffff) >> 1 |
            (uint)pfVar6[-1] & 0x9fffffff) >> 0x1d;
    switch(uVar4) {
    case 0:
      fVar1 = param_1[4] * *pfVar6 + param_1[5] * pfVar6[1];
      fVar2 = param_1[3];
      break;
    case 1:
      fVar1 = param_1[2] * pfVar6[1] + param_1[4] * *pfVar6;
      fVar2 = param_1[3];
      break;
    case 2:
      fVar1 = param_1[1] * *pfVar6 + param_1[5] * pfVar6[1];
      fVar2 = param_1[3];
      break;
    case 3:
      fVar1 = param_1[1] * *pfVar6 + param_1[2] * pfVar6[1];
      fVar2 = param_1[3];
      break;
    case 4:
      fVar2 = param_1[5] * pfVar6[1];
      fVar1 = param_1[4];
      goto LAB_100246b7;
    case 5:
      fVar2 = param_1[4] * *pfVar6;
      fVar1 = param_1[2] * pfVar6[1];
      goto LAB_100246b9;
    case 6:
      fVar1 = *param_1 * pfVar6[-1] + param_1[1] * *pfVar6 + param_1[5] * pfVar6[1];
      fVar2 = -pfVar6[2];
      uVar4 = (uint)(ushort)((ushort)(fVar2 < fVar1) << 8 | (ushort)(NAN(fVar2) || NAN(fVar1)) << 10
                            | (ushort)(fVar2 == fVar1) << 0xe);
      if (fVar2 < fVar1 != (NAN(fVar2) || NAN(fVar1))) goto LAB_1002469f;
      goto LAB_100246d8;
    case 7:
      fVar2 = param_1[2] * pfVar6[1];
      fVar1 = param_1[1];
LAB_100246b7:
      fVar1 = fVar1 * *pfVar6;
LAB_100246b9:
      fVar1 = fVar1 + fVar2;
      fVar2 = *param_1;
      break;
    default:
      *(undefined *)((int)this + 0x20b0) = 0;
      goto LAB_100246d8;
    }
    fVar1 = fVar2 * pfVar6[-1] + fVar1;
    fVar2 = -pfVar6[2];
    uVar4 = (uint)(ushort)((ushort)(fVar2 < fVar1) << 8 | (ushort)(NAN(fVar2) || NAN(fVar1)) << 10 |
                          (ushort)(fVar2 == fVar1) << 0xe);
    if (fVar2 < fVar1 != (NAN(fVar2) || NAN(fVar1))) {
LAB_1002469f:
      *(undefined *)((int)this + 0x20b0) = 0;
      return CONCAT31((int3)(uVar4 >> 8),1);
    }
LAB_100246d8:
    iVar7 = iVar7 + 1;
    pfVar6 = pfVar6 + 5;
    if (5 < iVar7) {
      *(undefined *)((int)this + 0x20b0) = 1;
      return CONCAT31((int3)(uVar4 >> 8),1);
    }
  } while( true );
}

