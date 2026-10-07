/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0052fad0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_0052fad0(int param_1)

{
  ushort uVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  float fVar6;
  float fVar7;
  float fVar8;
  float fVar9;
  float fVar10;
  bool bVar11;
  byte bVar12;
  char cVar13;
  ushort *puVar14;
  
  puVar14 = (ushort *)FUN_00567610(*(undefined4 *)(param_1 + 0x5b2));
  *(undefined4 *)(param_1 + 0x1b33) = 0;
  fVar2 = *(float *)(puVar14 + 0x2c);
  fVar3 = *(float *)(puVar14 + 0x30);
  fVar4 = *(float *)(puVar14 + 0x2e);
  fVar5 = *(float *)(puVar14 + 0x2a);
  fVar6 = *(float *)(puVar14 + 0x26);
  fVar7 = *(float *)(puVar14 + 0x28);
  if (((*(uint *)(puVar14 + 6) >> 0x1d & 1) == 0) && ((*(uint *)(puVar14 + 6) >> 0x1e & 1) == 0)) {
    bVar11 = false;
  }
  else {
    bVar11 = true;
  }
  uVar1 = *puVar14;
  fVar8 = _DAT_006e97d8 -
          (_DAT_006e97d8 - *(float *)(puVar14 + 0x1e)) *
          (_DAT_006e97d8 - *(float *)(puVar14 + 0x20)) *
          (_DAT_006e97d8 - *(float *)(puVar14 + 0x22)) *
          (_DAT_006e97d8 - *(float *)(puVar14 + 0x24));
  bVar12 = (byte)puVar14[1];
  fVar9 = _DAT_006e97d8 -
          (_DAT_006e97d8 - (float)(byte)((byte)uVar1 >> 6) * _DAT_006ea674) *
          (_DAT_006e97d8 - (float)((byte)(uVar1 >> 8) & 3) * _DAT_006ea674) *
          (_DAT_006e97d8 - (float)((uVar1 & 0xc00) >> 10) * _DAT_006ea674) *
          (_DAT_006e97d8 - (float)((uVar1 & 0x3000) >> 0xc) * _DAT_006ea674);
  fVar10 = _DAT_006e97d8 -
           (_DAT_006e97d8 - (float)(puVar14[1] & 3) * _DAT_006ea674) *
           (_DAT_006e97d8 - (float)(bVar12 >> 2 & 3) * _DAT_006ea674) *
           (_DAT_006e97d8 - (float)(bVar12 >> 4 & 3) * _DAT_006ea674) *
           (_DAT_006e97d8 - (float)(bVar12 >> 6) * _DAT_006ea674);
  FUN_0051f8d0(param_1);
  FUN_0052f0a0();
  if (((((((_DAT_006e981c < fVar2) || (_DAT_006e981c < fVar10)) || (_DAT_006e981c < fVar9)) ||
        ((_DAT_006ea504 < fVar8 || (_DAT_006ed020 < fVar3)))) ||
       ((_DAT_006ed020 < fVar4 || ((_DAT_006ed020 < fVar5 || (_DAT_006ed020 < fVar6)))))) ||
      (_DAT_006ed020 < fVar7)) ||
     ((*(float *)(param_1 + 0x1d56) < _DAT_006ed6c8 ||
      (_DAT_006ea49c < *(float *)(param_1 + 0x1d52))))) {
    *(undefined4 *)(param_1 + 0x1b33) = 2;
  }
  if (*(int *)(param_1 + 0x1b33) < 1) {
    if (((((fVar2 <= _DAT_006ee4c4) && (fVar10 <= _DAT_006ef640)) && (fVar9 <= _DAT_006ef640)) &&
        (((fVar8 <= _DAT_006ef640 && (!bVar11)) &&
         ((fVar3 <= _DAT_006ef640 &&
          ((fVar4 <= _DAT_006ea504 && (_DAT_006ed020 <= *(float *)(param_1 + 0x1d56))))))))) &&
       ((*(float *)(param_1 + 0x1d52) <= _DAT_006f4130 &&
        (cVar13 = FUN_00548420(puVar14), cVar13 == '\0')))) {
      return;
    }
    *(undefined4 *)(param_1 + 0x1b33) = 1;
  }
  return;
}


