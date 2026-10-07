/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005aee00 */

void FUN_005aee00(void)

{
  char *pcVar1;
  int iVar2;
  int iVar3;
  char cVar4;
  char *pcVar5;
  int iVar6;
  int local_94;
  char *local_90;
  int local_8c;
  undefined1 auStack_80 [128];
  
  local_8c = -0x80;
  local_90 = (char *)0x0;
  local_94 = 0;
  do {
    pcVar1 = (&PTR_DAT_00751e9c)[local_94 * 2];
    iVar6 = 0;
    cVar4 = *pcVar1;
    if (cVar4 == '\0') {
      DAT_00751fe0 = local_94;
      return;
    }
    pcVar5 = pcVar1;
    while( true ) {
      iVar2 = FUN_006c6254((int)pcVar5[(int)&DAT_00e7d1a0 - (int)pcVar1]);
      iVar3 = FUN_006c6254((int)cVar4);
      if (iVar3 != iVar2) break;
      cVar4 = pcVar5[1];
      iVar6 = iVar6 + 1;
      pcVar5 = pcVar5 + 1;
      if (cVar4 == '\0') {
        DAT_00751fe0 = local_94;
        return;
      }
    }
    if (cVar4 == '\0') {
      DAT_00751fe0 = local_94;
      return;
    }
    if (local_8c < iVar6) {
      local_90 = pcVar1;
      local_8c = iVar6;
    }
    local_94 = local_94 + 1;
  } while (local_94 < 6);
  if (local_8c < 4) {
    FUN_006c4f81(auStack_80,s_____s__not_found_00751fe8,&DAT_00e7d1a0);
  }
  else {
    FUN_006c4f81(auStack_80,s___subst___s__for___s__00751ffc,&DAT_00e7d1a0,local_90);
    FUN_006c4b00(&DAT_00e7d1a0,local_90,0x28);
  }
  FUN_005aef10(auStack_80);
  DAT_00751fe0 = 0xffffff80;
  return;
}


