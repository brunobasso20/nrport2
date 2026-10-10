/* NR2003.exe @ 0057bdd0 FUN_0057bdd0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0057bdd0(void)

{
  char cVar1;
  int iVar2;
  undefined4 uVar3;
  int iVar4;
  uint uVar5;
  undefined4 *puVar6;
  uint uVar7;
  undefined4 *puVar8;
  float10 fVar9;
  float10 fVar10;
  int local_10;
  uint local_c;
  uint local_8;
  undefined4 local_4;
  
  uVar7 = 0;
  DAT_00d37c9a = DAT_00d37c9a + -1;
  local_8 = 0;
  if (DAT_00d37c9a < 1) {
    _DAT_00d37c9e = 0;
    _DAT_00d37ca2 = 0;
  }
  if ((DAT_00d37c64 & 1) != 0) {
    uVar5 = 0;
    iVar2 = FUN_005d0420();
    if (0 < iVar2) {
      while ((int)uVar5 < 0x10) {
        fVar9 = (float10)FUN_005d0750(uVar5);
        fVar10 = fVar9 - (float10)(float)(&DAT_00d37c18)[uVar5];
        if (((float10)_DAT_006ef640 < fVar10) ||
           (fVar10 < (float10)_DAT_006f664c != (NAN(fVar10) || NAN((float10)_DAT_006f664c)))) {
          _DAT_00d37c8d = 1;
          DAT_00d37c95 = 0;
          DAT_00d37c99 = 1;
          DAT_00d37c91 = uVar5;
          if (fVar9 <= (float10)_DAT_006ea454) {
            DAT_00d37c99 = 0;
          }
          break;
        }
        uVar5 = uVar5 + 1;
        iVar2 = FUN_005d0420();
        if (iVar2 <= (int)uVar5) break;
      }
    }
  }
  if ((DAT_00d37c64 & 2) != 0) {
    iVar2 = 0;
    do {
      cVar1 = FUN_005d06c0(iVar2);
      if (cVar1 != '\0') {
        uVar7 = uVar7 | 1 << ((byte)iVar2 & 0x1f);
      }
      cVar1 = FUN_005d0700(iVar2);
      if (cVar1 != '\0') {
        local_8 = local_8 | 1 << ((byte)iVar2 & 0x1f);
      }
      iVar2 = iVar2 + 1;
    } while (iVar2 < 0x20);
    if (uVar7 != 0) {
      _DAT_00d37c8d = 2;
      DAT_00d37c91 = uVar7;
      uVar3 = FUN_005d0130();
      DAT_00d37c95 = FUN_0057c4e0(uVar3);
    }
  }
  local_c = 0;
  uVar7 = DAT_00d37c91;
  if ((DAT_00d37c64 & 4) != 0) {
    cVar1 = FUN_005d00d0(&local_c,&local_4);
    uVar7 = DAT_00d37c91;
    DAT_00d37c91 = local_c;
    do {
      local_c = DAT_00d37c91;
      if (((cVar1 == '\0') || (DAT_00d37c91 == 0x1b)) || (DAT_00d37c91 == 0xd)) break;
      if ((((DAT_00d37c91 != 0x10) && (DAT_00d37c91 != 0xc0)) &&
          ((DAT_00d37c91 != 0x11 && ((DAT_00d37c91 != 0xc1 && (DAT_00d37c91 != 0x12)))))) &&
         ((DAT_00d37c91 != 0xc2 && ((DAT_00d37c91 != 0x13 && (DAT_00d37c91 != 0x2c)))))) {
        if (((((DAT_00d3b02c != '\0') || ((DAT_00d37c68 & 1) == 0)) ||
             ((0xc4 < (int)DAT_00d37c91 && ((int)DAT_00d37c91 < 0xd1)))) ||
            ((0xaf < (int)DAT_00d37c91 && ((int)DAT_00d37c91 < 0xbf)))) || (DAT_00d37c91 == 0xc)) {
          _DAT_00d37c8d = 4;
          DAT_00d37c95 = FUN_0057c4e0(local_4);
          DAT_00d37c9a = 0;
          _DAT_00d37c9e = 0;
          _DAT_00d37ca2 = 0;
          uVar7 = DAT_00d37c91;
          break;
        }
        DAT_00d37c91 = uVar7;
        iVar2 = taskGetRate();
        DAT_00d37c9a = iVar2 * 5;
        _DAT_00d37c9e = 0;
        _DAT_00d37ca2 = 0x858;
        uVar7 = DAT_00d37c91;
      }
      DAT_00d37c91 = uVar7;
      cVar1 = FUN_005d00d0(&local_c,&local_4);
      uVar7 = DAT_00d37c91;
      DAT_00d37c91 = local_c;
    } while( true );
  }
  DAT_00d37c91 = uVar7;
  cVar1 = FUN_005d0070(0x1b,0);
  if ((cVar1 == '\0') && (local_c != 0x1b)) {
    if ((DAT_00d37c5c != 1) || ((cVar1 = FUN_005d0070(0xd,0), cVar1 == '\0' && (local_c != 0xd)))) {
      if ((DAT_00d37c5c == 0) && (_DAT_00d37c8d != 0)) goto LAB_0057c0db;
LAB_0057c05f:
      iVar2 = DAT_00d37c58;
      if (DAT_00d37ca6 != '\0') {
        return;
      }
      goto LAB_0057c070;
    }
    if (_DAT_00d37c8d == 0) goto LAB_0057c1fa;
LAB_0057c0db:
    cVar1 = FUN_0057c410(&local_10,0,&DAT_00d37c7d);
    if (cVar1 != '\0') {
      if (*(int *)((int)&DAT_00d37cc4 + local_10 * 0x1d) == 0) {
        iVar2 = taskGetRate();
        DAT_00d37c9a = iVar2 * 5;
        _DAT_00d37c9e = local_10;
        _DAT_00d37ca2 = 0x859;
        goto LAB_0057c05f;
      }
      FUN_0057c680(local_10);
    }
    if (DAT_00d37c5c == 1) {
      if (_DAT_00d37c8d == 2) {
        if (DAT_00d37c91 == local_8) {
          uVar3 = FUN_005d0130();
          iVar2 = FUN_0057c4e0(uVar3);
          if (DAT_00d37c95 != iVar2) goto LAB_0057c14b;
LAB_0057c17e:
          _DAT_00d37c7d = 0;
          goto LAB_0057c18c;
        }
      }
      else {
LAB_0057c14b:
        if ((_DAT_00d37c8d == 4) && (cVar1 = FUN_005d0060(DAT_00d37c91), cVar1 != '\0')) {
          uVar3 = FUN_005d0130();
          iVar2 = FUN_0057c4e0(uVar3);
          if (DAT_00d37c95 == iVar2) goto LAB_0057c17e;
        }
      }
      _DAT_00d37c7d = 1;
    }
LAB_0057c18c:
    puVar6 = (undefined4 *)&DAT_00d37c7d;
  }
  else {
LAB_0057c1fa:
    puVar6 = (undefined4 *)&DAT_00d37c60;
  }
  iVar2 = DAT_00d37c58;
  puVar8 = (undefined4 *)((int)&DAT_00d37cb8 + DAT_00d37c58 * 0x1d);
  for (iVar4 = 7; iVar4 != 0; iVar4 = iVar4 + -1) {
    *puVar8 = *puVar6;
    puVar6 = puVar6 + 1;
    puVar8 = puVar8 + 1;
  }
  *(undefined *)puVar8 = *(undefined *)puVar6;
  DAT_00d37ca6 = '\0';
LAB_0057c070:
  if (iVar2 == 7) {
    if (_DAT_00d37d93 == 1) {
      cVar1 = FUN_005d0770(DAT_00d37d97);
      if (cVar1 == '\0') {
        FUN_0057c6b0(8,DAT_00d37d97,DAT_00d37d9b,DAT_00d37d9f == '\0');
        cVar1 = FUN_0057c410(&local_10,0,&DAT_00d37da0);
        if (cVar1 != '\0') {
          if (*(int *)((int)&DAT_00d37cc4 + local_10 * 0x1d) == 0) {
            FUN_0057a870(7,DAT_00d37c5c);
            FUN_0057c680(8);
            iVar2 = taskGetRate();
            DAT_00d37c9a = iVar2 * 5;
            _DAT_00d37c9e = local_10;
            _DAT_00d37ca2 = 0x859;
          }
          else {
            FUN_0057c680(local_10);
          }
        }
      }
      else {
        FUN_0057a870(7,DAT_00d37c5c);
        iVar2 = taskGetRate();
        DAT_00d37c9a = iVar2 * 5;
        _DAT_00d37c9e = 0;
        _DAT_00d37ca2 = 0x85a;
      }
    }
    else {
      FUN_0057a870(8,DAT_00d37c5c);
    }
    DAT_00d3b025 = 1;
    FUN_0057c790();
    iVar2 = DAT_00d37c58;
    if (DAT_00d37ca6 != '\0') {
      return;
    }
  }
  if (iVar2 == 0x54) {
    if (_DAT_00d3864c == 1) {
      cVar1 = FUN_005d0770(DAT_00d38650);
      if (cVar1 == '\0') {
        FUN_0057c6b0(0x55,DAT_00d38650,DAT_00d38654,DAT_00d38658 == '\0');
        cVar1 = FUN_0057c410(&local_10,0,&DAT_00d38659);
        if (cVar1 != '\0') {
          if (*(int *)((int)&DAT_00d37cc4 + local_10 * 0x1d) == 0) {
            FUN_0057a870(0x54,DAT_00d37c5c);
            FUN_0057c680(0x55);
            iVar2 = taskGetRate();
            DAT_00d37c9a = iVar2 * 5;
            _DAT_00d37c9e = local_10;
            _DAT_00d37ca2 = 0x859;
          }
          else {
            FUN_0057c680(local_10);
          }
        }
      }
      else {
        FUN_0057a870(0x54,DAT_00d37c5c);
        iVar2 = taskGetRate();
        DAT_00d37c9a = iVar2 * 5;
        _DAT_00d37c9e = 0;
        _DAT_00d37ca2 = 0x85b;
      }
    }
    else {
      FUN_0057a870(0x55,DAT_00d37c5c);
    }
    DAT_00d3b025 = 1;
    FUN_0057c790();
    if (DAT_00d37ca6 != '\0') {
      return;
    }
  }
  DAT_00d3b025 = 1;
  FUN_0057c7f0();
  FUN_0057c790();
  return;
}

