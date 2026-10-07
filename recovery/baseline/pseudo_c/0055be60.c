/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0055be60 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0055be60(byte *param_1)

{
  ushort uVar1;
  char cVar2;
  int iVar3;
  uint uVar4;
  int extraout_ECX;
  uint extraout_ECX_00;
  int extraout_ECX_01;
  float10 fVar5;
  
  iVar3 = FUN_0055a6f0();
  if (*(int *)(param_1 + 8) != iVar3) {
    FUN_00567140();
    FUN_0055a910();
    return;
  }
  iVar3 = FUN_0055a6a0();
  if ((int)(short)(extraout_ECX << 4) >> 8 != iVar3) {
LAB_0055bf35:
    iVar3 = FUN_0055a6a0();
    if (iVar3 != -1) {
      FUN_00567140();
      cVar2 = FUN_00501480();
      if (cVar2 != '\0') {
        FUN_00501b30();
      }
    }
    uVar1 = *(ushort *)(param_1 + 2);
    FUN_00566e50((int)(short)(uVar1 << 4) >> 8,uVar1 & 0xf,uVar1 >> 0xc);
    fVar5 = (float10)FUN_005c3290(DAT_00c08194);
    FUN_0055a740((double)(fVar5 + (float10)*(float *)(param_1 + 4)));
    iVar3 = FUN_0055a680();
    FUN_00547e90(*(uint *)(iVar3 + 0x4c) >> 0x16 & 3);
    FUN_0055a7a0();
    FUN_005c2fb0();
    return;
  }
  uVar4 = FUN_0055a6b0();
  if ((extraout_ECX_00 & 0xf) != uVar4) goto LAB_0055bf35;
  fVar5 = (float10)FUN_005c3290();
  FUN_0055a740((double)(fVar5 + (float10)*(float *)(param_1 + 4)));
  FUN_0055a720(*(ushort *)(param_1 + 2) >> 0xc);
  if (*param_1 >> 6 != 0) {
    iVar3 = FUN_0055a5c0();
    if (iVar3 != extraout_ECX_01) {
      FUN_0055a940();
    }
    _DAT_00c081d0 = _DAT_00c081d0 + 1;
    iVar3 = taskGetRate();
    if (iVar3 < _DAT_00c081d0) {
      FUN_0055a790();
      _DAT_00c081d0 = 0;
    }
    return;
  }
  iVar3 = FUN_0055a5c0();
  if (iVar3 != 1) {
    iVar3 = FUN_0055a5c0();
    if (iVar3 != 2) goto LAB_0055bf2f;
  }
  FUN_0055aa40();
LAB_0055bf2f:
  FUN_0055a790();
  return;
}


