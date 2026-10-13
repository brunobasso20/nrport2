/* NR2003.exe @ 005e71f0 FUN_005e71f0 */

undefined4 __thiscall
FUN_005e71f0(int param_1_00,int param_1,int param_2,int param_3,int param_4,int param_5)

{
  int iVar1;
  int iVar2;
  int iVar3;
  int iVar4;
  int unaff_EBP;
  int unaff_EDI;

  if (param_5 != 0) {
    iVar2 = (param_2 * 0xdf + 8 + param_3) * 6;
    iVar4 = *(int *)(param_1_00 + 0x5d) + iVar2 + param_4;
    iVar1 = FUN_005cff5a(iVar4,1);
    if (iVar1 == 0) {
      return 0;
    }
    if (*(char *)(*(int *)(param_1_00 + 0x5d) + iVar2 + param_4) == '\0') {
      iVar1 = 0;
      iVar2 = param_2 * 0x29d + param_1 * 6 + param_4;
      do {
        iVar3 = FUN_005cff5a(*(int *)(unaff_EBP + 0x5d) + iVar2 * 2 + 0x4e + iVar1,1);
        if (iVar3 == 0) {
          return 0;
        }
        param_4 = param_1 * 6 + param_4;
        iVar3 = FUN_005cff5a(*(int *)(unaff_EDI + 0x5d) + (iVar1 + param_4 * 2) * 8 + 0x8a +
                             param_2 * 0x53a,8);
        if (iVar3 == 0) {
          return 0;
        }
        iVar3 = FUN_005cff5a(*(int *)(iVar4 + 0x5d) + (iVar1 + param_4 * 3) * 8 + 0x26a +
                             param_2 * 0x53a,8);
        if (iVar3 == 0) {
          return 0;
        }
        iVar1 = iVar1 + 1;
        param_4 = param_2;
      } while (iVar1 < 2);
    }
  }
  return 1;
}
