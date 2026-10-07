/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0056d310 */

bool FUN_0056d310(void)

{
  int iVar1;
  int iVar2;
  float10 fVar3;
  float10 fVar4;
  
  if (DAT_00c5caec == (code *)0x0) {
    fVar3 = (float10)(*DAT_00c5caf0)();
    fVar4 = (float10)(*DAT_00c5caf0)();
    if ((float10)(float)fVar3 < fVar4) {
      return true;
    }
    return false;
  }
  iVar1 = (*DAT_00c5caec)();
  iVar2 = (*DAT_00c5caec)();
  if (iVar1 == iVar2) {
    return false;
  }
  if (iVar1 == 0) {
    if (iVar2 != 0) {
      return true;
    }
  }
  else if (iVar2 == 0) {
    return false;
  }
  iVar1 = FUN_006c6530(iVar1,iVar2);
  return iVar1 < 0;
}


