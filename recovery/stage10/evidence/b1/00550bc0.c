/* NR2003.exe @ 00550bc0 FUN_00550bc0 */

void FUN_00550bc0(int param_1)

{
  int iVar1;
  int iVar2;
  undefined4 uVar3;
  
  iVar1 = *(int *)(param_1 + 0x5b2);
  iVar2 = FUN_0055ab00();
  if (iVar1 == iVar2) {
    uVar3 = FUN_0056ed60(0);
    FUN_0054c1c0(0,uVar3);
    uVar3 = FUN_0056ed60(1);
    FUN_0054c1c0(1,uVar3);
    uVar3 = FUN_0056ed60(2);
    FUN_0054c1c0(2,uVar3);
    uVar3 = FUN_0056ed60(3);
    FUN_0054c1c0(3,uVar3);
  }
  return;
}

