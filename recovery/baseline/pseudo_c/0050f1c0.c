/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0050f1c0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0050f1c0(void)

{
  char cVar1;
  int iVar2;
  byte bVar3;
  undefined4 local_8;
  uint local_4;
  
  DAT_00bd79b8 = 0;
  iVar2 = FUN_00544bf0();
  if ((*(byte *)(iVar2 + 0x50) & 4) == 0) {
    bVar3 = *(byte *)(iVar2 + 0x5f);
  }
  else {
    bVar3 = *(byte *)(iVar2 + 100) >> 1;
  }
  local_4 = (uint)bVar3;
  _DAT_0074851c = (float)local_4 * _DAT_006ea4a4;
  DAT_00bdaa2c = 0;
  DAT_00bdaa28 = (byte)((uint)*(undefined4 *)(iVar2 + 0x4c) >> 0x1e) & 1;
  _DAT_00bdaa30 = 0;
  _DAT_00bdaa34 = 0;
  DAT_00748520 = _DAT_0074851c;
  iVar2 = FUN_005099b0();
  if ((iVar2 == 7) && (iVar2 = FUN_00538ab0(), *(char *)(iVar2 + 0x10327) == '\0')) {
    iVar2 = FUN_00509a00();
    DAT_00bdaa38 = iVar2 + 1;
  }
  else {
    DAT_00bdaa38 = 0;
  }
  local_8 = 0;
  cVar1 = FUN_004f5f70(&local_8);
  while (cVar1 != '\0') {
    FUN_00529c70(local_8);
    cVar1 = FUN_004f5f70(&local_8);
  }
  if (DAT_00b9329c == '\0') {
    _DAT_00b93038 = FUN_006c5018();
    _DAT_00b93044 = DAT_00b93014;
    _DAT_00b8fbec = &DAT_00b93038;
    DAT_00b93014 = &DAT_00b8fbe0;
    DAT_00b9329c = '\x01';
  }
  FUN_004018d0();
  return;
}


