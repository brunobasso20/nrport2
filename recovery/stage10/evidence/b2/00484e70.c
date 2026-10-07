/* NR2003.exe @ 00484e70 FUN_00484e70 */

void __fastcall FUN_00484e70(int param_1)

{
  int **ppiVar1;
  int **ppiVar2;
  char cVar3;
  undefined4 uVar4;
  int iVar5;
  int iVar6;
  
  ppiVar1 = (int **)(param_1 + 0x60);
  cVar3 = FUN_005fc1c0(ppiVar1,s_slicntrlN3Wedge_0073ad48);
  if (cVar3 == '\x01') {
    ppiVar2 = (int **)(param_1 + 100);
    cVar3 = FUN_005fc1c0(ppiVar2,s_slicntrlN3FRBias_0073ad58);
    if (cVar3 == '\x01') {
      cVar3 = FUN_005fc1c0(param_1 + 0x68,s_slicntrlN3LRBias_0073ad6c);
      if (cVar3 == '\x01') {
        if (*ppiVar1 != (int *)0x0) {
          uVar4 = FUN_005582d0(0x40);
          (**(code **)(**ppiVar1 + 0x90))(0,0,uVar4);
          uVar4 = FUN_00558320(0x40);
          FUN_005fdd50(uVar4);
        }
        if (*ppiVar2 != (int *)0x0) {
          uVar4 = FUN_005582d0(0x3f);
          (**(code **)(**ppiVar2 + 0x90))(0,0,uVar4);
          uVar4 = FUN_00558320(0x3f);
          FUN_005fdd50(uVar4);
        }
        if (*(int *)(param_1 + 0x68) != 0) {
          iVar5 = FUN_005582d0(0x3e);
          (**(code **)(**(int **)(param_1 + 0x68) + 0x90))(0,0,iVar5);
          iVar6 = FUN_00558320(0x3e);
          FUN_005fdd50(iVar5 - iVar6);
        }
      }
    }
  }
  return;
}

