/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0054b970 */

void __thiscall FUN_0054b970(int param_1_00,char param_1,int param_2)

{
  ushort uVar1;
  
  uVar1 = (~(ushort)(3 << (param_1 * '\x02' & 0x1fU)) | 0xf000) & *(ushort *)(param_1_00 + 2);
  *(ushort *)(param_1_00 + 2) =
       (((ushort)(param_2 << (param_1 * '\x02' & 0x1fU)) | uVar1) ^ uVar1) & 0xfff ^ uVar1;
  return;
}


