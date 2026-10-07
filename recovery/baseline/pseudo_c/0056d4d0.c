/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0056d4d0 */

void __fastcall FUN_0056d4d0(int *param_1)

{
  int iVar1;
  undefined4 unaff_EBX;
  undefined4 unaff_ESI;
  undefined4 unaff_EDI;
  
  iVar1 = param_1[3];
  if (iVar1 != 0) {
    if (*(int *)(iVar1 + 8) != 0) {
      FUN_0056d5a0(*(int *)(iVar1 + 8));
    }
    *(undefined4 *)(iVar1 + 8) = 0;
    if (*(int *)(iVar1 + 0xc) != 0) {
      FUN_0056d5a0(*(int *)(iVar1 + 0xc));
    }
    *(undefined4 *)(iVar1 + 0xc) = 0;
    if ((DAT_00fa9d36 & 1) == 0) {
      DAT_00fa9d36 = DAT_00fa9d36 | 1;
      FUN_006c4f40(&DAT_0056d590,unaff_EDI,unaff_ESI,unaff_EBX);
      if ((DAT_00fa9d36 & 1) == 0) {
        DAT_00fa9d36 = DAT_00fa9d36 | 1;
        FUN_006c4f40();
      }
    }
    FUN_005cfccc();
    param_1[3] = 0;
    *param_1 = *param_1 + -1;
  }
  param_1[3] = 0;
  *param_1 = 0;
  return;
}


