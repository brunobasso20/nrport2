/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00592dc0 */

void FUN_00592dc0(int param_1,char param_2)

{
  bool bVar1;
  char cVar2;
  int iVar3;
  int iVar4;
  int *piVar5;
  
  bVar1 = inServer();
  if ((!bVar1) && (param_2 != '\0')) {
    cVar2 = FUN_00501850();
    if (cVar2 != '\0') {
      FUN_005acdd0(param_1 + 0x1493);
    }
    iVar4 = *(int *)(param_1 + 0x5b2);
    iVar3 = FUN_0055ab00();
    if (iVar4 == iVar3) {
      iVar4 = FUN_00567280();
      if (iVar4 != 2) {
        piVar5 = (int *)FUN_00538b50();
        (**(code **)(*piVar5 + 0x34))(param_1 + 0x1493);
      }
    }
  }
  return;
}


