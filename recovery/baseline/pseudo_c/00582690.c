/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00582690 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */
/* WARNING: Restarted to delay deadcode elimination for space: stack */

void FUN_00582690(void)

{
  float fVar1;
  undefined4 uVar2;
  undefined4 uVar3;
  float fVar4;
  float fVar5;
  float fVar6;
  byte bVar7;
  float fVar8;
  float fVar9;
  char cVar10;
  undefined1 uVar11;
  byte bVar12;
  byte bVar13;
  uint uVar14;
  uint uVar15;
  int iVar16;
  uint uVar17;
  int iVar18;
  byte *pbVar19;
  byte bVar20;
  undefined4 *puVar21;
  int local_48;
  float local_24;
  float local_20;
  float local_1c;
  
  DAT_00d7733c = 0;
  DAT_00d77340 = 0;
  DAT_00d77344 = 0;
  _DAT_00d77348 = 0;
  DAT_00d7734c = 0;
  DAT_00d77350 = 0;
  DAT_00d77354 = 0;
  DAT_00d77358 = 0;
  cVar10 = FUN_00502460();
  if (cVar10 == '\0') {
    DAT_0075012e = 1;
    (**(code **)(*DAT_00c72160 + 100))();
    iVar16 = DAT_00d6a5e0;
    if (DAT_00d6a5e0 != 0) {
      do {
        uVar15 = *(uint *)(iVar16 + 0x28);
        uVar14 = FUN_00583150();
        if ((uVar15 & uVar14) == 0) goto LAB_00582862;
        iVar18 = 0;
        switch(uVar15) {
        case 1:
          puVar21 = &DAT_00d7733c;
          break;
        case 2:
          puVar21 = &DAT_00d77344;
          break;
        default:
          goto switchD_0058271c_caseD_3;
        case 8:
          iVar18 = FUN_00582e80(&DAT_00d7734c);
          *(undefined1 *)(iVar18 + 0x29) = *(undefined1 *)(iVar16 + 0x18);
          goto LAB_0058280c;
        case 0x10:
          puVar21 = &DAT_00d77340;
          break;
        case 0x20:
          iVar18 = FUN_00582e80(&DAT_00d77350);
          fVar4 = *(float *)(iVar16 + 0x30);
          fVar5 = *(float *)(iVar16 + 0x3c);
          fVar6 = *(float *)(iVar16 + 0x34);
          fVar1 = *(float *)(iVar16 + 0x40);
          *(float *)(iVar18 + 0x14) = *(float *)(iVar16 + 0x2c) + *(float *)(iVar16 + 0x38);
          *(float *)(iVar18 + 0x18) = fVar4 + fVar5;
          *(float *)(iVar18 + 0x1c) = fVar6 + fVar1;
          goto switchD_0058271c_caseD_3;
        case 0x40:
          iVar18 = FUN_00582e80(&DAT_00d77354);
          uVar2 = *(undefined4 *)(iVar16 + 0x18);
          *(char *)(iVar18 + 0x28) = (char)((uint)uVar2 >> 0x10);
          *(char *)(iVar18 + 0x29) = (char)((uint)uVar2 >> 8);
          *(char *)(iVar18 + 0x2a) = (char)uVar2;
          *(char *)(iVar18 + 0x2b) = (char)((uint)uVar2 >> 0x18);
LAB_0058280c:
          if (_DAT_006f6870 <= *(float *)(iVar16 + 0x14)) {
            *(undefined4 *)(iVar18 + 0x20) = 0x40526666;
            goto switchD_0058271c_caseD_3;
          }
          goto LAB_0058282a;
        }
        iVar18 = FUN_00582e80(puVar21);
        uVar11 = FUN_006c5018();
        *(undefined1 *)(iVar18 + 0x28) = uVar11;
        if (*(float *)(iVar16 + 0x14) < _DAT_006f6874) {
LAB_0058282a:
          *(undefined4 *)(iVar18 + 0x20) = *(undefined4 *)(iVar16 + 0x14);
        }
        else {
          *(undefined4 *)(iVar18 + 0x20) = 0x424e0000;
        }
switchD_0058271c_caseD_3:
        if (*(int *)(iVar16 + 0x28) != 0x40) {
          uVar11 = *(undefined1 *)(iVar16 + 0x1c);
          if (0xff < *(int *)(iVar16 + 0x1c)) {
            uVar11 = 0xff;
          }
          *(undefined1 *)(iVar18 + 0x2a) = uVar11;
        }
        uVar2 = *(undefined4 *)(iVar16 + 0x34);
        uVar3 = *(undefined4 *)(iVar16 + 0x30);
        *(undefined4 *)(iVar18 + 4) = *(undefined4 *)(iVar16 + 0x2c);
        *(undefined4 *)(iVar18 + 0x10) = 0x3f800000;
        *(undefined4 *)(iVar18 + 8) = uVar3;
        *(undefined4 *)(iVar18 + 0xc) = uVar2;
LAB_00582862:
        iVar16 = *(int *)(iVar16 + 0xa8);
        if (iVar16 == 0) {
          return;
        }
      } while( true );
    }
  }
  else {
    local_48 = 0;
    DAT_0075012e = DAT_0075012f;
    if (DAT_00d7735c != 0) {
      pbVar19 = (byte *)((int)&DAT_00d68fd8 + 1);
      uVar15 = DAT_00d68fd8 & 0xff;
      if (uVar15 != 0) {
        do {
          bVar7 = *pbVar19;
          local_48 = local_48 + 1;
          if ((bVar7 & 0x7f) == 0x20) {
            local_24 = *(float *)(pbVar19 + 2);
            local_20 = *(float *)(pbVar19 + 6);
            local_1c = *(float *)(pbVar19 + 10);
            uVar14 = FUN_00583150();
            if ((uVar14 & 0x20) != 0) {
              iVar16 = FUN_00582e80(&DAT_00d77350);
              fVar1 = (float)((*(int *)(pbVar19 + 0xe) << 0x14) >> 0x14) * _DAT_006ea4a4;
              fVar8 = (float)((*(int *)(pbVar19 + 0xe) << 8) >> 0x14) * _DAT_006ea4a4;
              fVar9 = (float)(int)(char)pbVar19[0x11] * _DAT_006ea4a4;
              fVar4 = *(float *)(pbVar19 + 2);
              fVar5 = *(float *)(pbVar19 + 6);
              fVar6 = *(float *)(pbVar19 + 10);
              uVar2 = *(undefined4 *)(pbVar19 + 10);
              uVar3 = *(undefined4 *)(pbVar19 + 6);
              *(float *)(iVar16 + 4) = *(float *)(pbVar19 + 2);
              *(undefined4 *)(iVar16 + 0x10) = 0x3f800000;
              *(undefined4 *)(iVar16 + 8) = uVar3;
              *(undefined4 *)(iVar16 + 0xc) = uVar2;
              *(float *)(iVar16 + 0x14) = fVar4 + fVar1;
              *(float *)(iVar16 + 0x18) = fVar5 + fVar8;
              *(float *)(iVar16 + 0x1c) = fVar6 + fVar9;
              *(byte *)(iVar16 + 0x2a) = ((char)bVar7 < '\0') - 1U & 10;
            }
            bVar13 = pbVar19[1];
            pbVar19 = pbVar19 + 0x12;
          }
          else {
            bVar13 = pbVar19[0xf];
            bVar20 = bVar7 & 0x7f;
            bVar12 = FUN_00583150();
            if ((bVar20 & bVar12) != 0) {
              iVar16 = FUN_00582ea0(bVar20);
              *(byte *)(iVar16 + 0x28) = pbVar19[1];
              *(byte *)(iVar16 + 0x29) = pbVar19[1];
              uVar2 = *(undefined4 *)(pbVar19 + 0xb);
              uVar3 = *(undefined4 *)(pbVar19 + 7);
              *(undefined4 *)(iVar16 + 4) = *(undefined4 *)(pbVar19 + 3);
              *(undefined4 *)(iVar16 + 8) = uVar3;
              *(undefined4 *)(iVar16 + 0xc) = uVar2;
              *(undefined4 *)(iVar16 + 0x10) = 0x3f800000;
              *(byte *)(iVar16 + 0x2a) = ((char)bVar7 < '\0') - 1U & 10;
              switch(bVar20) {
              case 1:
              case 2:
              case 0x10:
                fVar4 = (float)pbVar19[2] * _DAT_006e9824 + _DAT_006ea44c;
                break;
              default:
                goto switchD_00582a42_caseD_3;
              case 0x40:
                bVar7 = pbVar19[1];
                iVar18 = (((bVar7 & 0xffffffe0 | 0xffffff00) << 5 | bVar7 & 0x1c) << 5 | bVar7 & 3)
                         << 6;
                *(char *)(iVar16 + 0x28) = (char)((uint)iVar18 >> 0x10);
                *(char *)(iVar16 + 0x29) = (char)((uint)iVar18 >> 8);
                *(char *)(iVar16 + 0x2a) = (char)iVar18;
                *(char *)(iVar16 + 0x2b) = (char)((uint)iVar18 >> 0x18);
              case 8:
                fVar4 = (float)pbVar19[2] * _DAT_006f686c + _DAT_006ea4cc;
              }
              *(float *)(iVar16 + 0x20) = fVar4;
            }
switchD_00582a42_caseD_3:
            local_24 = *(float *)(pbVar19 + 3);
            local_20 = *(float *)(pbVar19 + 7);
            local_1c = *(float *)(pbVar19 + 0xb);
            pbVar19 = pbVar19 + 0x10;
          }
          uVar14 = (uint)bVar13;
          if (bVar13 != 0) {
            local_48 = local_48 + uVar14;
            do {
              bVar7 = *pbVar19;
              if ((bVar7 & 0x7f) == 0x20) {
                uVar17 = FUN_00583150();
                if ((uVar17 & 0x20) != 0) {
                  fVar4 = (float)((*(int *)(pbVar19 + 1) << 0x14) >> 0x14) * _DAT_006ea4a4 +
                          local_24;
                  fVar5 = (float)((*(int *)(pbVar19 + 1) << 8) >> 0x14) * _DAT_006ea4a4 + local_20;
                  fVar6 = (float)(int)(char)pbVar19[4] * _DAT_006ea4a4 + local_1c;
                  iVar16 = FUN_00582e80(&DAT_00d77350);
                  *(float *)(iVar16 + 4) = fVar4;
                  *(float *)(iVar16 + 8) = fVar5;
                  *(float *)(iVar16 + 0xc) = fVar6;
                  *(undefined4 *)(iVar16 + 0x10) = 0x3f800000;
                  *(byte *)(iVar16 + 0x2a) = ((char)bVar7 < '\0') - 1U & 10;
                  fVar1 = (float)((*(int *)(pbVar19 + 5) << 8) >> 0x14) * _DAT_006ea4a4;
                  fVar8 = (float)(int)(char)pbVar19[8] * _DAT_006ea4a4;
                  *(float *)(iVar16 + 0x14) =
                       fVar4 + (float)((*(int *)(pbVar19 + 5) << 0x14) >> 0x14) * _DAT_006ea4a4;
                  *(float *)(iVar16 + 0x18) = fVar5 + fVar1;
                  *(float *)(iVar16 + 0x1c) = fVar6 + fVar8;
                }
                pbVar19 = pbVar19 + 9;
              }
              else {
                bVar12 = bVar7 & 0x7f;
                bVar13 = FUN_00583150();
                if ((bVar12 & bVar13) != 0) {
                  iVar18 = FUN_00582ea0(bVar12);
                  *(byte *)(iVar18 + 0x28) = pbVar19[1];
                  *(byte *)(iVar18 + 0x29) = pbVar19[1];
                  iVar16 = *(int *)(pbVar19 + 3);
                  fVar4 = (float)(int)(char)pbVar19[6] * _DAT_006ea4a4;
                  *(undefined4 *)(iVar18 + 0x10) = 0x3f800000;
                  fVar5 = (float)((iVar16 << 8) >> 0x14) * _DAT_006ea4a4;
                  *(float *)(iVar18 + 4) =
                       (float)((iVar16 << 0x14) >> 0x14) * _DAT_006ea4a4 + local_24;
                  *(float *)(iVar18 + 8) = fVar5 + local_20;
                  *(float *)(iVar18 + 0xc) = fVar4 + local_1c;
                  *(byte *)(iVar18 + 0x2a) = ((char)bVar7 < '\0') - 1U & 10;
                  switch(bVar12) {
                  case 1:
                  case 2:
                  case 0x10:
                    fVar4 = (float)pbVar19[2] * _DAT_006e9824 + _DAT_006ea44c;
                    break;
                  default:
                    goto switchD_00582ce6_caseD_3;
                  case 0x40:
                    bVar7 = pbVar19[1];
                    iVar16 = (((bVar7 & 0xffffffe0 | 0xffffff00) << 5 | bVar7 & 0x1c) << 5 |
                             bVar7 & 3) << 6;
                    *(char *)(iVar18 + 0x28) = (char)((uint)iVar16 >> 0x10);
                    *(char *)(iVar18 + 0x29) = (char)((uint)iVar16 >> 8);
                    *(char *)(iVar18 + 0x2a) = (char)iVar16;
                    *(char *)(iVar18 + 0x2b) = (char)((uint)iVar16 >> 0x18);
                  case 8:
                    fVar4 = (float)pbVar19[2] * _DAT_006f686c + _DAT_006ea4cc;
                  }
                  *(float *)(iVar18 + 0x20) = fVar4;
                }
switchD_00582ce6_caseD_3:
                pbVar19 = pbVar19 + 7;
              }
              uVar14 = uVar14 - 1;
            } while (uVar14 != 0);
          }
        } while (local_48 < (int)uVar15);
      }
    }
  }
  return;
}


