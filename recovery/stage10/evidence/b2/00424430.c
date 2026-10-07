/* NR2003.exe @ 00424430 FUN_00424430 */

void FUN_00424430(undefined4 param_1)

{
  char cVar1;
  undefined4 unaff_ESI;
  char *pcVar2;
  
  cVar1 = FUN_0055a770();
  if (cVar1 == '\0') {
    pcVar2 = &DAT_007220b0;
  }
  else {
    pcVar2 = s_arcade_007220a8;
  }
  FUN_006c4b00(param_1,pcVar2,0x100);
  FUN_006c5260(param_1,&DAT_007220b6,0x100,unaff_ESI);
  FUN_00424350();
  FUN_006c5260();
  return;
}

