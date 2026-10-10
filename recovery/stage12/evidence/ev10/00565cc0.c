/* NR2003.exe @ 00565cc0 FUN_00565cc0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00565cc0(int param_1,int param_2)

{
  undefined4 *puVar1;
  int iVar2;
  int iVar3;
  int iVar4;
  undefined4 uVar5;
  char local_d;
  float fStack_c;
  float fStack_8;
  undefined auStack_4 [4];
  
  iVar2 = param_2;
  iVar3 = FUN_005ba130();
  iVar4 = FUN_005b9e70();
  local_d = '\0';
  if (iVar4 != 0) {
    local_d = *(char *)(iVar4 + 0x25);
  }
  if (*(undefined4 **)(param_1 + 0x2e4) != (undefined4 *)0x0) {
    (**(code **)**(undefined4 **)(param_1 + 0x2e4))
              (*(undefined4 *)(param_1 + 0x22c),*(undefined4 *)(param_1 + 0x230),
               *(undefined4 *)(iVar3 + 0xd8));
  }
  if (*(undefined4 **)(param_1 + 0x2e8) != (undefined4 *)0x0) {
    (**(code **)**(undefined4 **)(param_1 + 0x2e8))
              (*(undefined4 *)(param_1 + 0x238),*(undefined4 *)(param_1 + 0x23c),
               *(undefined4 *)(iVar3 + 0xdc));
  }
  if (*(int **)(param_1 + 0x2e4) != (int *)0x0) {
    (**(code **)(**(int **)(param_1 + 0x2e4) + 8))
              (*(float *)(iVar3 + 0xbc) + _DAT_006f5e74,*(undefined4 *)(param_1 + 0x264),
               *(undefined4 *)(iVar3 + 0xe8));
  }
  if (*(int **)(param_1 + 0x2e8) != (int *)0x0) {
    (**(code **)(**(int **)(param_1 + 0x2e8) + 8))
              (*(float *)(iVar3 + 0xbc) + _DAT_006f5e74,*(undefined4 *)(param_1 + 0x270),
               *(undefined4 *)(iVar3 + 0xec));
  }
  if (*(undefined4 **)(param_1 + 0x2ec) != (undefined4 *)0x0) {
    (**(code **)**(undefined4 **)(param_1 + 0x2ec))
              (*(undefined4 *)(param_1 + 0x244),*(undefined4 *)(param_1 + 0x248),
               *(undefined4 *)(iVar3 + 0xe0));
  }
  if (*(undefined4 **)(param_1 + 0x2f0) != (undefined4 *)0x0) {
    (**(code **)**(undefined4 **)(param_1 + 0x2f0))
              (*(undefined4 *)(param_1 + 0x250),*(undefined4 *)(param_1 + 0x254),
               *(undefined4 *)(iVar3 + 0xe4));
  }
  if (*(int **)(param_1 + 0x2ec) != (int *)0x0) {
    (**(code **)(**(int **)(param_1 + 0x2ec) + 8))
              (*(float *)(param_1 + 0x274) + _DAT_006f5e74,*(undefined4 *)(param_1 + 0x27c),
               *(undefined4 *)(iVar3 + 0xf0));
  }
  if (*(int **)(param_1 + 0x2f0) != (int *)0x0) {
    (**(code **)(**(int **)(param_1 + 0x2f0) + 8))
              (*(float *)(param_1 + 0x280) + _DAT_006f5e74,*(undefined4 *)(param_1 + 0x288),
               *(undefined4 *)(iVar3 + 0xf4));
  }
  if (*(undefined4 **)(param_1 + 0x308) != (undefined4 *)0x0) {
    (**(code **)**(undefined4 **)(param_1 + 0x308))((float)*(int *)(param_2 + 0x2c));
  }
  if (*(undefined4 **)(param_1 + 0x310) != (undefined4 *)0x0) {
    (**(code **)**(undefined4 **)(param_1 + 0x310))(0);
  }
  if (*(undefined4 **)(param_1 + 0x314) != (undefined4 *)0x0) {
    (**(code **)**(undefined4 **)(param_1 + 0x314))(0x40000000);
  }
  if (*(undefined4 **)(param_1 + 0x318) != (undefined4 *)0x0) {
    (**(code **)**(undefined4 **)(param_1 + 0x318))(0x3f800000);
  }
  if (*(undefined4 **)(param_1 + 0x31c) != (undefined4 *)0x0) {
    (**(code **)**(undefined4 **)(param_1 + 0x31c))(0x3f800000);
  }
  puVar1 = *(undefined4 **)(param_1 + 800);
  if ((puVar1 != (undefined4 *)0x0) && (*(int *)(param_1 + 0x324) != 0)) {
    if (*(float *)(iVar3 + 0xf8) < _DAT_006ea4a4 ==
        (NAN(*(float *)(iVar3 + 0xf8)) || NAN(_DAT_006ea4a4))) {
      (**(code **)*puVar1)(0x3f800000);
      iVar4 = **(int **)(param_1 + 0x324);
      uVar5 = FUN_006c5018();
      (**(code **)(iVar4 + 4))(uVar5);
    }
    else {
      (**(code **)*puVar1)(0);
    }
  }
  if (*(undefined4 **)(param_1 + 0x328) != (undefined4 *)0x0) {
    (**(code **)**(undefined4 **)(param_1 + 0x328))(0);
  }
  FUN_00554fb0();
  FUN_005f74c0(auStack_4,&fStack_8,&fStack_c,iVar3 + 0x58);
  if (*(undefined4 **)(param_1 + 0x2f4) != (undefined4 *)0x0) {
    (**(code **)**(undefined4 **)(param_1 + 0x2f4))
              (*(undefined4 *)(iVar3 + 0xc0),*(undefined4 *)(iVar3 + 0xc4),
               *(undefined4 *)(iVar3 + 200));
  }
  if (*(int **)(param_1 + 0x2f4) != (int *)0x0) {
    (**(code **)(**(int **)(param_1 + 0x2f4) + 8))
              (0,*(float *)(iVar3 + 0xd0) - fStack_8,*(float *)(iVar3 + 0xd4) - fStack_c);
  }
  if (*(undefined4 **)(param_1 + 0x32c) != (undefined4 *)0x0) {
    (**(code **)**(undefined4 **)(param_1 + 0x32c))(0);
  }
  puVar1 = *(undefined4 **)(param_1 + 0x330);
  if (puVar1 != (undefined4 *)0x0) {
    if (((*(byte *)(param_2 + 0x30) & 0x10) == 0) && (local_d == '\0')) {
      (**(code **)*puVar1)(0x3f800000);
    }
    else {
      (**(code **)*puVar1)(0);
    }
  }
  if (((*(byte *)(param_2 + 0x30) & 1) == 0) &&
     (puVar1 = *(undefined4 **)(param_1 + 0x334), puVar1 != (undefined4 *)0x0)) {
    param_2 = FUN_006c5018();
    param_2 = param_2 * 10;
    if (param_2 < 0) {
      param_2 = 0;
    }
    (**(code **)*puVar1)((float)param_2);
  }
  FUN_00566050(param_1,iVar2);
  FUN_0042b410(param_1,iVar2);
  FUN_0042bad0(param_1,iVar2);
  return;
}

