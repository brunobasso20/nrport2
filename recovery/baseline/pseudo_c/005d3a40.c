/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005d3a40 */

undefined4 FUN_005d3a40(undefined4 param_1,undefined4 param_2)

{
  undefined4 uVar1;
  
  if (DAT_00f5e874 != (int *)0x0) {
    uVar1 = (**(code **)(*DAT_00f5e874 + 0xfc))(param_1,param_2);
    return uVar1;
  }
  return 0;
}


