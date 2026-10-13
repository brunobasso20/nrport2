/* Ghidra pseudo-C; NR2003.exe @ 005b3090 */

void FUN_005b3090(undefined4 param_1)

{
  undefined4 uVar1;
  int iVar2;

  DAT_00e84664 = &DAT_00e84474;
  FUN_005b39a0(param_1);
  DAT_00e84548 = FUN_005b9cf0();
  FUN_005b3180(param_1);
  FUN_0055e410();
  DAT_00e84498 = FUN_005b9cf0();
  iVar2 = 0;
  do {
    FUN_0055d9c0(iVar2);
    uVar1 = FUN_005b9cf0();
    (&DAT_00e84b90)[iVar2] = uVar1;
    iVar2 = iVar2 + 1;
  } while (iVar2 < 4);
  FUN_005b3990();
  DAT_00e84bdc = FUN_005b9cf0();
  DAT_00e84664 = &DAT_00e84474;
  FUN_005b3e50(param_1);
  DAT_00e84ba0 = FUN_005b9cf0();
  FUN_005b9d10(DAT_00e84498);
  iVar2 = 0;
  do {
    FUN_0055e1e0(&DAT_00e84c8c,0x3f800000,&DAT_00e84c8c,&DAT_00e84c8c,&DAT_00e84a20,iVar2,0,0,
                 0x3f800000,0x49742400,0);
    iVar2 = iVar2 + 1;
  } while (iVar2 < 4);
  FUN_005b9d10(DAT_00e84bdc);
  FUN_005b2fb0(param_1);
  DAT_00e84604 = FUN_005b9cf0();
  return;
}
