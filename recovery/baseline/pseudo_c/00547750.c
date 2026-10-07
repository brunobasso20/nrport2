/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00547750 */

void FUN_00547750(void)

{
  byte *pbVar1;
  ushort uVar2;
  char cVar3;
  int iVar4;
  int iVar5;
  int iVar6;
  int iVar7;
  int iVar8;
  undefined4 *puVar9;
  float10 fVar10;
  undefined4 local_10;
  undefined4 local_c;
  int local_8;
  float local_4;
  
  local_c = 0;
  cVar3 = FUN_005c2db0(&local_c);
  while (cVar3 != '\0') {
    iVar4 = FUN_005c2d40(local_c);
    if (iVar4 == 2) {
      iVar4 = FUN_005c2e10(local_c);
      if ((*(int *)(&DAT_00be11a7 + iVar4 * 0x3ec) == 0) ||
         (iVar8 = 0x1e, *(int *)(*(int *)(&DAT_00be11a7 + iVar4 * 0x3ec) + 4) == 0)) {
        iVar8 = 5;
      }
      iVar5 = taskGetRate();
      iVar7 = *(int *)(&DAT_00be1273 + iVar4 * 0x3ec);
      iVar6 = getIntCount();
      if ((iVar5 * iVar8 + iVar7 < iVar6) && (cVar3 = FUN_005c3850(local_c), cVar3 == '\0')) {
        iVar8 = taskGetRate();
        iVar8 = DAT_00bef2ea + iVar8 * 3;
        iVar7 = getIntCount();
        if (iVar8 < iVar7) {
          local_10 = 0;
          puVar9 = &DAT_00bef2f6;
          for (iVar8 = 0x18; iVar8 != 0; iVar8 = iVar8 + -1) {
            *puVar9 = 0;
            puVar9 = puVar9 + 1;
          }
          iVar8 = -1;
          cVar3 = FUN_005c2db0(&local_10);
          while (cVar3 != '\0') {
            iVar7 = FUN_005c2e10(local_10);
            iVar5 = FUN_005c2d40(local_10);
            if ((((iVar5 == 2) && (*(int *)(&DAT_00be11a7 + iVar7 * 0x3ec) != 0)) &&
                (iVar7 = *(int *)(*(int *)(&DAT_00be11a7 + iVar7 * 0x3ec) + 0x5b2), -1 < iVar7)) &&
               (iVar7 < 0x30)) {
              pbVar1 = (byte *)((int)&DAT_00bef2f6 + iVar7 * 2);
              *pbVar1 = *pbVar1 | 1;
              FUN_005c3320(local_10);
              iVar5 = FUN_006c5018();
              if (iVar5 < 0) {
                iVar5 = 0;
              }
              else if (0x7f < iVar5) {
                iVar5 = 0x7f;
              }
              uVar2 = *(ushort *)((int)&DAT_00bef2f6 + iVar7 * 2);
              *(ushort *)((int)&DAT_00bef2f6 + iVar7 * 2) =
                   (byte)((char)iVar5 * '\x02' ^ (byte)uVar2) & 0xfe ^ uVar2;
              fVar10 = (float10)FUN_005c32d0(local_10);
              local_4 = (float)fVar10;
              local_8 = taskGetRate();
              iVar5 = FUN_006c5018();
              if (iVar5 < 0) {
                iVar5 = 0;
              }
              else if (0x7f < iVar5) {
                iVar5 = 0x7f;
              }
              uVar2 = *(ushort *)((int)&DAT_00bef2f6 + iVar7 * 2);
              *(ushort *)((int)&DAT_00bef2f6 + iVar7 * 2) =
                   ((ushort)(byte)iVar5 << 8 ^ uVar2) & 0x7f00 ^ uVar2;
              if (iVar8 < iVar7) {
                iVar8 = iVar7;
              }
              DAT_00bef2ee = DAT_00bef2ee + 1;
            }
            cVar3 = FUN_005c2db0(&local_10);
          }
          DAT_00bef2f2 = iVar8;
          DAT_00bef2ea = getIntCount();
        }
        if ((0 < DAT_00bef2ee) &&
           (iVar8 = FUN_005c38b0(local_c,0x87,DAT_00bef2f2 * 2 + 2,&DAT_00bef2f6), iVar8 != 0)) {
          iVar8 = getIntCount();
          *(int *)(&DAT_00be1273 + iVar4 * 0x3ec) = iVar8;
        }
      }
    }
    cVar3 = FUN_005c2db0(&local_c);
  }
  return;
}


