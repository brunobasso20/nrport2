/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00419030 */

undefined4 __fastcall FUN_00419030(undefined4 param_1)

{
  char cVar1;
  int *piVar2;
  int iVar3;
  undefined4 uVar4;
  int *piVar5;
  
  piVar2 = (int *)FUN_00413e20(param_1);
  iVar3 = (**(code **)(*piVar2 + 0x24))(0);
  if (iVar3 != -1) {
    piVar2 = (int *)FUN_00413e20(DAT_0074b068);
    uVar4 = (**(code **)(*piVar2 + 0x24))();
    iVar3 = FUN_004f5970(uVar4);
    if (0.0 < *(float *)(iVar3 + 0x186a)) {
      uVar4 = *(undefined4 *)(DAT_00760b38 + 0x5b2);
      piVar2 = (int *)FUN_00413e20();
      piVar5 = (int *)FUN_00413e20();
      iVar3 = *piVar5;
      uVar4 = FUN_004f5970(uVar4,0);
      uVar4 = (**(code **)(*piVar2 + 0x24))(0,uVar4);
      uVar4 = FUN_004f5970(uVar4);
      cVar1 = (**(code **)(iVar3 + 0x40))(uVar4);
      if (cVar1 != '\0') {
        return 1;
      }
    }
  }
  return 0;
}


