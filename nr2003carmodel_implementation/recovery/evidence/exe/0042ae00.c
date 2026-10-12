/* NR2003.exe @ 0042ae00 FUN_0042ae00 */

undefined4 FUN_0042ae00(void)

{
  ulonglong uVar1;
  bool bVar2;
  char cVar3;
  uint uVar4;
  int iVar5;
  undefined4 uVar6;
  int iVar7;
  undefined local_c [12];
  
  bVar2 = true;
  cVar3 = FUN_0056e2b0();
  if (cVar3 == '\0') {
    uVar4 = FUN_005cfd6e();
    DAT_00876d0c = (-(uint)(0x6000000 < uVar4) & 4) + 4;
  }
  else {
    DAT_00876d0c = 1;
  }
  uVar1 = (ulonglong)DAT_00876d0c;
  iVar7 = 0;
  if (DAT_00876d0c != 0) {
    do {
      iVar5 = FUN_00428620(iVar7,local_c);
      (&DAT_008726c0)[iVar7] = iVar5;
      if (iVar5 == 0) {
        bVar2 = false;
      }
      iVar5 = FUN_00428660(iVar7);
      (&DAT_00872688)[iVar7] = iVar5;
      if (iVar5 == 0) {
        bVar2 = false;
      }
      iVar7 = iVar7 + (int)(8 / uVar1);
    } while (iVar7 < DAT_00876d0c);
  }
  uVar6 = FUN_005cfd1a();
  iVar7 = FUN_005cfd14(uVar6);
  if (iVar7 != 0) {
    uVar6 = FUN_0056c020();
    iVar7 = FUN_005cfd14(uVar6);
    if (iVar7 != 0) {
      uVar6 = FUN_0056c0c0(0xffffffff);
      iVar7 = FUN_005cfd14(uVar6);
      if (iVar7 != 0) {
        FUN_005d3a80(s_num_roof_stp_007234e8,&DAT_00876d10);
        FUN_005d3a80(s_num_bumper_stp_007234f8,&DAT_00876d18);
        FUN_005d3a80(s_num_doors_stp_00723508,&DAT_00876d14);
        FUN_005d3a80(s_num_bumper_rear_stp_00723518,&DAT_00876d1c);
        if (!bVar2) {
          FUN_0042af60();
          DAT_00876d0c = 0;
          return 0;
        }
        return 1;
      }
    }
  }
  DAT_00876d10 = 0;
  DAT_00876d18 = 0;
  DAT_00876d14 = 0;
  DAT_00876d1c = 0;
  FUN_0042af60();
  DAT_00876d0c = 0;
  return 0;
}

