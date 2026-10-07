/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004fff80 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 __fastcall FUN_004fff80(undefined4 *param_1)

{
  int iVar1;
  
  iVar1 = FUN_00536260(*param_1);
  return (float10)*(float *)(iVar1 + 0x2b) * (float10)_DAT_006e9810;
}


