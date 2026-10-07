/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 01014b60 */

void FUN_01014b60(void)

{
  byte in_AF;
  byte in_TF;
  byte in_IF;
  byte in_NT;
  byte in_AC;
  byte in_VIF;
  byte in_VIP;
  byte in_ID;
  int unaff_retaddr;
  undefined1 local_1c [12];
  int local_10;
  undefined1 local_c [4];
  undefined4 local_8;
  
  local_10 = DAT_0110ad04 + 2;
  local_8 = FUN_01014a20(unaff_retaddr + -4,local_10,8,2,
                         (uint)(in_NT & 1) * 0x4000 |
                         (uint)SBORROW4((int)&stack0xfffffffc,0x18) * 0x800 |
                         (uint)(in_IF & 1) * 0x200 | (uint)(in_TF & 1) * 0x100 |
                         (uint)((int)local_1c < 0) * 0x80 |
                         (uint)(&stack0x00000000 == (undefined1 *)0x1c) * 0x40 |
                         (uint)(in_AF & 1) * 0x10 |
                         (uint)((POPCOUNT((uint)local_1c & 0xff) & 1U) == 0) * 4 |
                         (uint)(&stack0xfffffffc < (undefined1 *)0x18) |
                         (uint)(in_ID & 1) * 0x200000 | (uint)(in_VIP & 1) * 0x100000 |
                         (uint)(in_VIF & 1) * 0x80000 | (uint)(in_AC & 1) * 0x40000);
  FUN_01014ad0(&DAT_01058338,local_8,local_c,2);
  return;
}


