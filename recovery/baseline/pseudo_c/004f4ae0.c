/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004f4ae0 */

bool __thiscall FUN_004f4ae0(int param_1_00,undefined4 param_1)

{
  int *piVar1;
  int iVar2;
  
  piVar1 = *(int **)(param_1_00 + 0x4a);
  iVar2 = 0;
  if ((piVar1 != (int *)0x0) && (*(char *)(param_1_00 + 0x4e) != '\0')) {
    param_1 = FUN_006c5018();
    iVar2 = (**(code **)(*piVar1 + 0x10))(piVar1,&DAT_006faab0,4,0,0,&param_1,4);
  }
  return -1 < iVar2;
}


