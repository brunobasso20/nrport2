/* NR2003.exe @ 00483f90 FUN_00483f90 */

void __fastcall FUN_00483f90(int param_1)

{
  int **ppiVar1;
  char cVar2;
  undefined4 uVar3;
  
  ppiVar1 = (int **)(param_1 + 0x60);
  cVar2 = FUN_005fc1c0(ppiVar1,s_slicntrlN3Wedge_00739f08);
  if ((cVar2 == '\x01') && (*ppiVar1 != (int *)0x0)) {
    uVar3 = FUN_005582d0(0x40);
    (**(code **)(**ppiVar1 + 0x90))(0,0,uVar3);
    uVar3 = FUN_00558320(0x40);
    FUN_005fdd50(uVar3);
  }
  return;
}

