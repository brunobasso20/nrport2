/* NR2003.exe @ 00558e70 FUN_00558e70 */

undefined4 FUN_00558e70(int param_1,undefined2 *param_2,int *param_3)

{
  undefined2 uVar1;
  int iVar2;
  
  iVar2 = FUN_00558830(1,0xe,param_2 + 3,param_1 + -6);
  *param_3 = iVar2;
  if (0 < iVar2) {
    uVar1 = FUN_005f7610(param_2 + 3,iVar2,0xffff);
    *param_2 = uVar1;
    *(undefined4 *)(param_2 + 1) = 0xe;
    *param_3 = *param_3 + 6;
    return 1;
  }
  return 0;
}

