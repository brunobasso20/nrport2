/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b36c0 */

void FUN_005b36c0(int param_1,int param_2,int param_3,int param_4,int *param_5)

{
  int iVar1;
  int *piVar2;
  int iVar3;
  
  iVar1 = 0;
  piVar2 = param_5;
  if (0 < param_4) {
    do {
      (**(code **)PTR_PTR_0074fe4c)(&DAT_00e84710,param_3 + *piVar2 * 4);
      iVar3 = 0;
      if (0 < iVar1) {
        do {
          (**(code **)(PTR_PTR_0074fe48 + 0xc))
                    (&DAT_00e84ba4,param_2 + (param_5[iVar3] + *piVar2 * 6) * 4,
                     param_1 + param_5[iVar3] * 4);
          (**(code **)(PTR_PTR_0074fe48 + 8))(&DAT_00e84710,&DAT_00e84710,&DAT_00e84ba4);
          iVar3 = iVar3 + 1;
        } while (iVar3 < iVar1);
      }
      (**(code **)PTR_PTR_0074fe4c)(param_1 + *piVar2 * 4,&DAT_00e84710);
      iVar1 = iVar1 + 1;
      piVar2 = piVar2 + 1;
    } while (iVar1 < param_4);
  }
  iVar1 = param_4 + -1;
  if (-1 < iVar1) {
    piVar2 = param_5 + iVar1;
    do {
      (**(code **)PTR_PTR_0074fe4c)(&DAT_00e84710,param_1 + *piVar2 * 4);
      iVar3 = iVar1;
      while (iVar3 = iVar3 + 1, iVar3 < param_4) {
        (**(code **)(PTR_PTR_0074fe48 + 0xc))
                  (&DAT_00e84ba4,param_2 + (param_5[iVar3] + *piVar2 * 6) * 4,
                   param_1 + param_5[iVar3] * 4);
        (**(code **)(PTR_PTR_0074fe48 + 8))(&DAT_00e84710,&DAT_00e84710,&DAT_00e84ba4);
      }
      (**(code **)(PTR_PTR_0074fe4c + 8))(&DAT_00e84ba4,param_2 + *piVar2 * 0x1c);
      (**(code **)(PTR_PTR_0074fe48 + 0xc))(param_1 + *piVar2 * 4,&DAT_00e84ba4,&DAT_00e84710);
      iVar1 = iVar1 + -1;
      piVar2 = piVar2 + -1;
    } while (-1 < iVar1);
  }
  return;
}


