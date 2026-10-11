/* NR2003.exe @ 005547a0 FUN_005547a0 */

void FUN_005547a0(void)

{
  undefined4 uVar1;
  bool bVar2;
  int iVar3;
  undefined4 uVar4;
  undefined4 local_b0;
  undefined4 local_ac;
  undefined4 local_a8;
  undefined4 local_a4;
  undefined4 local_a0;
  undefined4 local_9c;
  undefined local_98 [152];
  
  local_a4 = DAT_00bf6d40;
  local_a0 = DAT_00bf6d48;
  local_b0 = DAT_00bf6d44;
  local_ac = DAT_00bf6d4c;
  local_9c = DAT_00bf6d50;
  local_a8 = DAT_00bf6d54;
  thunk_FUN_005f58d0(local_98,&local_a4);
  FUN_005f5a60(local_98,&DAT_00bf6d58);
  FUN_005f5ac0(local_98,&local_b0,&DAT_00bf6d68);
  bVar2 = inBackground();
  uVar1 = DAT_00c0819c;
  if (!bVar2) {
    iVar3 = getSVCount();
    uVar4 = FUN_0055ab00();
    FUN_005a02b0(uVar4,local_98,iVar3,uVar1);
    uVar1 = DAT_00c0819c;
    iVar3 = getSVCount();
    uVar4 = FUN_0055ab00();
    FUN_005a02b0(uVar4,local_98,iVar3,uVar1);
    return;
  }
  iVar3 = getBGCount();
  uVar4 = FUN_0055ab00();
  FUN_005a02b0(uVar4,local_98,iVar3,uVar1);
  return;
}

