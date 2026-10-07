/* NR2003.exe @ 00546200 FUN_00546200 */

void FUN_00546200(void)

{
  char cVar1;
  int iVar2;
  int iVar3;
  
  FUN_005463b0();
  FUN_00544de0(FUN_00545cd0);
  iVar2 = FUN_00544e60();
  if (iVar2 == 2) {
    iVar2 = FUN_00544e90();
    if (0 < iVar2) {
      FUN_00509a70();
    }
  }
  iVar2 = FUN_00544e60();
  if (iVar2 == 2) {
    iVar2 = FUN_00544e90();
    if (0 < iVar2) {
      iVar2 = FUN_00538ae0();
      if (*(char *)(iVar2 + 0x24) != '\0') {
        iVar2 = FUN_005099d0();
        iVar3 = FUN_00509990();
        if (iVar3 != iVar2 + -1) {
          cVar1 = FUN_00546170();
          if (cVar1 == '\0') {
            FUN_00509890();
            iVar2 = FUN_00509990();
            FUN_00509630(iVar2 + 1);
            FUN_005a85c0();
            return;
          }
        }
        FUN_004f9cd0();
        FUN_005a85c0();
        return;
      }
      FUN_005462b0();
    }
    FUN_00544de0(FUN_00545e60);
  }
  FUN_005a85c0();
  return;
}

