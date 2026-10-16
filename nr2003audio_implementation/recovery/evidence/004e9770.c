/* NR2003.exe @ 004e9770 FUN_004e9770 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 __fastcall FUN_004e9770(int *param_1)

{
  float unaff_EBX;
  float fStack_24;
  float fVar1;
  float local_18;
  undefined auStack_14 [4];
  float local_10;
  undefined local_8 [8];
  
  fStack_24 = 1.401298e-45;
  local_10 = 0.0;
  (**(code **)(*param_1 + 4))(local_8,0);
  local_18 = local_10;
  fVar1 = unaff_EBX;
  if ((float)param_1[4] + (float)_DAT_006ed098 <= local_10) {
    while( true ) {
      do {
        unaff_EBX = fVar1;
        (**(code **)(*param_1 + 4))(auStack_14,unaff_EBX + fStack_24,1);
        fVar1 = unaff_EBX + fStack_24;
      } while ((float)param_1[4] + (float)_DAT_006ed098 < local_10);
      if (ABS(local_18 - local_10) < (float)_DAT_006ed098 !=
          (NAN(ABS(local_18 - local_10)) || NAN((float)_DAT_006ed098))) break;
      fStack_24 = fStack_24 * _DAT_006ea44c;
      fVar1 = unaff_EBX + fStack_24;
      (**(code **)(*param_1 + 4))(auStack_14,fVar1,1);
      if (local_10 <= (float)param_1[4] + (float)_DAT_006ed098) {
        do {
          fStack_24 = fStack_24 * _DAT_006ea44c;
          fVar1 = unaff_EBX + fStack_24;
          (**(code **)(*param_1 + 4))(auStack_14,fVar1,1);
        } while (local_10 <= (float)param_1[4] + (float)_DAT_006ed098);
      }
      fStack_24 = fStack_24 * _DAT_006ea44c;
      local_18 = local_10;
    }
  }
  return (float10)unaff_EBX;
}

