/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00566e50 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00566e50(int param_1,undefined4 param_2,undefined4 param_3)

{
  float fVar1;
  uint uVar2;
  uint uVar3;
  ulonglong uVar4;
  bool bVar5;
  undefined4 *puVar6;
  char cVar7;
  int iVar8;
  undefined4 uVar9;
  int *piVar10;
  int iVar11;
  float10 fVar12;
  undefined *puVar13;
  undefined4 *local_10;
  uint local_c;
  undefined4 uStack_8;
  undefined4 uStack_4;
  
  bVar5 = false;
  iVar8 = FUN_0055a6a0();
  if ((iVar8 != -1) && (iVar8 = FUN_0055a6a0(), param_1 <= iVar8)) {
    bVar5 = true;
  }
  iVar8 = FUN_0055a6a0();
  if (iVar8 != -1) {
    FUN_00567140();
  }
  local_c = taskGetRate();
  iVar11 = 0;
  DAT_00c087a4 = (float)(int)local_c;
  piVar10 = &DAT_00c08a18;
  iVar8 = 0x30;
  DAT_00c087a0 = _DAT_006e97d8 / DAT_00c087a4;
  do {
    FUN_0059fa90();
    *piVar10 = iVar11;
    piVar10[0x2e] = 5000;
    iVar11 = iVar11 + 1;
    piVar10 = piVar10 + 0xcb;
    iVar8 = iVar8 + -1;
  } while (iVar8 != 0);
  FUN_00551800();
  FUN_0055a6c0(param_1);
  FUN_0055a6d0(param_2);
  FUN_0055a720(param_3);
  FUN_0055a740(0,0);
  local_10 = (undefined4 *)0x0;
  cVar7 = FUN_00566a20(&local_10);
  while (cVar7 != '\0') {
    (**(code **)*local_10)();
    FUN_00563080(local_10,1);
    iVar8 = FUN_005c2d20(DAT_00c08194);
    if (iVar8 != 1) {
      FUN_00433cb0(*(int *)((int)local_10 + 0x5b2),(int)local_10 + 0x58e,
                   &DAT_00c08874 + *(int *)((int)local_10 + 0x5b2) * 0x32c);
    }
    puVar6 = local_10;
    fVar1 = *(float *)((int)local_10 + 0x586);
    iVar8 = FUN_0055a680();
    uStack_8 = 0;
    local_c = (*(uint *)(iVar8 + 0x50) & 3) + 1;
    uVar4 = (ulonglong)local_c;
    fVar12 = (float10)FUN_00516e1a();
    puVar6[0x154] = 0;
    puVar6[0x153] = (float)(fVar12 * (float10)uVar4 * (float10)fVar1 * (float10)_DAT_006ea67c);
    cVar7 = FUN_00566a20(&local_10);
  }
  local_10 = (undefined4 *)0x0;
  cVar7 = FUN_005aa650(&local_10);
  while (cVar7 != '\0') {
    (**(code **)*local_10)();
    cVar7 = FUN_005aa650(&local_10);
  }
  iVar8 = FUN_005c2d20(DAT_00c08194);
  if (iVar8 != 1) {
    FUN_00578610();
  }
  if ((DAT_00c08198 != '\0') && (DAT_00c08199 != '\0')) {
    puVar13 = &DAT_00c07170;
    uVar9 = FUN_0055a6f0(&DAT_00c07170);
    FUN_005a4100(param_1,uVar9,puVar13);
  }
  uStack_4 = 1;
  FUN_005f5890(&DAT_00e0b7e4);
  uVar2 = *DAT_00e0b7d8;
  uVar3 = *DAT_00e0b7e0;
  FUN_005f58a0(&DAT_00e0b7e4);
  bgRequestFGAction(FUN_00572a10,&uStack_4,(void *)(uVar2 ^ uVar3));
  FUN_00539180();
  FUN_005854a0();
  FUN_00583200();
  FUN_00559870();
  FUN_0057dd80();
  FUN_0059f740();
  uVar9 = FUN_0055ab00();
  uVar9 = FUN_00562f70(uVar9);
  FUN_005248d0(uVar9);
  local_10 = (undefined4 *)0x0;
  cVar7 = FUN_005669f0(&local_10);
  while (cVar7 != '\0') {
    iVar8 = FUN_005c2d20(DAT_00c08194);
    if ((iVar8 != 1) || (*(char *)((int)local_10 + 0x59b) == '\0')) {
      FUN_00524af0(*(undefined4 *)((int)local_10 + 0x5b2),0xff);
    }
    cVar7 = FUN_005669f0(&local_10);
  }
  if (!bVar5) {
    return;
  }
  uVar9 = FUN_0055a6a0();
  FUN_00501580(uVar9);
  FUN_005b5900();
  return;
}


