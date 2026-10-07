/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00578f80 */

void __thiscall FUN_00578f80(int param_1_00,int *param_1,int *param_2)

{
  int *piVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  float fVar6;
  float fVar7;
  undefined4 uVar8;
  int iVar9;
  int iVar10;
  int iVar11;
  int iVar12;
  int iVar13;
  int local_9c0 [624];
  
  do {
    if (param_1 == param_2) {
      return;
    }
    iVar9 = *(int *)(*param_1 + 0xc);
    if (iVar9 != 0) {
      fVar2 = *(float *)(iVar9 + 300);
      fVar3 = *(float *)(iVar9 + 300);
      fVar4 = *(float *)(iVar9 + 0x128);
      fVar5 = *(float *)(iVar9 + 0x128);
      uVar8 = *(undefined4 *)(param_1_00 + 0x9934);
      fVar6 = *(float *)(iVar9 + 0x124);
      fVar7 = *(float *)(iVar9 + 0x124);
      iVar9 = FUN_005796e0(local_9c0,*param_1);
      iVar11 = 0;
      if (0 < iVar9) {
        do {
          iVar13 = local_9c0[iVar11];
          iVar10 = *(int *)(iVar13 + 0xc);
          if (iVar10 == 0) {
LAB_0057904d:
            iVar12 = *param_1;
          }
          else {
            iVar12 = iVar13;
            if (*(int *)(iVar13 + 8) == 0) {
              iVar13 = *param_1;
            }
            else {
              if (*(float *)(iVar10 + 0x124) * *(float *)(iVar10 + 0x124) +
                  *(float *)(iVar10 + 0x128) * *(float *)(iVar10 + 0x128) +
                  *(float *)(iVar10 + 300) * *(float *)(iVar10 + 300) <=
                  fVar6 * fVar7 + fVar4 * fVar5 + fVar2 * fVar3) goto LAB_0057904d;
              iVar13 = *param_1;
            }
          }
          iVar10 = FUN_00578450(iVar12,iVar13,uVar8);
          if (iVar10 != 0) {
            piVar1 = (int *)(param_1_00 + 0x138c + *(int *)(param_1_00 + 0x6c14) * 0x2c44);
            piVar1[*(int *)(param_1_00 + 0x138c + *(int *)(param_1_00 + 0x6c14) * 0x2c44) + 1] =
                 iVar10;
            *piVar1 = *piVar1 + 1;
          }
          iVar11 = iVar11 + 1;
        } while (iVar11 < iVar9);
      }
    }
    param_1 = param_1 + 1;
  } while( true );
}


