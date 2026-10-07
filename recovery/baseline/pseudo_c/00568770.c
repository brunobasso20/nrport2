/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00568770 */

bool FUN_00568770(void)

{
  char cVar1;
  undefined4 uVar2;
  int iVar3;
  char *pcVar4;
  int *piVar5;
  int *piVar6;
  int *piVar7;
  undefined4 *puVar8;
  char *pcVar9;
  int *piVar10;
  undefined4 *puVar11;
  undefined4 uStack_70;
  uint uStack_6c;
  int iStack_68;
  int iStack_64;
  int iStack_60;
  undefined1 auStack_5c [4];
  char acStack_58 [32];
  int aiStack_38 [14];
  
  uVar2 = FUN_005cfd1a();
  iVar3 = FUN_005cfd14(uVar2);
  if ((iVar3 != 0) && (iVar3 = FUN_005cfd14(s_tracks_0074ec94), iVar3 != 0)) {
    pcVar4 = (char *)FUN_0055a680();
    iVar3 = FUN_005cfd14(pcVar4);
    if (iVar3 != 0) {
      iVar3 = -(int)pcVar4;
      do {
        cVar1 = *pcVar4;
        pcVar4[(int)(acStack_58 + iVar3)] = cVar1;
        pcVar4 = pcVar4 + 1;
      } while (cVar1 != '\0');
      iVar3 = -1;
      pcVar4 = acStack_58;
      do {
        pcVar9 = pcVar4;
        if (iVar3 == 0) break;
        iVar3 = iVar3 + -1;
        pcVar9 = pcVar4 + 1;
        cVar1 = *pcVar4;
        pcVar4 = pcVar9;
      } while (cVar1 != '\0');
      *(undefined4 *)(pcVar9 + -1) = DAT_0074ec9c;
      pcVar9[3] = DAT_0074eca0;
      iVar3 = FUN_005cfd0e(&uStack_70,acStack_58);
      if (iVar3 != 0) {
        iVar3 = FUN_005cfdbc(&iStack_60,&uStack_6c,auStack_5c,uStack_70);
        if ((iVar3 != 0) && (iStack_60 == 0x5443414d)) {
          iStack_64 = 0;
          if ((uStack_6c != 0) != 0xfffffffe) {
            piVar6 = &DAT_00c548a0;
            do {
              if (uStack_6c < 2) {
                iVar3 = FUN_005cfdb6(uStack_70,piVar6,4);
                if ((iVar3 == 0) || (0x3f < *piVar6)) break;
                iStack_68 = 0;
                if (0 < *piVar6) {
                  piVar5 = piVar6 + 0xf;
                  do {
                    iVar3 = FUN_005cfdb6(uStack_70,aiStack_38,0x38);
                    if (iVar3 == 0) break;
                    piVar7 = aiStack_38;
                    piVar10 = piVar5 + -0xe;
                    for (iVar3 = 0xe; iVar3 != 0; iVar3 = iVar3 + -1) {
                      *piVar10 = *piVar7;
                      piVar7 = piVar7 + 1;
                      piVar10 = piVar10 + 1;
                    }
                    *(undefined1 *)piVar5 = 0;
                    iStack_68 = iStack_68 + 1;
                    piVar5 = (int *)((int)piVar5 + 0x39);
                  } while (iStack_68 < *piVar6);
                }
                if (iStack_68 != *piVar6) break;
              }
              else {
                iVar3 = FUN_005cfdb6(uStack_70,piVar6,4);
                if (((iVar3 == 0) || (0x3f < *piVar6)) ||
                   (iVar3 = FUN_005cfdb6(uStack_70,piVar6 + 1,*piVar6 * 0x39), iVar3 == 0)) break;
              }
              iStack_64 = iStack_64 + 1;
              piVar6 = piVar6 + 0x391;
            } while (iStack_64 < (int)((uStack_6c != 0) + 2));
          }
          if (((iStack_64 == (uStack_6c != 0) + 2) &&
              (iVar3 = FUN_005cfdb6(uStack_70,&DAT_00c573f8,(-(uStack_6c != 0) & 0x24U) + 0x24),
              iVar3 != 0)) &&
             (iVar3 = FUN_005cfdb6(uStack_70,&DAT_00c57440,0x10), uVar2 = DAT_00c5c2a4, iVar3 != 0))
          {
            if (uStack_6c == 0) {
              DAT_00c57448 = DAT_00c5c2a0;
              puVar8 = &DAT_00c573f8;
              puVar11 = &DAT_00c5741c;
              for (iVar3 = 9; iVar3 != 0; iVar3 = iVar3 + -1) {
                *puVar11 = *puVar8;
                puVar8 = puVar8 + 1;
                puVar11 = puVar11 + 1;
              }
              DAT_00c5744c = uVar2;
              DAT_00c57444 = DAT_00c5c29c;
              DAT_00c57440 = 0x42c80000;
            }
            iVar3 = FUN_005cfd08(uStack_70);
            return iVar3 != 0;
          }
        }
        FUN_005cfd08(uStack_70);
      }
    }
  }
  return false;
}


