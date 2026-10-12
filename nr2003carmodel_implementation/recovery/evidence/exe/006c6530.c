/* NR2003.exe @ 006c6530 FUN_006c6530 */

/* WARNING: Control flow encountered bad instruction data */
/* WARNING: Instruction at (ram,0x006c6560) overlaps instruction at (ram,0x006c655c)
    */
/* WARNING: Unable to track spacebase fully for stack */
/* WARNING: Removing unreachable block (ram,0x006c6601) */
/* WARNING: Removing unreachable block (ram,0x006c6634) */
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

uint __fastcall FUN_006c6530(int param_1,undefined4 param_2)

{
  code *pcVar1;
  byte bVar2;
  char cVar3;
  short sVar4;
  int in_EAX;
  undefined *puVar5;
  uint uVar6;
  uint uVar7;
  byte bVar8;
  undefined4 extraout_ECX;
  uint *extraout_ECX_00;
  uint *puVar10;
  uint *puVar11;
  int *unaff_EBX;
  uint *puVar12;
  int unaff_EBP;
  byte *pbVar13;
  undefined4 *unaff_ESI;
  undefined4 *puVar14;
  byte *pbVar15;
  byte **unaff_EDI;
  byte **ppbVar16;
  undefined4 *puVar17;
  undefined2 in_ES;
  byte in_CF;
  bool bVar18;
  undefined uVar19;
  byte in_AF;
  undefined in_ZF;
  char in_SF;
  char in_OF;
  char cVar20;
  undefined2 in_FPUControlWord;
  float10 in_ST0;
  float10 extraout_ST0;
  float10 extraout_ST0_00;
  float10 in_ST1;
  float10 extraout_ST1;
  float10 extraout_ST1_00;
  float10 in_ST2;
  float10 in_ST3;
  float10 in_ST4;
  float10 in_ST5;
  float10 in_ST6;
  float10 in_ST7;
  ulonglong uVar21;
  undefined8 uVar22;
  uint *puStack_2c;
  uint *puStack_28;
  byte **ppbStack_24;
  undefined4 *puStack_20;
  int iStack_1c;
  undefined4 *puStack_18;
  undefined4 uStack_14;
  uint *puStack_10;
  byte **ppbStack_c;
  undefined4 uStack_8;
  undefined4 uStack_4;
  uint uVar9;
  
  do {
    uVar21 = CONCAT44(param_2,in_EAX);
    ppbVar16 = unaff_EDI;
    if ((bool)in_ZF || in_OF != in_SF) {
      uStack_4 = 0x34f99699;
      uStack_8 = CONCAT22(uStack_8._2_2_,in_ES);
      bVar8 = (byte)in_EAX - 0x2b;
      cVar3 = bVar8 + in_CF;
      puVar5 = (undefined *)
               CONCAT22((short)((uint)in_EAX >> 0x10),
                        CONCAT11((cVar3 < '\0') << 7 | (cVar3 == '\0') << 6 | in_AF << 4 |
                                 ((POPCOUNT(cVar3) & 1U) == 0) << 2 | 2 |
                                 (0x2a < (byte)in_EAX || CARRY1(bVar8,in_CF)),cVar3));
      ppbVar16 = (byte **)((int)unaff_EDI + 1);
      *(undefined *)unaff_EDI = *puVar5;
      pcVar1 = (code *)swi(0x39);
      uVar21 = (*pcVar1)();
      unaff_ESI = (undefined4 *)(puVar5 + 2);
      out(puVar5[1],(short)(uVar21 >> 0x20));
      param_1 = CONCAT22((short)((uint)extraout_ECX >> 0x10),CONCAT11(0xc4,(char)extraout_ECX));
      in_ST0 = extraout_ST0;
      in_ST1 = extraout_ST1;
    }
    puVar11 = (uint *)(uVar21 >> 0x20);
    uVar6 = (uint)uVar21 & 0xf42e1fc;
    if ((uVar21 & 0xf42e1fc) == 0) {
                    /* WARNING: Bad instruction - Truncating control flow here */
      halt_baddata();
    }
    bVar8 = (byte)((uint)unaff_EBX >> 8);
    bVar18 = CARRY1((byte)unaff_EBX,bVar8);
    cVar3 = (byte)unaff_EBX + bVar8;
    uStack_14 = CONCAT31((int3)((uint)unaff_EBX >> 8),cVar3);
    puStack_18 = &uStack_4;
    uStack_4 = 0xffffffcf;
    for (; param_1 != 0; param_1 = param_1 + -1) {
      *(byte *)ppbVar16 = *(byte *)unaff_ESI;
      unaff_ESI = (undefined4 *)((int)unaff_ESI + 1);
      ppbVar16 = (byte **)((int)ppbVar16 + 1);
    }
    DAT_f6375191 = (undefined)uVar6;
    ppbStack_c = (byte **)0x0;
    puStack_28 = (uint *)0x0;
    ppbStack_24 = ppbVar16;
    puStack_20 = unaff_ESI;
    iStack_1c = unaff_EBP;
    puVar17 = &uStack_4;
    puStack_10 = puVar11;
    uStack_8 = uVar6;
    if ((POPCOUNT(cVar3) & 1U) != 0) {
LAB_006c65b2:
      do {
        puVar17 = (undefined4 *)((int)ppbVar16 + -1);
        puVar10 = (uint *)((uint)&puStack_20 | 0xdb00);
        unaff_ESI = (undefined4 *)0xab196341;
        puVar12 = (uint *)CONCAT22(0x2258,CONCAT11(*(char *)puVar10 + '\'',0x6c));
        while( true ) {
          bVar18 = false;
          uVar7 = (uint)puVar10 | *(uint *)((int)unaff_ESI + 0x16f9e01e);
          uVar19 = (POPCOUNT(uVar7 & 0xff) & 1U) == 0;
          uVar6 = CONCAT31((int3)(uVar7 >> 8),3);
          ppbVar16 = (byte **)((int)puVar17 + 1);
          bVar8 = in((short)puVar11);
          *(byte *)puVar17 = bVar8;
          if (uVar7 == 0) break;
          if (uVar7 != 0) {
            return uVar6;
          }
          puVar10 = (uint *)((int)puVar11 + 1);
          if ((POPCOUNT((uint)puVar10 & 0xff) & 1U) != 0) {
            puStack_28 = puVar12;
            if (puVar10 != (uint *)0x0) {
              *(longlong *)((int)puVar11 + 0x41) = (longlong)ROUND(in_ST0);
              puVar11 = puVar10;
              in_ST0 = in_ST1;
              in_ST1 = in_ST2;
              in_ST2 = in_ST3;
              in_ST3 = in_ST4;
              in_ST4 = in_ST5;
              in_ST5 = in_ST6;
              in_ST6 = in_ST7;
              goto LAB_006c65b2;
            }
            if (-1 < (int)puVar10) {
              return uStack_8;
            }
            in_AF = 9 < (in_AF * '\x06' + 3 & 0xf) | in_AF;
            puStack_2c = puVar12;
            goto LAB_006c6501;
          }
          while( true ) {
            pbVar13 = (byte *)((int)puVar12 + (int)ppbVar16 * 4 + 0x45);
            bVar2 = ((byte)puStack_28 & 0x1f) % 9;
            bVar8 = *pbVar13;
            *pbVar13 = (byte)(CONCAT11(uVar6 < 0x580e4c6,bVar8) >> bVar2) | bVar8 << 9 - bVar2;
            puVar17 = (undefined4 *)*ppbStack_24;
            puVar14 = (undefined4 *)ppbStack_24[1];
            uVar7 = (uint)ppbStack_24[2];
            puVar12 = (uint *)ppbStack_24[4];
            puVar11 = (uint *)ppbStack_24[5];
            puStack_28 = (uint *)ppbStack_24[6];
            uVar6 = (uint)ppbStack_24[7];
            cVar20 = '\0';
            *puVar12 = *puVar12 & uVar6;
            cVar3 = (int)*puVar12 < 0;
            uVar19 = (POPCOUNT(*puVar12 & 0xff) & 1U) == 0;
            if (*puVar12 != 0) {
              *(int *)((int)puVar11 + 0xa33d225) = *(int *)((int)puVar11 + 0xa33d225) - (int)puVar11
              ;
              *puVar11 = *puVar11 + (int)puStack_28;
              return uVar7;
            }
            swi(4);
            if (!(bool)uVar19) break;
            ppbVar16 = (byte **)(puVar17 + 1);
            unaff_ESI = puVar14 + 1;
            *puVar17 = *puVar14;
            puStack_2c = (uint *)0x6c65de;
            uVar22 = func_0xaa17a3e9();
            puVar11 = (uint *)((ulonglong)uVar22 >> 0x20);
            uVar6 = (uint)uVar22;
            in_ST0 = extraout_ST0_00;
            in_ST1 = extraout_ST1_00;
            if (cVar20 == cVar3) {
              sVar4 = (short)(char)uVar22 * (short)(char)*(byte *)unaff_ESI;
              uVar6 = CONCAT22((short)((ulonglong)uVar22 >> 0x10),sVar4);
              bVar18 = (char)sVar4 != sVar4;
              puStack_28 = extraout_ECX_00;
              goto LAB_006c6561_1;
            }
            *(undefined2 *)((int)puVar14 + -0x3c84bd3b) = in_FPUControlWord;
            puStack_28 = extraout_ECX_00;
          }
          bVar8 = (byte)puStack_28 & 0x1f;
          uVar9 = *(uint *)(uVar7 + 0x100f3237);
          *(uint *)(uVar7 + 0x100f3237) = uVar9 >> bVar8 | uVar9 << 0x21 - bVar8;
          uVar9 = (uint)puVar12 >> 0x10;
          uVar19 = SUB41(puVar12,0);
          cVar3 = *(char *)((int)puVar14 + 1);
          unaff_ESI = (undefined4 *)((int)puVar17 + -0x67101f8a);
          *(byte *)unaff_ESI =
               *(byte *)unaff_ESI << 3 |
               (byte)(CONCAT11((int)(uVar7 >> 0x11 | uVar7 << 0xf) < 0,*(byte *)unaff_ESI) >> 6);
          puVar10 = (uint *)(CONCAT22((short)(uVar6 >> 0x10),
                                      (short)cVar3 * (short)*(char *)(puVar11 + 0x17)) | 0x50a70000)
          ;
          puVar12 = puStack_28;
          if ((int)(CONCAT22((short)uVar9,CONCAT11(199,uVar19)) ^ *puVar10) < 1) {
            puVar11 = (uint *)segment(puStack_28._0_2_,0xe040);
            *puVar11 = *puVar11 ^ 0xffffff96;
                    /* WARNING: Bad instruction - Truncating control flow here */
            halt_baddata();
          }
        }
LAB_006c6561_1:
        puVar17 = puStack_18;
      } while (!(bool)uVar19);
    }
    puStack_18 = puVar17;
    bVar8 = *(byte *)ppbVar16;
    _DAT_35daa652 = uVar6;
    *(uint *)((int)unaff_ESI + 1) = *(uint *)((int)unaff_ESI + 1) & (uint)puVar11;
    puStack_28 = puVar11;
    if ((int)&puStack_2c < 0) {
      out(0xe8,((char)uVar6 + bVar18 + '\x1f') - (*(byte *)unaff_ESI < bVar8));
                    /* WARNING: Bad instruction - Truncating control flow here */
      halt_baddata();
    }
LAB_006c6501:
    *(char *)(iStack_1c + 0x55) =
         *(char *)(iStack_1c + 0x55) + (char)((uint)((int)puStack_10 + 1) >> 8);
    in_AF = 9 < ((byte)puStack_18 & 7) | in_AF;
    pbVar15 = *ppbStack_c;
    unaff_EBX = (int *)ppbStack_c[4];
    param_2 = ppbStack_c[5];
    bVar8 = (byte)ppbStack_c[6];
    uVar9 = CONCAT31((int3)((uint)ppbStack_c[6] >> 8),bVar8 - *(byte *)unaff_EBX);
    in_EAX = (int)ppbStack_c[7] + 1;
    pbVar13 = (byte *)((int)ppbStack_c[1] + *unaff_EBX + (uint)(bVar8 < *(byte *)unaff_EBX));
    *(undefined *)(uVar9 + 0x72a585b1) = 0;
    unaff_EDI = (byte **)(pbVar15 + 1);
    unaff_ESI = (undefined4 *)(pbVar13 + 1);
    unaff_EBP = -0x16e98fd9;
    uVar6 = (uint)(*pbVar13 < *pbVar15);
    uVar7 = uVar9 + _DAT_992c3f53;
    in_CF = CARRY4(uVar9,_DAT_992c3f53) || CARRY4(uVar7,uVar6);
    in_OF = SCARRY4(uVar9,_DAT_992c3f53) != SCARRY4(uVar7,uVar6);
    param_1 = uVar7 + uVar6;
    in_SF = param_1 < 0;
    in_ZF = param_1 == 0;
  } while( true );
}

