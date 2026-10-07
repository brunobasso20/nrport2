/* NR2003.exe @ 004ef940 FUN_004ef940 */

int FUN_004ef940(undefined4 param_1,undefined param_2,int param_3,int param_4)

{
  int iVar1;
  int iVar2;
  
  iVar2 = DAT_00a6c1f8;
  if (0xff < DAT_00a6c1f8) {
    return -1;
  }
  *(undefined4 *)(&DAT_00a68880 + DAT_00a6c1f8 * 0x35) = param_1;
  if ((param_3 == 0xc) && (param_4 == 2)) {
    if (DAT_00a6c258 < 2) {
      iVar1 = FUN_005cfeb2();
      iVar2 = DAT_00a6c1f8;
      if (iVar1 == 3) {
        param_3 = 0x12;
        param_4 = 3;
      }
    }
    else {
      param_3 = DAT_00a6c258 * 6;
      param_4 = DAT_00a6c258;
    }
  }
  iVar1 = iVar2 * 0x35;
  DAT_00a6c1f8 = iVar2 + 1;
  *(int *)(&DAT_00a68888 + iVar1) = param_3;
  *(int *)(&DAT_00a6888c + iVar1) = param_4;
  (&DAT_00a688b4)[iVar1] = param_2;
  return iVar2;
}

