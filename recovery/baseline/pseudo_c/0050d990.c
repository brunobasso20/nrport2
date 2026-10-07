/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0050d990 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0050d990(int param_1)

{
  char *pcVar1;
  float *pfVar2;
  short sVar3;
  int iVar4;
  int iVar5;
  float *pfVar6;
  float10 fVar7;
  float10 fVar8;
  float local_24;
  float local_20;
  float local_1c;
  float local_18;
  undefined1 local_14 [4];
  undefined1 local_10 [4];
  undefined1 local_c [4];
  undefined1 local_8 [4];
  int local_4;
  
  if (DAT_00b8fac4 != '\0') {
    sVar3 = FUN_0055a690();
    if (sVar3 != 2) {
      DAT_00b8fac5 = '\0';
    }
    iVar5 = *(int *)(param_1 + 0x5ae);
    iVar4 = (int)ROUND(*(float *)(iVar5 + 0x3c) * _DAT_00b8f814);
    local_4 = iVar4;
    if (DAT_00b8fad0 != '\0') {
      DAT_00b8fad0 = '\0';
      DAT_00b8fad4 = iVar4;
      DAT_00b8fadc = FUN_0050d930(iVar4,-DAT_00749424);
      if (DAT_00b8faf4 != 0) {
        FUN_00583aa0(DAT_00b8faf4);
      }
      DAT_00b8faf4 = FUN_00583a40(iVar5);
    }
    if (DAT_00b8fad1 != '\0') {
      DAT_00b8fad1 = '\0';
      DAT_00b8fad8 = iVar4;
      DAT_00b8fae0 = FUN_0050d930(iVar4,DAT_00749424);
      if (DAT_00b8faf8 != 0) {
        FUN_00583aa0(DAT_00b8faf8);
      }
      DAT_00b8faf8 = FUN_00583a40(iVar5);
    }
    if (DAT_00b8fad2 != '\0') {
      DAT_00b8fad2 = '\0';
      DAT_00b8fad4 = 0;
      DAT_00b8fad8 = 0;
      DAT_00b8fadc = 0;
      DAT_00b8fae0 = 0;
      if (DAT_00b8faf4 != 0) {
        FUN_00583aa0(DAT_00b8faf4);
      }
      if (DAT_00b8faf8 != 0) {
        FUN_00583aa0(DAT_00b8faf8);
      }
      DAT_00b8faf4 = 0;
      DAT_00b8faf8 = 0;
    }
    if (DAT_00b8fad3 != '\0') {
      DAT_00b8fad3 = '\0';
      if (DAT_00b8fafc != 0) {
        FUN_00583aa0(DAT_00b8fafc);
      }
      DAT_00b8fafc = FUN_00583a40(iVar5);
    }
    FUN_0050ddb0();
    if (DAT_00b8fac5 == '\0') {
      iVar4 = 0;
      do {
        pcVar1 = s_Reflap_info_stashing_turned_off_00749500 + iVar4;
        (&DAT_00b8f880)[iVar4] = *pcVar1;
        iVar4 = iVar4 + 1;
      } while (*pcVar1 != '\0');
      _DAT_00b8fa98 = &DAT_00b8f880;
      return;
    }
    FUN_0051e0c0(iVar5,&local_1c,&local_18,local_c,local_8,&local_24,&local_20,local_10,local_14);
    iVar4 = (int)ROUND(_DAT_00b8f814 * local_1c);
    local_24 = SQRT(local_20 * local_20 + local_24 * local_24);
    local_4 = iVar4;
    if (iVar4 != DAT_00b8fb00) {
      fVar7 = (float10)FUN_00516d3a(DAT_00b8fb04,local_1c);
      iVar5 = DAT_00b8fb00;
      if ((float10)_DAT_006ea454 <= fVar7) {
        do {
          iVar5 = (iVar5 + 1) % DAT_00b8faa0;
          local_4 = iVar5;
          fVar8 = (float10)FUN_00516d3a(DAT_00b8fb04,(float)iVar5 * _DAT_006f4098);
          pfVar2 = (float *)(iVar5 * 0x18 + DAT_00b8fae4);
          pfVar6 = (float *)(DAT_00b8fae8 + iVar5 * 0x18);
          if ((float)fVar7 <= _DAT_006ea67c) {
            fVar8 = (float10)_DAT_006e97d8;
          }
          else {
            fVar8 = fVar8 / (float10)(float)fVar7;
          }
          pfVar6[2] = pfVar2[2];
          *pfVar6 = *pfVar2;
          pfVar6[1] = pfVar2[1];
          pfVar2[2] = (float)(((float10)local_18 - (float10)_DAT_00b8fb08) * fVar8 +
                             (float10)_DAT_00b8fb08);
          *pfVar2 = (float)(((float10)local_24 - (float10)_DAT_00b8fb0c) * fVar8 +
                           (float10)_DAT_00b8fb0c);
          pfVar2[1] = (float)(((float10)local_20 - (float10)_DAT_00b8fb10) * fVar8 +
                             (float10)_DAT_00b8fb10);
          if ((DAT_00b8fad4 != DAT_00b8fadc) && (iVar5 == DAT_00b8fad4)) {
            DAT_00b8fadc = FUN_0050d930(iVar5,-DAT_00749424);
          }
          if ((DAT_00b8fad8 != DAT_00b8fae0) && (iVar5 == DAT_00b8fad8)) {
            DAT_00b8fae0 = FUN_0050d930(iVar5,DAT_00749424);
          }
        } while (iVar5 != iVar4);
      }
    }
    DAT_00b8fb04 = local_1c;
    _DAT_00b8fb08 = local_18;
    _DAT_00b8fb0c = local_24;
    _DAT_00b8fb10 = local_20;
    DAT_00b8fb00 = iVar4;
    FUN_006c4f81(&DAT_00b8f268,s_Reflap_info_stashed_for__d_00749520,iVar4);
    iVar4 = 0;
    do {
      pcVar1 = &DAT_00b8f268 + iVar4;
      (&DAT_00b8f880)[iVar4] = *pcVar1;
      iVar4 = iVar4 + 1;
    } while (*pcVar1 != '\0');
    _DAT_00b8fa98 = &DAT_00b8f880;
  }
  return;
}


