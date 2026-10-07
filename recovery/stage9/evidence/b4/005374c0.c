/* NR2003.exe @ 005374c0 FUN_005374c0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005374c0(void)

{
  int iVar1;
  float10 fVar2;
  float fVar3;
  undefined4 uVar4;
  
  iVar1 = FUN_0055a680();
  uVar4 = 0;
  fVar2 = (float10)fcos(((float10)(ulonglong)(*(byte *)(iVar1 + 0x47) - 1) * (float10)_DAT_006f53c4
                        + (float10)(*(byte *)(iVar1 + 0x46) - 1)) * (float10)_DAT_006f53c0 *
                        (float10)_DAT_006f53bc);
  fVar3 = (float)-fVar2;
  if ((char)DAT_00bdccd8 != '\0') {
    FUN_006c4ac9(&DAT_00bdccd8,&DAT_0074c53c,&DAT_00bddd24,fVar3,0);
    DAT_00bddd24 = (DAT_00bddd24 - _DAT_006efe7c) * _DAT_006f53b8;
  }
  if (DAT_00bdcd18 != '\0') {
    FUN_006c4ac9(&DAT_00bdcd18,&DAT_0074c540,&DAT_00bddd28,fVar3,uVar4);
    _DAT_00bddd28 = _DAT_00bddd28 * _DAT_006f53b8;
  }
  if (DAT_00bdcd58 != '\0') {
    FUN_006c4ac9(&DAT_00bdcd58,&DAT_0074c544,&DAT_00bddd2c,fVar3,uVar4);
    _DAT_00bddd2c = _DAT_00bddd2c * _DAT_006f53b8;
  }
  DAT_00bddd24 = _DAT_00bddd2c * fVar3 + DAT_00bddd24;
  if (DAT_00bdcd98 != '\0') {
    FUN_006c4ac9(&DAT_00bdcd98,&DAT_0074c548,&DAT_00bddd30,fVar3,uVar4);
    _DAT_00bddd30 = _DAT_00bddd30 * (float)_DAT_006ef7b0;
  }
  if (DAT_00bdcdd8 != '\0') {
    FUN_006c4ac9(&DAT_00bdcdd8,&DAT_0074c54c,&DAT_00bddd34,fVar3,uVar4);
    _DAT_00bddd34 = _DAT_00bddd34 * (float)_DAT_006ef7b0;
  }
  if (DAT_00bdce18 != '\0') {
    FUN_006c4ac9(&DAT_00bdce18,&DAT_0074c550,&DAT_00bddd38);
    _DAT_00bddd38 = _DAT_00bddd38 * _DAT_006f5370;
  }
  if (DAT_00bdce58 != '\0') {
    FUN_006c4ac9(&DAT_00bdce58,&DAT_0074c554,&DAT_00bddd3c);
  }
  return;
}

