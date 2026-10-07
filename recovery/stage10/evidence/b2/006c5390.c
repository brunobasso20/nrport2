/* NR2003.exe @ 006c5390 FUN_006c5390 */

/* WARNING: Control flow encountered bad instruction data */
/* WARNING: Instruction at (ram,0x006c5484) overlaps instruction at (ram,0x006c5480)
    */
/* WARNING: Unable to track spacebase fully for stack */
/* WARNING: Removing unreachable block (ram,0x006c54b9) */
/* WARNING: Removing unreachable block (ram,0x006c54e8) */
/* WARNING: Removing unreachable block (ram,0x006c54e9) */
/* WARNING: Removing unreachable block (ram,0x006c54a8) */
/* WARNING: Removing unreachable block (ram,0x006c54f5) */
/* WARNING: Removing unreachable block (ram,0x006c554d) */
/* WARNING: Removing unreachable block (ram,0x006c54f7) */
/* WARNING: Removing unreachable block (ram,0x006c550b) */
/* WARNING: Removing unreachable block (ram,0x006c5583) */
/* WARNING: Removing unreachable block (ram,0x006c5584) */
/* WARNING: Removing unreachable block (ram,0x006c5520) */
/* WARNING: Removing unreachable block (ram,0x006c5521) */
/* WARNING: Removing unreachable block (ram,0x006c525d) */
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

uint __fastcall
FUN_006c5390(uint *param_1,int param_2,uint *param_3,undefined4 param_4,uint param_5,
            undefined4 *param_6,int param_7,uint *param_8,byte *param_9,uint param_10,
            undefined *param_11,uint *param_12)

{
  ushort *puVar1;
  short sVar2;
  code *pcVar3;
  undefined uVar4;
  char cVar5;
  undefined4 uVar6;
  int iVar7;
  uint uVar8;
  uint uVar9;
  uint *in_EAX;
  uint uVar10;
  byte bVar12;
  byte *extraout_ECX;
  undefined4 extraout_ECX_00;
  byte *extraout_ECX_01;
  byte *pbVar11;
  byte bVar13;
  char cVar14;
  undefined2 uVar15;
  uint uVar16;
  uint *puVar17;
  int iVar18;
  uint *puVar19;
  byte *pbVar20;
  uint *unaff_ESI;
  uint *puVar21;
  int unaff_EDI;
  undefined2 in_CS;
  byte in_AF;
  bool bVar22;
  char cVar23;
  byte in_OF;
  bool bVar24;
  float10 fVar25;
  float10 extraout_ST0;
  float10 fVar26;
  float10 extraout_ST1;
  float10 in_ST2;
  float10 in_ST3;
  float10 in_ST4;
  float10 in_ST5;
  float10 in_ST6;
  float10 in_ST7;
  ulonglong uVar27;
  undefined6 uVar28;
  int unaff_retaddr;
  
  *(undefined *)(unaff_EDI + -0x46) = 0;
  bVar24 = (bool)(in_OF & 1);
  uVar10 = 0xc61d5eef;
  out((short)param_2,0xc61d5eef);
  while (iVar18 = param_2, bVar24) {
    bVar13 = (byte)uVar10;
    cVar5 = bVar13 + 0xb6;
    if (cVar5 != '\0' && 'I' < (char)bVar13) {
                    /* WARNING: Bad instruction - Truncating control flow here */
      halt_baddata();
    }
    iVar18 = CONCAT31((int3)((uint)param_2 >> 8),0xe2);
    iVar7 = CONCAT22((short)((uint)_DAT_1eaaeea7 >> 0x10),
                     CONCAT11((cVar5 < '\0') << 7 | (cVar5 == '\0') << 6 | in_AF << 4 |
                              ((POPCOUNT(cVar5) & 1U) == 0) << 2 | 2 | bVar13 < 0x4a,
                              (char)_DAT_1eaaeea7));
    bVar13 = *(byte *)(iVar7 + -0x1f);
    bVar12 = (byte)((uint)param_3 >> 8);
    if (bVar13 == bVar12) {
                    /* WARNING: Bad instruction - Truncating control flow here */
      halt_baddata();
    }
    puVar21 = (uint *)((int)unaff_ESI + -1);
    cVar5 = (char)((uint)param_2 >> 8);
    if (bVar13 >= bVar12) {
      unaff_ESI = (uint *)((int)unaff_ESI + -2);
      uVar10 = (iVar7 + -0x4e6cce5d) - (uint)(bVar13 < bVar12);
      bVar24 = SCARRY1(*(char *)param_3,cVar5);
      *(char *)param_3 = *(char *)param_3 + cVar5;
      _DAT_73a1711c = 0x8b5bd405;
      param_1 = param_3;
      break;
    }
    in_EAX = (uint *)((int)in_EAX + -1);
    pbVar11 = (byte *)((int)param_3 + -1);
    if (pbVar11 != (byte *)0x0) goto LAB_006c5379;
    uVar10 = in(0x96);
    cVar5 = cVar5 + (char)((uint)unaff_retaddr >> 8);
    pbVar11 = (byte *)0x0;
    puVar19 = (uint *)CONCAT22((short)((uint)param_2 >> 0x10),CONCAT11(cVar5,0xe2));
    uVar8 = _DAT_73a1711c;
    if ((POPCOUNT(cVar5) & 1U) != 0) goto code_r0x006c5351;
    param_2 = 0x5eefbfd0;
    bVar24 = SBORROW4(uVar10,-0x1068a43a) != SBORROW4(uVar10 + 0x1068a43a,1);
    uVar10 = uVar10 + 0x1068a439;
    param_1 = (uint *)0x0;
    unaff_ESI = puVar21;
  }
  uVar15 = (undefined2)iVar18;
  if (bVar24) {
    param_3 = (uint *)CONCAT31((int3)((uint)param_1 >> 8),0xdd);
    puVar21 = unaff_ESI + 1;
    *in_EAX = *unaff_ESI;
    cVar5 = (char)((uint)param_1 >> 8);
    cVar23 = (char)(iVar18 + 1);
    cVar14 = cVar23 - cVar5;
    uVar15 = (undefined2)CONCAT31((int3)((uint)(iVar18 + 1) >> 8),cVar14);
    uVar28 = CONCAT24(uVar15,uVar10);
    if (cVar14 != '\0' && cVar5 <= cVar23) {
      pcVar3 = (code *)swi(1);
      uVar10 = (*pcVar3)();
      return uVar10;
    }
    bVar24 = false;
    if ((int)uVar10 >= 0) {
      pcVar3 = (code *)swi(0x97);
      uVar10 = (*pcVar3)();
      *(uint *)(uVar10 - 0x62) = *(uint *)(uVar10 - 0x62) ^ (uint)param_3;
      return uVar10;
    }
    if ((int)uVar10 < 0) {
      in_EAX[1] = 0xcea5854e;
      goto code_r0x006c5486;
    }
    puVar21 = (uint *)((int)unaff_ESI + 5);
    uVar10 = param_5;
  }
  else {
    puVar21 = unaff_ESI + 1;
    *in_EAX = *unaff_ESI;
  }
  uVar28 = CONCAT24(uVar15,uVar10);
  pcVar3 = (code *)swi(4);
  if (bVar24 == true) {
    uVar28 = (*pcVar3)();
  }
code_r0x006c5486:
  cVar5 = in((short)((uint6)uVar28 >> 0x20));
  *(char *)(in_EAX + 1) = cVar5;
  puVar19 = (uint *)((int)uVar28 + 0x6d);
  *puVar19 = *puVar19 ^ (uint)param_3;
  puVar19 = &param_5;
  cVar5 = '\b';
  do {
    param_3 = param_3 + -1;
    puVar19 = puVar19 + -1;
    *puVar19 = *param_3;
    cVar5 = cVar5 + -1;
  } while ('\0' < cVar5);
  return *puVar21;
code_r0x006c5351:
  uVar9 = uVar8;
  iVar18 = unaff_retaddr;
  puVar17 = puVar19;
  uVar8 = uVar10;
  param_12 = *(uint **)((int)puVar17 + 0x62);
code_r0x006c5355:
  *(char *)in_EAX = *(char *)puVar21;
  pbVar11 = pbVar11 + -1;
  uVar10 = uVar9;
  in_EAX = (uint *)((int)in_EAX + 1);
  while( true ) {
    pbVar11[-0x6b] = pbVar11[-0x6b] + 1;
    uVar9 = uVar10 + 1;
    *puVar17 = *puVar17 ^ 0xffffffcf;
    pbVar20 = pbVar11 + (uVar10 - 0x1c);
    *pbVar20 = *pbVar20 ^ (byte)uVar9;
    puVar21 = param_12;
    if ('\0' < (char)*pbVar20) break;
code_r0x006c530d:
    bVar13 = (byte)uVar9 + (char)(uVar9 >> 8) * -0x32;
    in_AF = 9 < (bVar13 & 0xf) | in_AF;
    bVar13 = bVar13 + in_AF * -6;
    param_12 = (uint *)CONCAT22(param_12._2_2_,in_CS);
    iVar7 = (CONCAT31((int3)(uVar9 >> 8),
                      bVar13 + (0x9f < bVar13 |
                               (byte)uVar9 < *(byte *)(puVar17 + -0x6325f23) | in_AF * (bVar13 < 6))
                               * -0x60) & 0xffff00ff) - 1;
    uVar10 = (uint)pbVar11 & 0x59cb9a9f;
    bRam199b01e7 = bRam199b01e7 ^ (byte)(uVar10 >> 8);
    pbVar11 = (byte *)(uVar8 + 0x3b4d5929);
    bVar24 = 0x5f < *pbVar11;
    bVar13 = *pbVar11;
    *pbVar11 = *pbVar11 + 0xa0;
    bVar12 = *pbVar11;
    puVar1 = (ushort *)(uVar10 - 0x1d);
    sVar2 = ((ushort)iVar7 & 3) - (*puVar1 & 3);
    *puVar1 = *puVar1 + (ushort)bVar24 * sVar2;
    if (uVar10 == 1) {
code_r0x006c5330:
      do {
                    /* WARNING: Do nothing block with infinite loop */
      } while( true );
    }
    pbVar11 = (byte *)(uVar10 - 2);
    if ((pbVar11 == (byte *)0x0 || sVar2 < 1) && (SCARRY1(bVar13,-0x60) != (char)bVar12 < '\0')) {
      iVar7 = in(0x95);
      cVar5 = *(char *)(iVar7 + 0x70e29d7c);
      iVar18 = CONCAT22((short)((uint)iVar18 >> 0x10),CONCAT11(cVar5,(char)iVar18));
      cVar23 = SBORROW4((int)pbVar11,1);
      puVar21 = (uint *)(uVar10 - 3);
      cVar14 = (int)puVar21 < 0;
      bVar22 = puVar21 == (uint *)0x0;
      in((short)puVar17);
      param_11 = &UNK_006c52c5;
      uVar27 = func_0xd1c9c077();
      puVar17 = (uint *)(uVar27 >> 0x20);
      if (bVar22 || cVar23 != cVar14) {
        pbVar11 = extraout_ECX + -1;
        if (pbVar11 != (byte *)0x0 && bVar22 != false) goto code_r0x006c5292;
        if (!bVar22) {
          fVar25 = extraout_ST0;
          fVar26 = extraout_ST1;
          if (bVar24) {
            while( true ) {
              uVar15 = (undefined2)(uVar27 >> 0x20);
              out(uVar15,(char)uVar27);
              in(uVar15);
              *(int *)(pbVar11 + -0x7c) = (int)ROUND(fVar25);
              uVar10 = in(0x31);
              if (pbVar11 != (byte *)0x1) break;
              uVar6 = in(0x96);
              uVar27 = (ulonglong)
                       CONCAT24(CONCAT11((char)(uVar27 >> 0x28) + cVar5,(char)(uVar27 >> 0x20)),
                                uVar6);
              pbVar11 = (byte *)0xffffffff;
              fVar25 = fVar26;
              fVar26 = in_ST2;
              in_ST2 = in_ST3;
              in_ST3 = in_ST4;
              in_ST4 = in_ST5;
              in_ST5 = in_ST6;
              in_ST6 = in_ST7;
            }
            puVar21 = (uint *)(uVar8 + 0x77 + (int)in_EAX);
            *puVar21 = *puVar21 ^
                       CONCAT31((int3)(uVar10 >> 8),((char)uVar10 + -4) - (uVar10 < 0x7fe0fe77));
                    /* WARNING: Bad instruction - Truncating control flow here */
            halt_baddata();
          }
          pcVar3 = (code *)swi(1);
          uVar10 = (*pcVar3)();
          return uVar10;
        }
        goto code_r0x006c5330;
      }
      pbVar11 = extraout_ECX;
      if (bVar22 || cVar23 != cVar14) goto code_r0x006c5332;
      uVar4 = in(0x8b);
      uVar9 = CONCAT31((int3)(uVar27 >> 8),uVar4);
      pbVar11 = extraout_ECX + -1;
      if (pbVar11 != (byte *)0x0 && bVar22 != false) {
        pbVar11 = extraout_ECX + -2;
        if (pbVar11 == (byte *)0x0 || bVar22 != false) goto code_r0x006c5301;
code_r0x006c5374:
        out(1,uVar9);
        break;
      }
      bVar13 = (byte)(uVar27 >> 8);
      puVar17 = (uint *)CONCAT31((int3)(uVar27 >> 0x28),(byte)(uVar27 >> 0x20) ^ bVar13);
      puVar19 = in_EAX + 0x1d65b97d;
      *(byte *)puVar19 = *(char *)puVar19 + bVar13;
      if ((POPCOUNT(*(char *)puVar19) & 1U) == 0) goto code_r0x006c5355;
      pcVar3 = (code *)swi(0x77);
      uVar6 = (*pcVar3)();
      pbVar20 = (byte *)((uint)puVar21 & 0x40a254c2);
      iVar18 = CONCAT22((short)((uint)(iVar18 + -1) >> 0x10),CONCAT11(0x81,(char)(iVar18 + -1)));
      pbVar11 = (byte *)CONCAT31((int3)((uint)extraout_ECX_00 >> 8),(byte)extraout_ECX_00 ^ *pbVar20
                                );
      *(byte *)in_EAX = (byte)uVar6;
      cVar5 = (char)((int)uVar6 >> 0x1f);
      if (!SCARRY1(cVar5,-0x7f)) {
code_r0x006c5288:
        *(uint *)(pbVar11 + 0x6e) = *(uint *)(pbVar11 + 0x6e) | 0xffffffae;
code_r0x006c5292:
        pcVar3 = (code *)swi(1);
        param_11 = (undefined *)uVar8;
        uVar10 = (*pcVar3)();
        return uVar10;
      }
      puVar17 = (uint *)CONCAT31((int3)(CONCAT22((short)((int)uVar6 >> 0x1f),
                                                 CONCAT11(cVar5 + -0x7f,cVar5)) >> 8),
                                 cVar5 - (char)((uint)extraout_ECX_00 >> 8));
      in_AF = 9 < (((byte)uVar6 ^ 0xfa) & 0xf) | in_AF;
      puVar21 = (uint *)(pbVar20 + 2);
      bVar24 = false;
      cVar23 = '\0';
      uVar9 = CONCAT31((int3)((uint)uVar6 >> 8),pbVar20[1]) & 0x73e062de;
      cVar14 = '\0';
      bVar22 = uVar9 == 0;
      in_EAX = (uint *)((int)in_EAX + 1);
code_r0x006c5301:
      uVar27 = CONCAT44(puVar17,uVar9);
      if (bVar24) {
        pbVar11 = pbVar11 + -1;
        if (pbVar11 == (byte *)0x0) goto code_r0x006c5288;
        if (!bVar24) goto code_r0x006c5374;
      }
      else {
        if (bVar22 || cVar23 != cVar14) {
          return uVar9;
        }
        pcVar3 = (code *)swi(4);
        uVar27 = CONCAT44(puVar17,uVar9);
        if (cVar23 == '\x01') {
          uVar27 = (*pcVar3)();
          pbVar11 = extraout_ECX_01;
        }
      }
      puVar17 = (uint *)(uVar27 >> 0x20);
      in_AF = (uVar27 & 0x1000) != 0;
      *in_EAX = *puVar21;
      in_EAX = (uint *)((int)in_EAX + 5);
      uVar9 = *in_EAX;
      goto code_r0x006c530d;
    }
    *(int *)(uVar10 + 0x4b) = *(int *)(uVar10 + 0x4b) - iVar18;
    uVar27 = CONCAT44(puVar17,iVar7) ^ 0x5c00;
code_r0x006c5332:
    uVar16 = (uint)(uVar27 >> 0x20);
    out(0xc4,(int)uVar27);
    uVar9 = uVar16 >> 0x18 | (uVar16 & 0xff0000) >> 8;
    uVar10 = in((short)uVar9);
    puVar17 = (uint *)((int)uVar10 >> 0x1f);
    if (*pbVar11 < (byte)pbVar11 || (uVar9 | (uVar16 & 0xff00) << 8 | uVar16 << 0x18) == 0xffffffff)
    {
      return uVar10;
    }
    iVar18 = (int)&param_12 + iVar18;
  }
  out((short)puVar17,(char)uVar9);
  param_3 = in_EAX + 1;
  uVar10 = in((short)puVar17);
  *in_EAX = uVar10;
  param_6 = &param_11;
  *(char *)puVar21 = *(char *)puVar21 >> ((byte)pbVar11 & 0x1f);
  bVar13 = (byte)puVar17 ^ *(byte *)(uVar9 + 0x1e73b51 + iVar18 * 8);
  if (bVar13 != 0) {
LAB_006c5379:
    *(uint **)(pbVar11 + 0x47326065) = param_3;
                    /* WARNING: Bad instruction - Truncating control flow here */
    halt_baddata();
  }
  *(char *)(uVar8 - 0x54) = *(char *)(uVar8 - 0x54) + -0x17;
  uVar10 = uVar9;
  puVar19 = (uint *)CONCAT31((int3)((uint)puVar17 >> 8),bVar13);
  unaff_retaddr = CONCAT31((int3)((uint)iVar18 >> 8),0xe5);
  in_EAX = param_3;
  param_5 = uVar8;
  param_7 = iVar18;
  param_8 = puVar17;
  param_9 = pbVar11;
  param_10 = uVar9;
  goto code_r0x006c5351;
}

