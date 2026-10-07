/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004686b0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 __thiscall FUN_004686b0(int param_1_00,undefined1 *param_1,int param_2)

{
  char *pcVar1;
  char cVar2;
  int iVar3;
  int iVar4;
  int iVar5;
  undefined *puVar6;
  char *pcVar7;
  undefined1 auStack_3a0 [79];
  undefined1 uStack_351;
  undefined1 auStack_350 [80];
  undefined1 local_300 [256];
  undefined2 local_200 [256];
  
  local_200[0] = 0;
  if (param_2 == -0x22dd) {
    *param_1 = 0;
    return 0;
  }
  if (*(byte *)(param_2 + 0x22e6) == 0xff) {
    *param_1 = 0;
    return 0;
  }
  pcVar1 = (char *)((uint)*(byte *)(param_2 + 0x22e6) * 0xaf + 5 + param_2);
  iVar5 = -1;
  pcVar7 = pcVar1 + 0x24;
  do {
    if (iVar5 == 0) break;
    iVar5 = iVar5 + -1;
    cVar2 = *pcVar7;
    pcVar7 = pcVar7 + 1;
  } while (cVar2 != '\0');
  if (iVar5 == -2) {
    if (*pcVar1 == '\0') {
      FUN_006c4f81(local_300,&DAT_00722324);
    }
    else {
      FUN_006c4f81(local_300,s__c__s_0072231c,(int)*pcVar1,pcVar1 + 0x10);
    }
  }
  else {
    FUN_006c4f81(local_300,&DAT_00722324,pcVar1 + 0x24);
  }
  FUN_006c4b00(auStack_3a0,local_300,0x4f);
  uStack_351 = 0;
  if (*(int *)(param_1_00 + 0x25c1) != -1) goto LAB_004687f5;
  if (((*(uint *)(param_2 + 0x22eb) & 0x3ff) == 0) && (*(char *)(param_2 + 0x22f0) != -1)) {
    if (_DAT_006e97d8 <= *(float *)(param_2 + 0x22e7)) {
      puVar6 = &DAT_006f01c4;
      goto LAB_004687d3;
    }
    puVar6 = &DAT_006f01a8;
    iVar5 = 7;
  }
  else {
    puVar6 = &DAT_006f01e4;
LAB_004687d3:
    iVar5 = 8;
  }
  iVar3 = FUN_006c5bf8();
  iVar4 = FUN_006c5bf8();
  *(undefined4 *)(param_1_00 + 0x25c1) =
       *(undefined4 *)(puVar6 + ((iVar4 + (iVar3 >> 0x10)) % iVar5) * 4);
LAB_004687f5:
  FUN_005f9820(*(undefined4 *)(param_1_00 + 0x25c1),auStack_350,0x50);
  FUN_005f9900(&DAT_00f72794,0x34d2,local_200,0x100,auStack_3a0,auStack_350,&DAT_00bdba58);
  FUN_006c4f81(param_1,&DAT_00735754,local_200);
  return 1;
}


