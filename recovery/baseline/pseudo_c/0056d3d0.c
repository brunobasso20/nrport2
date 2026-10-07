/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0056d3d0 */

void __thiscall FUN_0056d3d0(int *param_1_00,undefined4 *param_1,int param_2)

{
  int iVar1;
  int iVar2;
  undefined4 unaff_EBX;
  undefined4 unaff_EBP;
  undefined4 unaff_ESI;
  undefined4 unaff_EDI;
  bool bVar3;
  int *unaff_retaddr;
  
  if (*param_1_00 != 0) {
    if (*(int *)(param_2 + 0xc) == 0) {
      iVar1 = *(int *)(param_2 + 4);
      iVar2 = iVar1;
      if (param_2 == *(int *)(iVar1 + 0xc)) {
        do {
          iVar1 = *(int *)(iVar2 + 4);
          bVar3 = iVar2 == *(int *)(iVar1 + 0xc);
          iVar2 = iVar1;
        } while (bVar3);
      }
    }
    else {
      iVar1 = FUN_004712e0();
    }
    *param_1_00 = *param_1_00 + -1;
    iVar2 = param_2;
    FUN_005cfe04(param_2);
    *(undefined4 *)(param_2 + 8) = 0;
    *(undefined4 *)(param_2 + 0xc) = 0;
    *(undefined4 *)(param_2 + 4) = 0;
    if ((DAT_00fa9d36 & 1) == 0) {
      DAT_00fa9d36 = DAT_00fa9d36 | 1;
      FUN_006c4f40(&DAT_0056d590,iVar2,unaff_ESI,unaff_EBP,unaff_EDI,unaff_EBX);
      if ((DAT_00fa9d36 & 1) == 0) {
        DAT_00fa9d36 = DAT_00fa9d36 | 1;
        FUN_006c4f40();
      }
    }
    FUN_005cfccc(param_2);
    *unaff_retaddr = iVar1;
    return;
  }
  *param_1 = param_1_00 + 1;
  return;
}


