/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00419eb0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_00419eb0(int param_1)

{
  char cVar1;
  int *piVar2;
  float10 fVar3;
  double dVar4;
  
  cVar1 = FUN_00417f30();
  if (cVar1 == '\0') {
    if ((*(int *)(param_1 + 0x4d) == 0) && (*(int *)(param_1 + 0x51) == -0x40100000)) {
      dVar4 = rndUniform(0);
      dVar4 = dVar4 * _DAT_006e9838 + _DAT_006ed060;
      fVar3 = (float10)(*(code *)**(undefined4 **)(param_1 + 0x49))();
      *(double *)(param_1 + 0x4d) = (double)(fVar3 + (float10)dVar4);
    }
    if ((*(int *)(param_1 + 0x4d) != 0) || (*(int *)(param_1 + 0x51) != -0x40100000)) {
      fVar3 = (float10)(*(code *)**(undefined4 **)(param_1 + 0x49))();
      if ((fVar3 <= (float10)*(double *)(param_1 + 0x4d)) &&
         (fVar3 = (float10)(*(code *)**(undefined4 **)(param_1 + 0x49))(),
         (float10)*(double *)(param_1 + 0x4d) - fVar3 != (float10)_DAT_006ea4b0)) {
        return;
      }
      piVar2 = (int *)FUN_00413e20();
      (**(code **)(*piVar2 + 0xc))();
      FUN_00509bd0(4);
      FUN_0041a070();
      return;
    }
  }
  else {
    if ((*(int *)(param_1 + 0x35) == 0) && (*(int *)(param_1 + 0x39) == -0x40100000)) {
      dVar4 = rndUniform(0);
      dVar4 = dVar4 * _DAT_006e9838 + _DAT_006ed060;
      fVar3 = (float10)(*(code *)**(undefined4 **)(param_1 + 0x31))();
      *(double *)(param_1 + 0x35) = (double)(fVar3 + (float10)dVar4);
    }
    if ((*(int *)(param_1 + 0x35) != 0) || (*(int *)(param_1 + 0x39) != -0x40100000)) {
      fVar3 = (float10)(*(code *)**(undefined4 **)(param_1 + 0x31))();
      if ((fVar3 <= (float10)*(double *)(param_1 + 0x35)) &&
         (fVar3 = (float10)(*(code *)**(undefined4 **)(param_1 + 0x31))(),
         (float10)*(double *)(param_1 + 0x35) - fVar3 != (float10)_DAT_006ea4b0)) {
        return;
      }
      piVar2 = (int *)FUN_00413e20();
      (**(code **)(*piVar2 + 0xc))();
      FUN_00509bd0(3);
    }
  }
  return;
}


