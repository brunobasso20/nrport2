/* NR2003.exe @ 00539390 FUN_00539390 */

void FUN_00539390(void)

{
  double dVar1;
  char cVar2;
  int iVar3;
  int *piVar4;
  float10 fVar5;
  
  fVar5 = (float10)thunk_FUN_0055a760();
  dVar1 = (double)fVar5;
  iVar3 = FUN_00538b90();
  if (*(double *)(iVar3 + 0xc) < dVar1 != (NAN(*(double *)(iVar3 + 0xc)) || NAN(dVar1))) {
    iVar3 = 0;
    do {
      piVar4 = (int *)FUN_00538b90();
      (**(code **)(*piVar4 + 0x20))();
      iVar3 = iVar3 + 1;
    } while (iVar3 < 0x1a);
  }
  iVar3 = FUN_00538b70();
  if (*(double *)(iVar3 + 0xc) < dVar1 != (NAN(*(double *)(iVar3 + 0xc)) || NAN(dVar1))) {
    iVar3 = 0;
    do {
      piVar4 = (int *)FUN_00538b70();
      (**(code **)(*piVar4 + 0x20))();
      iVar3 = iVar3 + 1;
    } while (iVar3 < 2);
  }
  iVar3 = FUN_00538b80();
  if (*(double *)(iVar3 + 0xc) < dVar1 != (NAN(*(double *)(iVar3 + 0xc)) || NAN(dVar1))) {
    iVar3 = 0;
    do {
      piVar4 = (int *)FUN_00538b80();
      (**(code **)(*piVar4 + 0x20))();
      iVar3 = iVar3 + 1;
    } while (iVar3 < 2);
  }
  iVar3 = FUN_00538b60();
  if (*(double *)(iVar3 + 0xc) < dVar1 != (NAN(*(double *)(iVar3 + 0xc)) || NAN(dVar1))) {
    piVar4 = (int *)FUN_00538b60();
    (**(code **)(*piVar4 + 0x20))();
  }
  iVar3 = FUN_00538b50();
  if (*(double *)(iVar3 + 0xc) < dVar1 != (NAN(*(double *)(iVar3 + 0xc)) || NAN(dVar1))) {
    piVar4 = (int *)FUN_00538b50();
    (**(code **)(*piVar4 + 0x20))();
  }
  iVar3 = FUN_00538b20();
  if (*(double *)(iVar3 + 0xc) < dVar1 != (NAN(*(double *)(iVar3 + 0xc)) || NAN(dVar1))) {
    piVar4 = (int *)FUN_00538b20();
    (**(code **)(*piVar4 + 0x20))();
  }
  iVar3 = FUN_00538b40();
  if (*(double *)(iVar3 + 0xc) < dVar1 != (NAN(*(double *)(iVar3 + 0xc)) || NAN(dVar1))) {
    piVar4 = (int *)FUN_00538b40();
    (**(code **)(*piVar4 + 0x20))();
  }
  iVar3 = FUN_00538b30();
  if (*(double *)(iVar3 + 0xc) < dVar1 != (NAN(*(double *)(iVar3 + 0xc)) || NAN(dVar1))) {
    piVar4 = (int *)FUN_00538b30();
    (**(code **)(*piVar4 + 0x20))();
  }
  iVar3 = FUN_00538b10();
  if (*(double *)(iVar3 + 0xc) < dVar1 != (NAN(*(double *)(iVar3 + 0xc)) || NAN(dVar1))) {
    piVar4 = (int *)FUN_00538b10();
    (**(code **)(*piVar4 + 0x20))();
  }
  iVar3 = FUN_00538b00();
  if (*(double *)(iVar3 + 0xc) < dVar1 != (NAN(*(double *)(iVar3 + 0xc)) || NAN(dVar1))) {
    piVar4 = (int *)FUN_00538b00();
    (**(code **)(*piVar4 + 0x20))();
  }
  iVar3 = FUN_00538b20();
  if (*(double *)(iVar3 + 0x1c) < dVar1 != (NAN(*(double *)(iVar3 + 0x1c)) || NAN(dVar1))) {
    piVar4 = (int *)FUN_00538b20();
    (**(code **)(*piVar4 + 0x24))();
  }
  cVar2 = FUN_0056e2b0();
  if (cVar2 == '\0') {
    fVar5 = (float10)thunk_FUN_0055a760();
    FUN_00524950((double)fVar5);
  }
  return;
}

