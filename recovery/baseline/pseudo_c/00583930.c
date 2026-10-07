/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00583930 */

void FUN_00583930(int param_1)

{
  int iVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  int iVar5;
  int iVar6;
  int iVar7;
  undefined4 *puVar8;
  float local_c [3];
  
  *(undefined4 *)(param_1 + 0xb0) = 0;
  local_c[0] = 625.0;
  *(undefined4 *)(param_1 + 0xb4) = 0;
  local_c[1] = 625.0;
  *(undefined4 *)(param_1 + 0xb8) = 0;
  local_c[2] = 625.0;
  iVar1 = DAT_00d6a5e0;
  do {
    if (iVar1 == 0) {
      return;
    }
    if ((iVar1 != param_1) && (*(int *)(iVar1 + 0x28) == *(int *)(param_1 + 0x28))) {
      fVar2 = *(float *)(iVar1 + 0x2c) - *(float *)(param_1 + 0x2c);
      fVar3 = *(float *)(iVar1 + 0x30) - *(float *)(param_1 + 0x30);
      fVar4 = *(float *)(iVar1 + 0x34) - *(float *)(param_1 + 0x34);
      iVar7 = 0;
      fVar2 = fVar3 * fVar3 + fVar2 * fVar2 + fVar4 * fVar4;
      do {
        if (fVar2 < local_c[iVar7]) {
          if (iVar7 < 3) {
            if (iVar7 < 2) {
              puVar8 = (undefined4 *)(param_1 + 0xb8);
              iVar5 = 2;
              do {
                iVar6 = iVar5 + -1;
                *puVar8 = puVar8[-1];
                local_c[iVar5] = local_c[iVar6];
                puVar8 = puVar8 + -1;
                iVar5 = iVar6;
              } while (iVar7 < iVar6);
            }
            local_c[iVar7] = fVar2;
            *(int *)(param_1 + 0xb0 + iVar7 * 4) = iVar1;
          }
          break;
        }
        iVar7 = iVar7 + 1;
      } while (iVar7 < 3);
    }
    if (iVar1 == 0) {
      return;
    }
    iVar1 = *(int *)(iVar1 + 0xa8);
  } while( true );
}


