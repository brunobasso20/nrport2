/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00408430 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00408430(int param_1)

{
  int iVar1;
  int *piVar2;
  int iVar3;
  int iVar4;
  float10 fVar5;
  float unaff_retaddr;
  
  iVar1 = FUN_00405000(param_1);
  FUN_00408570(iVar1);
  if ((iVar1 == DAT_00760b38) &&
     (*(float *)(iVar1 + 0x1872) < (_DAT_0074b080 - _DAT_006ea514) * _DAT_006e9810)) {
    iVar1 = 0;
  }
  fVar5 = (float10)FUN_00405140(param_1);
  *(float *)(param_1 + 0x1b71) = (float)fVar5;
  piVar2 = (int *)FUN_00413e20();
  iVar4 = *(int *)(param_1 + 0x1afe);
  iVar3 = (**(code **)(*piVar2 + 0x24))(iVar4);
  if ((iVar3 == *(int *)(param_1 + 0x5b2)) &&
     (*(float *)(param_1 + 0x1b71) =
           ((_DAT_0074b080 + _DAT_006ea4a0) * _DAT_006e9810 - *(float *)(param_1 + 0x1872)) *
           _DAT_006ea508, 0 < iVar4)) {
    piVar2 = (int *)FUN_00413e20();
    iVar4 = (**(code **)(*piVar2 + 0x24))(iVar4 + -1);
    if (-1 < iVar4) {
      iVar3 = FUN_004f5970(iVar4);
      if (*(int *)(iVar3 + 4) != 0) {
        if (*(int *)(param_1 + 0x1b0a) < 0) {
          *(undefined4 *)(param_1 + 0x1b0a) = 0xfffffffe;
        }
        iVar1 = FUN_004f5970(iVar4);
        unaff_retaddr = 0.25;
        *(undefined4 *)(param_1 + 0x1b71) = 0x4cbebc20;
      }
    }
  }
  if (iVar1 != 0) {
    fVar5 = (float10)FUN_0052b070(param_1,iVar1);
    FUN_00404f30(param_1,iVar1,
                 (float)((fVar5 - (float10)unaff_retaddr) * (float10)_DAT_006ea44c +
                        (float10)unaff_retaddr));
  }
  FUN_00407f20(param_1,iVar1,param_1 + 0x1b85,param_1 + 0x1b89);
  return;
}


