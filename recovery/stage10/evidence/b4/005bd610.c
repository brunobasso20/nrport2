/* NR2003.exe @ 005bd610 FUN_005bd610 */

undefined4 FUN_005bd610(int *param_1,int param_2)

{
  int iVar1;
  undefined8 uVar2;
  
  *param_1 = 0;
  iVar1 = *(int *)(param_2 + 0x10);
  while( true ) {
    if (iVar1 == 0) {
      return 0;
    }
    *param_1 = iVar1;
    uVar2 = FUN_005bd0c0(iVar1);
    if ((int)uVar2 != 0) break;
    iVar1 = (&DAT_00edb538)[(int)((ulonglong)uVar2 >> 0x20)];
  }
  return 1;
}

