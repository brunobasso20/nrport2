/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00563080 */

void FUN_00563080(int param_1,char param_2)

{
  int iVar1;
  int iVar2;
  undefined4 uVar3;
  
  if (param_2 != '\0') {
    FUN_00563070(param_1,1);
    FUN_00592db0(param_1);
    FUN_0054b3c0(*(undefined4 *)(param_1 + 0x5b2));
  }
  iVar1 = *(int *)(param_1 + 0x5b2);
  *(undefined4 *)(param_1 + 0x148f) = 0;
  *(undefined4 *)(param_1 + 0x1487) = 0;
  *(undefined4 *)(param_1 + 0x148b) = 0;
  iVar2 = FUN_0055ab00();
  if ((iVar1 == iVar2) && (DAT_00c7e75c != 0)) {
    uVar3 = FUN_00592db0(param_1,DAT_00c7e75c,1);
    FUN_0054b0d0(uVar3);
  }
  return;
}


