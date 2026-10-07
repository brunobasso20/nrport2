/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0040c600 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0040c600(int param_1,undefined4 param_2,float param_3,undefined4 param_4,int param_5)

{
  undefined4 uVar1;
  int iVar2;
  int iVar3;
  uint uVar4;
  float10 fVar5;
  double dVar6;
  
  iVar2 = param_5;
  iVar3 = (int)param_3;
  uVar1 = *(undefined4 *)(param_1 + 8);
  *(float *)(param_1 + 0x31) = param_3;
  *(undefined4 *)(param_1 + 0x2d) = param_4;
  *(int *)(param_1 + 0x35) = param_5;
  *(undefined4 *)(param_1 + 0xc) = param_2;
  *(undefined4 *)(param_1 + 0x14) = 0;
  *(undefined1 *)(param_1 + 0x28) = 0;
  param_3 = 0.0;
  fVar5 = (float10)FUN_0040c590(uVar1,param_5,&param_3);
  *(float *)(param_1 + 0x10) = (float)fVar5;
  if ((*(char *)(iVar2 + 0x8d) == '\0') || (param_3 <= _DAT_006ea62c))
  goto switchD_0040c68d_caseD_c;
  switch(uVar1) {
  case 0xb:
  case 0xe:
    if (param_3 <= _DAT_006e9804) {
      dVar6 = rndUniform(0);
      if (dVar6 < _DAT_006ea668) goto switchD_0040c68d_caseD_d;
LAB_0040c6d4:
      uVar4 = 2;
    }
    else {
      dVar6 = rndUniform(0);
      if ((double)_DAT_006ea674 <= dVar6) {
        if (dVar6 < (double)_DAT_006ea670) goto LAB_0040c6d4;
        uVar4 = 4;
      }
      else {
        uVar4 = 1;
      }
    }
    break;
  default:
    goto switchD_0040c68d_caseD_c;
  case 0xd:
switchD_0040c68d_caseD_d:
    uVar4 = 1;
    break;
  case 0xf:
  case 0x10:
  case 0x12:
    uVar4 = 0x40;
    break;
  case 0x39:
  case 0x3e:
    uVar4 = 0x10;
  }
  DAT_00898f44 = DAT_00898f44 | uVar4;
switchD_0040c68d_caseD_c:
  iVar2 = *(int *)(*(int *)(param_1 + 0x39) + 0xc2);
  if (iVar2 != 0) {
    uVar4 = (uint)*(byte *)(iVar3 + 8);
    *(uint *)(param_1 + 0x29) = uVar4;
    *(float *)(param_1 + 0x18) =
         (*(float *)(iVar2 + 500 + uVar4 * 8) - *(float *)(iVar2 + 0x1f0 + uVar4 * 8)) /
         (float)fVar5;
    uVar1 = *(undefined4 *)(iVar2 + 0x1f0 + uVar4 * 8);
    *(undefined4 *)(param_1 + 0x1c) = uVar1;
    *(undefined4 *)(*(int *)(param_1 + 0x39) + 0xd) = uVar1;
  }
  return;
}


