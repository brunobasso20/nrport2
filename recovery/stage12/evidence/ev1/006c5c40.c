/* NR2003.exe @ 006c5c40 FUN_006c5c40 */

char __fastcall FUN_006c5c40(undefined4 param_1,undefined2 param_2)

{
  char in_AL;
  char *pcVar1;
  undefined *unaff_ESI;
  
  pcVar1 = (char *)((longlong)(int)unaff_ESI * -0x55);
  *pcVar1 = *pcVar1 + (char)param_2 + ((longlong)(int)pcVar1 != (longlong)(int)unaff_ESI * -0x55);
  out(*unaff_ESI,param_2);
  return in_AL + '\x7f';
}

