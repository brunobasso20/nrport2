/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00573a60 */

undefined4 FUN_00573a60(int *param_1)

{
  int *piVar1;
  int *piVar2;
  int iVar3;
  
  piVar1 = DAT_00c72138 + DAT_00c7212c;
  piVar2 = DAT_00c72138;
  do {
    if (piVar2 == piVar1) {
      return 1;
    }
    iVar3 = (**(code **)(*param_1 + 0x14))(*piVar2,*piVar2 + 0x18);
    piVar2 = piVar2 + 1;
  } while (iVar3 == 1);
  return 0;
}


