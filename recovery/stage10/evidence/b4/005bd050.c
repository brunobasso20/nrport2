/* NR2003.exe @ 005bd050 FUN_005bd050 */

uint * FUN_005bd050(int param_1)

{
  uint *puVar1;
  int iVar2;
  
  puVar1 = (uint *)FUN_005bd0d0();
  *puVar1 = *puVar1 & 0xfffffffe;
  iVar2 = FUN_005bd0c0(param_1);
  if (iVar2 == 0) {
    iVar2 = FUN_005bd0f0(param_1);
    *puVar1 = *puVar1 & 3 ^ iVar2 << 2;
  }
  else {
    *puVar1 = *puVar1 & 3 ^ param_1 * 4;
  }
  puVar1[1] = 0;
  puVar1[2] = 0;
  *puVar1 = *puVar1 & 0xfffffffd;
  puVar1[3] = 0;
  puVar1[4] = 0;
  (&DAT_00ed7840)[param_1] = puVar1;
  return puVar1;
}

