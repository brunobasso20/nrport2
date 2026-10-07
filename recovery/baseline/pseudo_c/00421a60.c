/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00421a60 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_00421a60(int *param_1_00,int param_1)

{
  uint *puVar1;
  char cVar2;
  int iVar3;
  uint uVar4;
  float10 fVar5;
  
  cVar2 = FUN_004219e0(param_1);
  switch(*(undefined4 *)((int)param_1_00 + param_1 * 4 + 0x11b)) {
  case 0:
    if (cVar2 != '\0') {
      *(undefined4 *)((int)param_1_00 + param_1 * 4 + 0x11b) = 1;
LAB_00421b47:
      fVar5 = (float10)FUN_00509a20();
      *(double *)((int)param_1_00 + param_1 * 8 + 0x1db) = (double)(fVar5 + (float10)_DAT_006ea668);
      return;
    }
    break;
  case 1:
    if (cVar2 == '\0') goto LAB_00421cd0;
    fVar5 = (float10)FUN_00509a20();
    if (fVar5 <= (float10)*(double *)((int)param_1_00 + param_1 * 8 + 0x1db)) {
      return;
    }
    goto LAB_00421b8f;
  case 2:
    if (cVar2 == '\0') {
      *(undefined4 *)((int)param_1_00 + param_1 * 4 + 0x11b) = 3;
      fVar5 = (float10)FUN_00509a20();
      *(double *)((int)param_1_00 + param_1 * 8 + 0x1db) = (double)(fVar5 + (float10)_DAT_006e9808);
      return;
    }
    iVar3 = (&DAT_00accfde)[param_1 * 0x885];
    if (*(float *)(iVar3 + 0x14) * *(float *)(iVar3 + 0x14) +
        *(float *)(iVar3 + 0x10) * *(float *)(iVar3 + 0x10) +
        *(float *)(iVar3 + 0xc) * *(float *)(iVar3 + 0xc) < (float)_DAT_006ea668) {
      if (_DAT_006ea4b0 <= *(double *)((int)param_1_00 + param_1 * 8 + 0x1db)) {
        fVar5 = (float10)FUN_00509a20();
        if (fVar5 <= (float10)*(double *)((int)param_1_00 + param_1 * 8 + 0x1db)) {
          return;
        }
        *(undefined4 *)((int)param_1_00 + param_1 * 4 + 0x11b) = 4;
        return;
      }
      goto LAB_00421b47;
    }
    goto LAB_00421b9a;
  case 3:
    if (cVar2 == '\0') {
      fVar5 = (float10)FUN_00509a20();
      if (fVar5 <= (float10)*(double *)((int)param_1_00 + param_1 * 8 + 0x1db)) {
        return;
      }
      *(undefined4 *)((int)param_1_00 + param_1 * 4 + 0x11b) = 4;
      iVar3 = FUN_005099b0();
      if (iVar3 != 4) {
        iVar3 = FUN_005099b0();
        if ((iVar3 != 5) && (iVar3 = FUN_005099b0(), iVar3 != 6)) {
          iVar3 = FUN_005099b0();
          if (iVar3 != 7) {
            return;
          }
          puVar1 = (uint *)(param_1_00 + param_1 + 1);
          (**(code **)(*DAT_00bdb9d8 + 0xc))(puVar1,3,1);
          uVar4 = (**(code **)(*param_1_00 + 0x30))(param_1);
          *puVar1 = (uVar4 & 1) << 0x11 ^ *puVar1 & 0xfffdffff;
          return;
        }
        puVar1 = (uint *)(param_1_00 + param_1 + 1);
        FUN_005351e0(puVar1,9,0);
        uVar4 = (**(code **)(*param_1_00 + 0x30))(param_1);
        *puVar1 = (uVar4 & 1) << 0x11 ^ *puVar1 & 0xfffdffff;
        return;
      }
      FUN_00538ac0(param_1);
      FUN_0053b550(param_1);
      return;
    }
LAB_00421b8f:
    *(undefined4 *)((int)param_1_00 + param_1 * 4 + 0x11b) = 2;
LAB_00421b9a:
    *(undefined4 *)((int)param_1_00 + param_1 * 8 + 0x1db) = 0;
    *(undefined4 *)((int)param_1_00 + param_1 * 8 + 0x1df) = 0xbff00000;
    return;
  case 4:
    if (cVar2 == '\0') {
      *(undefined4 *)((int)param_1_00 + param_1 * 4 + 0x11b) = 5;
      fVar5 = (float10)FUN_00509a20();
      *(double *)((int)param_1_00 + param_1 * 8 + 0x1db) = (double)(fVar5 + (float10)_DAT_006ed030);
      return;
    }
    break;
  case 5:
    if (cVar2 != '\0') {
      *(undefined4 *)((int)param_1_00 + param_1 * 4 + 0x11b) = 4;
      return;
    }
    fVar5 = (float10)FUN_00509a20();
    if (fVar5 <= (float10)*(double *)((int)param_1_00 + param_1 * 8 + 0x1db)) {
      return;
    }
LAB_00421cd0:
    *(undefined4 *)((int)param_1_00 + param_1 * 4 + 0x11b) = 0;
  }
  return;
}


