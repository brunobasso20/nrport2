/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00528260 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00528260(float param_1,float *param_2)

{
  float fVar1;
  int iVar2;
  char cVar3;
  int iVar4;
  int *piVar5;
  float unaff_ESI;
  float10 fVar6;
  unkbyte10 Var7;
  undefined1 **ppuVar8;
  undefined1 *puStack_1c;
  undefined4 uStack_10;
  undefined1 local_c [4];
  float fStack_8;
  int local_4;
  
  iVar2 = (int)param_1;
  puStack_1c = (undefined1 *)0x528274;
  fVar6 = (float10)FUN_004fff80();
  puStack_1c = (undefined1 *)**(undefined4 **)((int)param_1 + 0x21e8);
  param_1 = (float)(fVar6 - (float10)_DAT_006e9810);
  iVar4 = FUN_00536260();
  local_4 = *(int *)(iVar4 + 0xb);
  if (param_1 < _DAT_006ea454 != (param_1 == _DAT_006ea454)) {
    param_1 = 12.408;
  }
  if (*param_2 < _DAT_006ea454) {
    *param_2 = 0.0;
  }
  puStack_1c = local_c;
  (**(code **)(**(int **)(iVar2 + 0x13bb) + 0x2c))(iVar2);
  if (unaff_ESI < *param_2) {
    *param_2 = unaff_ESI;
  }
  cVar3 = FUN_0052e780();
  if (cVar3 == '\0') {
    if (param_1._0_1_ != '\0') {
      iVar4 = (**(code **)(**(int **)(iVar2 + 0x13b3) + 0x4c))(iVar2);
      Var7 = fpatan((float10)*(float *)(*(int *)(iVar4 + 0xc) + 0xc + local_4 * 0x1c),(float10)1);
      fVar6 = (float10)fcos(Var7);
      puStack_1c = (undefined1 *)(float)fVar6;
      fStack_8 = (float)(fVar6 * (float10)fStack_8);
      fVar6 = (float10)FUN_00516daa(*(undefined4 *)(iVar2 + 0x186a),uStack_10);
      if (fVar6 < (float10)_DAT_006e97d8) {
        fVar6 = (float10)_DAT_006e97d8;
      }
      fVar6 = (((float10)fStack_8 - (float10)*(float *)(iVar2 + 0x1872)) *
              ((float10)fStack_8 + (float10)*(float *)(iVar2 + 0x1872))) / (fVar6 + fVar6);
      fVar1 = (float)fVar6;
      if (fVar6 < (float10)_DAT_006ea454) {
        fStack_8 = 0.45;
        piVar5 = (int *)FUN_00538ae0();
        iVar4 = (**(code **)(*piVar5 + 0x38))();
        if (iVar4 != 0) {
          fStack_8 = _DAT_006ea50c;
        }
        if ((fVar1 < -(fStack_8 * *(float *)(iVar2 + 0x1972))) &&
           (fVar1 = (*(float *)(iVar2 + 0x1846) + *(float *)(iVar2 + 0x1b8d) + _DAT_006ea62c) *
                    fVar1 + *(float *)(iVar2 + 0x1872), fVar1 < *param_2)) {
          *param_2 = fVar1;
          return;
        }
      }
    }
  }
  else {
    piVar5 = (int *)(**(code **)(**(int **)(iVar2 + 0x13b3) + 0x4c))(iVar2);
    ppuVar8 = &puStack_1c;
    (**(code **)(*piVar5 + 0x38))(iVar2,&stack0xffffffec);
    if ((float)ppuVar8 * unaff_ESI < *param_2) {
      *param_2 = (float)ppuVar8 * unaff_ESI;
      return;
    }
  }
  return;
}


