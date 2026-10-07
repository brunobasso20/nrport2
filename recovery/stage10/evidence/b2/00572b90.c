/* NR2003.exe @ 00572b90 FUN_00572b90 */

undefined4 FUN_00572b90(void *param_1)

{
  void *pvVar1;
  int iVar2;
  int iVar3;
  int local_44;
  undefined local_40 [64];
  
  pvVar1 = param_1;
  iVar3 = (int)param_1 + 0x20;
  local_44 = -1;
  iVar2 = FUN_0056c190(iVar3,&local_44);
  if (iVar2 != 0) {
    iVar2 = FUN_0056c040();
    if (iVar2 == local_44) {
      param_1 = (void *)0x1;
      bgRequestFGAction(FUN_00572cb0,&param_1,pvVar1);
      if (param_1 != (void *)0x0) {
        iVar3 = FUN_0042ad20();
        if (iVar3 != 0) {
          bgRequestFGAction(thunk_FUN_00411eb0,(void *)0x0,(void *)0x0);
          FUN_00556da0(DAT_00bdbd00);
          FUN_00578560();
          return 1;
        }
        FUN_00619640(local_40,0x40,0x83a);
        FUN_0055c800(2,local_40);
        FUN_005cfeb8();
        bgRequestFGAction(FUN_00573bc0,(void *)0x0,(void *)0x0);
        return 0;
      }
      FUN_00619640(local_40,0x40,0x7d5,0);
      goto LAB_00572c99;
    }
  }
  FUN_00619640(local_40,0x40,0x836,iVar3);
LAB_00572c99:
  FUN_0055c800(2,local_40);
  FUN_005cfeb8();
  return 0;
}

