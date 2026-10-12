/* NR2003.exe @ 00428be0 FUN_00428be0 */

int FUN_00428be0(int param_1,int param_2)

{
  uint uVar1;
  uint uVar2;
  int iVar3;
  int iVar4;
  int iVar5;
  int local_14;
  int local_10;
  int local_c;
  int local_8;
  int local_4;
  
  iVar5 = DAT_00876d14;
  local_4 = *(int *)(param_2 + 8);
  if (local_4 == 0) {
    return 0;
  }
  uVar2 = *(uint *)(param_1 + 0x9c);
  uVar1 = (uVar2 & 1) + *(int *)(param_2 + 4) * 2;
  iVar4 = (&DAT_008726c0)[uVar1];
  if (((&DAT_008726c0)[uVar1] == 0) &&
     (iVar4 = (&DAT_008726c0)[uVar1 ^ 1], (&DAT_008726c0)[uVar1 ^ 1] == 0)) {
    iVar4 = DAT_008726c0;
  }
  local_14 = DAT_00876d10;
  local_c = DAT_00876d18;
  local_8 = DAT_00876d1c;
  if ((((iVar4 != 0) && (DAT_00876d10 != 0)) && (DAT_00876d18 != 0)) &&
     ((DAT_00876d14 != 0 && (DAT_00876d1c != 0)))) {
    FUN_005d4560(iVar4,&param_2,&param_1);
    iVar3 = FUN_005cfce4(&local_10,param_2 * param_1 * 4);
    if ((iVar3 == 0) || (iVar3 = local_10, local_10 == 0)) {
      iVar3 = 0;
    }
    iVar4 = FUN_005d4580(iVar4,iVar3);
    if (iVar4 == 1) {
      FUN_00428e20(iVar3,param_2,param_1,local_14,0xbf,0x112,0xb4,uVar2);
      FUN_00428e20(iVar3,param_2,param_1,local_c,3,0xe,0,uVar2);
      FUN_00428e20(iVar3,param_2,param_1,local_8,0x1d3,0x25,0,uVar2);
      FUN_00428e20(iVar3,param_2,param_1,iVar5,0xcc,0x1aa,0,uVar2);
      FUN_00428e20(iVar3,param_2,param_1,iVar5,0xcc,0x84,0xb4,uVar2);
      local_14 = 0;
      iVar5 = FUN_005d4b50(&local_14,param_2,param_1,param_2 * 4,iVar3,0x3f4ccccd,1,1,0,0);
      if (iVar5 != 0) {
        if (iVar3 != 0) {
          FUN_005cfccc(iVar3);
        }
        local_10 = 0;
        iVar5 = FUN_005d39d0(local_14,&local_10,1);
        if (iVar5 != 0) {
          return local_10;
        }
      }
      if (iVar3 != 0) {
        FUN_005cfccc(iVar3);
      }
    }
  }
  iVar5 = local_4 * 0xe00;
  (**(code **)**(undefined4 **)(&DAT_00872710 + iVar5))();
  return *(int *)(&DAT_00872710 + iVar5);
}

