/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b53e0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005b53e0(float *param_1,int *param_2)

{
  undefined1 *puVar1;
  int *piVar2;
  undefined1 uVar3;
  float *pfVar4;
  int *piVar5;
  
  piVar2 = param_2;
  *(undefined1 *)(param_1 + 0xd) = *(undefined1 *)((int)param_2 + 0x1a);
  *param_1 = (float)*param_2 * _DAT_006f7428;
  param_1[1] = (float)param_2[1] * _DAT_006f7428;
  param_1[2] = (float)param_2[2] * _DAT_006f7428;
  uVar3 = FUN_006c5018();
  puVar1 = (undefined1 *)((int)param_1 + 0x31);
  *(undefined1 *)(param_1 + 0xc) = uVar3;
  piVar5 = (int *)((int)param_2 + 0xe);
  pfVar4 = param_1 + 5;
  param_1 = (float *)0x3;
  param_2 = (int *)puVar1;
  do {
    pfVar4[-2] = (float)(((*piVar5 << 0x16) >> 0x16) + *piVar2) * _DAT_006f7428;
    pfVar4[-1] = (float)(((*piVar5 << 0xc) >> 0x16) + piVar2[1]) * _DAT_006f7428;
    *pfVar4 = (float)(((*piVar5 << 4) >> 0x18) + piVar2[2]) * _DAT_006f7428;
    uVar3 = FUN_006c5018();
    pfVar4 = pfVar4 + 3;
    piVar5 = piVar5 + 1;
    *(undefined1 *)param_2 = uVar3;
    param_2 = (int *)((int)param_2 + 1);
    param_1 = (float *)((int)param_1 + -1);
  } while (param_1 != (float *)0x0);
  return;
}


