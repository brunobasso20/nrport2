/* NR2003.exe @ 0057a740 FUN_0057a740 */

void FUN_0057a740(void)

{
  int iVar1;
  int iVar2;
  char cVar3;
  int iVar4;
  int iVar5;
  undefined4 uVar6;
  
  iVar5 = 0;
  do {
    iVar2 = iVar5 * 0x1d;
    if (*(int *)((int)&DAT_00d37cc8 + iVar2) != 1) goto LAB_0057a7c3;
    iVar1 = *(int *)((int)&DAT_00d37ccc + iVar2);
    if (iVar1 < 0) {
LAB_0057a786:
      if (*(int *)((int)&DAT_00d37cc4 + iVar2) != 0) {
        FUN_0057c680(iVar5);
        if (iVar5 == 7) {
          uVar6 = 8;
        }
        else if (iVar5 == 8) {
          uVar6 = 7;
        }
        else if (iVar5 == 0x54) {
          uVar6 = 0x55;
        }
        else {
          if (iVar5 != 0x55) goto LAB_0057a7c3;
          uVar6 = 0x54;
        }
        FUN_0057c680(uVar6);
      }
    }
    else {
      iVar4 = FUN_005d0420();
      if (iVar4 <= iVar1) goto LAB_0057a786;
      if ((&DAT_00d37cd4)[iVar2] == '\0') {
        cVar3 = FUN_005d0770(iVar1);
        if (cVar3 != '\0') goto LAB_0057a786;
      }
    }
LAB_0057a7c3:
    iVar5 = iVar5 + 1;
    if (0xd6 < iVar5) {
      return;
    }
  } while( true );
}

