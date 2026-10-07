/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005438c0 */

uint __thiscall FUN_005438c0(int param_1_00,int param_1,int param_2)

{
  return *(uint *)(*(int *)(param_1_00 + 0xc) +
                  ((param_1 << ((byte)*(undefined4 *)(param_1_00 + 8) & 0x1f)) + param_2) * 4) >>
         0x1c & 1;
}


