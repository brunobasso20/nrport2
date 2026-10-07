/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00579ab0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00579ab0(undefined4 *param_1)

{
  int *piVar1;
  undefined4 unaff_ESI;
  undefined4 unaff_EDI;
  int *in_stack_0001c5f0;
  undefined4 extraout_var;
  
  if (param_1 != (undefined4 *)0x0) {
    if (param_1[2] != 0) {
      FUN_00579ab0(param_1[2]);
    }
    param_1[2] = 0;
    if (param_1[3] != 0) {
      FUN_00579ab0(param_1[3]);
    }
    param_1[3] = 0;
    if ((DAT_00fa9d1a & 1) == 0) {
      DAT_00fa9d1a = DAT_00fa9d1a | 1;
      DAT_00fae564 = &DAT_00fa9d60;
      _DAT_00fae568 = 0x4800;
      DAT_00fae56c = 0x20;
      FUN_00519c50();
      FUN_006c4f40(&DAT_00519d10,unaff_EDI,unaff_ESI,extraout_var);
      if ((DAT_00fa9d1a & 1) == 0) {
        DAT_00fa9d1a = DAT_00fa9d1a | 1;
        DAT_00fae564 = &DAT_00fa9d60;
        _DAT_00fae568 = 0x4800;
        DAT_00fae56c = 0x20;
        piVar1 = &DAT_00fa9d60;
        do {
          *piVar1 = DAT_00fae56c + (int)piVar1;
          piVar1 = (int *)((int)piVar1 + DAT_00fae56c);
        } while (piVar1 < &DAT_00fae560);
        *(undefined4 *)((int)piVar1 - DAT_00fae56c) = 0;
        DAT_00fae560 = DAT_00fae564;
        FUN_006c4f40();
      }
    }
    *param_1 = DAT_00fae560;
    DAT_00fae560 = param_1;
    *in_stack_0001c5f0 = *in_stack_0001c5f0 + -1;
  }
  return;
}


