/* NR2003.exe @ 00428800 FUN_00428800 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

int FUN_00428800(int param_1,float param_2)

{
  int iVar1;
  int iVar2;
  int iVar3;
  float10 fVar4;
  float10 fVar5;
  
  iVar3 = *(int *)((int)param_2 + 8);
  if ((iVar3 != 0) && (iVar1 = (&DAT_008726c0)[*(int *)(param_1 + 0x9c) % DAT_00876d0c], iVar1 != 0)
     ) {
    param_1 = 0;
    FUN_005d3e50(iVar1);
    fVar4 = (float10)FUN_005d4f70(iVar1);
    fVar5 = (float10)FUN_005d34c0();
    param_2 = (float)(fVar5 - (float10)_DAT_006ea4a0);
    if ((float10)_DAT_006ea454 < fVar5 - (float10)_DAT_006ea4a0) {
      param_2 = 0.0;
    }
    FUN_005d4f80(iVar1,param_2);
    iVar2 = FUN_005d39d0(iVar1,&param_1,1);
    if (iVar2 != 0) {
      FUN_005d4f80(iVar1,(float)fVar4);
      return param_1;
    }
    FUN_005d4f80(iVar1,(float)fVar4);
  }
  iVar3 = iVar3 * 0xe00;
  (**(code **)**(undefined4 **)(&DAT_00872710 + iVar3))();
  return *(int *)(&DAT_00872710 + iVar3);
}

