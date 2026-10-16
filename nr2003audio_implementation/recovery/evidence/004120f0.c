/* NR2003.exe @ 004120f0 recovered_004120f0 */

void recovered_004120f0(int *param_1,char *param_2)

{
  int iVar1;
  int iVar2;
  undefined4 uVar3;
  int iVar4;
  undefined *puVar5;
  undefined4 uStack_204;
  undefined auStack_200 [512];
  
  *param_2 = '\0';
  iVar2 = FUN_005cfd20(auStack_200);
  if (iVar2 != 0) {
    uVar3 = FUN_005cfd1a();
    iVar2 = FUN_005cfd14(uVar3);
    if ((iVar2 != 0) && (iVar2 = FUN_005cfd14(s_SOUND_00721734), iVar2 != 0)) {
      if (*(char *)(param_1 + 1) == '\0') {
        puVar5 = (&PTR_DAT_007216d8)[*param_1] + 0x1899;
      }
      else {
        puVar5 = (&PTR_DAT_007216d8)[*param_1];
      }
      iVar2 = FUN_005cfd0e(&uStack_204,*(undefined4 *)(puVar5 + 0x1895));
      if (iVar2 != 0) {
        FUN_004ea2d0(uStack_204);
        FUN_005cfd08(uStack_204);
        *param_2 = '\x01';
        iVar2 = -1;
        do {
          iVar1 = iVar2 + 1;
          if (*(int *)(puVar5 + 0x1820) <= iVar1) {
            if (*param_2 != '\0') {
              uVar3 = FUN_004eab20(puVar5,puVar5 + 0x1880,4);
              *(undefined4 *)(puVar5 + 0x1890) = uVar3;
            }
            break;
          }
          iVar4 = FUN_004ea050();
          if (iVar4 != 1) {
            if (0 < iVar2) {
              do {
                FUN_004ea030();
                iVar2 = iVar2 + -1;
              } while (iVar2 != 0);
            }
            *param_2 = '\0';
          }
          iVar2 = iVar1;
        } while (*param_2 != '\0');
      }
    }
    FUN_005cfd14(auStack_200);
  }
  return;
}

