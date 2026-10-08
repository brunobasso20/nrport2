/* NR2003.exe @ 00592d60 FUN_00592d60 */

void FUN_00592d60(int param_1)

{
  char cVar1;
  undefined4 uVar2;
  
  uVar2 = FUN_00562f70(*(uint *)(param_1 + 4) & 0x7f);
  uVar2 = FUN_00592db0(uVar2);
  cVar1 = FUN_00547f20(uVar2,param_1);
  if (cVar1 == '\0') {
    FUN_005acdd0(uVar2);
    FUN_005acdd0(param_1);
    FUN_00548dd0(uVar2,param_1);
  }
  return;
}

