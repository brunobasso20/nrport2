/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0056d5a0 */

void __thiscall FUN_0056d5a0(int *param_1_00,int param_1)

{
  undefined4 unaff_EBX;
  undefined4 unaff_ESI;
  
  if (param_1 != 0) {
    if (*(int *)(param_1 + 8) != 0) {
      FUN_0056d5a0(*(int *)(param_1 + 8));
    }
    *(undefined4 *)(param_1 + 8) = 0;
    if (*(int *)(param_1 + 0xc) != 0) {
      FUN_0056d5a0(*(int *)(param_1 + 0xc));
    }
    *(undefined4 *)(param_1 + 0xc) = 0;
    if ((DAT_00fa9d36 & 1) == 0) {
      DAT_00fa9d36 = DAT_00fa9d36 | 1;
      FUN_006c4f40(&DAT_0056d590,unaff_ESI,unaff_EBX);
      if ((DAT_00fa9d36 & 1) == 0) {
        DAT_00fa9d36 = DAT_00fa9d36 | 1;
        FUN_006c4f40();
      }
    }
    FUN_005cfccc();
    *param_1_00 = *param_1_00 + -1;
  }
  return;
}


