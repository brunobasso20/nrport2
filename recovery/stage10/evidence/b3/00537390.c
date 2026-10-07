/* NR2003.exe @ 00537390 FUN_00537390 */

undefined4 FUN_00537390(void)

{
  int iVar1;
  int extraout_EDX;
  undefined4 *puVar2;
  undefined *puVar3;
  undefined local_6c [108];
  
  FUN_0056772e(local_6c,1,3);
  FUN_005676f0();
  iVar1 = 0;
  do {
    FUN_00536d60(iVar1);
    iVar1 = extraout_EDX + 1;
  } while (iVar1 < 0x19);
  FUN_00536cf0();
  puVar2 = &DAT_00bdccd8;
  puVar3 = &DAT_00bde2d6;
  iVar1 = 0;
  do {
    FUN_005cfcc6(0x28,s_track_0074c528,*(undefined4 *)((int)&PTR_s_track_name_0074c130 + iVar1),
                 *(undefined4 *)((int)&DAT_00be0c38 + iVar1),2,2);
    *(undefined4 **)(puVar3 + -4) = puVar2;
    FUN_006c4b00(puVar3,puVar2,0x40);
    FUN_006c4b00(puVar3 + 0x40,puVar3,0x40);
    puVar3 = puVar3 + 0xa6;
    iVar1 = iVar1 + 4;
    puVar2 = puVar2 + 0x10;
  } while ((int)puVar3 < 0xbdf30c);
  iVar1 = FUN_005cfd26(0x28,s_track_ini_0074c530);
  puVar2 = &DAT_00bde2b0;
  do {
    FUN_005cfcc0();
    puVar2 = (undefined4 *)((int)puVar2 + 0xa6);
  } while ((int)puVar2 < 0xbdf2e6);
  if (iVar1 == 0) {
    FUN_0056775d(local_6c);
    return 0;
  }
  iVar1 = 0;
  do {
    FUN_00537010(iVar1);
    iVar1 = iVar1 + 1;
  } while (iVar1 < 0x19);
  if ((1 < DAT_00bddde0) && ((DAT_00bdbd00 < 0 || (DAT_00bddde0 = 1, 4 < DAT_00bdbd00)))) {
    DAT_00bddde0 = 0;
  }
  FUN_0056775d(local_6c);
  return 1;
}

