/* NR2003.exe @ 00428e20 FUN_00428e20 */

void FUN_00428e20(int param_1,int param_2,undefined4 param_3,int param_4,int param_5,int param_6,
                 int param_7,int param_8)

{
  char cVar1;
  byte bVar2;
  uint uVar3;
  int iVar4;
  int iVar5;
  int iVar6;
  int iVar7;
  int iVar8;
  int iVar9;
  int iStack_24;
  undefined4 *local_20;
  int iStack_1c;
  undefined4 local_18;
  int local_14;
  char *local_10 [4];
  
  iVar5 = param_8 / 1000;
  iVar8 = 0;
  local_10[0] = &DAT_00723544;
  local_10[1] = s__01d_0072353c;
  local_10[2] = s__02d_00723534;
  local_10[3] = &DAT_0072352c;
  iVar6 = param_8 % 1000;
  if ((((iVar5 < 0) || (3 < iVar5)) || (iVar6 < 0)) || (999 < iVar6)) {
    local_14 = -1;
    local_18 = 0;
  }
  else {
    local_14 = iVar5 * 1000 + iVar6;
    local_18 = 0;
    FUN_006c4f81(&local_18,local_10[iVar5],iVar6);
  }
  iVar5 = param_4;
  local_20 = &local_18;
  bVar2 = (byte)local_18;
  uVar3 = local_18;
  while ((bVar2 != 0 && (((char)uVar3 < '0' || ('9' < (char)uVar3))))) {
    bVar2 = *(byte *)((int)local_20 + 1);
    local_20 = (undefined4 *)((int)local_20 + 1);
    uVar3 = (uint)bVar2;
  }
  cVar1 = *(char *)local_20;
  while (((cVar1 != '\0' && ('/' < cVar1)) && (cVar1 < ':'))) {
    iVar6 = iVar8 + 1;
    iVar8 = iVar8 + 1;
    cVar1 = *(char *)(iVar6 + (int)local_20);
  }
  param_8 = iVar8;
  FUN_005d4980(param_4,&iStack_1c,&iStack_24);
  iVar6 = iStack_1c / 10;
  iVar4 = FUN_005cfce4(&param_4,iStack_1c * iStack_24 * 4);
  if ((iVar4 == 0) || (param_4 == 0)) {
    param_4 = 0;
  }
  iVar4 = param_4;
  iVar5 = FUN_005d49a0(iVar5,param_4);
  if (iVar5 == 1) {
    param_1 = param_1 + (param_2 * param_6 + param_5) * 4;
    if (param_7 < 0xb5) {
      if (param_7 == 0xb4) {
        iVar5 = -1;
        iVar7 = -param_2;
        param_1 = param_1 + -4 + ((iStack_24 + -1) * param_2 + iVar6 * 3) * 4;
      }
      else if (param_7 == 0) {
        iVar5 = 1;
        iVar7 = param_2;
      }
      else {
        if (param_7 != 0x5a) goto LAB_00429061;
        param_1 = param_1 + -4 + iStack_24 * 4;
        iVar5 = param_2;
        iVar7 = -1;
      }
    }
    else {
      if (param_7 != 0x10e) goto LAB_00429061;
      iVar5 = -param_2;
      iVar7 = 1;
      param_1 = param_1 + (iVar6 * 3 + -1) * param_2 * 4;
    }
    iVar9 = 0;
    param_2 = param_1 + (((3 - iVar8) * iVar6) / 2) * iVar5 * 4;
    iVar4 = param_4;
    if (0 < param_8) {
      param_6 = iVar5 * iVar6 * 4;
      do {
        FUN_00429080(param_2,iVar5,iVar7,
                     param_4 + (*(char *)(iVar9 + (int)local_20) + -0x30) * iVar6 * 4,iVar6,
                     iStack_24,iStack_1c);
        param_2 = param_2 + param_6;
        iVar9 = iVar9 + 1;
        iVar4 = param_4;
      } while (iVar9 < param_8);
    }
  }
LAB_00429061:
  if (iVar4 != 0) {
    FUN_005cfccc(iVar4);
  }
  return;
}

