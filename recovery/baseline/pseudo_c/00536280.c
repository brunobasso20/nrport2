/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00536280 */

void __thiscall FUN_00536280(int param_1_00,int param_1)

{
  int iVar1;
  
  if (param_1 == 0x7fffffff) {
    FUN_005362d0(*(undefined4 *)(param_1_00 + 8));
    return;
  }
  iVar1 = FUN_00536180(param_1,&param_1);
                    /* WARNING: Could not recover jumptable at 0x005362c5. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (*(code *)**(undefined4 **)(param_1_00 + 0xc + iVar1 * 0x394))();
  return;
}


