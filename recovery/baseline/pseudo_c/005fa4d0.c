/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005fa4d0 */

int __thiscall FUN_005fa4d0(int param_1_00,short *param_1,int param_2,char param_3)

{
  short sVar1;
  short sVar2;
  short *psVar3;
  int iVar4;
  undefined4 uVar5;
  uint uVar6;
  int local_60;
  undefined1 local_54 [16];
  ushort local_44;
  undefined1 local_38 [30];
  undefined1 local_1a [26];
  
  psVar3 = (short *)0x0;
  for (local_60 = 0;
      ((param_1 != (short *)0x0 && (sVar1 = *param_1, sVar1 != 0)) &&
      ((param_2 == 0 || (local_60 < param_2)))); local_60 = local_60 + 1) {
    FUN_005fa1a0(local_38,sVar1);
    if (psVar3 != (short *)0x0) {
      sVar2 = *psVar3;
      iVar4 = FUN_005fa1a0(local_1a,sVar2);
      if (*(short *)(iVar4 + 0x10) != 0) {
        FUN_005fa1a0(local_54,sVar2);
        uVar6 = (uint)local_44;
        if (local_44 != 0) {
          do {
            uVar6 = uVar6 - 1;
          } while (uVar6 != 0);
        }
      }
    }
    if (((param_3 != '\0') && (*(int **)(param_1_00 + 0x30) != (int *)0x0)) && (param_1[1] == 0)) {
      iVar4 = **(int **)(param_1_00 + 0x30);
      uVar5 = FUN_005fa180(sVar1);
      (**(code **)(iVar4 + 0xc))(uVar5);
    }
    psVar3 = param_1;
    param_1 = param_1 + 1;
  }
  uVar6 = FUN_006c5018();
  iVar4 = (int)(uVar6 + ((int)uVar6 >> 0x1f & 3U)) >> 2;
  if ((uVar6 & 3) != 0) {
    iVar4 = iVar4 + 1;
  }
  return iVar4;
}


