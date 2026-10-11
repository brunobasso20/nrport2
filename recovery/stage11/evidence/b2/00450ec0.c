/* NR2003.exe @ 00450ec0 FUN_00450ec0 */

uint FUN_00450ec0(int param_1,int param_2,undefined4 param_3,undefined4 param_4,undefined4 param_5,
                 undefined4 param_6,undefined4 param_7)

{
  int iVar1;
  undefined4 uVar2;
  char cVar3;
  uint uVar4;
  int iVar5;
  undefined4 extraout_EDX;
  
  uVar4 = FUN_0055a5a0();
  if ((uVar4 == 4) && (uVar4 = FUN_0055a5c0(), uVar4 == 3)) {
    iVar1 = param_2 * 0x1a;
    if (*(int *)(&DAT_0072f788 + param_2 * 0x1a) != 3) {
      cVar3 = FUN_004548b0();
      if ((cVar3 == '\0') && (uVar4 = FUN_004548c0(), (char)uVar4 == '\0')) {
        return uVar4;
      }
      if ((int)DAT_007325a4 < *(int *)(&DAT_0072f788 + iVar1)) {
        return DAT_007325a4;
      }
      iVar5 = FUN_0055a610();
      if (*(int *)(iVar5 + 0xc) == 0) {
        uVar4 = 0xffffffff;
      }
      else {
        uVar4 = *(uint *)(*(int *)(iVar5 + 0xc) + 0x5b2);
      }
      if (uVar4 != *(uint *)(DAT_0089e3d8 + 0x5b2)) {
        return uVar4;
      }
    }
    uVar4 = DAT_00898914;
    if ((*(uint *)(&DAT_00732174 + param_1 * 0x39) & DAT_00898914) == 0) {
      if (param_2 == -1) {
        uVar4 = FUN_0044c470(0xffffffff,param_3,param_4,param_5,param_6,param_7);
        return uVar4;
      }
      uVar4 = CONCAT31((int3)(DAT_00898914 >> 8),(&DAT_0072f78c)[iVar1]) & 0xffffff03;
      if ((char)uVar4 != '\x03') {
        uVar2 = *(undefined4 *)(&DAT_0072f784 + iVar1);
        cVar3 = FUN_00450160(uVar2,*(undefined4 *)((int)&DAT_00732178 + param_1 * 0x39));
        if (cVar3 == '\0') {
          uVar4 = FUN_00450180(uVar2,extraout_EDX);
          if ((char)uVar4 == '\0') {
            return uVar4;
          }
          iVar5 = FUN_006c5bf8();
          if (0x20 < iVar5 % 100) {
            return iVar5 / 100;
          }
        }
        FUN_0044c470(param_2,param_3,param_4,param_5,param_6,param_7);
        uVar4 = FUN_0044c4a0(*(undefined4 *)(&DAT_0072f784 + iVar1));
      }
    }
  }
  return uVar4;
}

