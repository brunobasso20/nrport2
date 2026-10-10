/* NR2003.exe @ 005d0070 FUN_005d0070 */

uint FUN_005d0070(int param_1,uint *param_2)

{
  uint uVar1;
  
  uVar1 = (&DAT_00f5cd90)[param_1];
  if ((uVar1 & 2) != 0) {
    if (param_2 != (uint *)0x0) {
      *param_2 = uVar1 & 0x1ff0000;
    }
    (&DAT_00f5cd90)[param_1] = uVar1 & 0xfffffffd;
    return CONCAT31((int3)((uVar1 & 0xfffffffd) >> 8),1);
  }
  return uVar1 & 0xffffff00;
}

