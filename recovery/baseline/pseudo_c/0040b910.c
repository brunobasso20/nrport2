/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0040b910 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_0040b910(int param_1_00,int param_1)

{
  char cVar1;
  int iVar2;
  int iVar3;
  double local_10;
  
  FUN_00415210();
  iVar2 = FUN_00417fc0();
  if (iVar2 == 6) {
    *(undefined1 *)(param_1_00 + 8) = 1;
  }
  local_10 = (double)*(float *)(*(int *)(param_1 + 0x58a) + 0x24);
  FUN_0040bde0(&local_10);
  *(undefined4 *)(param_1 + 0x548) = 0xbff00000;
  *(undefined4 *)(param_1 + 0x544) = 0;
  switch(*(undefined4 *)(*(int *)(param_1 + 0x13a7) + 8)) {
  case 1:
    if (ABS(*(float *)(param_1 + 0x1886)) <= _DAT_006ea624) {
      if (_DAT_006ea620 < (float)*(int *)(param_1 + 0x1b16)) {
        FUN_0052a1b0(&DAT_00bcf7b4);
        return;
      }
      cVar1 = FUN_0052e0f0();
      if (cVar1 == '\0') {
        return;
      }
      FUN_0052a1b0(*(undefined4 *)(param_1 + 0x13ab));
      return;
    }
  case 2:
switchD_0040b98b_caseD_2:
    FUN_0052a1b0(&DAT_00760e30);
    break;
  case 0x1c:
    *(undefined1 *)(param_1_00 + 8) = 0;
    iVar3 = FUN_00509b60(0xffffffff);
    if ((iVar3 < 5) && ((((iVar2 == 1 || (iVar2 == 0)) || (iVar2 == 4)) || (iVar2 == 5)))) {
      FUN_0052a1b0(&DAT_00760da0);
      return;
    }
    break;
  case 0x1d:
    iVar2 = FUN_00509b60(0xffffffff);
    if (iVar2 < 5) {
      if (*(int *)(param_1 + 0x1b0a) != 0) {
        return;
      }
      FUN_0052a1b0(&DAT_00760f14);
      return;
    }
    goto switchD_0040b98b_caseD_2;
  case 0x1e:
    if (*(int *)(param_1 + 0x1b0a) == 0) {
      FUN_0052a1b0(&DAT_00760d48);
      return;
    }
    break;
  case 0x1f:
    if ((iVar2 == 5) || (iVar2 == 7)) {
      FUN_0052a1b0(&DAT_00760e5c);
      return;
    }
    break;
  case 0x20:
    if (iVar2 == 4) {
      _DAT_00760d54 = 0;
      FUN_0052a1b0(&DAT_00760d48);
LAB_0040ba71:
      iVar2 = FUN_00509b60(0xffffffff);
      if (iVar2 < 5) {
        return;
      }
    }
    else if ((iVar2 != 6) && (iVar2 != 7)) goto LAB_0040ba71;
    cVar1 = FUN_0052f2c0(*(undefined4 *)(param_1 + 0x186a),DAT_0074b068,
                         *(undefined4 *)(*(int *)(param_1 + 0x21e8) + 0x24));
    if (cVar1 != '\0') {
      FUN_0052a1b0(&DAT_00760e3c);
      return;
    }
    break;
  case 0x21:
    if ((*(int *)(*(int *)(param_1 + 0x13b3) + 8) == 1) && (cVar1 = FUN_0052c0e0(), cVar1 != '\0'))
    {
      FUN_0052a1b0(&DAT_00760e30);
    }
    iVar3 = FUN_00509b60(0xffffffff);
    if ((iVar3 < 5) &&
       ((((iVar2 == 1 || (iVar2 == 0)) || (iVar2 == 4)) ||
        ((iVar2 == 5 && (*(char *)(param_1_00 + 8) != '\0')))))) {
      _DAT_00760f20 = 0;
      FUN_0052a1b0(&DAT_00760f14);
      return;
    }
    break;
  case 0x22:
    iVar2 = FUN_00509b60(0xffffffff);
    if (iVar2 == 3) {
      FUN_0052a1b0(&DAT_00760dd8);
      return;
    }
    break;
  case 0x23:
    *(undefined1 *)(param_1_00 + 8) = 0;
    if ((*(int *)(param_1 + 0x1b0a) == 0) &&
       (cVar1 = FUN_0052f2c0(*(undefined4 *)(param_1 + 0x186a),
                             *(undefined4 *)(*(int *)(param_1 + 0x21e8) + 0x24),DAT_0074b050),
       cVar1 == '\0')) {
      FUN_0052a1b0(&DAT_00760e5c);
    }
    if ((*(undefined4 **)(param_1 + 0x13b3) == &DAT_00bd78ec) &&
       (cVar1 = FUN_0052f2c0(*(undefined4 *)(param_1 + 0x186a),DAT_0074b068,
                             *(undefined4 *)(*(int *)(param_1 + 0x21e8) + 0x24)), cVar1 != '\0')) {
      FUN_0052a1b0(&DAT_00760e3c);
      return;
    }
  }
  return;
}


