/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005c06f0 */

undefined4 * __thiscall FUN_005c06f0(undefined4 *param_1_00,byte param_1)

{
  int iVar1;
  
  FUN_004ed160();
  iVar1 = 4;
  do {
    FUN_004ed160();
    iVar1 = iVar1 + -1;
  } while (iVar1 != 0);
  iVar1 = 4;
  do {
    FUN_004ed160();
    iVar1 = iVar1 + -1;
  } while (iVar1 != 0);
  FUN_00401f80((int)param_1_00 + 0x118e,4,4,FUN_004ed160);
  FUN_005c09e0();
  *param_1_00 = &PTR_DAT_006e97e4;
  if ((param_1 & 1) != 0) {
    FUN_005cfccc(param_1_00);
  }
  return param_1_00;
}


