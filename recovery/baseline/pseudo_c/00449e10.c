/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00449e10 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall
FUN_00449e10(int *param_1_00,int param_1,int param_2,undefined8 param_3,undefined8 param_4,
            int param_5,double param_7)

{
  int iVar1;
  int iVar2;
  int *piVar3;
  
  iVar1 = param_1_00[200];
  iVar2 = 0;
  piVar3 = param_1_00;
  if (0 < iVar1) {
    do {
      if (*piVar3 == param_2) break;
      iVar2 = iVar2 + 1;
      piVar3 = (int *)((int)piVar3 + 0x32);
    } while (iVar2 < iVar1);
  }
  if (iVar2 == iVar1) {
    if (iVar1 < 0x10) {
      param_7 = param_7 + _DAT_006e9830;
      *(int *)((int)param_1_00 + iVar1 * 0x32) = param_2;
      *(int *)((int)param_1_00 + param_1_00[200] * 0x32 + 0x2c) = param_1 + param_5 * 8;
      piVar3 = *(int **)((int)param_1_00 + param_1_00[200] * 0x32 + 0x2c);
      *(undefined4 *)((int)param_1_00 + param_1_00[200] * 0x32 + 0x1c) = 1;
      iVar1 = param_1_00[200];
      piVar3[1] = 0;
      *piVar3 = param_5;
      *(double *)((int)param_1_00 + iVar1 * 0x32 + 0x14) = param_7;
      *(undefined8 *)((int)param_1_00 + param_1_00[200] * 0x32 + 4) = param_3;
      *(undefined8 *)((int)param_1_00 + param_1_00[200] * 0x32 + 0xc) = param_4;
      *(undefined1 *)((int)param_1_00 + param_1_00[200] * 0x32 + 0x30) = 0;
      *(undefined1 *)((int)param_1_00 + param_1_00[200] * 0x32 + 0x31) = 0;
      param_1_00[200] = param_1_00[200] + 1;
      return;
    }
  }
  else {
    *(int *)((int)param_1_00 + iVar2 * 0x32 + 0x1c) =
         *(int *)((int)param_1_00 + iVar2 * 0x32 + 0x1c) + 1;
    iVar1 = *(int *)((int)param_1_00 + param_1_00[200] * 0x32 + 0x2c);
    *(int *)((int)param_1_00 + param_1_00[200] * 0x32 + 0x2c) = param_1 + param_5 * 8;
    piVar3 = *(int **)((int)param_1_00 + param_1_00[200] * 0x32 + 0x2c);
    piVar3[1] = iVar1;
    *piVar3 = param_5;
  }
  return;
}


