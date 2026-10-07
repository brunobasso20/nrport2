/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00419d70 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_00419d70(int param_1)

{
  undefined4 *puVar1;
  bool bVar2;
  char cVar3;
  int iVar4;
  int iVar5;
  float10 fVar6;
  
  if ((*(int *)(param_1 + 0x29) == 0) && (*(int *)(param_1 + 0x2d) == -0x40100000)) {
    *(ushort *)(param_1 + 0xc9) = *(ushort *)(param_1 + 0xc9) & 0xfef3 | 0x200;
    iVar4 = FUN_00538ab0();
    if (*(char *)(iVar4 + 0x10327) == '\0') {
      fVar6 = (float10)(*(code *)**(undefined4 **)(param_1 + 0x25))();
      fVar6 = fVar6 + (float10)_DAT_006ed058;
    }
    else {
      fVar6 = (float10)(*(code *)**(undefined4 **)(param_1 + 0x25))();
      fVar6 = fVar6 + (float10)_DAT_006ea440;
    }
    *(double *)(param_1 + 0x29) = (double)fVar6;
  }
  bVar2 = true;
  iVar4 = 0;
  do {
    iVar5 = FUN_004f5970(iVar4);
    if ((*(char *)(iVar5 + 0x59a) != '\0') && (*(char *)(iVar4 + 300 + param_1) == '\0')) {
      iVar5 = iVar4;
      FUN_00538ab0(iVar4);
      iVar5 = FUN_0053a590(iVar5);
      if ((-1 < iVar5) &&
         ((cVar3 = FUN_0056e2b0(), cVar3 == '\0' || (iVar4 != *(int *)(param_1 + 0x43db))))) {
        bVar2 = false;
      }
    }
    iVar4 = iVar4 + 1;
  } while (iVar4 < 0x30);
  if (((bVar2) &&
      (((puVar1 = (undefined4 *)(param_1 + 0x25), *(int *)(param_1 + 0x29) != 0 ||
        (*(int *)(param_1 + 0x2d) != -0x40100000)) &&
       (fVar6 = (float10)(**(code **)*puVar1)(), fVar6 <= (float10)*(double *)(param_1 + 0x29)))))
     && (fVar6 = (float10)(**(code **)*puVar1)(),
        (float10)_DAT_006e9830 < (float10)*(double *)(param_1 + 0x29) - fVar6)) {
    fVar6 = (float10)(**(code **)*puVar1)();
    *(double *)(param_1 + 0x29) = (double)(fVar6 + (float10)_DAT_006e9830);
  }
  if ((*(int *)(param_1 + 0x29) != 0) || (*(int *)(param_1 + 0x2d) != -0x40100000)) {
    fVar6 = (float10)(*(code *)**(undefined4 **)(param_1 + 0x25))();
    if ((fVar6 <= (float10)*(double *)(param_1 + 0x29)) &&
       (fVar6 = (float10)(*(code *)**(undefined4 **)(param_1 + 0x25))(),
       (float10)*(double *)(param_1 + 0x29) - fVar6 != (float10)_DAT_006ea4b0)) {
      return;
    }
    FUN_00509bd0(2);
  }
  return;
}


