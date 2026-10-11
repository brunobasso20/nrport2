/* NR2003.exe @ 006c5018 FUN_006c5018 */

/* WARNING: Instruction at (ram,0x006c5019) overlaps instruction at (ram,0x006c5018)
    */
/* WARNING: Control flow encountered bad instruction data */
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

uint __fastcall
FUN_006c5018(int param_1,undefined6 *param_2,undefined4 *param_3,undefined2 *param_4,
            undefined *param_5,undefined4 param_6,int param_7,undefined4 param_8,int param_9,
            undefined4 param_10)

{
  char *pcVar1;
  uint *puVar2;
  code *pcVar3;
  byte bVar4;
  byte bVar5;
  int in_EAX;
  uint uVar6;
  int3 iVar13;
  uint uVar7;
  undefined4 **ppuVar8;
  undefined2 *puVar9;
  undefined4 uVar10;
  undefined4 *puVar11;
  undefined4 **ppuVar12;
  char cVar16;
  int *piVar14;
  int *piVar15;
  int *extraout_ECX;
  undefined2 uVar17;
  undefined6 *extraout_EDX;
  int *unaff_EBX;
  byte *pbVar18;
  int iVar19;
  undefined4 *unaff_EBP;
  undefined4 *puVar20;
  undefined2 *unaff_ESI;
  int *piVar21;
  undefined4 *unaff_EDI;
  undefined4 *puVar22;
  undefined2 in_DS;
  int in_GS_OFFSET;
  bool bVar23;
  byte bVar24;
  byte in_AF;
  bool bVar25;
  bool bVar26;
  bool bVar27;
  bool bVar28;
  undefined2 in_FPUControlWord;
  undefined2 in_FPUStatusWord;
  undefined2 in_FPUTagWord;
  undefined2 in_FPULastInstructionOpcode;
  undefined4 in_FPUDataPointer;
  undefined4 in_FPUInstructionPointer;
  float10 in_ST0;
  float10 fVar29;
  unkbyte10 in_ST1;
  unkbyte10 in_ST2;
  unkbyte10 in_ST3;
  unkbyte10 in_ST4;
  unkbyte10 in_ST5;
  unkbyte10 in_ST6;
  unkbyte10 in_ST7;
  int aiStack_6a [11];
  undefined4 *puStack_3c;
  int *piStack_38;
  undefined4 *puStack_34;
  undefined6 **ppuStack_30;
  int iStack_2c;
  undefined6 *puStack_28;
  undefined *puStack_24;
  undefined4 *puStack_20;
  undefined6 *puStack_1c;
  undefined4 *puStack_18;
  
  fVar29 = in_ST0 - (float10)*(short *)((int)unaff_EBP + 0x6b);
  uVar7 = CONCAT31((int3)((uint)(in_EAX + 1) >> 8),(char)(in_EAX + 1) + -0x51);
  while( true ) {
    puVar20 = unaff_EBP;
    puVar22 = unaff_EDI + (int)unaff_EBX * 2;
    *(byte *)puVar22 = *(byte *)puVar22 ^ 0xde;
    piVar14 = (int *)CONCAT31((int3)((uint)unaff_EBX >> 8),0x51);
    uVar6 = uVar7 & 0xffffffa4;
    if ('\0' < (char)*(byte *)puVar22) {
      out(*(undefined *)unaff_ESI,(short)param_2);
      return uVar7 & 0x930560a0;
    }
    while( true ) {
      pbVar18 = (byte *)segment(in_DS,(short)piVar14 + (short)unaff_ESI + -0x55);
      bVar5 = *pbVar18;
      *pbVar18 = *pbVar18 + 0x51;
      in_AF = 9 < ((byte)uVar6 & 0xf) | in_AF;
      iVar13 = (int3)(uVar6 >> 8);
      bVar4 = (byte)uVar6 + in_AF * '\x06';
      bVar4 = bVar4 + (0x90 < (bVar4 & 0xf0) | 0xae < bVar5 | in_AF * (0xf9 < bVar4)) * '`';
      bVar5 = *(byte *)(param_1 + (int)puVar20 * 8);
      param_1 = CONCAT31((int3)((uint)param_1 >> 8),bVar5);
      unaff_EBP = (undefined4 *)((int)unaff_EDI + 1);
      bVar23 = bVar4 < *(byte *)unaff_EDI;
      cVar16 = bVar4 - *(char *)unaff_EDI;
      bVar25 = cVar16 == '\0';
      if (cVar16 < '\0') break;
      pcVar1 = (char *)(CONCAT31(iVar13,bVar4) - 0x55);
      *pcVar1 = *pcVar1 + 'Q';
      uVar6 = CONCAT31(iVar13,bVar4);
      unaff_EDI = unaff_EBP;
    }
    if (!bVar25) {
      *(undefined2 *)((int)param_2 + -0x61) = in_FPUControlWord;
      ppuVar8 = (undefined4 **)_DAT_c5ab81ff;
      goto code_r0x006c50eb;
    }
    if ((POPCOUNT(cVar16) & 1U) != 0) {
      bVar23 = bVar5 < 0xd9;
      bVar25 = (byte)(bVar5 + 0x27) == '\0';
      ppuVar8 = (undefined4 **)_DAT_c5ab81ff;
      if ((POPCOUNT(bVar5 + 0x27) & 1U) != 0) goto code_r0x006c50eb;
    }
    uVar17 = (undefined2)((uint)param_2 >> 0x10);
    if (!bVar25) break;
    param_1 = param_1 + -1;
    bVar5 = (byte)((uint)unaff_EBX >> 8);
    if (param_1 == 0 || bVar25) {
      bVar4 = (byte)((uint)param_2 >> 8) ^ (byte)param_1;
      pbVar18 = (byte *)CONCAT22((short)((uint)unaff_EBX >> 0x10),CONCAT11(bVar5 + bVar4,0x51));
      *(byte *)(CONCAT22(uVar17,CONCAT11(bVar4,(char)param_2)) + -0x1cbccfcc) = bVar5 + bVar4;
      *pbVar18 = *pbVar18 << 1 | CARRY1(bVar5,bVar4);
      goto LAB_006c5092;
    }
    pbVar18 = (byte *)((int)param_2 + param_1 * 2);
    *pbVar18 = *pbVar18 | bVar5;
    param_2 = (undefined6 *)((int)iVar13 >> 0x17);
    uVar7 = *(int *)(in_GS_OFFSET +
                    CONCAT31((int3)(CONCAT22((short)(uVar6 >> 0x10),CONCAT11(bVar4 / 0xe3,bVar4)) >>
                                   8),bVar4 % 0xe3 + 0x22) + 0x2c) * 0x51;
    unaff_EBX = piVar14;
    unaff_EDI = puVar20;
  }
  in_AF = 9 < (bVar4 & 0xf) | in_AF;
  bVar4 = bVar4 + in_AF * -6;
  bVar23 = (bool)(0x9f < bVar4 | bVar23 | in_AF * (bVar4 < 6));
  ppuVar8 = (undefined4 **)CONCAT31(iVar13,bVar4 + bVar23 * -0x60);
  param_2 = (undefined6 *)CONCAT22(uVar17,CONCAT11(0xd9,(char)param_2));
  if (bVar25) {
    param_5 = (undefined *)((int)puVar20 + 1);
    param_4 = unaff_ESI;
code_r0x006c5104:
    aiStack_6a[(int)param_5 * 2] = (int)(aiStack_6a[(int)param_5 * 2] + (int)param_4);
    *param_4 = in_FPUControlWord;
    param_4[2] = in_FPUStatusWord;
    param_4[4] = in_FPUTagWord;
    *(undefined4 *)(param_4 + 10) = in_FPUDataPointer;
    *(undefined4 *)(param_4 + 6) = in_FPUInstructionPointer;
    param_4[9] = in_FPULastInstructionOpcode;
    *(float10 *)(param_4 + 0xe) = fVar29;
    *(unkbyte10 *)(param_4 + 0x13) = in_ST1;
    *(unkbyte10 *)(param_4 + 0x18) = in_ST2;
    *(unkbyte10 *)(param_4 + 0x1d) = in_ST3;
    *(unkbyte10 *)(param_4 + 0x22) = in_ST4;
    *(unkbyte10 *)(param_4 + 0x27) = in_ST5;
    *(unkbyte10 *)(param_4 + 0x2c) = in_ST6;
    *(unkbyte10 *)(param_4 + 0x31) = in_ST7;
  }
  else if (bVar23 || bVar25) {
    if ((POPCOUNT(*(char *)((int)ppuVar8 + 0x31bd8a00) + -0x51) & 1U) != 0) {
      (*(code *)((int)piVar14 + -0x5d))();
      *piVar14 = *piVar14 - (int)unaff_ESI;
                    /* WARNING: Bad instruction - Truncating control flow here */
      halt_baddata();
    }
code_r0x006c50eb:
    do {
      puVar9 = (undefined2 *)ppuVar8;
      bVar25 = (byte)unaff_ESI < 0x91;
      bVar4 = (byte)param_2;
      bVar5 = -bVar4 - 0x1c;
      bVar24 = 0xe4 < bVar4 || bVar5 < bVar25;
      cVar16 = bVar5 - bVar25;
      piVar14 = (int *)CONCAT22(0x8b00,CONCAT11(cVar16,0x8d));
      if ((SBORROW1(-0x1c,bVar4) != SBORROW1(bVar5,bVar25)) != cVar16 < '\0') {
        pcVar1 = (char *)(CONCAT31((int3)((uint)unaff_ESI >> 8),(byte)unaff_ESI + 0x6f) + 0x433034ba
                         );
        cVar16 = *pcVar1;
        *pcVar1 = *pcVar1 + -1;
        goto code_r0x006c5100;
      }
      ppuVar8 = (undefined4 **)(iRam7ad9f982 * -0x7e005e61);
      puVar22 = unaff_EBP + 1;
      *unaff_EBP = ppuVar8;
      iVar19 = (int)*param_2;
      piVar21 = piVar14;
      unaff_ESI = puVar9;
      unaff_EBP = puVar22;
    } while (cVar16 < '\0');
    goto LAB_006c513f;
  }
  pcVar3 = (code *)swi(1);
  uVar7 = (*pcVar3)();
  return uVar7;
code_r0x006c5100:
  if (*pcVar1 >= '\0') goto LAB_006c50c9;
  if (*pcVar1 == '\0') goto code_r0x006c5104;
  param_8 = 0x61433034;
  goto code_r0x006c5100;
LAB_006c50c9:
  ppuVar8 = (undefined4 **)CONCAT31((int3)((uint)param_10 >> 8),*(undefined *)param_4);
  if (SBORROW1(cVar16,'\x01') == *pcVar1 < '\0') {
    pcVar3 = (code *)swi(0x6a);
    uVar10 = (*pcVar3)();
    bVar5 = 9 < ((byte)uVar10 & 0xf) | in_AF;
    bVar4 = (byte)uVar10 + bVar5 * -6;
    puVar2 = (uint *)(CONCAT31((int3)((uint)uVar10 >> 8),
                               bVar4 + (0x9f < bVar4 | bVar24 | bVar5 * (bVar4 < 6)) * -0x60) +
                     -0x32c2e6d6);
    *puVar2 = *puVar2 >> 1 | (uint)((*puVar2 & 1) != 0) << 0x1f;
                    /* WARNING: Bad instruction - Truncating control flow here */
    halt_baddata();
  }
  puVar20 = (undefined4 *)(param_5 + -1);
  piVar14 = (int *)(param_9 + -1);
  if (piVar14 == (int *)0x0) {
    if ((int)param_5 < 1) {
                    /* WARNING: Bad instruction - Truncating control flow here */
      halt_baddata();
    }
LAB_006c5092:
    pcVar3 = (code *)swi(1);
    uVar7 = (*pcVar3)();
    return uVar7;
  }
  param_2 = (undefined6 *)CONCAT22((short)((uint)param_8 >> 0x10),CONCAT11(0xbd,(char)param_8));
  iVar19 = param_7;
  piVar21 = (int *)((int)param_4 + 1);
  puVar22 = param_3;
LAB_006c513f:
  do {
    bVar5 = (byte)ppuVar8;
    ppuVar8 = (undefined4 **)((uint)ppuVar8 | 0x5e);
  } while (-1 < (char)(bVar5 | 0x5e));
  puVar11 = *(undefined4 **)((int)piVar21 + 0x35f69845);
  bVar25 = puVar22 < puVar11;
  bVar28 = SBORROW4((int)puVar22,(int)puVar11);
  uVar7 = (int)puVar22 - (int)puVar11;
  bVar27 = (int)uVar7 < 0;
  bVar26 = uVar7 == 0;
  bVar23 = (POPCOUNT(uVar7 & 0xff) & 1U) == 0;
  do {
    puStack_18 = puVar20;
    puStack_20 = puVar22;
    if (bVar28 == bVar27) {
      if (bVar26) {
        *(char *)(puVar22 + -0x68330b9) = *(char *)(puVar22 + -0x68330b9) + '\x01';
        param_2 = (undefined6 *)((int)param_2 + -1);
      }
      puVar11 = (undefined4 *)in(0x22);
      *piVar21 = *piVar21 << 10;
      piVar15 = (int *)((int)piVar14 + -1);
      if (piVar15 != (int *)0x0 && *piVar21 != 0) {
        bVar5 = 9 < ((byte)puVar11 & 0xf) | in_AF;
        bVar4 = (byte)puVar11 + bVar5 * -6;
        ppuVar12 = (undefined4 **)
                   CONCAT31((int3)((uint)puVar11 >> 8),
                            bVar4 + (0x9f < bVar4 | bVar5 * (bVar4 < 6)) * -0x60);
        goto code_r0x006c51b5;
      }
      if ((SBORROW1((char)puVar22,'=') !=
          SBORROW1((char)puVar22 + -0x3d,(byte)((uint)param_2 >> 8) < (byte)((uint)iVar19 >> 8))) !=
          *piVar21 < 0) {
        puStack_1c = (undefined6 *)0x6c5165;
        (**(code **)((int)param_2 + 0x29))();
                    /* WARNING: Bad instruction - Truncating control flow here */
        halt_baddata();
      }
      puStack_1c = param_2;
      puVar20 = (undefined4 *)
                (CONCAT22((short)((uint)ppuVar8 >> 0x10),
                          CONCAT11(bVar27 << 7 | bVar26 << 6 | in_AF << 4 | bVar23 << 2 | 2 | bVar25
                                   ,(char)ppuVar8)) - (int)puVar11);
      if ((undefined *)((int)piVar14 + -2) == (undefined *)0x0 || puVar20 == (undefined4 *)0x0) {
        *(double *)(piVar21 + -0x1a03b339) = (double)fVar29;
        puStack_1c = (undefined6 *)&DAT_d5cd4996;
        DAT_d5cd4996 = in((short)param_2);
        out(*(undefined *)((int)piVar21 + *(int *)((int)piVar21 + -0x1d988ced)),(short)param_2);
        pcVar3 = (code *)swi(1);
        uVar7 = (*pcVar3)();
        return uVar7;
      }
      (&stack0x1709ae5e)[(int)piVar21 * 8] = (&stack0x1709ae5e)[(int)piVar21 * 8] & 0x55;
      puVar22 = (undefined4 *)((int)piVar21 + -1);
      if (puVar22 != (undefined4 *)0x0 && 0 < (int)piVar21) {
        *(char *)(piVar21 + -0x1d907086) = *(char *)(piVar21 + -0x1d907086) >> 1;
        if (param_2 != (undefined6 *)0x1) {
                    /* WARNING: Bad instruction - Truncating control flow here */
          halt_baddata();
        }
        out(*piVar21,0);
        out(*(undefined *)(piVar21 + 1),0);
        out(0,puVar11);
                    /* WARNING: Bad instruction - Truncating control flow here */
        halt_baddata();
      }
      pcVar3 = (code *)swi(0x7b);
      puStack_3c = puVar22;
      piStack_38 = piVar21;
      puStack_34 = puVar20;
      ppuStack_30 = &puStack_1c;
      iStack_2c = iVar19;
      puStack_28 = param_2;
      puStack_24 = (undefined *)((int)piVar14 + -2);
      puStack_20 = puVar11;
      fVar29 = (float10)(*pcVar3)();
      bVar5 = (byte)(iVar19 + -1);
      bVar25 = CARRY1(bVar5,bVar5);
      bVar28 = SCARRY1(bVar5,bVar5);
      cVar16 = bVar5 * '\x02';
      iVar19 = CONCAT31((int3)((uint)(iVar19 + -1) >> 8),cVar16);
      bVar27 = cVar16 < '\0';
      bVar26 = cVar16 == '\0';
      bVar23 = (POPCOUNT(cVar16) & 1U) == 0;
      piVar14 = extraout_ECX;
      param_2 = extraout_EDX;
    }
    ppuVar8 = &puStack_20;
    ppuVar12 = &puStack_20;
    param_2 = (undefined6 *)CONCAT22((short)((uint)param_2 >> 0x10),CONCAT11(0x9d,(char)param_2));
    piVar15 = (int *)((int)piVar14 + -1);
    piVar14 = piVar15;
    if (piVar15 == (int *)0x0) {
code_r0x006c51b5:
      puVar2 = (uint *)((int)ppuVar12 * 8 + -0x673982ba);
      bVar5 = (byte)piVar15 & 0x1f;
      *puVar2 = *puVar2 << bVar5 | *puVar2 >> 0x20 - bVar5;
      uVar7 = in(0x22);
      _DAT_2f67f838 = (undefined *)ppuVar12;
      *piVar21 = *piVar21 << 10;
      return uVar7;
    }
  } while( true );
}

