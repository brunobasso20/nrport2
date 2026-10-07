/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 006c5018 */

/* WARNING: Instruction at (ram,0x006c5019) overlaps instruction at (ram,0x006c5018)
    */
/* WARNING: Control flow encountered bad instruction data */
/* WARNING: Removing unreachable block (ram,0x006c50de) */
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

uint __fastcall
FUN_006c5018(int param_1,undefined6 *param_2,byte *param_3,undefined2 *param_4,byte *param_5,
            undefined4 param_6,int param_7,undefined4 param_8,int param_9,undefined4 param_10)

{
  char *pcVar1;
  uint *puVar2;
  code *pcVar3;
  byte bVar4;
  char cVar6;
  int in_EAX;
  uint uVar7;
  int3 iVar14;
  uint uVar8;
  byte **ppbVar9;
  undefined2 *puVar10;
  undefined4 uVar11;
  byte *pbVar12;
  byte **ppbVar13;
  int *piVar15;
  undefined1 *puVar16;
  int *extraout_ECX;
  undefined2 uVar17;
  undefined6 *extraout_EDX;
  int *unaff_EBX;
  int iVar18;
  byte *unaff_EBP;
  byte *pbVar19;
  undefined2 *unaff_ESI;
  int *piVar20;
  byte *unaff_EDI;
  byte *pbVar21;
  undefined2 in_DS;
  int in_GS_OFFSET;
  byte bVar22;
  bool bVar23;
  byte in_AF;
  bool bVar24;
  bool bVar25;
  bool bVar26;
  bool bVar27;
  undefined2 in_FPUControlWord;
  undefined2 in_FPUStatusWord;
  undefined2 in_FPUTagWord;
  undefined2 in_FPULastInstructionOpcode;
  undefined4 in_FPUDataPointer;
  float10 in_ST0;
  float10 fVar28;
  unkbyte10 in_ST1;
  unkbyte10 in_ST2;
  unkbyte10 in_ST3;
  unkbyte10 in_ST4;
  unkbyte10 in_ST5;
  unkbyte10 in_ST6;
  unkbyte10 in_ST7;
  int aiStack_6a [11];
  byte *pbStack_3c;
  int *piStack_38;
  byte *pbStack_34;
  undefined1 *puStack_30;
  int iStack_2c;
  undefined6 *puStack_28;
  undefined1 *puStack_24;
  byte *pbStack_20;
  undefined6 *puStack_1c;
  byte *pbStack_18;
  byte bVar5;
  
  fVar28 = in_ST0 - (float10)*(short *)(unaff_EBP + 0x6b);
  uVar8 = CONCAT31((int3)((uint)(in_EAX + 1) >> 8),(char)(in_EAX + 1) + -0x51);
  while( true ) {
    pbVar19 = unaff_EBP;
    pbVar21 = unaff_EDI + (int)unaff_EBX * 8;
    *pbVar21 = *pbVar21 ^ 0xde;
    piVar15 = (int *)CONCAT31((int3)((uint)unaff_EBX >> 8),0x51);
    uVar7 = uVar8 & 0xffffffa4;
    if ('\0' < (char)*pbVar21) {
      out(*(undefined1 *)unaff_ESI,(short)param_2);
      return uVar8 & 0x930560a0;
    }
    while( true ) {
      pbVar21 = (byte *)segment(in_DS,(short)piVar15 + (short)unaff_ESI + -0x55);
      bVar4 = *pbVar21;
      *pbVar21 = *pbVar21 + 0x51;
      bVar5 = (byte)uVar7;
      in_AF = 9 < (bVar5 & 0xf) | in_AF;
      iVar14 = (int3)(uVar7 >> 8);
      bVar4 = bVar5 + in_AF * '\x06' + (0x99 < bVar5 || 0xae < bVar4) * '`';
      param_1 = CONCAT31((int3)((uint)param_1 >> 8),*(undefined1 *)(param_1 + (int)pbVar19 * 8));
      unaff_EBP = unaff_EDI + 1;
      bVar24 = bVar4 == *unaff_EDI;
      if ((char)(bVar4 - *unaff_EDI) < '\0') break;
      pcVar1 = (char *)(CONCAT31(iVar14,bVar4) - 0x55);
      *pcVar1 = *pcVar1 + 'Q';
      uVar7 = CONCAT31(iVar14,bVar4);
      unaff_EDI = unaff_EBP;
    }
    if (!bVar24) {
      *(undefined2 *)((int)param_2 + -0x61) = in_FPUControlWord;
      ppbVar9 = (byte **)_DAT_c5ab81ff;
      goto code_r0x006c50eb;
    }
    uVar17 = (undefined2)((uint)param_2 >> 0x10);
    if (!bVar24) break;
    param_1 = param_1 + -1;
    bVar5 = (byte)((uint)unaff_EBX >> 8);
    if (param_1 == 0 || bVar24) {
      bVar4 = (byte)((uint)param_2 >> 8) ^ (byte)param_1;
      pbVar21 = (byte *)CONCAT22((short)((uint)unaff_EBX >> 0x10),CONCAT11(bVar5 + bVar4,0x51));
      *(byte *)(CONCAT22(uVar17,CONCAT11(bVar4,(char)param_2)) + -0x1cbccfcc) = bVar5 + bVar4;
      *pbVar21 = *pbVar21 << 1 | CARRY1(bVar5,bVar4);
      goto LAB_006c5092;
    }
    pbVar21 = (byte *)((int)param_2 + param_1 * 2);
    *pbVar21 = *pbVar21 | bVar5;
    param_2 = (undefined6 *)((int)iVar14 >> 0x17);
    uVar8 = *(int *)(in_GS_OFFSET +
                    CONCAT31((int3)(CONCAT22((short)(uVar7 >> 0x10),CONCAT11(bVar4 / 0xe3,bVar4)) >>
                                   8),bVar4 % 0xe3 + 0x22) + 0x2c) * 0x51;
    unaff_EBX = piVar15;
    unaff_EDI = pbVar19;
  }
  in_AF = 9 < (bVar4 & 0xf) | in_AF;
  bVar24 = 0x99 < bVar4 || bVar4 < *unaff_EDI;
  cVar6 = bVar4 + in_AF * -6 + bVar24 * -0x60;
  ppbVar9 = (byte **)CONCAT31(iVar14,cVar6);
  param_2 = (undefined6 *)CONCAT22(uVar17,CONCAT11(0xd9,(char)param_2));
  if (cVar6 == '\0') {
    param_5 = pbVar19 + 1;
    param_4 = unaff_ESI;
code_r0x006c5104:
    aiStack_6a[(int)param_5 * 2] = (int)(aiStack_6a[(int)param_5 * 2] + (int)param_4);
    *param_4 = in_FPUControlWord;
    param_4[2] = in_FPUStatusWord;
    param_4[4] = in_FPUTagWord;
    *(undefined4 *)(param_4 + 10) = in_FPUDataPointer;
    *(code **)(param_4 + 6) = FUN_006c5018;
    param_4[9] = in_FPULastInstructionOpcode;
    *(float10 *)(param_4 + 0xe) = fVar28;
    *(unkbyte10 *)(param_4 + 0x13) = in_ST1;
    *(unkbyte10 *)(param_4 + 0x18) = in_ST2;
    *(unkbyte10 *)(param_4 + 0x1d) = in_ST3;
    *(unkbyte10 *)(param_4 + 0x22) = in_ST4;
    *(unkbyte10 *)(param_4 + 0x27) = in_ST5;
    *(unkbyte10 *)(param_4 + 0x2c) = in_ST6;
    *(unkbyte10 *)(param_4 + 0x31) = in_ST7;
  }
  else if (bVar24) {
    if ((POPCOUNT(*(char *)((int)ppbVar9 + 0x31bd8a00) + -0x51) & 1U) != 0) {
      (*(code *)((int)piVar15 + -0x5d))();
      *piVar15 = *piVar15 - (int)unaff_ESI;
                    /* WARNING: Bad instruction - Truncating control flow here */
      halt_baddata();
    }
code_r0x006c50eb:
    do {
      puVar10 = (undefined2 *)ppbVar9;
      bVar24 = (byte)unaff_ESI < 0x91;
      bVar5 = (byte)param_2;
      bVar4 = -bVar5 - 0x1c;
      bVar22 = 0xe4 < bVar5 || bVar4 < bVar24;
      cVar6 = bVar4 - bVar24;
      piVar15 = (int *)CONCAT22(0x8b00,CONCAT11(cVar6,0x8d));
      if ((SBORROW1(-0x1c,bVar5) != SBORROW1(bVar4,bVar24)) != cVar6 < '\0') {
        pcVar1 = (char *)(CONCAT31((int3)((uint)unaff_ESI >> 8),(byte)unaff_ESI + 0x6f) + 0x433034ba
                         );
        cVar6 = *pcVar1;
        *pcVar1 = *pcVar1 + -1;
        goto code_r0x006c5100;
      }
      ppbVar9 = (byte **)(iRam7ad9f982 * -0x7e005e61);
      pbVar21 = unaff_EBP + 4;
      *(byte ***)unaff_EBP = ppbVar9;
      iVar18 = (int)*param_2;
      piVar20 = piVar15;
      unaff_ESI = puVar10;
      unaff_EBP = pbVar21;
    } while (cVar6 < '\0');
    goto LAB_006c513f;
  }
  pcVar3 = (code *)swi(1);
  uVar8 = (*pcVar3)();
  return uVar8;
code_r0x006c5100:
  if (-1 < *pcVar1) goto LAB_006c50c9;
  if (*pcVar1 == '\0') goto code_r0x006c5104;
  param_8 = 0x61433034;
  goto code_r0x006c5100;
LAB_006c50c9:
  ppbVar9 = (byte **)CONCAT31((int3)((uint)param_10 >> 8),*(undefined1 *)param_4);
  if (!SBORROW1(cVar6,'\x01')) {
    pcVar3 = (code *)swi(0x6a);
    uVar11 = (*pcVar3)();
    bVar4 = (byte)uVar11;
    puVar2 = (uint *)(CONCAT31((int3)((uint)uVar11 >> 8),
                               bVar4 + (9 < (bVar4 & 0xf) | in_AF) * -6 +
                               (0x99 < bVar4 | bVar22) * -0x60) + -0x32c2e6d6);
    *puVar2 = *puVar2 >> 1 | (uint)((*puVar2 & 1) != 0) << 0x1f;
                    /* WARNING: Bad instruction - Truncating control flow here */
    halt_baddata();
  }
  pbVar19 = param_5 + -1;
  piVar15 = (int *)(param_9 + -1);
  if (piVar15 == (int *)0x0) {
    if ((int)param_5 < 1) {
                    /* WARNING: Bad instruction - Truncating control flow here */
      halt_baddata();
    }
LAB_006c5092:
    pcVar3 = (code *)swi(1);
    uVar8 = (*pcVar3)();
    return uVar8;
  }
  param_2 = (undefined6 *)CONCAT22((short)((uint)param_8 >> 0x10),CONCAT11(0xbd,(char)param_8));
  iVar18 = param_7;
  piVar20 = (int *)((int)param_4 + 1);
  pbVar21 = param_3;
LAB_006c513f:
  do {
    bVar4 = (byte)ppbVar9;
    ppbVar9 = (byte **)((uint)ppbVar9 | 0x5e);
  } while (-1 < (char)(bVar4 | 0x5e));
  pbVar12 = *(byte **)((int)piVar20 + 0x35f69845);
  bVar24 = pbVar21 < pbVar12;
  bVar27 = SBORROW4((int)pbVar21,(int)pbVar12);
  uVar8 = (int)pbVar21 - (int)pbVar12;
  bVar26 = (int)uVar8 < 0;
  bVar25 = uVar8 == 0;
  bVar23 = (POPCOUNT(uVar8 & 0xff) & 1U) == 0;
  do {
    pbStack_18 = pbVar19;
    pbStack_20 = pbVar21;
    if (bVar27 == bVar26) {
      if (bVar25) {
        pbVar21[-0x1a0cc2e4] = pbVar21[-0x1a0cc2e4] + 1;
        param_2 = (undefined6 *)((int)param_2 + -1);
      }
      pbVar12 = (byte *)in(0x22);
      *piVar20 = *piVar20 << 10;
      puVar16 = (undefined1 *)((int)piVar15 + -1);
      if (puVar16 != (undefined1 *)0x0 && *piVar20 != 0) {
        bVar4 = (byte)pbVar12;
        ppbVar13 = (byte **)CONCAT31((int3)((uint)pbVar12 >> 8),
                                     bVar4 + (9 < (bVar4 & 0xf) | in_AF) * -6 +
                                     (0x99 < bVar4) * -0x60);
        goto code_r0x006c51b5;
      }
      if ((SBORROW1((char)pbVar21,'=') !=
          SBORROW1((char)pbVar21 + -0x3d,(byte)((uint)param_2 >> 8) < (byte)((uint)iVar18 >> 8))) !=
          *piVar20 < 0) {
        puStack_1c = (undefined6 *)0x6c5165;
        (**(code **)((int)param_2 + 0x29))();
                    /* WARNING: Bad instruction - Truncating control flow here */
        halt_baddata();
      }
      puStack_1c = param_2;
      pbVar19 = (byte *)(CONCAT22((short)((uint)ppbVar9 >> 0x10),
                                  CONCAT11(bVar26 << 7 | bVar25 << 6 | in_AF << 4 | bVar23 << 2 | 2
                                           | bVar24,(char)ppbVar9)) - (int)pbVar12);
      if ((undefined1 *)((int)piVar15 + -2) == (undefined1 *)0x0 || pbVar19 == (byte *)0x0) {
        *(double *)(piVar20 + -0x1a03b339) = (double)fVar28;
        puStack_1c = (undefined6 *)&DAT_d5cd4996;
        DAT_d5cd4996 = in((short)param_2);
        out(*(undefined1 *)((int)piVar20 + *(int *)((int)piVar20 + -0x1d988ced)),(short)param_2);
        pcVar3 = (code *)swi(1);
        uVar8 = (*pcVar3)();
        return uVar8;
      }
      (&stack0x1709ae5e)[(int)piVar20 * 8] = (&stack0x1709ae5e)[(int)piVar20 * 8] & 0x55;
      pbVar21 = (byte *)((int)piVar20 + -1);
      if (pbVar21 != (byte *)0x0 && 0 < (int)piVar20) {
        *(char *)(piVar20 + -0x1d907086) = (char)piVar20[-0x1d907086] >> 1;
        if (param_2 == (undefined6 *)0x1) {
          out(*piVar20,0);
          out((char)piVar20[1],0);
          out(0,pbVar12);
                    /* WARNING: Bad instruction - Truncating control flow here */
          halt_baddata();
        }
                    /* WARNING: Bad instruction - Truncating control flow here */
        halt_baddata();
      }
      pcVar3 = (code *)swi(0x7b);
      pbStack_3c = pbVar21;
      piStack_38 = piVar20;
      pbStack_34 = pbVar19;
      puStack_30 = (undefined1 *)&puStack_1c;
      iStack_2c = iVar18;
      puStack_28 = param_2;
      puStack_24 = (undefined1 *)((int)piVar15 + -2);
      pbStack_20 = pbVar12;
      fVar28 = (float10)(*pcVar3)();
      bVar4 = (byte)(iVar18 + -1);
      bVar24 = CARRY1(bVar4,bVar4);
      bVar27 = SCARRY1(bVar4,bVar4);
      cVar6 = bVar4 * '\x02';
      iVar18 = CONCAT31((int3)((uint)(iVar18 + -1) >> 8),cVar6);
      bVar26 = cVar6 < '\0';
      bVar25 = cVar6 == '\0';
      bVar23 = (POPCOUNT(cVar6) & 1U) == 0;
      piVar15 = extraout_ECX;
      param_2 = extraout_EDX;
    }
    ppbVar9 = &pbStack_20;
    ppbVar13 = &pbStack_20;
    param_2 = (undefined6 *)CONCAT22((short)((uint)param_2 >> 0x10),CONCAT11(0x9d,(char)param_2));
    piVar15 = (int *)((int)piVar15 + -1);
    puVar16 = (undefined1 *)0x0;
    if (piVar15 == (int *)0x0) {
code_r0x006c51b5:
      puVar2 = (uint *)((int)ppbVar13 * 8 + -0x673982ba);
      bVar4 = (byte)puVar16 & 0x1f;
      *puVar2 = *puVar2 << bVar4 | *puVar2 >> 0x20 - bVar4;
      uVar8 = in(0x22);
      _DAT_2f67f838 = (undefined1 *)ppbVar13;
      *piVar20 = *piVar20 << 10;
      return uVar8;
    }
  } while( true );
}


