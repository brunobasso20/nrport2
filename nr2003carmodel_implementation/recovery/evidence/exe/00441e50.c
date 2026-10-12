/* NR2003.exe @ 00441e50 FUN_00441e50 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00441e50(void)

{
  char cVar1;
  uint uVar2;
  undefined4 *puVar3;
  undefined4 uVar4;
  int iVar5;
  int extraout_ECX;
  int extraout_ECX_00;
  int extraout_ECX_01;
  int extraout_ECX_02;
  undefined4 *puVar6;
  undefined4 local_30;
  undefined4 uStack_2c;
  undefined uStack_24;
  undefined uStack_23;
  undefined uStack_22;
  undefined uStack_20;
  undefined uStack_1f;
  undefined uStack_1d;
  undefined uStack_1c;
  undefined uStack_1b;
  undefined4 uStack_1a;
  undefined uStack_16;
  undefined uStack_15;
  undefined4 uStack_14;
  undefined4 uStack_10;
  undefined4 uStack_c;
  
  FUN_00583140();
  uVar2 = FUN_00585590();
  iVar5 = 0;
  do {
    if (iVar5 == 5) {
      cVar1 = FUN_00441710();
      iVar5 = extraout_ECX;
      if ((cVar1 == '\0') || (cVar1 = FUN_004416f0(), iVar5 = extraout_ECX_00, cVar1 == '\0')) {
        uVar2 = uVar2 & 0xfffffffe;
      }
      else {
        uVar2 = uVar2 | 1;
      }
    }
    else {
      cVar1 = FUN_00441710();
      iVar5 = extraout_ECX_01;
      if (cVar1 != '\0') {
        FUN_004416f0();
        iVar5 = extraout_ECX_02;
      }
    }
    iVar5 = iVar5 + 1;
  } while (iVar5 < 6);
  FUN_00583120();
  FUN_00585580(uVar2);
  iVar5 = FUN_004417b0();
  FUN_005d4090((double)iVar5 * _DAT_006ef4c8);
  puVar3 = (undefined4 *)FUN_005d44c0();
  puVar6 = (undefined4 *)&uStack_24;
  for (iVar5 = 7; iVar5 != 0; iVar5 = iVar5 + -1) {
    *puVar6 = *puVar3;
    puVar3 = puVar3 + 1;
    puVar6 = puVar6 + 1;
  }
  uStack_24 = FUN_00441670(0);
  uStack_1a = FUN_00441650();
  uStack_22 = 1;
  uStack_20 = FUN_00441670(2);
  uStack_1f = FUN_00441670(1);
  uStack_1d = FUN_00441670(4);
  cVar1 = FUN_00441770(1);
  if (cVar1 == '\0') {
LAB_00441f60:
    uStack_1c = 0;
  }
  else {
    cVar1 = FUN_00441750();
    uStack_1c = 1;
    if (cVar1 == '\0') goto LAB_00441f60;
  }
  uStack_14 = DAT_0072c824;
  uStack_1b = FUN_00441670();
  iVar5 = FUN_006c6530(s_rend_ogl_dll_0072c6f8,s_rend_ogl_dll_0072d57c);
  if ((iVar5 == 0) || ((DAT_00895a4c == '\0' && (cVar1 = FUN_005d3570(), cVar1 != '\0')))) {
    uStack_23 = FUN_00441670();
  }
  else {
    uStack_23 = 0;
  }
  iVar5 = FUN_00441ae0();
  if (iVar5 == 0) {
    uStack_10 = 8;
  }
  else if ((iVar5 == 1) || (iVar5 != 2)) {
    uStack_10 = 4;
  }
  else {
    uStack_10 = 0;
  }
  iVar5 = FUN_00441b20();
  if (iVar5 == 0) {
    uStack_c = 0;
  }
  else if ((iVar5 == 1) || (iVar5 != 2)) {
    uStack_c = 1;
  }
  else {
    uStack_c = 2;
  }
  cVar1 = FUN_00441770();
  if (cVar1 == '\0') {
LAB_00442026:
    uStack_16 = 0;
  }
  else {
    cVar1 = FUN_00441750();
    uStack_16 = 1;
    if (cVar1 == '\0') goto LAB_00442026;
  }
  cVar1 = FUN_00441770();
  if (cVar1 != '\0') {
    cVar1 = FUN_00441750();
    uStack_15 = 1;
    if (cVar1 != '\0') goto LAB_00442050;
  }
  uStack_15 = 0;
LAB_00442050:
  FUN_005d44a0();
  local_30 = 0;
  uStack_2c = 0xbff00000;
  iVar5 = FUN_004552c0();
  if (*(int *)(iVar5 + 8) == 0) {
    local_30 = 0x33333333;
    uStack_2c = 0x3fe33333;
  }
  else if (*(int *)(iVar5 + 8) == 1) {
    local_30 = 0x9999999a;
    uStack_2c = 0x3fe99999;
  }
  FUN_005d34d0(local_30,uStack_2c);
  uVar4 = FUN_004419a0();
  FUN_00587d00(uVar4);
  uVar4 = FUN_004419e0();
  FUN_00587d10(uVar4);
  FUN_00441900();
  FUN_00587bc0();
  FUN_00441950();
  FUN_00587c70();
  FUN_00587cf0(DAT_0072c820);
  FUN_005d4fd0(DAT_0072c85c);
  FUN_005d4ff0(DAT_0072c85d);
  FUN_005d5010(DAT_00895a40);
  FUN_005d5050(DAT_00895a48);
  cVar1 = FUN_005d4ef0();
  if (cVar1 != '\0') {
    FUN_005d4f10();
    FUN_005d4f40();
  }
  FUN_005d3a40(0,1);
  FUN_005d50c0(DAT_00895a50);
  FUN_005d50e0(DAT_00895a54);
  FUN_005d5100(DAT_0072c865);
  FUN_005d5120(DAT_0072c868);
  FUN_005d5140(DAT_0072c86c);
  FUN_005d5160(DAT_0072c870,DAT_0072c874);
  FUN_005d5180(DAT_0072c878);
  FUN_005d51a0(DAT_00895a58);
  FUN_005d5220(DAT_00895a4d);
  FUN_005d5250(DAT_00895a4e);
  FUN_005d51c0(DAT_0072c87c);
  FUN_005d51e0(DAT_0072c880);
  FUN_005d5200(_DAT_0072c884);
  return;
}

