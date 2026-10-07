/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005714e0 */

undefined4 FUN_005714e0(undefined4 param_1)

{
  char cVar1;
  
  cVar1 = FUN_005f8da0(&DAT_00c70d14);
  if (cVar1 != '\0') {
    FUN_006c4b00(&DAT_00c6f990,param_1,0x100);
    DAT_00c6fa8f = 0;
    FUN_005f8e20(&DAT_00c70d14);
    return 1;
  }
  return 0;
}


