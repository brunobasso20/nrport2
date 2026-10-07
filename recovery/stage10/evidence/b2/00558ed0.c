/* NR2003.exe @ 00558ed0 FUN_00558ed0 */

undefined4 __thiscall
FUN_00558ed0(int param_1_00,uint param_1,undefined2 *param_2,undefined4 *param_3)

{
  short sVar1;
  int iVar2;
  int iVar3;
  
  iVar3 = param_1 - 6;
  *(undefined2 *)(param_1_00 + 0x4ed) = *param_2;
  sVar1 = FUN_005f7610(param_2 + 3,iVar3,0xffff);
  *(short *)(param_1_00 + 0x4ef) = sVar1;
  if (0xe < *(int *)(param_2 + 1)) {
    *param_3 = 0x853;
    return 0;
  }
  if ((6 < param_1) && (*(short *)(param_1_00 + 0x4ed) == sVar1)) {
    iVar2 = FUN_00558830(0,*(int *)(param_2 + 1),param_2 + 3,iVar3);
    if (iVar2 == iVar3) {
      iVar3 = FUN_00558da0();
      if (iVar3 != 0) {
        FUN_00550c60();
        FUN_00559820();
        *param_3 = 0;
        return 1;
      }
    }
    *param_3 = 0x855;
    return 0;
  }
  *param_3 = 0x854;
  return 0;
}

