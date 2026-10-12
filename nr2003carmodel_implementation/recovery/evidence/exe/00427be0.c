/* NR2003.exe @ 00427be0 FUN_00427be0 */

undefined4 __fastcall FUN_00427be0(int param_1)

{
  int **ppiVar1;
  int **ppiVar2;
  int iVar3;
  
  FUN_00427bd0();
  ppiVar1 = (int **)(param_1 + 0x52);
  iVar3 = FUN_005d3900(0,ppiVar1);
  if (iVar3 == 1) {
    ppiVar2 = (int **)(param_1 + 0x62);
    iVar3 = FUN_005d4010(ppiVar2);
    if (iVar3 == 1) {
      iVar3 = FUN_005d4050((undefined4 *)(param_1 + 0x66));
      if (iVar3 == 1) {
        (**(code **)(**ppiVar1 + 0x2c))(*(undefined4 *)(param_1 + 0x66));
        iVar3 = getIntCount();
        *(int *)(param_1 + 0x28) = iVar3;
        return 1;
      }
      (**(code **)(**ppiVar2 + 4))();
      *ppiVar2 = (int *)0x0;
    }
    (**(code **)(**ppiVar1 + 4))();
    *ppiVar1 = (int *)0x0;
  }
  return 0;
}

