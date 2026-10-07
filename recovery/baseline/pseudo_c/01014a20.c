/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 01014a20 */

uint FUN_01014a20(uint param_1,int param_2,uint param_3,byte param_4)

{
  return (param_1 >> 0x10 ^ param_1 & 0xffff) << (param_4 & 0x1f) ^
         (uint)*(byte *)(param_2 + (param_1 >> 5) % param_3) ^
         (uint)*(byte *)(param_2 + param_1 % param_3) << 7;
}


