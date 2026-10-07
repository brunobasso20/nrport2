/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0052d340 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_0052d340(int param_1)

{
  float fVar1;
  float fVar2;
  int iVar3;
  int *piVar4;
  float10 fVar5;
  undefined1 *puVar6;
  undefined1 local_c [4];
  uint local_8;
  undefined4 local_4;
  
  *(int *)(param_1 + 0x1a7a) = *(int *)(param_1 + 0x1a7a) + 1;
  *(int *)(param_1 + 0x1a7e) = *(int *)(param_1 + 0x1a7e) + 1;
  *(int *)(param_1 + 0x1a82) = *(int *)(param_1 + 0x1a82) + 1;
  iVar3 = FUN_005099b0();
  if (iVar3 == 7) {
    iVar3 = FUN_00509a00();
    fVar1 = (float)iVar3;
    piVar4 = (int *)FUN_00538ab0();
    puVar6 = local_c;
    (**(code **)(*piVar4 + 0x30))(puVar6);
    iVar3 = FUN_005443e0(puVar6);
    fVar2 = fVar1 - (float)iVar3;
    iVar3 = FUN_00544bf0();
    local_8 = *(uint *)(iVar3 + 0x60);
    local_4 = 0;
    if ((float)local_8 * _DAT_006ea4a4 < _DAT_006e9824) {
      fVar1 = (_DAT_006e9824 / ((float)local_8 * _DAT_006ea4a4)) * fVar1;
    }
    FUN_004f71b0(_DAT_006e97d8 - fVar2 / fVar1);
  }
  local_8 = 0;
  local_4 = 0x40000000;
  FUN_00516e1a();
  fVar5 = (float10)FUN_006c5c40();
  *(float *)(param_1 + 0x1a86) =
       (float)(((float10)_DAT_006e97d8 - (float10)*(float *)(param_1 + 0x1a86)) *
               ((float10)_DAT_006e97d8 - fVar5) + (float10)*(float *)(param_1 + 0x1a86));
  (**(code **)(**(int **)(param_1 + 0x13a3) + 8))(param_1);
  return;
}


