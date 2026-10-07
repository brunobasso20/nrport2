/* NR2003.exe @ 005390e0 FUN_005390e0 */

void FUN_005390e0(void)

{
  int *piVar1;
  int iVar2;
  
  iVar2 = 0;
  do {
    piVar1 = (int *)FUN_00538b90(iVar2);
    (**(code **)(*piVar1 + 4))();
    iVar2 = iVar2 + 1;
  } while (iVar2 < 0x1a);
  iVar2 = 0;
  do {
    piVar1 = (int *)FUN_00538b70(iVar2);
    (**(code **)(*piVar1 + 4))();
    iVar2 = iVar2 + 1;
  } while (iVar2 < 2);
  iVar2 = 0;
  do {
    piVar1 = (int *)FUN_00538b80(iVar2);
    (**(code **)(*piVar1 + 4))();
    iVar2 = iVar2 + 1;
  } while (iVar2 < 2);
  piVar1 = (int *)FUN_00538b60();
  (**(code **)(*piVar1 + 4))();
  piVar1 = (int *)FUN_00538b20();
  (**(code **)(*piVar1 + 4))();
  piVar1 = (int *)FUN_00538b40();
  (**(code **)(*piVar1 + 4))();
  piVar1 = (int *)FUN_00538b50();
  (**(code **)(*piVar1 + 4))();
  piVar1 = (int *)FUN_00538b30();
  (**(code **)(*piVar1 + 4))();
  piVar1 = (int *)FUN_00538b10();
  (**(code **)(*piVar1 + 4))();
  piVar1 = (int *)FUN_00538b00();
                    /* WARNING: Could not recover jumptable at 0x0053917b. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (**(code **)(*piVar1 + 4))();
  return;
}

