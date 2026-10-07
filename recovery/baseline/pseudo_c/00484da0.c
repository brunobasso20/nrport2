/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00484da0 */

undefined4 __fastcall FUN_00484da0(int param_1)

{
  undefined **ppuVar1;
  char cVar2;
  int iVar3;
  undefined **ppuVar4;
  
  *(undefined4 *)(param_1 + 0xb8) = 0;
  cVar2 = FUN_005fc350(param_1 + 0x44,s_tabGarageMode_0073acf8);
  if (cVar2 == '\x01') {
    FUN_0060a670(*(undefined4 *)(param_1 + 0xb8));
    cVar2 = FUN_005fbce0(param_1 + 0x4c,s_grpEngineType_0073ad08);
    if ((((cVar2 == '\x01') &&
         (cVar2 = FUN_005fbce0(param_1 + 0x50,s_grpDriveTrain_0073ad18), cVar2 == '\x01')) &&
        (cVar2 = FUN_005fbce0(param_1 + 0x54,s_grpN3Suspension_0073ad28), cVar2 == '\x01')) &&
       ((cVar2 = FUN_005fbce0(param_1 + 0x58,s_grpWeightAero_0073ad38), cVar2 == '\x01' &&
        (iVar3 = FUN_0047ce30(), iVar3 != 0)))) {
      if (PTR_s_btnSteerRatioDown_0073ab10 != (undefined *)0x0) {
        ppuVar4 = &PTR_s_btnSteerRatioDown_0073ab10;
        do {
          iVar3 = FUN_0047cc90(*ppuVar4);
          if (iVar3 != 1) {
            return 0;
          }
          ppuVar1 = ppuVar4 + 1;
          ppuVar4 = ppuVar4 + 1;
        } while (*ppuVar1 != (undefined *)0x0);
      }
      return 1;
    }
  }
  return 0;
}


