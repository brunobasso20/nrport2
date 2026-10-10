/* NR2003.exe @ 0057bdb0 FUN_0057bdb0 */

void FUN_0057bdb0(void)

{
  undefined4 *puVar1;
  
  puVar1 = &DAT_00d35b18;
  do {
    *(undefined *)(puVar1 + 1) = 0;
    *puVar1 = 0;
    puVar1 = (undefined4 *)((int)puVar1 + 10);
  } while ((int)puVar1 < 0xd3637e);
  return;
}

