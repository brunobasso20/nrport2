/* NR2003.exe @ 0042b410 FUN_0042b410 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0042b410(int param_1,int param_2)

{
  int *piVar1;
  byte bVar2;
  undefined4 unaff_EDI;
  undefined4 local_c;
  undefined4 local_8;
  undefined4 local_4;
  
  bVar2 = (byte)*(undefined2 *)(param_2 + 0x92);
  local_c = 0;
  local_4 = 0;
  local_8 = 0;
  if (((bVar2 & 3) == 3) && (*(undefined4 **)(param_1 + 0x2f8) != (undefined4 *)0x0)) {
    (**(code **)**(undefined4 **)(param_1 + 0x2f8))(0);
    piVar1 = *(int **)(param_1 + 0x2e4);
    if (piVar1 != (int *)0x0) {
      (**(code **)(*piVar1 + 0x10))(&local_c,&local_4,&local_8);
      if (piVar1 != (int *)0x0) {
        (**(code **)(*piVar1 + 8))(local_c,*(float *)(param_1 + 0x264) - _DAT_006ee4cc,0);
        if (piVar1 != (int *)0x0) {
          (**(code **)*piVar1)
                    (*(undefined4 *)(param_1 + 0x22c),*(float *)(param_1 + 0x230) - _DAT_006ee4c8,
                     *(float *)(param_1 + 0x234) + _DAT_006ea4d4);
        }
      }
    }
  }
  if (((bVar2 & 0xc) == 0xc) && (*(undefined4 **)(param_1 + 0x2fc) != (undefined4 *)0x0)) {
    if (param_1 != -0x2f8) {
      (**(code **)**(undefined4 **)(param_1 + 0x2fc))(0);
    }
    piVar1 = *(int **)(param_1 + 0x2e8);
    if (piVar1 != (int *)0x0) {
      (**(code **)(*piVar1 + 0x10))(&local_c,&local_4,&local_8);
      if (piVar1 != (int *)0x0) {
        (**(code **)(*piVar1 + 8))(local_c,*(float *)(param_1 + 0x270) + _DAT_006ee4cc,0);
        if (piVar1 != (int *)0x0) {
          (**(code **)*piVar1)
                    (*(undefined4 *)(param_1 + 0x238),*(float *)(param_1 + 0x23c) + _DAT_006ee4c4,
                     *(float *)(param_1 + 0x240) + _DAT_006ea4d4);
        }
      }
    }
  }
  if (((bVar2 & 0x30) == 0x30) && (*(undefined4 **)(param_1 + 0x300) != (undefined4 *)0x0)) {
    if (param_1 != -0x2f8) {
      (**(code **)**(undefined4 **)(param_1 + 0x300))(0);
    }
    piVar1 = *(int **)(param_1 + 0x2ec);
    if (piVar1 != (int *)0x0) {
      (**(code **)(*piVar1 + 0x10))(&local_c,&local_4,&local_8);
      if (piVar1 != (int *)0x0) {
        (**(code **)(*piVar1 + 8))(local_c,*(float *)(param_1 + 0x27c) - _DAT_006ee4cc,0);
        if (piVar1 != (int *)0x0) {
          (**(code **)*piVar1)
                    (*(undefined4 *)(param_1 + 0x244),*(float *)(param_1 + 0x248) - _DAT_006ee4c4,
                     *(float *)(param_1 + 0x24c) + _DAT_006ea4d4);
        }
      }
    }
  }
  if (((bVar2 & 0xc0) == 0xc0) && (*(undefined4 **)(param_1 + 0x304) != (undefined4 *)0x0)) {
    if (param_1 != -0x2f8) {
      (**(code **)**(undefined4 **)(param_1 + 0x304))(0);
    }
    piVar1 = *(int **)(param_1 + 0x2f0);
    if (piVar1 != (int *)0x0) {
      (**(code **)(*piVar1 + 0x10))(&local_c,&local_4,&local_8);
      if (piVar1 != (int *)0x0) {
        (**(code **)(*piVar1 + 8))(unaff_EDI,*(float *)(param_1 + 0x288) + _DAT_006ee4cc,0);
        if (piVar1 != (int *)0x0) {
          (**(code **)*piVar1)
                    (*(undefined4 *)(param_1 + 0x250),*(float *)(param_1 + 0x254) + _DAT_006ee4c4,
                     *(float *)(param_1 + 600) + _DAT_006ea4d4);
        }
      }
    }
  }
  return;
}

