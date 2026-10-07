/* NR2003.exe @ 005236b0 FUN_005236b0 */

void __thiscall FUN_005236b0(int param_1_00,float param_1)

{
  int iVar1;
  float10 fVar2;
  
  if (*(char *)(param_1_00 + 0xfd) != '\0') {
    fVar2 = (float10)FUN_00557d80(0x2e);
    if ((float10)param_1 < fVar2 != (NAN((float10)param_1) || NAN(fVar2))) {
      param_1 = (float)fVar2;
    }
    fVar2 = (float10)FUN_00557dc0(0x2e);
    if (fVar2 < (float10)param_1) {
      param_1 = (float)fVar2;
    }
    iVar1 = *(int *)(*(int *)(param_1_00 + 0x89) + 0x58e);
    if (((iVar1 == 1) || (iVar1 == 5)) &&
       (fVar2 = (float10)FUN_00557e40(0x2d),
       (float10)param_1 < fVar2 != (NAN((float10)param_1) || NAN(fVar2)))) {
      *(float *)(param_1_00 + 0xee) = (float)fVar2;
      return;
    }
    *(float *)(param_1_00 + 0xee) = param_1;
  }
  return;
}

