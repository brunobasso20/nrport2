/* Ghidra pseudo-C; NR2003.exe @ 005b2cd0 */

void FUN_005b2cd0(int param_1)

{
  uint uVar1;
  undefined4 *puVar2;
  
  if (((*(uint *)(param_1 + 0x40) & 1) != 0) || (((int)*(uint *)(param_1 + 0x40) >> 7 & 7U) == 1)) {
    *DAT_00e847c8 = **(undefined4 **)(param_1 + 0x2cd);
    DAT_00e847c8 = DAT_00e847c8 + 1;
    *DAT_00e847c8 = **(undefined4 **)(param_1 + 0x385);
    DAT_00e847c8 = DAT_00e847c8 + 1;
  }
  if (((*(uint *)(param_1 + 0x40) & 2) != 0) || (((int)*(uint *)(param_1 + 0x40) >> 7 & 7U) == 2)) {
    *DAT_00e847c8 = **(undefined4 **)(param_1 + 0x2d1);
    DAT_00e847c8 = DAT_00e847c8 + 1;
    *DAT_00e847c8 = **(undefined4 **)(param_1 + 0x389);
    DAT_00e847c8 = DAT_00e847c8 + 1;
  }
  if (((*(uint *)(param_1 + 0x40) & 4) != 0) || (((int)*(uint *)(param_1 + 0x40) >> 7 & 7U) == 3)) {
    *DAT_00e847c8 = **(undefined4 **)(param_1 + 0x2d5);
    DAT_00e847c8 = DAT_00e847c8 + 1;
    *DAT_00e847c8 = **(undefined4 **)(param_1 + 0x38d);
    DAT_00e847c8 = DAT_00e847c8 + 1;
  }
  uVar1 = *(uint *)(param_1 + 0x40);
  if ((int)(((int)uVar1 >> 7 & 7U) - 1) < 3) {
    if ((uVar1 & 0x18) == 0) {
      if ((uVar1 & 0x20) == 0) goto LAB_005b2edd;
      *DAT_00e847c8 = **(undefined4 **)(param_1 + 0x35d);
      DAT_00e847c8 = DAT_00e847c8 + 1;
      *DAT_00e847c8 = **(undefined4 **)(param_1 + 0x361);
      DAT_00e847c8 = DAT_00e847c8 + 1;
      *DAT_00e847c8 = **(undefined4 **)(param_1 + 0x365);
      DAT_00e847c8 = DAT_00e847c8 + 1;
      *DAT_00e847c8 = **(undefined4 **)(param_1 + 0x369);
      DAT_00e847c8 = DAT_00e847c8 + 1;
      *DAT_00e847c8 = **(undefined4 **)(param_1 + 0x391);
      DAT_00e847c8 = DAT_00e847c8 + 1;
      *DAT_00e847c8 = **(undefined4 **)(param_1 + 0x395);
      DAT_00e847c8 = DAT_00e847c8 + 1;
      puVar2 = *(undefined4 **)(param_1 + 0x399);
    }
    else {
      *DAT_00e847c8 = **(undefined4 **)(param_1 + 0x35d);
      DAT_00e847c8 = DAT_00e847c8 + 1;
      puVar2 = *(undefined4 **)(param_1 + 0x38d + (*(int *)(param_1 + 0x40) >> 3 & 3U) * 4);
    }
  }
  else {
    *DAT_00e847c8 = **(undefined4 **)(param_1 + 0x35d);
    DAT_00e847c8 = DAT_00e847c8 + 1;
    puVar2 = *(undefined4 **)(param_1 + 0x381 + (*(int *)(param_1 + 0x40) >> 7 & 7U) * 4);
  }
  *DAT_00e847c8 = *puVar2;
  DAT_00e847c8 = DAT_00e847c8 + 1;
LAB_005b2edd:
  FUN_005b2ef0(param_1,FUN_005b2cd0);
  return;
}

