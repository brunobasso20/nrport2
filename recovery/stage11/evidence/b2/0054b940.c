/* NR2003.exe @ 0054b940 FUN_0054b940 */

void __thiscall FUN_0054b940(int param_1_00,byte param_1,char param_2)

{
  byte bVar1;
  byte bVar2;
  
  bVar1 = '\x01' << (param_1 & 0x1f);
  bVar2 = *(byte *)(param_1_00 + 0xe) & ~bVar1;
  *(byte *)(param_1_00 + 0xe) = bVar2;
  if (param_2 != '\0') {
    *(byte *)(param_1_00 + 0xe) = bVar2 | bVar1;
  }
  return;
}

