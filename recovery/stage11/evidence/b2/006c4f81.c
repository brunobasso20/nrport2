/* NR2003.exe @ 006c4f81 FUN_006c4f81 */

void __fastcall FUN_006c4f81(int param_1,ushort param_2)

{
  ushort *puVar1;
  code *pcVar2;
  byte in_CF;
  
  puVar1 = (ushort *)(param_1 + 0x51);
  *puVar1 = *puVar1 + (ushort)in_CF * ((param_2 & 3) - (*puVar1 & 3));
  pcVar2 = (code *)swi(3);
  (*pcVar2)();
  return;
}

