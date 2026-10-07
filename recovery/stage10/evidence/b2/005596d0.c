/* NR2003.exe @ 005596d0 FUN_005596d0 */

undefined4 __thiscall
FUN_005596d0(int param_1_00,undefined4 param_1,undefined4 param_2,char *param_3,char param_4)

{
  char *pcVar1;
  char cVar2;
  undefined4 uVar3;
  int iVar4;
  uint uVar5;
  undefined4 unaff_EBX;
  undefined4 unaff_ESI;
  undefined4 unaff_EDI;
  char *pcVar6;
  
  uVar3 = FUN_005cfd1a();
  iVar4 = FUN_005cfd14(uVar3);
  if (param_4 == '\0') {
    if (iVar4 == 0) {
      return 0;
    }
    iVar4 = FUN_005cfd14(s_players_0074dad8);
    if (iVar4 == 0) {
      return 0;
    }
    iVar4 = FUN_005cfd14(param_1);
    if (iVar4 == 0) {
      return 0;
    }
    iVar4 = FUN_005cfd14(s_setups_0074dae0);
  }
  else {
    if (iVar4 == 0) {
      return 0;
    }
    iVar4 = FUN_005cfd14(s_tracks_0074dad0);
  }
  if (((iVar4 == 0) || (iVar4 = FUN_005cfd14(param_2), iVar4 == 0)) ||
     (iVar4 = FUN_00558aa0(param_3), iVar4 == 0)) {
    return 0;
  }
  if (param_4 == '\0') {
    iVar4 = (param_1_00 + 0x3ec) - (int)param_3;
    do {
      cVar2 = *param_3;
      param_3[iVar4] = cVar2;
      param_3 = param_3 + 1;
    } while (cVar2 != '\0');
    return 1;
  }
  pcVar1 = (char *)(param_1_00 + 0x3ec);
  iVar4 = (int)pcVar1 - (int)param_3;
  do {
    cVar2 = *param_3;
    param_3[iVar4] = cVar2;
    param_3 = param_3 + 1;
  } while (cVar2 != '\0');
  uVar5 = 0xffffffff;
  pcVar6 = pcVar1;
  do {
    if (uVar5 == 0) break;
    uVar5 = uVar5 - 1;
    cVar2 = *pcVar6;
    pcVar6 = pcVar6 + 1;
  } while (cVar2 != '\0');
  FUN_006c5390(param_1_00 + 0x3ed,pcVar1,~uVar5,unaff_EDI,unaff_ESI,unaff_EBX);
  *pcVar1 = '\\';
  return 1;
}

