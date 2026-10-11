/* NR2003.exe @ 005992a0 FUN_005992a0 */

void FUN_005992a0(void)

{
  char cVar1;
  int iVar2;
  
  FUN_00538b30();
  FUN_0053dc30();
  FUN_00538b60();
  FUN_0053e1e0();
  iVar2 = 0;
  do {
    FUN_00538b70(iVar2);
    FUN_0053df30();
    iVar2 = iVar2 + 1;
  } while (iVar2 < 2);
  iVar2 = 0;
  do {
    FUN_00538b80(iVar2);
    FUN_0053e0e0();
    iVar2 = iVar2 + 1;
  } while (iVar2 < 2);
  cVar1 = FUN_00501480();
  if (cVar1 != '\0') {
    FUN_00599310();
    FUN_00599420();
    FUN_00599360();
    FUN_005993c0();
    return;
  }
  return;
}

