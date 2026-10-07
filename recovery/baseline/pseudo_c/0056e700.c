/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0056e700 */

undefined4 FUN_0056e700(int param_1,int param_2)

{
  int iVar1;
  int iVar2;
  int local_8;
  int local_4;
  
  iVar2 = param_2;
  iVar1 = FUN_005cfe52(&param_2,&local_8,&local_4,param_2);
  if ((((iVar1 == 1) && (param_2 == 0x574b4e46)) && (local_8 == 0)) && (local_4 == 0xad)) {
    *(undefined1 *)(param_1 + 0xab) = 0;
    *(undefined1 *)(param_1 + 0xac) = 1;
    iVar2 = FUN_005cfedc(param_1,0x574b4e46,0,0xad,iVar2);
    if (iVar2 != 0) {
      return 1;
    }
  }
  return 0;
}


