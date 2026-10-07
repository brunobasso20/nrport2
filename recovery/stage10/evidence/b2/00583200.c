/* NR2003.exe @ 00583200 FUN_00583200 */

void FUN_00583200(void)

{
  undefined4 *puVar1;
  int iVar2;
  
  (**(code **)(*DAT_00c72160 + 100))();
  iVar2 = 0xff;
  DAT_00d6a5e4 = 0;
  DAT_00d6a5e0 = 0;
  DAT_00d6a5dc = 0;
  DAT_00d6a5d8 = (undefined4 *)0x0;
  puVar1 = &DAT_00d6a690;
  do {
    puVar1[-0x20] = 0xffffffff;
    *puVar1 = DAT_00d6a5d8;
    DAT_00d6a5d8 = puVar1 + -0x2a;
    puVar1 = puVar1 + 0x2f;
    iVar2 = iVar2 + -1;
  } while (iVar2 != 0);
  return;
}

