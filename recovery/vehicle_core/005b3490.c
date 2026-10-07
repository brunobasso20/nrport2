/* Ghidra pseudo-C; NR2003.exe @ 005b3490 */

void FUN_005b3490(int *param_1,int param_2,int param_3,int *param_4)

{
  int iVar1;
  int iVar2;
  int iVar3;
  int *piVar4;
  int *piVar5;
  int local_4;
  
  iVar1 = (int)param_1;
  local_4 = 0;
  piVar5 = param_4;
  if (0 < param_3) {
    do {
      iVar3 = 0;
      if (0 < local_4) {
        param_1 = param_4;
        do {
          (**(code **)PTR_PTR_0074fe4c)(&DAT_00e8472c,param_2 + (*piVar5 + *param_1 * 6) * 4);
          iVar2 = 0;
          if (0 < iVar3) {
            do {
              (**(code **)(PTR_PTR_0074fe48 + 0xc))
                        (&DAT_00e84ad4,iVar1 + (param_4[iVar2] + *param_1 * 6) * 4,
                         iVar1 + (*piVar5 + param_4[iVar2] * 6) * 4);
              (**(code **)(PTR_PTR_0074fe48 + 8))(&DAT_00e8472c,&DAT_00e8472c,&DAT_00e84ad4);
              iVar2 = iVar2 + 1;
            } while (iVar2 < iVar3);
          }
          (**(code **)PTR_PTR_0074fe4c)(iVar1 + (*piVar5 + *param_1 * 6) * 4,&DAT_00e8472c);
          iVar3 = iVar3 + 1;
          param_1 = param_1 + 1;
        } while (iVar3 < local_4);
      }
      if (local_4 < param_3) {
        param_1 = (int *)(param_3 - local_4);
        piVar4 = piVar5;
        do {
          (**(code **)PTR_PTR_0074fe4c)(&DAT_00e8472c,param_2 + (*piVar5 + *piVar4 * 6) * 4);
          iVar3 = 0;
          if (0 < local_4) {
            do {
              (**(code **)(PTR_PTR_0074fe48 + 0xc))
                        (&DAT_00e84ad4,iVar1 + (param_4[iVar3] + *piVar4 * 6) * 4,
                         iVar1 + (*piVar5 + param_4[iVar3] * 6) * 4);
              (**(code **)(PTR_PTR_0074fe48 + 8))(&DAT_00e8472c,&DAT_00e8472c,&DAT_00e84ad4);
              iVar3 = iVar3 + 1;
            } while (iVar3 < local_4);
          }
          (**(code **)PTR_PTR_0074fe4c)(iVar1 + (*piVar5 + *piVar4 * 6) * 4,&DAT_00e8472c);
          piVar4 = piVar4 + 1;
          param_1 = (int *)((int)param_1 + -1);
        } while (param_1 != (int *)0x0);
      }
      if (local_4 != param_3 + -1) {
        (**(code **)(PTR_PTR_0074fe4c + 8))(&DAT_00e84ad4,iVar1 + *piVar5 * 0x1c);
        iVar3 = local_4;
        while (iVar3 = iVar3 + 1, iVar3 < param_3) {
          iVar2 = iVar1 + (*piVar5 + param_4[iVar3] * 6) * 4;
          (**(code **)(PTR_PTR_0074fe48 + 0xc))(iVar2,iVar2,&DAT_00e84ad4);
        }
      }
      local_4 = local_4 + 1;
      piVar5 = piVar5 + 1;
    } while (local_4 < param_3);
  }
  return;
}

