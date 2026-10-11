/* NR2003.exe @ 005543f0 FUN_005543f0 */

int FUN_005543f0(void)

{
  bool bVar1;
  undefined4 uVar2;
  int iVar3;
  undefined *puVar4;
  undefined4 local_18;
  undefined4 local_14;
  undefined4 local_10;
  undefined4 local_c;
  undefined4 local_8;
  undefined4 local_4;
  
  bVar1 = inBackground();
  if (bVar1) {
    uVar2 = FUN_0055ab00();
    iVar3 = FUN_00562f70(uVar2);
    if (*(int *)(iVar3 + 4) == 0) {
      return iVar3 + 4;
    }
    iVar3 = FUN_0055ab00();
    puVar4 = &DAT_00c0890c + iVar3 * 0x32c;
  }
  else {
    uVar2 = FUN_0055ab00();
    iVar3 = FUN_004f5970(uVar2);
    if (*(int *)(iVar3 + 4) == 0) {
      return iVar3 + 4;
    }
    iVar3 = FUN_0055ab00();
    puVar4 = &DAT_00b32f84 + iVar3 * 0x32c;
  }
  local_18 = DAT_00bf6d40;
  local_10 = DAT_00bf6d50;
  local_c = DAT_00bf6d44;
  local_14 = DAT_00bf6d48;
  local_4 = DAT_00bf6d54;
  local_8 = DAT_00bf6d4c;
  thunk_FUN_005f58d0(puVar4,&local_18);
  FUN_005f5a60(puVar4,&DAT_00bf6d58);
  iVar3 = FUN_005f5ac0(puVar4,&local_c,&DAT_00bf6d68);
  return iVar3;
}

