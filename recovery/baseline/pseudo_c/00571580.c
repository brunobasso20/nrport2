/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00571580 */

undefined4 FUN_00571580(undefined4 param_1)

{
  char cVar1;
  
  cVar1 = FUN_005f8da0(&DAT_00c692cc);
  if (cVar1 != '\0') {
    FUN_006c4b00(&DAT_00c5f5f8,param_1,0x100);
    DAT_00c5f6f7 = 0;
    DAT_00c5f6f8 = 0;
    FUN_005f8e20(&DAT_00c692cc);
    return 1;
  }
  return 0;
}


