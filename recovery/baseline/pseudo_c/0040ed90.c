/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0040ed90 */

void __fastcall FUN_0040ed90(int param_1)

{
  int *piVar1;
  
  if (*(char *)(param_1 + 0x8d) != '\0') {
    piVar1 = (int *)FUN_00538b40();
                    /* WARNING: Could not recover jumptable at 0x0040eda3. Too many branches */
                    /* WARNING: Treating indirect jump as call */
    (**(code **)(*piVar1 + 0x3c))();
    return;
  }
  (**(code **)(*DAT_00bdb9d8 + 0x20))(*(undefined4 *)(*(int *)(param_1 + 0x89) + 0x5b2));
  return;
}


