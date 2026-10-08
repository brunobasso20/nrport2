/* NR2003.exe @ 006c5bf8 FUN_006c5bf8 */

int __fastcall FUN_006c5bf8(int param_1)

{
  int in_EAX;
  int unaff_EBX;
  char in_CF;
  
  *(char *)(unaff_EBX + -0x66) = *(char *)(unaff_EBX + -0x66) + (char)unaff_EBX + in_CF;
  if (param_1 == 1) {
    return in_EAX;
  }
  return in_EAX + 1;
}

