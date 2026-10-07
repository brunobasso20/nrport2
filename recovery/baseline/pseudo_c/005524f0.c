/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005524f0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005524f0(void)

{
  char cVar1;
  undefined4 uVar2;
  int iVar3;
  int iVar4;
  float10 fVar5;
  
  fVar5 = (float10)FUN_00554f50();
  uVar2 = FUN_0055ab00();
  iVar3 = FUN_00562f70(uVar2);
  if (_DAT_006ee598 <= (float)fVar5) {
    iVar4 = FUN_0055a610();
    if (*(int *)(iVar4 + 0xc) != iVar3) {
      FUN_0055a610();
      FUN_00568e00();
    }
    _DAT_00bf6f18 = 0;
  }
  iVar4 = FUN_0055a5c0();
  if (((iVar4 != 3) || (DAT_00bf6eb8 != '\0')) ||
     (iVar4 = FUN_0055a610(), *(int *)(iVar4 + 0xc) != iVar3)) {
    _DAT_00bf63c8 = 0.0;
    _DAT_00bf6f14 = 0;
    _DAT_0074c98c = 0;
    _DAT_00bf6388 = 0;
    _DAT_00bf6e84 = 0;
    DAT_00bf63bc = 0;
    _DAT_00bf638c = 0;
    _DAT_00bf6390 = 0.0;
    _DAT_00bf6eac = 1.0;
    DAT_00bf6eb0 = 0.0;
    iVar3 = FUN_0055a5c0();
    if (iVar3 != 3) {
      FUN_00550640();
    }
    DAT_00bf6e22 = 0;
    DAT_00bf6e21 = 0;
    DAT_00bf6e20 = 0;
    return;
  }
  cVar1 = FUN_0057af40(3);
  if (cVar1 == '\0') {
    if (DAT_00bf6f36 != '\0') {
      *(undefined4 *)(iVar3 + 0x1518) = *(undefined4 *)(iVar3 + 0x1508);
    }
    DAT_00bf6f36 = 0;
  }
  else {
    DAT_00bf6f36 = 1;
  }
  if (DAT_00bf6eb9 == '\0') {
    fVar5 = (float10)FUN_00553080();
    _DAT_00bf6eac = (float)fVar5;
    fVar5 = (float10)FUN_005534f0();
    DAT_00bf6eb0 = (float)fVar5;
  }
  else {
    _DAT_00bf6eac = 1.0;
    DAT_00bf6eb0 = 0.0;
  }
  fVar5 = (float10)FUN_00552720();
  _DAT_00bf63c8 = (float)fVar5;
  fVar5 = (float10)FUN_00552df0();
  _DAT_00bf6390 = (float)fVar5;
  FUN_00553540(&DAT_00bf6e20);
  cVar1 = FUN_0057af40(0x19);
  if (cVar1 != '\0') {
    if (DAT_00bf6ea0 == 3) {
      DAT_00bf6e98 = FUN_006c5018();
      DAT_00bf6df4 = DAT_00bf6e98;
      DAT_00bf6ea0 = 4;
      return;
    }
    if (DAT_00bf6ea0 != 0) {
      return;
    }
    taskGetRate();
    DAT_00bf6e0c = FUN_006c5018();
    DAT_00bf6e10 = DAT_00bf6e0c;
    DAT_00bf6ea0 = 5;
    return;
  }
  if (DAT_00bf6ea0 != 6) {
    return;
  }
  taskGetRate();
  DAT_00bf6e0c = FUN_006c5018();
  DAT_00bf6e10 = DAT_00bf6e0c;
  DAT_00bf6ea0 = 7;
  return;
}


