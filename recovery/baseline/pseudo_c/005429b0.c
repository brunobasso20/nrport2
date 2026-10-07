/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005429b0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_005429b0(int param_1_00,int param_1,double *param_2)

{
  int iVar1;
  undefined4 *puVar2;
  uint uVar3;
  double *pdVar4;
  int *piVar5;
  uint local_cc;
  int local_c0 [4];
  undefined4 local_b0;
  undefined4 local_ac;
  undefined1 local_8c;
  
  if ((_DAT_006ea4b0 <= *(double *)((int)param_2 + 0x1c)) &&
     (uVar3 = (uint)(*(char *)(param_1 + 0x1fb5) != '\0'), uVar3 < 6)) {
    puVar2 = (undefined4 *)(uVar3 * 0x19 + 0x2c + (int)param_2);
    do {
      if (*(double *)(puVar2 + -4) < _DAT_006ea4b0) break;
      *puVar2 = 3;
      *(undefined1 *)(puVar2 + 2) = 0;
      uVar3 = uVar3 + 1;
      puVar2 = (undefined4 *)((int)puVar2 + 0x19);
    } while ((int)uVar3 < 6);
  }
  FUN_00542b70(param_1,param_2);
  if (_DAT_006ea4b0 <= *(double *)((int)param_2 + 0x1c)) {
    pdVar4 = param_2;
    piVar5 = local_c0;
    for (iVar1 = 0x2c; iVar1 != 0; iVar1 = iVar1 + -1) {
      *piVar5 = *(int *)pdVar4;
      pdVar4 = (double *)((int)pdVar4 + 4);
      piVar5 = piVar5 + 1;
    }
    *(undefined2 *)piVar5 = *(undefined2 *)pdVar4;
    local_cc = (uint)(*(char *)(param_1 + 0x1fb5) != '\0');
    if (local_cc < 6) {
      piVar5 = (int *)(local_cc * 0x19 + 0x2c + (int)param_2);
      do {
        if (*(double *)(piVar5 + -4) < _DAT_006ea4b0) break;
        iVar1 = 2;
        do {
          *(int *)(((int)local_c0 - (int)param_2) + (int)piVar5) = iVar1;
          FUN_00542b70(param_1,local_c0);
          if (*param_2 <= (double)CONCAT44(local_c0[1],local_c0[0])) {
            *(int *)(((int)local_c0 - (int)param_2) + (int)piVar5) = *piVar5;
          }
          else {
            *piVar5 = iVar1;
            *(int *)param_2 = local_c0[0];
            *(int *)((int)param_2 + 4) = local_c0[1];
            *(int *)(param_2 + 1) = local_c0[2];
            *(int *)((int)param_2 + 0xc) = local_c0[3];
            *(undefined4 *)(param_2 + 2) = local_b0;
            *(undefined4 *)((int)param_2 + 0x14) = local_ac;
          }
          iVar1 = iVar1 + -1;
        } while (-1 < iVar1);
        piVar5 = (int *)((int)piVar5 + 0x19);
        local_cc = local_cc + 1;
      } while ((int)local_cc < 6);
    }
    if (_DAT_006ea4b0 < *(double *)(param_1_00 + 0x58)) {
      local_8c = 1;
      FUN_00542b70(param_1,local_c0);
      if ((double)CONCAT44(local_c0[1],local_c0[0]) < *param_2) {
        *(int *)param_2 = local_c0[0];
        *(int *)((int)param_2 + 4) = local_c0[1];
        *(int *)(param_2 + 1) = local_c0[2];
        *(undefined1 *)((int)param_2 + 0x34) = 1;
        *(int *)((int)param_2 + 0xc) = local_c0[3];
        *(undefined4 *)(param_2 + 2) = local_b0;
        *(undefined4 *)((int)param_2 + 0x14) = local_ac;
      }
    }
  }
  return;
}


