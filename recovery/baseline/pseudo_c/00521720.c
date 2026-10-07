/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00521720 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

uint __fastcall FUN_00521720(float *param_1)

{
  float fVar1;
  float *pfVar2;
  ushort uVar3;
  
  pfVar2 = *(float **)(*(int *)((int)param_1 + 0x89) + 0x5ae);
  if ((pfVar2 != (float *)0x0) && (*(char *)(param_1 + 0x19) != '\0')) {
    fVar1 = (pfVar2[1] - param_1[1]) * param_1[0x16] - (*pfVar2 - *param_1) * param_1[0x17];
    if (*(char *)((int)param_1 + 0xfe) != '\0') {
      pfVar2 = (float *)CONCAT22((short)((uint)pfVar2 >> 0x10),
                                 (ushort)(fVar1 < _DAT_006ed6c8) << 8 |
                                 (ushort)(NAN(fVar1) || NAN(_DAT_006ed6c8)) << 10 |
                                 (ushort)(fVar1 == _DAT_006ed6c8) << 0xe);
      if (fVar1 < _DAT_006ed6c8) {
        return CONCAT31((int3)((uint)pfVar2 >> 8),1);
      }
      if (*(char *)((int)param_1 + 0xfe) != '\0') goto LAB_0052177d;
    }
    uVar3 = (ushort)(fVar1 < _DAT_006f4a30) << 8 | (ushort)(fVar1 == _DAT_006f4a30) << 0xe;
    pfVar2 = (float *)(uint)uVar3;
    if (fVar1 < _DAT_006f4a30 == 0 && (fVar1 == _DAT_006f4a30) == 0) {
      return CONCAT31((uint3)(byte)(uVar3 >> 8),1);
    }
  }
LAB_0052177d:
  return (uint)pfVar2 & 0xffffff00;
}


