/* NR2003.exe @ 00564b80 FUN_00564b80 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00564b80(int param_1)

{
  int iVar1;
  undefined4 uVar2;
  float10 fVar3;
  undefined local_c [12];
  
  uVar2 = FUN_00592db0(param_1);
  fVar3 = (float10)FUN_00563530(param_1,uVar2);
  if ((float10)_DAT_006ea454 < fVar3) {
    iVar1 = *(int *)(param_1 + 0x5ae);
    FUN_005634a0(param_1,local_c);
    FUN_00583a00(local_c,iVar1 + 0xc,*(undefined4 *)(iVar1 + 0x3c),(float)fVar3);
  }
  return;
}

