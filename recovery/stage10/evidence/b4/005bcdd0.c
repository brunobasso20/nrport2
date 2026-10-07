/* NR2003.exe @ 005bcdd0 FUN_005bcdd0 */

void FUN_005bcdd0(void)

{
  int iVar1;
  undefined4 *puVar2;
  
  puVar2 = &DAT_00edf228;
  for (iVar1 = 0x5dc; iVar1 != 0; iVar1 = iVar1 + -1) {
    *puVar2 = 0;
    puVar2 = puVar2 + 1;
  }
  puVar2 = &DAT_00ee0998;
  for (iVar1 = 400; iVar1 != 0; iVar1 = iVar1 + -1) {
    *puVar2 = 0;
    puVar2 = puVar2 + 1;
  }
  DAT_00edb530 = 1;
  iVar1 = 0;
  do {
    (&DAT_00ebfc80)[iVar1] = iVar1 + 0x5dc;
    iVar1 = iVar1 + 1;
  } while (iVar1 < 400);
  DAT_00ebfc7c = 0;
  DAT_00ec3fbc = 0x76c;
  DAT_00ec3fb8 = 0xdac;
  DAT_00ec02c4 = &DAT_00ebf610;
  return;
}

