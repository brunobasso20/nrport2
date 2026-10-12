/* NR2003.exe @ 00569280 FUN_00569280 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_00569280(int param_1_00,int param_1,undefined4 param_2)

{
  undefined4 *puVar1;
  int iVar2;
  float fVar3;
  char cVar4;
  int *piVar5;
  int *piVar6;
  undefined4 unaff_EBX;
  float local_4;
  
  cVar4 = FUN_0056e2b0();
  if (cVar4 == '\0') {
    local_4 = _DAT_006ea454;
    if (*(char *)(param_1 + 0x15f) != '\0') {
      fVar3 = _DAT_006f5ee8 * _DAT_006ea50c;
      local_4 = _DAT_006e97d8;
      if ((*(float *)(param_1 + 0xa4) < fVar3 == (*(float *)(param_1 + 0xa4) == fVar3)) &&
         (local_4 = _DAT_006ea454,
         *(float *)(param_1 + 0xa4) < _DAT_006f5f2c !=
         (NAN(*(float *)(param_1 + 0xa4)) || NAN(_DAT_006f5f2c)))) {
        local_4 = _DAT_006e97d8 -
                  (*(float *)(param_1 + 0xa4) - fVar3) * (_DAT_006e97d8 / (_DAT_006f5f2c - fVar3));
      }
      local_4 = local_4 * local_4 * local_4;
    }
    piVar6 = (int *)(param_1 + 4);
    if (*(int *)(param_1 + 4) == 0) {
      if (*(char *)(param_1 + 0x15e) != '\0') {
        cVar4 = FUN_0056ba70(*(undefined4 *)(param_1_00 + 4));
        piVar5 = (int *)FUN_006c4990(param_1 + 0xc,*(undefined4 *)(param_1_00 + 0x330),cVar4 != '\0'
                                     ,param_2,local_4);
        puVar1 = (undefined4 *)*piVar6;
        if (puVar1 != (undefined4 *)*piVar5) {
          if ((puVar1 != (undefined4 *)0x0) &&
             (iVar2 = puVar1[1], puVar1[1] = iVar2 + -1, iVar2 + -1 == 0)) {
            (**(code **)*puVar1)(1);
          }
          iVar2 = *piVar5;
          *piVar6 = iVar2;
          if (iVar2 != 0) {
            *(int *)(iVar2 + 4) = *(int *)(iVar2 + 4) + 1;
          }
        }
        FUN_006c4a00();
        return;
      }
    }
    else {
      if (*(char *)(param_1 + 0x15e) == '\0') {
        piVar5 = (int *)FUN_006c4980();
        puVar1 = (undefined4 *)*piVar6;
        if (puVar1 != (undefined4 *)*piVar5) {
          if ((puVar1 != (undefined4 *)0x0) &&
             (iVar2 = puVar1[1], puVar1[1] = iVar2 + -1, iVar2 + -1 == 0)) {
            (**(code **)*puVar1)(1);
          }
          iVar2 = *piVar5;
          *piVar6 = iVar2;
          if (iVar2 != 0) {
            *(int *)(iVar2 + 4) = *(int *)(iVar2 + 4) + 1;
          }
        }
        FUN_006c4a00();
        piVar6 = (int *)FUN_004ed0c0();
        puVar1 = *(undefined4 **)(param_1 + 0x18e);
        if (puVar1 != (undefined4 *)*piVar6) {
          if ((puVar1 != (undefined4 *)0x0) &&
             (iVar2 = puVar1[1], puVar1[1] = iVar2 + -1, iVar2 + -1 == 0)) {
            (**(code **)*puVar1)(1);
          }
          iVar2 = *piVar6;
          *(int *)(param_1 + 0x18e) = iVar2;
          if (iVar2 != 0) {
            *(int *)(iVar2 + 4) = *(int *)(iVar2 + 4) + 1;
          }
        }
        FUN_004ed160();
        return;
      }
      FUN_006c4a20(param_2);
      FUN_004ed190(param_2);
      FUN_006c4a60(unaff_EBX);
    }
  }
  return;
}

