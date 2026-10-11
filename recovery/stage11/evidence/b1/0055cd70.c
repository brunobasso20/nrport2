/* NR2003.exe @ 0055cd70 FUN_0055cd70 */

void __fastcall FUN_0055cd70(int param_1)

{
  char cVar1;
  undefined4 uVar2;
  int iVar3;
  int local_4;
  
  local_4 = param_1;
  do {
    while( true ) {
      cVar1 = FUN_005b7720(&local_4,0);
      if (cVar1 == '\x01') break;
      if (local_4 == 0x7f) {
        return;
      }
LAB_0055cd96:
      if (local_4 == 0x83) {
        uVar2 = FUN_005b7960(0x83);
        FUN_00501870(0x74);
        FUN_005019e0(0xc4,uVar2);
        FUN_00501a40();
      }
      else if (local_4 == 0x84) {
        uVar2 = FUN_005b7960(0x84);
        FUN_00501870(0x75);
        FUN_005019e0(0x28,uVar2);
        FUN_00501a40();
      }
    }
    if (local_4 != 0x7f) goto LAB_0055cd96;
    cVar1 = FUN_00501480();
    if (cVar1 != '\0') {
      iVar3 = FUN_005b7960(0);
      if (iVar3 != 0) {
        FUN_00501870(100);
        FUN_005019e0(0x14,iVar3);
        FUN_00501a40();
      }
      iVar3 = FUN_005b7960(1);
      if (iVar3 != 0) {
        FUN_00501870(0x65);
        FUN_005019e0(0x4c,iVar3);
        FUN_00501a40();
      }
      iVar3 = FUN_005b7960(2);
      if (iVar3 != 0) {
        FUN_00501870(0x66);
        FUN_005019e0(0x40,iVar3);
        FUN_00501a40();
      }
      iVar3 = FUN_005b7960(3);
      if (iVar3 != 0) {
        FUN_00501870(0x67);
        FUN_005019e0(0x40,iVar3);
        FUN_00501a40();
      }
      iVar3 = FUN_005b7960(4);
      if (iVar3 != 0) {
        FUN_00501870(0x68);
        FUN_005019e0(0xc,iVar3);
        FUN_00501a40();
      }
      iVar3 = FUN_005b7960(5);
      if (iVar3 != 0) {
        FUN_00501870(0x69);
        FUN_005019e0(0x14,iVar3);
        FUN_00501a40();
      }
    }
    FUN_005b7940();
  } while( true );
}

