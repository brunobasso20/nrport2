/* NR2003.exe @ 0042b1f0 FUN_0042b1f0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0042b1f0(int param_1,int param_2)

{
  int *piVar1;
  int iVar2;
  byte bVar3;
  undefined4 unaff_EBX;
  
  iVar2 = param_1;
  bVar3 = (byte)*(undefined2 *)(param_2 + 0x92);
  if ((bVar3 & 3) == 3) {
    (**(code **)**(undefined4 **)(param_1 + 0x2b8))(0);
    piVar1 = *(int **)(iVar2 + 0xf0);
    (**(code **)(*piVar1 + 0x10))(&param_1,&stack0xfffffff8,&stack0x00000000);
    (**(code **)(*piVar1 + 8))(unaff_EBX,*(float *)(iVar2 + 0x264) - _DAT_006ee4cc,0);
    (**(code **)*piVar1)
              (*(undefined4 *)(iVar2 + 0x22c),*(float *)(iVar2 + 0x230) - _DAT_006ee4c8,
               *(float *)(iVar2 + 0x234) + _DAT_006ea4d4);
  }
  if ((bVar3 & 0xc) == 0xc) {
    (**(code **)**(undefined4 **)(iVar2 + 700))(0);
    piVar1 = *(int **)(iVar2 + 0xf8);
    (**(code **)(*piVar1 + 0x10))(&param_1,&stack0xfffffff8,&stack0x00000000);
    (**(code **)(*piVar1 + 8))(unaff_EBX,*(float *)(iVar2 + 0x270) + _DAT_006ee4cc,0);
    (**(code **)*piVar1)
              (*(undefined4 *)(iVar2 + 0x238),*(float *)(iVar2 + 0x23c) + _DAT_006ee4c4,
               *(float *)(iVar2 + 0x240) + _DAT_006ea4d4);
  }
  if ((bVar3 & 0x30) == 0x30) {
    (**(code **)**(undefined4 **)(iVar2 + 0x2c0))(0);
    piVar1 = *(int **)(iVar2 + 0x100);
    (**(code **)(*piVar1 + 0x10))(&param_1,&stack0xfffffff8,&stack0x00000000);
    (**(code **)(*piVar1 + 8))(unaff_EBX,*(float *)(iVar2 + 0x27c) - _DAT_006ee4cc,0);
    (**(code **)*piVar1)
              (*(undefined4 *)(iVar2 + 0x244),*(float *)(iVar2 + 0x248) - _DAT_006ee4c4,
               *(float *)(iVar2 + 0x24c) + _DAT_006ea4d4);
  }
  if ((bVar3 & 0xc0) == 0xc0) {
    (**(code **)**(undefined4 **)(iVar2 + 0x2c4))(0);
    piVar1 = *(int **)(iVar2 + 0x108);
    (**(code **)(*piVar1 + 0x10))(&param_1,&stack0xfffffff8,&stack0x00000000);
    (**(code **)(*piVar1 + 8))(unaff_EBX,*(float *)(iVar2 + 0x288) + _DAT_006ee4cc,0);
    (**(code **)*piVar1)
              (*(undefined4 *)(iVar2 + 0x250),*(float *)(iVar2 + 0x254) + _DAT_006ee4c4,
               *(float *)(iVar2 + 600) + _DAT_006ea4d4);
  }
  return;
}

