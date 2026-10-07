/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004790f0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_004790f0(int param_1_00,int param_1,int param_2)

{
  char cVar1;
  int *piVar2;
  bool bVar3;
  float fVar4;
  undefined4 uVar5;
  int iVar6;
  undefined *puVar7;
  undefined *puVar8;
  undefined1 local_40 [64];
  
  cVar1 = *(char *)(param_1 + 0x60);
  fVar4 = _DAT_006e97d8;
  if (cVar1 == '\0') {
    fVar4 = *(float *)(param_2 + 8);
  }
  if (fVar4 != *(float *)(param_1_00 + 0x128)) {
    bVar3 = fVar4 < _DAT_006ea454;
    *(float *)(param_1_00 + 0x128) = fVar4;
    puVar7 = &DAT_008b99c6;
    if (bVar3) {
      puVar7 = &DAT_007379ae;
      fVar4 = -fVar4;
    }
    puVar8 = &DAT_008b99c7;
    if ((_DAT_006ea454 < fVar4) && (fVar4 < _DAT_006f0694)) {
      puVar8 = &DAT_007379b0;
    }
    uVar5 = FUN_006c5018();
    FUN_006c5990(local_40,u__S_S_dx_007379b4,puVar7,puVar8,uVar5);
    piVar2 = (int *)**(int **)(*(int *)(param_1_00 + 0x1c7) + 0x1ae);
    if (piVar2 != (int *)0x0) {
      (**(code **)(*piVar2 + 0x68))(local_40);
    }
  }
  if (cVar1 == '\0') {
    iVar6 = FUN_006c5018();
    if (iVar6 < 0) {
      iVar6 = 0;
      goto LAB_004791d9;
    }
    if (iVar6 < 0x65) goto LAB_004791d9;
  }
  iVar6 = 100;
LAB_004791d9:
  if (iVar6 != *(int *)(param_1_00 + 300)) {
    *(int *)(param_1_00 + 300) = iVar6;
    (**(code **)(**(int **)(param_1_00 + 0x197) + 0x74))(iVar6);
  }
  return;
}


