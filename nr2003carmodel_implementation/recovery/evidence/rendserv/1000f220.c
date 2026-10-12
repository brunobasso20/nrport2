/* NR2003.exe @ 1000f220 FUN_1000f220 */

int * __fastcall FUN_1000f220(int *param_1)

{
  int iVar1;
  
  if ((int *)param_1[0x10] != (int *)0x0) {
    iVar1 = (**(code **)(*(int *)param_1[0x10] + 8))();
    param_1[0x10] = iVar1;
    if (iVar1 == 0) {
      FUN_10005260(param_1);
      return (int *)0x0;
    }
  }
  return param_1;
}

