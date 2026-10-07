/* NR2003.exe @ 00572cb0 FUN_00572cb0 */

void FUN_00572cb0(undefined4 *param_1,char *param_2)

{
  byte bVar1;
  char cVar2;
  int iVar3;
  char *pcVar4;
  char *pcVar5;
  undefined4 uVar6;
  undefined4 uStack_22c;
  undefined4 local_228;
  int iStack_224;
  char local_220 [32];
  undefined auStack_200 [512];
  
  iVar3 = FUN_0055a680();
  bVar1 = *(byte *)(iVar3 + 0x4f);
  pcVar4 = param_2;
  do {
    cVar2 = *pcVar4;
    pcVar4[(int)(local_220 + -(int)param_2)] = cVar2;
    pcVar4 = pcVar4 + 1;
  } while (cVar2 != '\0');
  iVar3 = -1;
  pcVar4 = local_220;
  do {
    pcVar5 = pcVar4;
    if (iVar3 == 0) break;
    iVar3 = iVar3 + -1;
    pcVar5 = pcVar4 + 1;
    cVar2 = *pcVar4;
    pcVar4 = pcVar5;
  } while (cVar2 != '\0');
  *(undefined4 *)(pcVar5 + -1) = DAT_0074f50c;
  pcVar5[3] = DAT_0074f510;
  FUN_005d34a0(0,0);
  FUN_00586b20();
  iVar3 = FUN_00572760(param_2);
  if (iVar3 == 0) goto LAB_00572f9f;
  local_228 = 0;
  DAT_00c721d4 = param_2;
  FUN_005cff24(&LAB_00572fd0);
  FUN_005d5070(&LAB_00587010);
  iVar3 = FUN_005d36d0(local_220,&local_228);
  if (iVar3 != 1) goto LAB_00572f9f;
  DAT_00c720ec = 0xffff;
  iVar3 = FUN_00572760(param_2);
  if ((iVar3 != 0) && (iVar3 = FUN_005cfd0e(&uStack_22c,local_220), iVar3 != 0)) {
    iVar3 = FUN_005cff1e(uStack_22c,&iStack_224,auStack_200,0x200);
    while ((iVar3 != 0 && (iStack_224 != 0))) {
      DAT_00c720ec = FUN_005f7610(auStack_200,iStack_224,DAT_00c720ec);
      iVar3 = FUN_005cff1e(uStack_22c,&iStack_224,auStack_200,0x200);
    }
    FUN_005cfd08(uStack_22c);
  }
  DAT_00c71f54 = 0xffff;
  iVar3 = FUN_005cfd0e(&uStack_22c,s_track_ini_0074f514);
  if (iVar3 != 0) {
    iVar3 = FUN_005cff1e(uStack_22c,&iStack_224,auStack_200,0x200);
    while ((iVar3 != 0 && (iStack_224 != 0))) {
      DAT_00c71f54 = FUN_005f7610(auStack_200,iStack_224,DAT_00c71f54);
      iVar3 = FUN_005cff1e(uStack_22c,&iStack_224,auStack_200,0x200);
    }
    FUN_005cfd08(uStack_22c);
  }
  iVar3 = FUN_0050f780(local_228);
  if (iVar3 != 0) {
    iVar3 = FUN_00572760(param_2);
    if ((iVar3 != 0) && (iVar3 = FUN_00538560(~bVar1 & 1,0), iVar3 != 0)) {
      FUN_004243d0(auStack_200);
      iVar3 = FUN_00558aa0(auStack_200);
      if (iVar3 == 0) {
        FUN_00424430(auStack_200);
        iVar3 = FUN_00558aa0(auStack_200);
        if (iVar3 == 0) goto LAB_00572f86;
      }
      uVar6 = 0;
      FUN_00538b20(0);
      FUN_0053faa0(uVar6);
      iVar3 = FUN_00550490();
      if (iVar3 != 0) {
        iVar3 = FUN_00573010(param_2,local_228);
        if (iVar3 != 0) {
          FUN_005cff18();
          FUN_00583200();
          FUN_005b58d0();
          FUN_0057dd50();
          DAT_00bdb9dc = FUN_006c5018();
          FUN_005cff12(local_228);
          local_228 = 0;
          *param_1 = 1;
          FUN_005cff24(0);
          return;
        }
        FUN_00550680();
      }
    }
LAB_00572f86:
    FUN_0050f7c0();
  }
  FUN_005cff24(0);
  FUN_005cff12(local_228);
LAB_00572f9f:
  uVar6 = FUN_005cfd1a();
  FUN_005cfd14(uVar6);
  *param_1 = 0;
  return;
}

