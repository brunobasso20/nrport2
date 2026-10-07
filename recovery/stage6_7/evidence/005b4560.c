/* NR2003.exe @ 005b4560 FUN_005b4560 */

void FUN_005b4560(int param_1)

{
  uint uVar1;
  undefined4 *puVar2;
  
  if ((*(uint *)(param_1 + 0x40) & 1) == 0) {
    if (((int)*(uint *)(param_1 + 0x40) >> 7 & 7U) == 1) {
      **(undefined4 **)(param_1 + 0x1e5) = *DAT_00e847c8;
      *(undefined4 *)*DAT_00e84664 = **(undefined4 **)(param_1 + 0x1e5);
      DAT_00e84664 = DAT_00e84664 + 1;
      goto LAB_005b45bd;
    }
  }
  else {
    **(undefined4 **)(param_1 + 0x1e5) = *DAT_00e847c8;
LAB_005b45bd:
    DAT_00e847c8 = DAT_00e847c8 + 1;
    **(undefined4 **)(param_1 + 0x29d) = *DAT_00e847c8;
    DAT_00e847c8 = DAT_00e847c8 + 1;
  }
  if ((*(uint *)(param_1 + 0x40) & 2) == 0) {
    if (((int)*(uint *)(param_1 + 0x40) >> 7 & 7U) == 2) {
      **(undefined4 **)(param_1 + 0x1e9) = *DAT_00e847c8;
      *(undefined4 *)*DAT_00e84664 = **(undefined4 **)(param_1 + 0x1e9);
      DAT_00e84664 = DAT_00e84664 + 1;
      goto LAB_005b4639;
    }
  }
  else {
    **(undefined4 **)(param_1 + 0x1e9) = *DAT_00e847c8;
LAB_005b4639:
    DAT_00e847c8 = DAT_00e847c8 + 1;
    **(undefined4 **)(param_1 + 0x2a1) = *DAT_00e847c8;
    DAT_00e847c8 = DAT_00e847c8 + 1;
  }
  if ((*(uint *)(param_1 + 0x40) & 4) == 0) {
    if (((int)*(uint *)(param_1 + 0x40) >> 7 & 7U) == 3) {
      **(undefined4 **)(param_1 + 0x1ed) = *DAT_00e847c8;
      *(undefined4 *)*DAT_00e84664 = **(undefined4 **)(param_1 + 0x1ed);
      DAT_00e84664 = DAT_00e84664 + 1;
      goto LAB_005b46b4;
    }
  }
  else {
    **(undefined4 **)(param_1 + 0x1ed) = *DAT_00e847c8;
LAB_005b46b4:
    DAT_00e847c8 = DAT_00e847c8 + 1;
    **(undefined4 **)(param_1 + 0x2a5) = *DAT_00e847c8;
    DAT_00e847c8 = DAT_00e847c8 + 1;
  }
  uVar1 = *(uint *)(param_1 + 0x40);
  if ((int)(((int)uVar1 >> 7 & 7U) - 1) < 3) {
    if ((uVar1 & 0x18) == 0) {
      if ((uVar1 & 0x20) == 0) goto LAB_005b482d;
      **(undefined4 **)(param_1 + 0x275) = *DAT_00e847c8;
      DAT_00e847c8 = DAT_00e847c8 + 1;
      **(undefined4 **)(param_1 + 0x279) = *DAT_00e847c8;
      DAT_00e847c8 = DAT_00e847c8 + 1;
      **(undefined4 **)(param_1 + 0x27d) = *DAT_00e847c8;
      DAT_00e847c8 = DAT_00e847c8 + 1;
      **(undefined4 **)(param_1 + 0x281) = *DAT_00e847c8;
      DAT_00e847c8 = DAT_00e847c8 + 1;
      **(undefined4 **)(param_1 + 0x2a9) = *DAT_00e847c8;
      DAT_00e847c8 = DAT_00e847c8 + 1;
      **(undefined4 **)(param_1 + 0x2ad) = *DAT_00e847c8;
      DAT_00e847c8 = DAT_00e847c8 + 1;
      puVar2 = *(undefined4 **)(param_1 + 0x2b1);
    }
    else {
      **(undefined4 **)(param_1 + 0x275) = *DAT_00e847c8;
      DAT_00e847c8 = DAT_00e847c8 + 1;
      puVar2 = *(undefined4 **)(param_1 + 0x2a5 + (*(int *)(param_1 + 0x40) >> 3 & 3U) * 4);
    }
  }
  else {
    **(undefined4 **)(param_1 + 0x275) = *DAT_00e847c8;
    *(undefined4 *)*DAT_00e84664 = **(undefined4 **)(param_1 + 0x275);
    DAT_00e84664 = DAT_00e84664 + 1;
    DAT_00e847c8 = DAT_00e847c8 + 1;
    puVar2 = *(undefined4 **)(param_1 + 0x299 + (*(int *)(param_1 + 0x40) >> 7 & 7U) * 4);
  }
  *puVar2 = *DAT_00e847c8;
  DAT_00e847c8 = DAT_00e847c8 + 1;
LAB_005b482d:
  FUN_005b2ef0(param_1,FUN_005b4560);
  return;
}

