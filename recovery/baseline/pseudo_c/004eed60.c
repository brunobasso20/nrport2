/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004eed60 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_004eed60(int param_1,undefined4 *param_2)

{
  int iVar1;
  undefined4 *puVar2;
  char cVar3;
  int *piVar4;
  int iVar5;
  int iVar6;
  int *piVar7;
  uint uVar8;
  int *piVar9;
  int iVar10;
  __uint64 _Var11;
  undefined8 uVar12;
  int *local_34;
  undefined8 local_30;
  int local_28;
  uint uStack_24;
  uint uStack_20;
  undefined4 uStack_1c;
  double local_18;
  undefined4 uStack_c;
  
  _Var11 = taskGetCPURate();
  uVar8 = (uint)(_Var11 >> 0x20);
  uStack_24 = uVar8 & 0x80000000;
  local_28 = 0;
  local_18 = _DAT_006e9808 /
             (-(double)(longlong)(((ulonglong)uVar8 & 0x80000000) << 0x20) +
             (double)(_Var11 & 0x7fffffffffffffff));
  if (-1 < DAT_00a6c1f8 + -1) {
    piVar9 = (int *)((int)&DAT_00a68890 + (DAT_00a6c1f8 + -1) * 0x35);
    local_30 = (double)CONCAT44(local_30._4_4_,DAT_00a6c1f8);
    do {
      FUN_004f3830(piVar9[2]);
      FUN_004efea0(&local_34);
      for (; local_34 != piVar9; local_34 = (int *)local_34[1]) {
        if (local_34[2] != 0) {
          *(undefined1 *)(local_34[2] + 0x1d) = 0;
          piVar4 = (int *)(**(code **)(*(int *)local_34[2] + 0xc))();
          iVar5 = *piVar4;
          if (iVar5 != 0) {
            if (*(int *)(iVar5 + 0x4c) == 0) {
LAB_004eee2b:
              cVar3 = FUN_004f0810();
              if (cVar3 != '\0') {
LAB_004eee36:
                if ((*(int *)(iVar5 + 0x4c) != 3) || (2 < *(int *)(iVar5 + 4))) goto LAB_004eee75;
              }
            }
            else if ((2 < *(int *)(iVar5 + 4)) || (cVar3 = FUN_004f0810(), cVar3 != '\0')) {
              if (*(int *)(iVar5 + 0x4c) == 0) goto LAB_004eee2b;
              goto LAB_004eee36;
            }
            *(undefined1 *)(iVar5 + 0x154) = 1;
            (**(code **)(*(int *)local_34[2] + 8))();
            *(undefined1 *)(local_34[2] + 0x1d) = 1;
            (**(code **)(*(int *)local_34[2] + 0x14))();
          }
        }
LAB_004eee75:
      }
      piVar9 = (int *)((int)piVar9 + -0x35);
      iVar5 = (int)(int *)local_30 + -1;
      local_30._4_4_ = (undefined4)((ulonglong)local_30 >> 0x20);
      local_30 = (double)CONCAT44(local_30._4_4_,iVar5);
    } while (iVar5 != 0);
  }
  if ((DAT_00a6c1fc & 1) == 0) {
    DAT_00a6c1fc = DAT_00a6c1fc | 1;
    local_28 = taskGetRate();
    DAT_00a6c230 = _DAT_006e97d8 / (float)local_28;
  }
  iVar5 = 0;
  local_30 = (double)((ulonglong)local_30 & 0xffffffff00000000);
  do {
    FUN_004efec0(&local_34);
    iVar10 = iVar5;
    for (; local_34 != &DAT_00a6bfb8 + iVar5 * 4; local_34 = (int *)local_34[1]) {
      iVar1 = local_34[2];
      if (iVar1 != 0) {
        if (iVar10 == 0) {
          if (*(int *)(iVar1 + 0x4c) == 3) {
            if (*(char *)(iVar1 + 0x154) == '\0') {
              if (1 < *(int *)(iVar1 + 4)) goto LAB_004eef26;
              goto LAB_004eef15;
            }
          }
          else {
LAB_004eef15:
            cVar3 = FUN_004f0810();
            if (cVar3 != '\0') goto LAB_004eef26;
          }
LAB_004ef00b:
          if (*(int *)(DAT_00a6bf80 + 4) != DAT_00a6bf84) {
            FUN_004f0000(local_34 + 2);
            DAT_00a6bf80 = *(int *)(DAT_00a6bf80 + 4);
          }
        }
        else {
          if ((1 < *(int *)(iVar1 + 4)) || (cVar3 = FUN_004f0810(), cVar3 != '\0')) {
LAB_004eef26:
            FUN_004f0840(DAT_00a6c230);
            if (((iVar10 != 0) && (iVar10 != 3)) && (iVar10 != param_1)) goto LAB_004ef0a4;
            FUN_004f0980(param_2[2]);
            FUN_004f08a0(&param_2);
            iVar1 = local_34[2];
            if ((DAT_00748429 == '\0') || (DAT_00748430 != 2)) {
LAB_004eefa1:
              FUN_004f0a80();
              iVar10 = (int)(int *)local_30;
            }
            else if (*(int *)(iVar1 + 0x14e) == 0) {
              iVar6 = 0;
              if (*(char *)(iVar1 + 0x152) == '\0') {
                iVar6 = *(int *)(iVar1 + 0x14);
              }
              if (iVar6 == 0) goto LAB_004eefa1;
            }
            FUN_004f38a0(local_34 + 2);
            goto LAB_004ef0a4;
          }
          if (iVar10 == 3) goto LAB_004ef00b;
        }
        piVar4 = local_34;
        piVar9 = local_34;
        if ((local_34 != &DAT_00a6bfb8 + iVar5 * 4) && ((&DAT_00a6bfc0)[iVar5 * 4] != 0)) {
          piVar9 = (int *)local_34[1];
          *(int **)(*local_34 + 4) = piVar9;
          *(int *)local_34[1] = *local_34;
          local_34[1] = 0;
          *local_34 = 0;
          FUN_004f0040();
          iVar10 = (&DAT_00a6bfc4)[iVar5 * 4];
          *piVar4 = *(int *)(iVar10 + 0x3000);
          *(int *)(iVar10 + 0x3000) = (int)piVar4;
          (&DAT_00a6bfc0)[iVar5 * 4] = (&DAT_00a6bfc0)[iVar5 * 4] + -1;
        }
        local_34 = (int *)*piVar9;
        iVar10 = (int)(int *)local_30;
      }
LAB_004ef0a4:
    }
    iVar5 = iVar10 + 1;
    local_30._4_4_ = (undefined4)((ulonglong)local_30 >> 0x20);
    local_30 = (double)CONCAT44(local_30._4_4_,iVar5);
  } while (iVar5 < 3);
  if (-1 < DAT_00a6c1f8 + -1) {
    local_34 = (int *)((DAT_00a6c1f8 + -1) * 0x35);
    local_28 = DAT_00a6c1f8;
    do {
      piVar9 = (int *)local_34[0x29a225];
      if (piVar9 != local_34 + 0x29a224) {
        do {
          if ((int *)piVar9[2] != (int *)0x0) {
            piVar4 = (int *)(**(code **)(*(int *)piVar9[2] + 0xc))();
            iVar5 = *piVar4;
            if (iVar5 != 0) {
              piVar4 = local_34 + 0x29a228;
              FUN_004efeb0(&local_30);
              piVar7 = (int *)local_30;
              if ((int *)local_30 != piVar4) {
                do {
                  if (piVar7[2] == iVar5) break;
                  piVar7 = (int *)piVar7[1];
                  local_30 = (double)CONCAT44(local_30._4_4_,piVar7);
                } while (piVar7 != piVar4);
                if (piVar7 != piVar4) {
                  FUN_004f3ab0(piVar7 + 2);
                  goto LAB_004ef152;
                }
              }
              (**(code **)(*(int *)piVar9[2] + 8))();
            }
          }
LAB_004ef152:
          piVar9 = (int *)piVar9[1];
        } while (piVar9 != local_34 + 0x29a224);
      }
      local_34 = (int *)((int)local_34 + -0x35);
      local_28 = local_28 + -1;
    } while (local_28 != 0);
  }
  if (-1 < DAT_00a6c1f8 + -1) {
    local_34 = (int *)((DAT_00a6c1f8 + -1) * 0x35);
    local_28 = DAT_00a6c1f8;
    do {
      piVar4 = local_34;
      piVar9 = (int *)local_34[0x29a225];
      iVar5 = local_34[0x29a22a];
      if (piVar9 != local_34 + 0x29a224) {
        do {
          if (iVar5 == 0) break;
          piVar7 = (int *)(**(code **)(*(int *)piVar9[2] + 0xc))();
          if (*piVar7 == 0) {
            (**(code **)(*(int *)piVar9[2] + 0x14))();
            iVar5 = iVar5 + -1;
            *(undefined1 *)(piVar9[2] + 0x1d) = 1;
          }
          piVar9 = (int *)piVar9[1];
        } while (piVar9 != piVar4 + 0x29a224);
      }
      if (DAT_00a6c234 != '\0') {
        local_30 = 0.0;
        piVar9 = local_34 + 0x29a224;
        for (piVar4 = (int *)local_34[0x29a225]; piVar4 != piVar9; piVar4 = (int *)piVar4[1]) {
          uVar12 = FUN_005cfcfc();
          uStack_c = (undefined4)((ulonglong)uVar12 >> 0x20);
          (**(code **)(*(int *)piVar4[2] + 0x18))();
          iVar5 = FUN_005cfcfc();
          uStack_1c = 0;
          uStack_20 = iVar5 * 1000 + (int)uVar12 * -1000;
          local_30 = (double)uStack_20 * local_18 + local_30;
          if (_DAT_006ecfd0 < local_30) break;
        }
      }
      piVar4 = (int *)local_34[0x29a225];
      piVar9 = local_34 + 0x29a224;
      if (piVar4 != piVar9) {
        do {
          if ((int *)piVar4[2] != (int *)0x0) {
            piVar7 = (int *)(**(code **)(*(int *)piVar4[2] + 0xc))();
            if (((*piVar7 == 0) && (piVar9[6] != 0)) &&
               ((int *)local_34[0x29a229] != local_34 + 0x29a228)) {
              piVar9 = (int *)local_34[0x29a229] + 2;
              (**(code **)(*(int *)piVar4[2] + 4))(piVar9);
              (**(code **)(*(int *)piVar4[2] + 0x14))();
              FUN_004f3ab0(piVar9);
              FUN_004f0980(param_2[2]);
              FUN_004f08a0(&param_2);
            }
            piVar9 = (int *)(**(code **)(*(int *)piVar4[2] + 0xc))();
            iVar5 = *piVar9;
            if ((iVar5 != 0) && (*(char *)(iVar5 + 0x156) != '\0')) {
              (**(code **)(*(int *)piVar4[2] + 0x14))();
              *(undefined1 *)(iVar5 + 0x156) = 0;
            }
            (**(code **)(*(int *)piVar4[2] + 0x10))();
          }
          piVar4 = (int *)piVar4[1];
          piVar9 = local_34 + 0x29a224;
        } while (piVar4 != piVar9);
      }
      piVar4 = (int *)piVar9[5];
      while (piVar4 != piVar9 + 4) {
        if ((piVar4 != piVar9 + 4) && (piVar9[6] != 0)) {
          piVar7 = (int *)piVar4[1];
          *(int **)(*piVar4 + 4) = piVar7;
          *(int *)piVar4[1] = *piVar4;
          piVar4[1] = 0;
          *piVar4 = 0;
          puVar2 = (undefined4 *)piVar4[2];
          if ((puVar2 != (undefined4 *)0x0) &&
             (iVar5 = puVar2[1], puVar2[1] = iVar5 + -1, iVar5 + -1 == 0)) {
            (**(code **)*puVar2)(1);
          }
          iVar5 = piVar9[7];
          **(undefined4 **)(iVar5 + 0x301c) = piVar4;
          *(int **)(iVar5 + 0x301c) = piVar4;
          piVar9[6] = piVar9[6] + -1;
          piVar4 = piVar7;
        }
      }
      local_34 = (int *)((int)local_34 + -0x35);
      local_28 = local_28 + -1;
    } while (local_28 != 0);
  }
  if ((param_2 != (undefined4 *)0x0) &&
     (iVar5 = param_2[1], param_2[1] = iVar5 + -1, iVar5 + -1 == 0)) {
    (**(code **)*param_2)(1);
  }
  return;
}


