/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00553d70 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00553d70(void)

{
  char cVar1;
  int iVar2;
  bool bVar3;
  float10 fVar4;
  undefined8 uVar5;
  
  iVar2 = DAT_00bf6f0c;
  if (DAT_00bf6f0c == 2) {
    iVar2 = FUN_0051a000();
    if (*(int *)(iVar2 + 0x444) + 1 < DAT_00bf6e23) {
      DAT_00bf6e23 = 1;
    }
    if ((DAT_0074c97c != DAT_00bf6e23) && (DAT_00bf6e23 != 1)) {
      FUN_005543e0();
      DAT_0074c970 = 0.0;
    }
    DAT_0074c97c = DAT_00bf6e23;
    DAT_0074c978 = FUN_00565830(DAT_00bf6e23);
    cVar1 = FUN_005542e0();
    if (cVar1 == '\0') {
      return;
    }
    if (DAT_0074c970 < DAT_00bf6370) {
      DAT_00bf6370 = DAT_0074c970;
    }
    DAT_0074c970 = _DAT_0074fd74 * _DAT_006ea514 + DAT_0074c970;
    if (DAT_0074c970 <= _DAT_006e97d8) {
      return;
    }
    DAT_0074c970 = 1.0;
    return;
  }
  if (DAT_00bf6e98 != 0) {
    DAT_00bf6e98 = DAT_00bf6e98 + -1;
    if (DAT_00bf6e98 == 0) {
      if (DAT_00bf6ea0 == 3) {
        DAT_00bf6df4 = FUN_006c5018();
        DAT_00bf6ea0 = 4;
        DAT_00bf6e98 = DAT_00bf6df4;
      }
      else if (DAT_00bf6ea0 == 4) {
        DAT_00bf6ea0 = 0;
      }
    }
    goto switchD_00553eaf_caseD_8;
  }
  switch(DAT_00bf63cc) {
  case 1:
    cVar1 = FUN_00552400();
    if (cVar1 == '\0') {
      DAT_00bf63ac = DAT_00bf6e23;
      if (iVar2 == 0) {
        DAT_00bf63ac = DAT_0074c97c + 1;
      }
    }
    else {
      DAT_00bf63ac = FUN_005538a0(DAT_0074c97c);
    }
    iVar2 = FUN_0051a000();
    if ((*(int *)(iVar2 + 0x444) + 1 < DAT_00bf63ac) || (DAT_00bf63ac == DAT_0074c97c))
    goto LAB_005541eb;
    DAT_00bf6e98 = 0;
    DAT_00bf6df4 = 0;
    DAT_00bf6ea0 = 1;
    DAT_00bf63cc = 2;
    cVar1 = FUN_00552400();
    if (cVar1 == '\0') break;
    DAT_0074c96c = 0.0;
    goto LAB_00554206;
  case 2:
    DAT_0074c978 = FUN_00565830(DAT_0074c97c);
    DAT_0074c97c = 1;
    DAT_00bf6df4 = FUN_006c5018();
    DAT_00bf6ea0 = 2;
    DAT_00bf63cc = 3;
    DAT_00bf6e98 = DAT_00bf6df4;
    break;
  case 3:
    DAT_0074c978 = FUN_00565830(DAT_00bf63ac);
    DAT_00bf6df4 = FUN_006c5018();
    DAT_00bf6ea0 = 2;
    DAT_00bf63cc = 4;
    DAT_00bf6e98 = DAT_00bf6df4;
    break;
  case 4:
    DAT_0074c97c = DAT_00bf63ac;
    FUN_005543e0();
    DAT_00bf6df4 = FUN_006c5018();
    DAT_00bf6ea0 = 4;
    DAT_00bf63cc = 0;
    DAT_0074c96c = -1.0;
    DAT_00bf6e98 = DAT_00bf6df4;
    goto LAB_00554210;
  case 5:
    cVar1 = FUN_00552400();
    if (cVar1 == '\0') {
      uVar5 = CONCAT44(DAT_0074c97c,DAT_0074c97c + -1);
      if (iVar2 != 0) {
        uVar5 = CONCAT44(DAT_0074c97c,DAT_00bf6e23);
      }
    }
    else {
      uVar5 = FUN_005538f0(DAT_0074c97c);
    }
    DAT_00bf63ac = (int)uVar5;
    if ((DAT_00bf63ac < 0) || (DAT_00bf63ac == (int)((ulonglong)uVar5 >> 0x20))) goto LAB_005541eb;
    DAT_00bf6df4 = 0;
    bVar3 = DAT_00bf6ea0 != 3;
    DAT_00bf6e98 = 0;
    DAT_00bf6ea0 = 2;
    if (bVar3) {
      DAT_00bf6ea0 = 1;
    }
    DAT_00bf63cc = 6;
    break;
  case 6:
    DAT_0074c978 = FUN_00565830(DAT_0074c97c);
    DAT_0074c97c = 1;
    _DAT_00bf6e18 = 0x3e91eb85;
    fVar4 = (float10)FUN_00554f10();
    if (((float10)_DAT_006f5a40 < fVar4) && (1 < DAT_00bf63ac)) {
      DAT_00bf635c = 0.48;
      cVar1 = FUN_005542e0();
      if (cVar1 != '\0') {
        DAT_0074c96c = DAT_00bf635c;
      }
    }
    DAT_00bf6df4 = FUN_006c5018();
    DAT_00bf6ea0 = 2;
    DAT_00bf63cc = 7;
    DAT_00bf6e98 = DAT_00bf6df4;
    break;
  case 7:
    DAT_0074c978 = FUN_00565830(DAT_00bf63ac);
    DAT_0074c96c = -1.0;
    cVar1 = FUN_005542e0();
    if (cVar1 != '\0') {
      DAT_0074c970 = 0.0;
    }
    DAT_00bf6df4 = FUN_006c5018();
    DAT_00bf6ea0 = 2;
    DAT_00bf63cc = 8;
    DAT_00bf6e98 = DAT_00bf6df4;
    break;
  case 8:
    DAT_0074c97c = DAT_00bf63ac;
    FUN_005543e0();
    DAT_0074c970 = 1.0;
    if (DAT_00bf63ac < 3) {
      DAT_00bf6df4 = FUN_006c5018();
      DAT_00bf6ea0 = 4;
      DAT_00bf6e98 = DAT_00bf6df4;
    }
    else {
      DAT_00bf6df4 = FUN_006c5018();
      DAT_00bf6ea0 = 3;
      DAT_00bf6e98 = DAT_00bf6df4;
    }
LAB_005541eb:
    DAT_00bf63cc = 0;
  }
switchD_00553eaf_caseD_8:
  if (_DAT_006ea454 <= DAT_0074c96c) {
LAB_00554206:
    DAT_00bf6368 = DAT_0074c96c;
  }
LAB_00554210:
  cVar1 = FUN_005542e0();
  if (cVar1 == '\0') {
    cVar1 = FUN_0057af60(4);
    if (cVar1 != '\0') {
      FUN_005542f0(DAT_00bf6370,0x3f800000);
    }
    return;
  }
  cVar1 = FUN_0057af60(4);
  if (cVar1 != '\0') {
    if (DAT_0074c970 < DAT_00bf6370) {
      FUN_005542f0(DAT_0074c970,0x3f800000);
      return;
    }
    FUN_005542f0(DAT_00bf6370,0x3f800000);
    return;
  }
  FUN_005542f0(DAT_0074c970,DAT_00bf6370);
  return;
}


