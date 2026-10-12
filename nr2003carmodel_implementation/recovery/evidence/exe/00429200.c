/* NR2003.exe @ 00429200 FUN_00429200 */

undefined4 * FUN_00429200(int param_1,int param_2)

{
  uint uVar1;
  uint uVar2;
  int iVar3;
  int iVar4;
  int iVar5;
  undefined4 *puVar6;
  undefined4 uStack_8;
  undefined4 *local_4;
  
  iVar5 = DAT_00876d14;
  if (*(int *)(param_2 + 8) == 0) {
    return (undefined4 *)0x0;
  }
  uVar2 = *(uint *)(param_1 + 0x9c);
  uVar1 = (uVar2 & 1) + *(int *)(param_2 + 4) * 2;
  iVar4 = (&DAT_00872688)[uVar1];
  if (((&DAT_00872688)[uVar1] == 0) &&
     (iVar4 = (&DAT_008726c0)[uVar1 ^ 1], (&DAT_008726c0)[uVar1 ^ 1] == 0)) {
    iVar4 = DAT_008726c0;
  }
  if ((iVar4 != 0) && (DAT_00876d14 != 0)) {
    FUN_005d4560(iVar4,&param_2,&param_1);
    iVar3 = FUN_005cfce4(&local_4,param_2 * param_1 * 4);
    if ((iVar3 == 0) || (puVar6 = local_4, local_4 == (undefined4 *)0x0)) {
      puVar6 = (undefined4 *)0x0;
    }
    iVar4 = FUN_005d4580(iVar4,puVar6);
    if (iVar4 == 1) {
      FUN_00428e20(puVar6,param_2,param_1,iVar5,0x194,0x131,0,uVar2);
      uStack_8 = 0;
      iVar5 = FUN_005d4b50(&uStack_8,param_2,param_1,param_2 * 4,puVar6,0x3f4ccccd,1,1,0,0);
      if (iVar5 != 0) {
        if (puVar6 != (undefined4 *)0x0) {
          FUN_005cfccc(puVar6);
        }
        local_4 = (undefined4 *)0x0;
        iVar5 = FUN_005d39d0(uStack_8,&local_4,1);
        if (iVar5 != 0) {
          return local_4;
        }
      }
      if (puVar6 != (undefined4 *)0x0) {
        FUN_005cfccc(puVar6);
      }
    }
  }
  puVar6 = (undefined4 *)FUN_00525a70();
  if (puVar6 != (undefined4 *)0x0) {
    (**(code **)*puVar6)();
  }
  return puVar6;
}

