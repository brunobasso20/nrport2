/* NR2003.exe @ 004eab20 FUN_004eab20 */

int FUN_004eab20(int param_1,undefined4 *param_2,int param_3)

{
  undefined4 uVar1;
  int iVar2;
  int iVar3;
  undefined4 uVar4;
  undefined4 *puVar5;
  int iVar6;
  undefined4 local_40 [8];
  undefined4 local_20 [8];
  
  uVar1 = param_1;
  if (param_3 < 9) {
    iVar2 = FUN_004ea9f0(param_1,0,local_40,param_3);
    iVar3 = FUN_004ea9f0(param_1,1,local_20,param_3 - iVar2);
    if (0 < iVar2) {
      puVar5 = param_2;
      param_1 = iVar2;
      do {
        uVar4 = FUN_004ea990(uVar1,0,*(undefined4 *)(((int)local_40 - (int)param_2) + (int)puVar5));
        *puVar5 = uVar4;
        puVar5 = puVar5 + 1;
        param_1 = param_1 + -1;
      } while (param_1 != 0);
    }
    iVar6 = 0;
    if (0 < iVar3) {
      puVar5 = param_2 + iVar2;
      do {
        uVar4 = FUN_004ea990(uVar1,1,local_20[iVar6]);
        *puVar5 = uVar4;
        iVar6 = iVar6 + 1;
        puVar5 = puVar5 + 1;
      } while (iVar6 < iVar3);
    }
    FUN_004eaa60(param_2,iVar2 + iVar3,0xffffffff);
    return iVar2 + iVar3;
  }
  return 0;
}

