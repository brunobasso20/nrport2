/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0055a830 */

undefined4 FUN_0055a830(void)

{
  int iVar1;
  undefined4 uVar2;
  undefined4 uVar3;
  undefined1 local_20 [32];
  
  iVar1 = FUN_00500430();
  if (iVar1 != 0) {
    uVar2 = FUN_0055a680();
    FUN_005a3c00(uVar2);
    FUN_0055a610();
    uVar3 = 1;
    uVar2 = FUN_0055ab00(1);
    uVar2 = FUN_00562f70(uVar2);
    FUN_00568a20(&DAT_00c08768,uVar2,uVar3);
    uVar2 = FUN_0055ab00();
    uVar2 = FUN_00562f70(uVar2);
    FUN_00568e20(0x11,0,0,uVar2);
    FUN_00539030();
    FUN_0057dd80();
    return 1;
  }
  FUN_00619640(local_20,0x20,0x7d4,0);
  FUN_0055c800(2,local_20);
  FUN_005cfeb8();
  return 0;
}


