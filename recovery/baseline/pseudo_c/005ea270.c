/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005ea270 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 __thiscall FUN_005ea270(int param_1_00,undefined4 param_1,int param_3)

{
  float10 fVar1;
  short sVar2;
  int iVar3;
  int iVar4;
  undefined4 *puVar5;
  float10 fVar6;
  undefined4 local_20;
  int iStack_1c;
  int iStack_18;
  int iStack_10;
  undefined4 uStack_c;
  float fStack_8;
  undefined2 uStack_4;
  
  puVar5 = &local_20;
  for (iVar4 = 8; iVar4 != 0; iVar4 = iVar4 + -1) {
    *puVar5 = 0;
    puVar5 = puVar5 + 1;
  }
  iVar4 = FUN_005cfdb6(param_1,&local_20,2);
  if ((iVar4 == 1) && (((sVar2 = (short)local_20, sVar2 == 2 || (sVar2 == 3)) || (sVar2 == 4)))) {
    iVar4 = FUN_005cfdb6(param_1,(int)&local_20 + 2,0x1e);
    if (iVar4 == 1) {
      fVar6 = (float10)_DAT_006ea454;
      if ((char)param_3 != '\0') {
        if (DAT_00f5e874 != (int *)0x0) {
          fVar6 = (float10)(**(code **)(*DAT_00f5e874 + 0xf0))();
        }
        fVar6 = fVar6 - (float10)fStack_8;
        *(undefined4 *)(param_1_00 + 0x3d) = 0;
        if ((float10)_DAT_006ea454 < fVar6) {
          do {
            if (((iStack_10 < 2) || (iStack_1c < 3)) || (iStack_18 < 3)) break;
            fVar6 = fVar6 - (float10)_DAT_006e97d8;
            iStack_10 = iStack_10 + -1;
            iStack_1c = iStack_1c + -1;
            iStack_18 = iStack_18 + -1;
            fVar1 = (float10)_DAT_006ea454;
            *(int *)(param_1_00 + 0x3d) = *(int *)(param_1_00 + 0x3d) + 1;
          } while (fVar1 < fVar6);
        }
      }
      iVar4 = FUN_005cfce4(&param_3,iStack_10 * 4);
      if ((iVar4 != 0) && (param_3 != 0)) {
        iVar4 = 0;
        if (0 < iStack_10) {
          do {
            *(undefined4 *)(param_3 + iVar4 * 4) = 0;
            iVar4 = iVar4 + 1;
          } while (iVar4 < iStack_10);
        }
        *(int *)(param_1_00 + 0x30) = param_3;
        *(int *)(param_1_00 + 0x28) = iStack_10;
        *(int *)(param_1_00 + 0x1c) = 1 << ((byte)iStack_1c & 0x1f);
        *(int *)(param_1_00 + 0x20) = 1 << ((byte)iStack_18 & 0x1f);
        *(ushort *)(param_1_00 + 0x26) = (ushort)(local_20._3_1_ >> 1 & 1);
        *(float *)(param_1_00 + 0x35) = fStack_8;
        *(ushort *)(param_1_00 + 0x24) = (ushort)(local_20._3_1_ & 1);
        *(undefined4 *)(param_1_00 + 0x2c) = uStack_c;
        *(char *)(param_1_00 + 0x41) = (char)((ushort)uStack_4 >> 8);
        *(bool *)(param_1_00 + 0x34) = (char)uStack_4 != '\0';
        iVar4 = iStack_10;
        while (iVar4 = iVar4 + -1, -1 < iVar4) {
          iVar3 = FUN_005eb930(*(int *)(param_1_00 + 0x30) + iVar4 * 4,param_1);
          if (iVar3 != 1) {
            return 0;
          }
        }
        iVar4 = 0;
        if (*(int *)(param_1_00 + 0x3d) < 1) {
          return 1;
        }
        while (iVar3 = FUN_005eb9c0(param_1), iVar3 == 1) {
          iVar4 = iVar4 + 1;
          if (*(int *)(param_1_00 + 0x3d) <= iVar4) {
            return 1;
          }
        }
      }
    }
  }
  return 0;
}


