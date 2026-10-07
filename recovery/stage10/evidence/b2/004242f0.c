/* NR2003.exe @ 004242f0 FUN_004242f0 */

void FUN_004242f0(undefined4 param_1)

{
  char cVar1;
  undefined4 unaff_ESI;
  char *pcVar2;
  
  cVar1 = FUN_0055a770();
  if (cVar1 == '\0') {
    pcVar2 = &DAT_00722080;
  }
  else {
    pcVar2 = s_arcade_00722078;
  }
  FUN_006c4b00(param_1,pcVar2,0x100);
  FUN_006c5260(param_1,&DAT_00722086,0x100,unaff_ESI);
  FUN_00424350();
  FUN_006c5260();
  return;
}

