/* NR2003.exe @ 006c5990 FUN_006c5990 */

void FUN_006c5990(void)

{
  code *pcVar1;
  undefined4 in_EAX;
  int extraout_ECX;
  int unaff_EDI;
  
  *(undefined4 *)(unaff_EDI + 1) = in_EAX;
  pcVar1 = (code *)swi(0x1c);
  (*pcVar1)();
  *(char *)(extraout_ECX + -0x5e359ebd) = *(char *)(extraout_ECX + -0x5e359ebd) << 1;
  pcVar1 = (code *)swi(1);
  (*pcVar1)();
  return;
}

