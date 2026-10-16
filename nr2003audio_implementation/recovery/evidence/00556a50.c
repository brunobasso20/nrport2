/* NR2003.exe @ 00556a50 recovered_00556a50 */

undefined4 recovered_00556a50(void)

{
  int iVar1;
  undefined4 uVar2;
  int iVar3;
  int *piVar4;
  undefined4 uStack_8;
  int iStack_4;
  
  iVar3 = 0;
  do {
    iVar1 = func_0x00593ad0(iVar3);
    if (iVar1 == 0) {
      while (iVar3 = iVar3 + -1, -1 < iVar3) {
        func_0x00593cc0(iVar3);
      }
      return 0;
    }
    iVar3 = iVar3 + 1;
  } while (iVar3 < 0x29);
  uVar2 = FUN_005cfd1a();
  iVar3 = FUN_005cfd14(uVar2);
  if ((iVar3 == 1) && (iVar3 = FUN_005cfd14(s_SOUND_0074da60), iVar3 == 1)) {
    piVar4 = (int *)0xbfc8b0;
    iStack_4 = 0;
    do {
      iVar3 = iStack_4;
      iVar1 = FUN_005cfd0e(&uStack_8,
                           *(undefined4 *)((int)&PTR_s_tire_asphalt_ces_0074d0dc + iStack_4));
      if (iVar1 != 0) {
        FUN_004ea2d0(uStack_8);
        FUN_005cfd08(uStack_8);
        iVar1 = 0;
        if (0 < *piVar4) {
          do {
            iVar3 = FUN_004ea050();
            if (iVar3 != 1) {
              return 0;
            }
            iVar1 = iVar1 + 1;
            iVar3 = iStack_4;
          } while (iVar1 < *piVar4);
        }
        uVar2 = FUN_004ea990(piVar4 + -0x608,0,0);
        *(undefined4 *)(iVar3 + 0xc01510) = uVar2;
      }
      piVar4 = piVar4 + 0x620;
      iStack_4 = iVar3 + 4;
    } while ((int)piVar4 < 0xc02ab0);
    iVar3 = FUN_005cfd0e(&uStack_8,s_engvol_ces_0074da68);
    if (iVar3 != 0) {
      FUN_004ea2d0(uStack_8);
      FUN_005cfd08(uStack_8);
      return 1;
    }
    DAT_00bf8a88 = 0;
  }
  return 1;
}

