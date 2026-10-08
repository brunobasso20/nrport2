/* NR2003.exe @ 0054b5a0 FUN_0054b5a0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_0054b5a0(int param_1_00,float param_1)

{
  float fVar1;
  uint uVar2;
  float fVar3;
  uint uVar4;
  
  uVar2 = *(uint *)(param_1_00 + 0xc);
  uVar4 = FUN_006c5018();
  fVar3 = _DAT_006f3e30;
  fVar1 = *(float *)(param_1_00 + 0x58);
  *(uint *)(param_1_00 + 0xc) = (uVar4 ^ uVar2) & 0x3f ^ uVar2;
  *(float *)(param_1_00 + 0x58) = param_1;
  if ((fVar3 < param_1) && (_DAT_006ea470 < param_1 - fVar1)) {
    FUN_00549be0(*(uint *)(param_1_00 + 4) & 0x7f);
    return;
  }
  return;
}

