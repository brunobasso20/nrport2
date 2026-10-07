/* NR2003.exe @ 00424230 FUN_00424230 */

void FUN_00424230(undefined4 param_1)

{
  char cVar1;
  undefined4 unaff_ESI;
  char *pcVar2;
  
  cVar1 = FUN_0055a770();
  if (cVar1 == '\0') {
    pcVar2 = &DAT_00722060;
  }
  else {
    pcVar2 = s_arcade_00722058;
  }
  FUN_006c4b00(param_1,pcVar2,0x100);
  FUN_006c5260(param_1,&DAT_00722066,0x100,unaff_ESI);
  FUN_00424290();
  FUN_006c5260();
  return;
}

