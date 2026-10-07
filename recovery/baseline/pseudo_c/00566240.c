/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00566240 */

void FUN_00566240(undefined4 param_1,int param_2)

{
  undefined8 uVar1;
  
  uVar1 = FUN_00565b10(*(undefined4 *)(param_2 + 0x54));
  (*(code *)*(undefined4 *)((ulonglong)uVar1 >> 0x20))((float)(int)uVar1);
  uVar1 = FUN_00565b10(*(undefined4 *)(param_2 + 0x58));
  (*(code *)*(undefined4 *)((ulonglong)uVar1 >> 0x20))((float)(int)uVar1);
  uVar1 = FUN_00565b10(*(undefined4 *)(param_2 + 0x5c));
  (*(code *)*(undefined4 *)((ulonglong)uVar1 >> 0x20))((float)(int)uVar1);
  uVar1 = FUN_00565b10(*(undefined4 *)(param_2 + 0x60));
  (*(code *)*(undefined4 *)((ulonglong)uVar1 >> 0x20))((float)(int)uVar1);
  return;
}


