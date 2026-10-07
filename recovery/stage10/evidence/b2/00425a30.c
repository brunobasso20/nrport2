/* NR2003.exe @ 00425a30 FUN_00425a30 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00425a30(void)

{
  float fVar1;
  float *pfVar2;
  float *pfVar3;
  float *pfVar4;
  
  pfVar2 = (float *)FUN_00557d60(0x26);
  pfVar3 = (float *)FUN_00557d60(0x9e);
  pfVar4 = (float *)FUN_00557d60(0x27);
  *pfVar3 = *pfVar4 - *pfVar2;
  pfVar2 = (float *)FUN_00557d60(0x9e);
  pfVar3 = (float *)FUN_00557d60(0x24);
  fVar1 = (float)(int)ROUND((*pfVar3 + *pfVar2) * _DAT_006ed794 * _DAT_006e9804 + _DAT_006ea4cc) *
          _DAT_006ed798 * _DAT_006ea50c;
  pfVar2 = (float *)FUN_00557d60(0x25);
  *pfVar2 = fVar1;
  return;
}

