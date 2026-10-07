/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00541820 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall
FUN_00541820(int param_1_00,int param_1,int param_2,undefined4 param_3,undefined4 param_5,
            char param_4)

{
  double dVar1;
  uint uVar2;
  float10 fVar3;
  undefined4 uVar4;
  undefined4 uVar5;
  undefined8 uVar6;
  undefined4 local_1c;
  undefined8 local_18;
  undefined8 local_10;
  
  FUN_00541600();
  if (0 < param_2) {
    if (*(char *)(param_1_00 + 0xe8) == '\0') {
      if (param_4 != '\0') {
        FUN_00541640(0,*(undefined4 *)(param_1_00 + 0x78),*(undefined4 *)(param_1_00 + 0x7c),0,
                     0x3ff00000,0,0);
      }
      uVar2 = (uint)(param_4 != '\0');
      dVar1 = *(double *)(param_1_00 + 0x78);
      local_10 = *(double *)(param_1_00 + 8) / (double)(int)((param_2 - uVar2) + 1);
      if ((double)CONCAT44(param_5,param_3) < local_10) {
        local_10 = (double)CONCAT44(param_5,param_3);
      }
      local_1c = param_2;
      if (4 < param_2) {
        local_1c = 5;
      }
      for (; (int)uVar2 < local_1c; uVar2 = uVar2 + 1) {
        dVar1 = dVar1 + local_10;
        uVar6 = 0;
        uVar5 = 0x3ff00000;
        uVar4 = 0;
        fVar3 = (float10)FUN_006c503f((dVar1 + _DAT_006e9808) - *(double *)(param_1_00 + 0x70),0,
                                      0x3ff00000,0,0);
        FUN_00541640(uVar2,(double)(fVar3 + (float10)*(double *)(param_1_00 + 0x70)),uVar4,uVar5,
                     uVar6);
      }
    }
    else {
      if (param_4 != '\0') {
        FUN_00541640(0,*(undefined4 *)(param_1_00 + 0x78),*(undefined4 *)(param_1_00 + 0x7c),0,
                     0x3ff00000,0,0);
      }
      uVar2 = (uint)(param_4 != '\0');
      if (0 < (int)(uVar2 + param_2)) {
        fVar3 = (float10)FUN_006c510e(*(double *)(param_1_00 + 8) / *(double *)(param_1_00 + 0x68) -
                                      _DAT_006e9808);
        local_10 = *(double *)(param_1_00 + 0x78);
        local_18 = (double)((fVar3 * (float10)*(double *)(param_1_00 + 0x68)) /
                           (float10)(int)(param_2 - uVar2));
        if ((double)CONCAT44(param_5,param_3) < local_18) {
          local_18 = (double)CONCAT44(param_5,param_3);
        }
        local_1c = param_2;
        if (4 < param_2) {
          local_1c = 5;
        }
        if ((int)uVar2 < local_1c) {
          do {
            local_10 = local_10 + local_18;
            uVar6 = 0;
            uVar5 = 0x3ff00000;
            uVar4 = 0;
            fVar3 = (float10)FUN_006c503f((local_10 + _DAT_006e9808) -
                                          *(double *)(param_1_00 + 0x70),0,0x3ff00000,0,0);
            FUN_00541640(uVar2,(double)(fVar3 + (float10)*(double *)(param_1_00 + 0x70)),uVar4,uVar5
                         ,uVar6);
            uVar2 = uVar2 + 1;
          } while ((int)uVar2 < local_1c);
          *(int *)(param_1 + 0x18) = param_2;
          return;
        }
      }
    }
    *(int *)(param_1 + 0x18) = param_2;
  }
  return;
}


