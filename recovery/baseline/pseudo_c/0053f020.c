/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0053f020 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_0053f020(int param_1)

{
  byte bVar1;
  bool bVar2;
  char cVar3;
  undefined1 uVar4;
  int iVar5;
  undefined4 *puVar6;
  uint uVar7;
  int iVar8;
  float *pfVar9;
  int iVar10;
  undefined4 *puVar11;
  int extraout_EDX;
  byte bVar12;
  int *piVar13;
  int iVar14;
  char *pcVar15;
  float10 fVar16;
  undefined8 uVar17;
  undefined4 uVar18;
  int *local_58;
  float local_54;
  int *local_50;
  undefined4 local_4c;
  undefined4 local_48;
  undefined4 local_44;
  undefined4 local_3c;
  uint local_38;
  int local_34;
  int local_30;
  int local_2c;
  int local_28;
  undefined1 local_24;
  undefined1 uStack_23;
  undefined2 uStack_22;
  undefined1 uStack_20;
  undefined1 uStack_1f;
  undefined4 local_1e;
  undefined4 local_1a;
  undefined4 local_16;
  undefined4 local_12;
  undefined4 local_e;
  
  fVar16 = (float10)FUN_00509a20();
  iVar14 = 0;
  pcVar15 = &DAT_00accfca;
  *(double *)(param_1 + 0x1c) = (double)(fVar16 + (float10)*(double *)(param_1 + 0x14));
  do {
    if (((*pcVar15 != '\0') && (*(char *)(iVar14 + 0x8e0 + param_1) != '\0')) &&
       (iVar5 = FUN_00539550(iVar14,200,0,0,0), iVar5 != 0)) {
      *(undefined1 *)(iVar14 + 0x8e0 + param_1) = 0;
    }
    pcVar15 = pcVar15 + 0x2214;
    iVar14 = iVar14 + 1;
  } while ((int)pcVar15 < 0xb3338a);
  iVar14 = 0;
  local_54 = (float)(param_1 + 0xaf0);
  local_58 = &DAT_00acddbf;
LAB_0053f098:
  if (*local_58 == 0) {
    *(undefined1 *)(iVar14 + 0x9d0 + param_1) = 1;
    *(undefined1 *)(iVar14 + 0xa00 + param_1) = 1;
    *(undefined1 *)(iVar14 + 0xa30 + param_1) = 1;
    *(undefined1 *)(iVar14 + 0xa60 + param_1) = 1;
    *(undefined1 *)(iVar14 + 0xa90 + param_1) = 1;
  }
  else {
    cVar3 = FUN_005c37f0(*local_58,0x84,0);
    if (((cVar3 == '\0') && (cVar3 = FUN_005c37f0(*local_58,0x44,0), cVar3 == '\0')) &&
       ((cVar3 = FUN_005c37f0(*local_58,0x88,0), cVar3 == '\0' &&
        ((cVar3 = FUN_005c37f0(*local_58,0x85,0), cVar3 == '\0' &&
         (cVar3 = FUN_005c37f0(*local_58,0xd1,0), cVar3 == '\0')))))) {
      if ((*(char *)(iVar14 + 0x9d0 + param_1) == '\0') &&
         (iVar5 = FUN_00539550(iVar14,0x84,0xda,&DAT_00be0d18,1), iVar5 != 0)) {
        *(undefined1 *)(iVar14 + 0x9d0 + param_1) = 1;
      }
      else if ((((DAT_00bebd9c & 1) == 0) || (*(char *)(iVar14 + 0xa00 + param_1) != '\0')) ||
              (iVar5 = FUN_00539550(iVar14,0x44,*(undefined4 *)(param_1 + 0x224),param_1 + 0x24,1),
              iVar5 == 0)) {
        if (*(char *)(iVar14 + 0xa60 + param_1) == '\0') {
          iVar10 = 0;
          iVar5 = FUN_00536170();
          if (0 < iVar5) {
            puVar11 = (undefined4 *)(param_1 + 0xc10);
            do {
              puVar6 = (undefined4 *)FUN_00536280(iVar10);
              iVar10 = iVar10 + 1;
              *puVar11 = *puVar6;
              puVar11[1] = puVar6[1];
              puVar11[2] = puVar6[2];
              iVar5 = FUN_00536170();
              puVar11 = puVar11 + 3;
            } while (iVar10 < iVar5);
          }
          iVar5 = FUN_00536170(param_1 + 0xc10,1);
          iVar5 = FUN_00539550(iVar14,0x88,iVar5 * 0xc);
          if (iVar5 != 0) {
            *(undefined1 *)(iVar14 + 0xa60 + param_1) = 1;
            goto LAB_0053f3ed;
          }
        }
        if (*(char *)(iVar14 + 0xa30 + param_1) == '\0') {
          iVar5 = iVar14;
          FUN_00538ab0(iVar14);
          iVar5 = FUN_0053a580(iVar5);
          if (iVar5 != 0x7ffffffe) {
            iVar5 = iVar14;
            FUN_00538ab0(iVar14);
            local_24 = FUN_0053a580(iVar5);
            puVar11 = (undefined4 *)FUN_00536280(local_24);
            uVar18 = *puVar11;
            uStack_22 = (undefined2)uVar18;
            uStack_20 = (undefined1)((uint)uVar18 >> 0x10);
            uStack_1f = (undefined1)((uint)uVar18 >> 0x18);
            local_1e = puVar11[1];
            local_1a = puVar11[2];
            iVar5 = FUN_005099b0();
            if (iVar5 == 7) {
              iVar5 = iVar14;
              FUN_00538ab0(iVar14);
              iVar5 = FUN_0053a590(iVar5);
              if (iVar5 < 0) goto LAB_0053f2e3;
              iVar5 = iVar14;
              FUN_00538ab0(iVar14);
              uStack_23 = FUN_0053a590(iVar5);
              puVar11 = (undefined4 *)FUN_00536080(uStack_23);
              local_16 = *puVar11;
              local_12 = puVar11[1];
              local_e = puVar11[2];
            }
            else {
LAB_0053f2e3:
              uStack_23 = 0xff;
              local_16 = 0xc3fa0000;
              local_12 = 0xc3fa0000;
            }
            iVar5 = FUN_00539550(iVar14,0x85,0x1a,&local_24,0);
            if (iVar5 != 0) {
              *(undefined1 *)(iVar14 + 0xa30 + param_1) = 1;
              goto LAB_0053f3ed;
            }
          }
        }
        iVar5 = FUN_005c2d20(*local_58);
        if (iVar5 == 1) {
          *(undefined1 *)(iVar14 + 0xa90 + param_1) = 1;
        }
        if (((*(char *)(iVar14 + 0xa90 + param_1) == '\0') &&
            (cVar3 = FUN_004fa3c0(*local_58), cVar3 != '\0')) &&
           (iVar5 = FUN_00544d20(*local_58), iVar5 == 3)) {
          local_3c = FUN_00544be0();
          uVar7 = FUN_00509990();
          local_38 = local_38 ^ (uVar7 ^ local_38) & 0xfffffff;
          iVar5 = FUN_005099a0();
          local_38 = local_38 & 0xfffffff ^ iVar5 << 0x1c;
          local_34 = local_58[-0x1a];
          local_30 = local_58[-0x19];
          local_2c = local_58[-0x18];
          local_28 = local_58[-0x17];
          iVar5 = FUN_00539550(iVar14,0xd1,0x18,&local_3c,0);
          if (iVar5 != 0) {
            *(undefined1 *)(iVar14 + 0xa90 + param_1) = 1;
          }
        }
      }
      else {
        *(undefined1 *)(iVar14 + 0xa00 + param_1) = 1;
      }
    }
LAB_0053f3ed:
    cVar3 = FUN_005c37f0(*local_58,0x89,0);
    if (cVar3 == '\0') {
      iVar5 = 0;
      do {
        if (*(char *)((int)local_54 + iVar5) != -1) {
          iVar5 = 0;
          local_50 = (int *)0x0;
          goto LAB_0053f426;
        }
        iVar5 = iVar5 + 1;
      } while (iVar5 < 6);
    }
  }
  goto LAB_0053f53d;
LAB_0053f426:
  do {
    if (7 < iVar5) break;
    iVar10 = (int)local_50 >> 3;
    bVar1 = *(byte *)((int)local_54 + iVar10);
    bVar12 = (byte)(1 << ((byte)local_50 & 7));
    if ((bVar12 & bVar1) == 0) {
      if ((int *)iVar14 != local_50) {
        iVar10 = iVar14;
        FUN_00538ab0(iVar14);
        uVar17 = FUN_0053a580(iVar10);
        iVar10 = (int)((ulonglong)uVar17 >> 0x20);
        if ((int)uVar17 != 0x7fffffff) {
          *(byte *)((int)&local_4c + iVar5 * 2) = (byte)local_50;
          piVar13 = local_50;
          FUN_00538ab0(local_50);
          uVar17 = FUN_0053a580(piVar13);
          uVar18 = (undefined4)((ulonglong)uVar17 >> 0x20);
          if ((int)uVar17 == 0x7ffffffe) {
            *(undefined1 *)((int)&local_4c + iVar5 * 2 + 1) = 0xff;
            iVar5 = iVar5 + 1;
          }
          else {
            FUN_00538ab0(uVar18);
            uVar4 = FUN_0053a580(uVar18);
            *(undefined1 *)((int)&local_4c + iVar5 * 2 + 1) = uVar4;
            iVar5 = iVar5 + 1;
            local_50 = (int *)extraout_EDX;
          }
          goto LAB_0053f4b6;
        }
      }
      *(byte *)((int)local_54 + iVar10) = bVar1 | bVar12;
    }
LAB_0053f4b6:
    local_50 = (int *)((int)local_50 + 1);
  } while ((int)local_50 < 0x30);
  if (((0 < iVar5) && (iVar10 = FUN_00539550(iVar14,0x89,iVar5 * 2,&local_4c,0), iVar10 != 0)) &&
     (iVar10 = 0, 0 < iVar5)) {
    do {
      bVar1 = *(byte *)((int)&local_4c + iVar10 * 2);
      iVar8 = (int)(uint)bVar1 >> 3;
      iVar10 = iVar10 + 1;
      *(byte *)((int)local_54 + iVar8) = *(byte *)((int)local_54 + iVar8) | '\x01' << (bVar1 & 7);
    } while (iVar10 < iVar5);
  }
LAB_0053f53d:
  local_58 = local_58 + 0x885;
  iVar14 = iVar14 + 1;
  local_54 = (float)((int)local_54 + 6);
  if (0xb3417e < (int)local_58) goto code_r0x0053f561;
  goto LAB_0053f098;
code_r0x0053f561:
  iVar14 = 0;
  piVar13 = &DAT_00acddbf;
  local_50 = (int *)(param_1 + 0x910);
  do {
    bVar2 = false;
    if (((*piVar13 != 0) && (iVar5 = FUN_005c2d20(*piVar13), iVar5 == 1)) &&
       (iVar5 = FUN_005c2e10(*piVar13), ((&DAT_00be11b7)[iVar5 * 0xfb] & 0x10000) == 0)) {
      bVar2 = true;
    }
    if (((*(char *)((int)piVar13 + -0xdf5) != '\0') && (*local_50 == 1)) &&
       ((((*(char *)(iVar14 + 0x9d0 + param_1) != '\0' &&
          (((DAT_00bebd9c & 1) == 0 || (*(char *)(iVar14 + 0xa00 + param_1) != '\0')))) &&
         (*(char *)(iVar14 + 0xa30 + param_1) != '\0')) &&
        (((*(char *)(iVar14 + 0xa60 + param_1) != '\0' &&
          (*(char *)(iVar14 + 0xa90 + param_1) != '\0')) && (!bVar2)))))) {
      local_54 = 0.0;
      iVar5 = FUN_005099b0();
      if ((iVar5 == 7) && (iVar5 = FUN_00509b60(0xffffffff), 1 < iVar5)) {
        iVar5 = iVar14;
        FUN_00538ab0(iVar14);
        iVar5 = FUN_0053a580(iVar5);
        if (-1 < iVar5) {
          pfVar9 = (float *)FUN_00536280(iVar5);
          fVar16 = (float10)FUN_00516e1a();
          local_54 = (float)(((float10)_DAT_006e97d8 - (float10)*pfVar9 / fVar16) *
                            (float10)_DAT_00b8fa5c);
        }
      }
      iVar5 = FUN_00538ae0();
      iVar10 = FUN_00509b60(0xffffffff);
      if (iVar10 == 1) {
LAB_0053f721:
        local_4c = 0xc3fa0000;
        local_48 = 0xc3fa0000;
        local_44 = 0xc3fa0000;
        if (*(char *)(iVar14 + 0x8b0 + param_1) != '\0') {
          iVar5 = FUN_005099b0();
          if (iVar5 == 5) {
            puVar11 = (undefined4 *)FUN_00536320(0);
            local_4c = *puVar11;
            local_48 = puVar11[1];
            local_44 = puVar11[2];
          }
          else {
            iVar5 = FUN_005099b0();
            if ((iVar5 == 7) && (iVar5 = FUN_00509b60(0xffffffff), iVar5 < 2)) {
              iVar5 = iVar14;
              FUN_00538ab0(iVar14);
              iVar5 = FUN_0053a590(iVar5);
              if (-1 < iVar5) {
                puVar11 = (undefined4 *)FUN_00536080(iVar5);
LAB_0053f7cd:
                local_4c = *puVar11;
                local_48 = puVar11[1];
                local_44 = puVar11[2];
              }
            }
            else {
              iVar5 = iVar14;
              FUN_00538ab0(iVar14);
              iVar5 = FUN_0053a580(iVar5);
              if (-1 < iVar5) {
                puVar11 = (undefined4 *)FUN_00536280(iVar5);
                goto LAB_0053f7cd;
              }
            }
          }
        }
        iVar5 = FUN_00539550(iVar14,0xc9,0xc,&local_4c,0);
        if (iVar5 != 0) {
          *local_50 = 0;
        }
      }
      else {
        iVar10 = FUN_00509b60(0xffffffff);
        if (iVar10 == 4) {
          if ((*(int *)(iVar5 + 0xc1) == 0) && (*(int *)(iVar5 + 0xc5) == -0x40100000)) {
            fVar16 = (float10)_DAT_006ea4b8;
          }
          else {
            fVar16 = (float10)(*(code *)**(undefined4 **)(iVar5 + 0xbd))();
            if (fVar16 <= (float10)*(double *)(iVar5 + 0xc1)) {
              fVar16 = (float10)(*(code *)**(undefined4 **)(iVar5 + 0xbd))();
              fVar16 = (float10)*(double *)(iVar5 + 0xc1) - fVar16;
            }
            else {
              fVar16 = (float10)_DAT_006ea4b0;
            }
          }
          if (fVar16 - (float10)local_54 < (float10)_DAT_006ea4b0 !=
              (fVar16 - (float10)local_54 == (float10)_DAT_006ea4b0)) goto LAB_0053f721;
        }
      }
    }
    piVar13 = piVar13 + 0x885;
    iVar14 = iVar14 + 1;
    local_50 = local_50 + 1;
    if (0xb3417e < (int)piVar13) {
      iVar14 = 0;
      pcVar15 = &DAT_00accfca;
      piVar13 = (int *)(param_1 + 0x910);
      do {
        if ((*pcVar15 != '\0') && ((*piVar13 == 2 || (*piVar13 == 3)))) {
          local_4c = 0xc3fa0000;
          local_48 = 0xc3fa0000;
          local_44 = 0xc3fa0000;
          iVar5 = iVar14;
          FUN_00538ab0(iVar14);
          iVar5 = FUN_0053a580(iVar5);
          if (-1 < iVar5) {
            puVar11 = (undefined4 *)FUN_00536280(iVar5);
            local_4c = *puVar11;
            local_48 = puVar11[1];
            local_44 = puVar11[2];
          }
          iVar5 = FUN_00539550(iVar14,0xc9,0xc,&local_4c,0);
          if (iVar5 != 0) {
            if (*piVar13 == 3) {
              *(undefined1 *)(iVar14 + 0xac0 + param_1) = 1;
            }
            *piVar13 = 0;
          }
        }
        pcVar15 = pcVar15 + 0x2214;
        iVar14 = iVar14 + 1;
        piVar13 = piVar13 + 1;
      } while ((int)pcVar15 < 0xb3338a);
      return;
    }
  } while( true );
}


