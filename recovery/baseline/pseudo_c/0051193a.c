/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0051193a */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0051193a(int param_1,int param_2)

{
  undefined4 *puVar1;
  int iVar2;
  
  if (*(char *)(param_1 + 0x41) == '\0') {
    iVar2 = *(int *)(param_2 + 0x5c) + 1;
    *(int *)(param_2 + 0x5c) = iVar2;
    *(undefined4 *)(param_2 + 0x8d8) = 0;
    *(undefined4 *)(param_2 + 0x8dc) = 0;
    FUN_005f65a0(param_1,(double)(*(float *)(param_2 + 0x5ac) * _DAT_006ea454 +
                                 *(float *)(param_2 + 0x5a8)),
                 (double)(*(float *)(param_2 + 0x5a8) + *(float *)(param_2 + 0x5ac)),
                 CONCAT31((int3)((uint)iVar2 >> 8),0 < *(int *)(param_2 + 0x5a4)),param_2 + 0x930,
                 param_2 + 0x944);
    FUN_005f65a0(param_1,(double)((*(float *)(param_2 + 0x5ac) * _DAT_006ea454 +
                                  *(float *)(param_2 + 0x5a8)) - _DAT_006ecfc8),
                 (double)((*(float *)(param_2 + 0x5a8) + *(float *)(param_2 + 0x5ac)) -
                         _DAT_006ecfc8),
                 CONCAT31((int3)((uint)*(int *)(param_2 + 0x5a4) >> 8),0 < *(int *)(param_2 + 0x5a4)
                         ),param_2 + 0x96c,param_2 + 0x980);
    *(undefined4 *)(param_2 + 0x994) = 0;
    *(undefined4 *)(param_2 + 0x958) = 0;
    puVar1 = (undefined4 *)(param_2 + 0x9bc);
    *(undefined4 *)(param_2 + 0x998) = *(undefined4 *)(param_2 + 0x80);
    *(undefined4 *)(param_2 + 0x95c) = *(undefined4 *)(param_2 + 0x80);
    iVar2 = 5;
    *(undefined4 *)(param_2 + 0x99c) = *(undefined4 *)(param_2 + 0x84);
    *(undefined4 *)(param_2 + 0x960) = *(undefined4 *)(param_2 + 0x84);
    *(undefined4 *)(param_2 + 0x9a0) = *(undefined4 *)(param_2 + 0x88);
    *(undefined4 *)(param_2 + 0x964) = *(undefined4 *)(param_2 + 0x88);
    *(undefined4 *)(param_2 + 0x9a4) = *(undefined4 *)(param_2 + 0x8c);
    *(undefined4 *)(param_2 + 0x968) = *(undefined4 *)(param_2 + 0x8c);
    *(float *)(param_2 + 0x928) =
         (*(float *)(param_2 + 0x5ac) * _DAT_006ea454 + *(float *)(param_2 + 0x5a8)) - _DAT_006ea478
    ;
    *(undefined4 *)(param_2 + 0x9d0) = 0x41200000;
    *(undefined4 *)(param_2 + 0x9d4) = 0;
    *(undefined4 *)(param_2 + 0x9d8) = 0x49742400;
    *(undefined4 *)(param_2 + 0x9dc) = 0;
    *(float *)(param_2 + 0x92c) =
         (*(float *)(param_2 + 0x5a8) + *(float *)(param_2 + 0x5ac)) - _DAT_006ea478;
    do {
      puVar1[-5] = 0;
      *puVar1 = 0;
      puVar1 = puVar1 + 1;
      iVar2 = iVar2 + -1;
    } while (iVar2 != 0);
  }
  return;
}


