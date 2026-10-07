/* NR2003.exe @ 006c4f40 FUN_006c4f40 */

undefined __fastcall FUN_006c4f40(undefined4 param_1,undefined4 param_2)

{
  undefined4 uVar1;
  code *pcVar2;
  byte bVar3;
  undefined in_AL;
  undefined uVar4;
  byte bVar5;
  undefined4 unaff_EBX;
  int unaff_EBP;
  undefined *unaff_ESI;
  byte *unaff_EDI;
  bool bVar6;
  undefined4 *unaff_retaddr;
  
  bVar5 = (byte)((uint)param_1 >> 8);
  bVar6 = CARRY1(*unaff_EDI,bVar5);
  if (!bVar6 && (byte)(*unaff_EDI + bVar5) != '\0') {
    uVar1 = in(CONCAT11((char)((uint)param_2 >> 8) + (char)((uint)unaff_EBX >> 8),(char)param_2));
    *unaff_retaddr = uVar1;
    pcVar2 = (code *)swi(0x16);
    (*pcVar2)();
    uVar4 = in(0x2f);
    return uVar4;
  }
  if (bVar6) {
    out(*unaff_ESI,(short)param_2);
    bVar3 = ((byte)param_1 & 0x1f) % 9;
    bVar5 = *(byte *)(unaff_EBP + -0x74);
    *(byte *)(unaff_EBP + -0x74) = bVar5 << bVar3 | (byte)(CONCAT11(bVar6,bVar5) >> 9 - bVar3);
    return in_AL;
  }
  return in_AL;
}

