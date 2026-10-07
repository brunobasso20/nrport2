/* NR2003.exe @ 005bd3c0 FUN_005bd3c0 */

void FUN_005bd3c0(void)

{
  int iVar1;
  uint extraout_ECX;
  uint uVar2;
  uint *puVar3;
  
  FUN_005bd450();
  puVar3 = DAT_00ee0fd8;
  if (DAT_00ee0fd8 < DAT_00ebfc50) {
    do {
      uVar2 = puVar3[3];
      if ((uVar2 == 0) || (5 < (int)uVar2)) {
        if (puVar3[4] == 0) {
          iVar1 = FUN_005bd200(puVar3);
          if ((iVar1 != 0) || (uVar2 = extraout_ECX, (*puVar3 & 0xfffffffc) != 0x38)) {
            iVar1 = FUN_005bd200(puVar3);
            if (iVar1 == 0) {
              FUN_005bd490((int)*puVar3 >> 2,puVar3[1],puVar3[2],8);
            }
            goto LAB_005bd434;
          }
        }
        puVar3[3] = uVar2 + 1;
        FUN_005bd650(puVar3,8);
      }
LAB_005bd434:
      puVar3 = puVar3 + 5;
    } while (puVar3 < DAT_00ebfc50);
  }
  DAT_00ee0fd8 = puVar3;
  return;
}

