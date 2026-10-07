/* NR2003.exe @ 00424290 FUN_00424290 */

undefined * FUN_00424290(void)

{
  char cVar1;
  undefined4 uVar2;
  undefined4 uVar3;
  
  uVar3 = 0x18;
  DAT_00871ab8 = 0;
  uVar2 = FUN_0056c0f0(0xffffffff,0x18);
  FUN_006c5260(&DAT_00871ab8,uVar2,uVar3);
  cVar1 = FUN_0055a770();
  if (cVar1 != '\0') {
    FUN_006c5260();
    return &DAT_00871ab8;
  }
  FUN_006c5260();
  return &DAT_00871ab8;
}

