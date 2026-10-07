/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00511aca */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00511aca(int param_1,int param_2)

{
  int iVar1;
  int iVar2;
  int iVar3;
  undefined4 uVar4;
  float fVar5;
  float fVar6;
  undefined4 *puVar7;
  int iVar8;
  int local_4;
  
  local_4 = 0;
  if (*(char *)(param_1 + 0x40) == '\0') {
    iVar8 = *(int *)(param_2 + 0x5c) + 1;
    *(int *)(param_2 + 0x5c) = iVar8;
    iVar1 = param_2 + iVar8 * 0x108;
    iVar3 = param_2 + 0x578 + *(int *)(param_2 + 0x58) * 0x24;
    iVar2 = param_2 + 0x68 + *(int *)(param_2 + 0x54) * 0x48;
    if (1 < iVar8) {
      local_4 = iVar1 + 0x6c8;
    }
    *(undefined4 *)(iVar1 + 2000) = 0;
    *(undefined4 *)(iVar1 + 0x7d4) = 0;
    FUN_005f65a0(param_1,(double)(*(float *)(iVar3 + 0x10) * _DAT_006ea454 + *(float *)(iVar3 + 0xc)
                                 + _DAT_006ecfc8),
                 (double)(*(float *)(iVar3 + 0xc) + *(float *)(iVar3 + 0x10) + _DAT_006ecfc8),
                 CONCAT31((int3)((uint)*(int *)(iVar3 + 8) >> 8),0 < *(int *)(iVar3 + 8)),
                 iVar1 + 0x828,iVar1 + 0x83c);
    FUN_005f65a0(param_1,(double)(*(float *)(iVar3 + 0x10) * _DAT_006ea454 + *(float *)(iVar3 + 0xc)
                                 ),(double)(*(float *)(iVar3 + 0xc) + *(float *)(iVar3 + 0x10)),
                 0 < *(int *)(iVar3 + 8),iVar1 + 0x864,iVar1 + 0x878);
    *(undefined4 *)(iVar1 + 0x88c) = 0;
    *(undefined4 *)(iVar1 + 0x850) = 0;
    uVar4 = *(undefined4 *)(iVar2 + 0x18);
    puVar7 = (undefined4 *)(iVar1 + 0x8b4);
    *(undefined4 *)(iVar1 + 0x890) = uVar4;
    *(undefined4 *)(iVar1 + 0x854) = uVar4;
    uVar4 = *(undefined4 *)(iVar2 + 0x1c);
    iVar8 = 5;
    *(undefined4 *)(iVar1 + 0x894) = uVar4;
    *(undefined4 *)(iVar1 + 0x858) = uVar4;
    uVar4 = *(undefined4 *)(iVar2 + 0x20);
    *(undefined4 *)(iVar1 + 0x898) = uVar4;
    *(undefined4 *)(iVar1 + 0x85c) = uVar4;
    uVar4 = *(undefined4 *)(iVar2 + 0x24);
    *(undefined4 *)(iVar1 + 0x89c) = uVar4;
    *(undefined4 *)(iVar1 + 0x860) = uVar4;
    *(float *)(iVar1 + 0x820) =
         *(float *)(iVar3 + 0x10) * _DAT_006ea454 + *(float *)(iVar3 + 0xc) + _DAT_006ea478;
    fVar5 = *(float *)(iVar3 + 0xc);
    fVar6 = *(float *)(iVar3 + 0x10);
    *(undefined4 *)(iVar1 + 0x8c8) = 0x41200000;
    *(undefined4 *)(iVar1 + 0x8cc) = 0;
    *(undefined4 *)(iVar1 + 0x8d0) = 0x49742400;
    *(undefined4 *)(iVar1 + 0x8d4) = 0;
    *(float *)(iVar1 + 0x824) = fVar5 + fVar6 + _DAT_006ea478;
    do {
      puVar7[-5] = 0;
      *puVar7 = 0;
      puVar7 = puVar7 + 1;
      iVar8 = iVar8 + -1;
    } while (iVar8 != 0);
  }
  else {
    if (*(int *)(param_2 + 0x5c) < 1) {
      return;
    }
    local_4 = param_2 + 2000 + *(int *)(param_2 + 0x5c) * 0x108;
  }
  if (local_4 != 0) {
    *(undefined4 *)(local_4 + 0x100) = 0x49742400;
    *(undefined4 *)(local_4 + 0x104) = 0;
  }
  return;
}


