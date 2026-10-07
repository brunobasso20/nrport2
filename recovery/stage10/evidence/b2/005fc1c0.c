/* NR2003.exe @ 005fc1c0 FUN_005fc1c0 */

uint __thiscall FUN_005fc1c0(int param_1_00,int *param_1,undefined4 param_2)

{
  int iVar1;
  int iVar2;
  
  iVar1 = FUN_0060e070(*(undefined4 *)(param_1_00 + 0x29),param_2);
  if ((iVar1 != 0) && (iVar1 = *(int *)(iVar1 + 0x46d), iVar1 != 0)) {
    iVar2 = FUN_00609e80();
    if (iVar2 == 0xe) {
      *param_1 = iVar1;
      return 1;
    }
  }
  *param_1 = 0;
  return (uint)param_1 & 0xffffff00;
}

