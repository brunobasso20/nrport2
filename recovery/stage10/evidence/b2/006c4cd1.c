/* NR2003.exe @ 006c4cd1 FUN_006c4cd1 */

/* WARNING: Instruction at (ram,0x006c4dd8) overlaps instruction at (ram,0x006c4dd6)
    */
/* WARNING: Control flow encountered bad instruction data */
/* WARNING (jumptable): Stack frame is not setup normally: Input value of stackpointer is not used
    */
/* WARNING: Stack frame is not setup normally: Input value of stackpointer is not used */
/* WARNING: This function may have set the stack pointer */
/* WARNING: Removing unreachable block (ram,0x006c4f89) */
/* WARNING: Removing unreachable block (ram,0x006c4f8e) */
/* WARNING: Removing unreachable block (ram,0x006c4f19) */
/* WARNING: Removing unreachable block (ram,0x006c4f23) */
/* WARNING: Removing unreachable block (ram,0x006c4f7c) */
/* WARNING: Removing unreachable block (ram,0x006c4f40) */
/* WARNING: Removing unreachable block (ram,0x006c4f62) */
/* WARNING: Removing unreachable block (ram,0x006c4f65) */
/* WARNING: Removing unreachable block (ram,0x006c4fd9) */
/* WARNING: Removing unreachable block (ram,0x006c4f46) */
/* WARNING: Removing unreachable block (ram,0x006c4f90) */
/* WARNING: Removing unreachable block (ram,0x006c4f9b) */
/* WARNING: Removing unreachable block (ram,0x006c4f9d) */
/* WARNING: Removing unreachable block (ram,0x006c4fae) */
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined * __fastcall FUN_006c4cd1(code *param_1,undefined *param_2)

{
  byte *pbVar1;
  char *pcVar2;
  ushort *puVar3;
  char cVar4;
  uint uVar5;
  bool bVar6;
  bool bVar7;
  code *pcVar8;
  undefined4 *puVar9;
  byte bVar10;
  uint in_EAX;
  uint uVar11;
  undefined3 uVar15;
  undefined *puVar12;
  undefined *puVar13;
  int iVar14;
  code *extraout_ECX;
  uint *puVar16;
  code *extraout_ECX_00;
  undefined4 extraout_ECX_01;
  undefined4 extraout_ECX_02;
  undefined4 uVar17;
  undefined2 uVar18;
  undefined2 extraout_DX;
  undefined2 extraout_DX_00;
  char cVar19;
  code **ppcVar20;
  code **ppcVar21;
  code *pcVar22;
  code *unaff_EBP;
  code **unaff_ESI;
  code **ppcVar23;
  ushort uVar24;
  undefined4 *unaff_EDI;
  undefined4 *puVar25;
  undefined2 in_ES;
  undefined2 in_CS;
  undefined2 in_DS;
  byte bVar26;
  byte bVar27;
  byte bVar28;
  bool bVar29;
  float10 fVar30;
  undefined8 uVar31;
  undefined6 uVar32;
  
  bVar28 = 0;
  do {
    uVar32 = CONCAT24((short)param_2,in_EAX);
    if (param_1 == (code *)0x0) {
LAB_006c4d57:
      puVar12 = (undefined *)((int)uVar32 + -1);
      *(uint *)((int)unaff_EDI + -0x1a) = *(uint *)((int)unaff_EDI + -0x1a) & (uint)puVar12;
      *(int *)(param_1 + -0x2023dab4) = *(int *)(param_1 + -0x2023dab4) + -1;
      out(*puVar12,(short)((uint6)uVar32 >> 0x20));
                    /* WARNING: Could not recover jumptable at 0x006c4d64. Too many branches */
                    /* WARNING: Treating indirect jump as call */
      puVar12 = (undefined *)(**unaff_ESI)();
      return puVar12;
    }
    out(*unaff_ESI,(short)param_2);
    uVar11 = in_EAX ^ *(uint *)(in_EAX + 0x70 + (int)unaff_EBP * 8);
    out(0x2c,(char)uVar11);
    _DAT_579d8159 = 0xffffffe2;
    *(int *)((int)uVar11 >> 0x1f) = *(int *)((int)uVar11 >> 0x1f) << 10;
    puVar13 = _DAT_86615445;
    param_1 = _DAT_86615441;
    param_2 = _DAT_8661543d;
    puVar12 = _DAT_86615439;
    unaff_EBP = _DAT_86615431;
    ppcVar23 = _DAT_8661542d;
    puVar9 = _DAT_86615429;
    bVar27 = (_DAT_86615425 & 0x10) != 0;
    bVar26 = (_DAT_86615425 & 1) != 0;
    out(*(undefined *)(unaff_ESI + (uint)bVar28 * -2 + 1),(short)((int)uVar11 >> 0x1f));
    bVar28 = 1;
    _DAT_86615445 = _DAT_8661543d;
    bVar10 = (byte)_DAT_86615439;
    if ((_DAT_86615425 & 0x80) == 0) {
      LOCK();
      _DAT_86615439[0x7e] = bVar10;
      UNLOCK();
      unaff_EDI = puVar9;
    }
    else {
      puVar25 = _DAT_86615429 + -1;
      uVar18 = SUB42(_DAT_8661543d,0);
      uVar17 = in(uVar18);
      *_DAT_86615429 = uVar17;
      puVar16 = (uint *)((int)ppcVar23 + -0x7a);
      uVar11 = (uint)bVar26;
      bVar26 = CARRY4(*puVar16,(uint)ppcVar23) ||
               CARRY4((uint)(undefined *)(*puVar16 + (int)ppcVar23),uVar11);
      *puVar16 = (uint)((undefined *)(*puVar16 + (int)ppcVar23) + uVar11);
      param_2[-7] = param_2[-7] + '\x01';
      ppcVar20 = (code **)&DAT_86615441;
      _DAT_86615441 = unaff_EBP;
      if (param_1 != (code *)0x0) {
        unaff_EDI = puVar9 + -2;
        uVar17 = in(uVar18);
        *puVar25 = uVar17;
        param_1 = (code *)CONCAT22((short)((uint)param_1 >> 0x10),
                                   CONCAT11((byte)((uint)param_1 >> 8) ^
                                            *(byte *)(unaff_EDI + (int)puVar12 * 2),(char)param_1));
        out(uVar18,puVar13);
        pbVar1 = puVar13 + 0x25cc844;
        bVar26 = CARRY1(*pbVar1,bVar10);
        bVar28 = *pbVar1;
        *pbVar1 = *pbVar1 + bVar10;
        ppcVar20 = (code **)_DAT_86615441;
        if (SCARRY1(bVar28,bVar10)) {
          pcVar22 = _DAT_86615441 + -4;
          *(code **)(_DAT_86615441 + -4) = param_1;
          *(code **)((int)ppcVar23 + 0x4b) = pcVar22;
          puVar16 = (uint *)((int)puVar9 + 0x122b603b);
          *puVar16 = *puVar16 | 0xffffffe3;
          if (param_1 == (code *)0x1) {
            puVar13 = puVar12 + 0x79;
            LOCK();
            *puVar12 = 0;
            UNLOCK();
            *(undefined **)(unaff_EBP + 0x6c) =
                 (undefined *)(*(int *)(unaff_EBP + 0x6c) + (int)unaff_EDI);
code_r0x006c4db3:
            *(uint *)(*(int *)((int)ppcVar20 + -4) + 0x50) =
                 *(uint *)(*(int *)((int)ppcVar20 + -4) + 0x50) >> 0xb;
            return puVar13;
          }
          if ((int)*puVar16 < 1) {
            *(code ***)(unaff_EBP + -0x200f9b) = ppcVar23;
            _DAT_0849366d = ppcVar23;
                    /* WARNING: Bad instruction - Truncating control flow here */
            halt_baddata();
          }
        }
        else {
          ppcVar23 = (code **)((int)ppcVar23 + 1);
          ppcVar20 = (code **)&DAT_8661543d;
          _DAT_8661543d = (undefined *)CONCAT22(DAT_8661543d_2,in_DS);
code_r0x006c4d1a:
          uRam1e46af22 = SUB41(puVar13,0);
          *(undefined *)unaff_EDI = *(undefined *)ppcVar23;
          uVar11 = _DAT_6b78fd73;
          uVar24 = (ushort)(undefined *)((int)unaff_EDI + -1);
          unaff_EDI = (undefined4 *)
                      CONCAT22((short)((uint)(undefined *)((int)unaff_EDI + -1) >> 0x10),
                               uVar24 + (ushort)bVar26 * (((ushort)unaff_EBP & 3) - (uVar24 & 3)));
          uVar17 = *ppcVar20;
          *ppcVar20 = param_1;
          *(undefined2 *)(ppcVar20 + -1) = in_ES;
          cVar19 = (char)((uint)uVar17 >> 8) + (char)param_1;
          puVar12 = (undefined *)
                    CONCAT22((short)((uint)uVar17 >> 0x10),CONCAT11(cVar19,(char)uVar17));
          puVar16 = (uint *)(param_1 + -1);
          if ((puVar16 != (uint *)0x0 && cVar19 == '\0') &&
             (puVar12 = puVar12 + 1, (int)puVar12 < 0)) {
            puVar13 = (undefined *)(uVar11 | *puVar16);
            if (-1 < (int)puVar13) {
              cVar19 = '\0';
              if (puVar16 != (uint *)0x0) {
                ppcVar20[-1] = (code *)puVar16;
                *(char *)(unaff_EDI + 1) = *(char *)(unaff_EDI + 1) + (char)((uint)puVar16 >> 8);
                uVar17 = in((short)param_2);
                *unaff_EDI = uVar17;
                iVar14 = in(0xef);
                pbVar1 = (byte *)(iVar14 + 0x64edacf5);
                bVar28 = *pbVar1;
                bVar27 = (byte)((uint)param_2 >> 8);
                *pbVar1 = *pbVar1 + bVar27;
                *(undefined **)(unaff_EBP + -0x76) = (undefined *)((int)ppcVar23 + -2);
                *(int *)((int)unaff_EDI + -0x82) =
                     (int)((undefined *)((int)ppcVar23 + -2) +
                          (uint)CARRY1(bVar28,bVar27) + *(int *)((int)unaff_EDI + -0x82));
                    /* WARNING: Bad instruction - Truncating control flow here */
                halt_baddata();
              }
              *ppcVar20 = (code *)0x6c4e9f;
              (*unaff_EBP)();
              pcVar8 = (code *)swi(4);
              uVar17 = extraout_ECX_01;
              uVar18 = extraout_DX;
              if (cVar19 == '\x01') {
                (*pcVar8)();
                uVar17 = extraout_ECX_02;
                uVar18 = extraout_DX_00;
              }
              ppcVar20[-1] = (code *)0x8e5fbec0;
              pcVar8 = _DAT_c28ee074;
              ppcVar20[-2] = (code *)uVar17;
              uVar11 = (uint)ppcVar20[-2];
              bVar29 = (uVar11 & 0x400) != 0;
              out(*(undefined *)((int)ppcVar23 + -2),uVar18);
              if ((uVar11 & 0x40) == 0) {
                in(uVar18);
                    /* WARNING: Bad instruction - Truncating control flow here */
                halt_baddata();
              }
              uVar5 = (uint)((uVar11 & 1) != 0);
              bVar27 = ((char)pcVar8 + 'j') -
                       (unaff_EBP < pcVar8 || (uint)((int)unaff_EBP - (int)pcVar8) < uVar5);
              out(6,bVar27);
              bVar6 = 9 < (bVar27 & 0xf) || (uVar11 & 0x10) != 0;
              bVar27 = bVar27 + bVar6 * '\x06';
              bVar28 = bVar6 * (0xf9 < bVar27);
              bVar7 = 0x90 < (bVar27 & 0xf0);
              pcVar2 = (char *)(CONCAT31((int3)((uint)pcVar8 >> 8),bVar27 + (bVar7 | bVar28) * '`')
                               + (((int)unaff_EBP - (int)pcVar8) - uVar5));
              cVar19 = *pcVar2;
              _DAT_1f68a8b0 = (undefined *)((int)ppcVar23 + (uint)bVar29 * -2 + -1);
              *pcVar2 = *pcVar2 + '\x01';
              cVar4 = *pcVar2;
              uVar17 = in(uVar18);
              *(undefined4 *)*ppcVar20 = uVar17;
              *ppcVar20 = (code *)((uint)((uVar11 & 0x4000) != 0) * 0x4000 |
                                   (uint)SCARRY1(cVar19,'\x01') * 0x800 | (uint)bVar29 * 0x400 |
                                   (uint)((uVar11 & 0x200) != 0) * 0x200 |
                                   (uint)((uVar11 & 0x100) != 0) * 0x100 |
                                   (uint)(cVar4 < '\0') * 0x80 | (uint)(cVar4 == '\0') * 0x40 |
                                   (uint)bVar6 * 0x10 | (uint)((POPCOUNT(cVar4) & 1U) == 0) * 4 |
                                   (uint)(bVar7 | bVar28 & 1) |
                                   (uint)((uVar11 & 0x200000) != 0) * 0x200000 |
                                  (uint)((uVar11 & 0x40000) != 0) * 0x40000);
              pcVar8 = (code *)swi(0x16);
              (*pcVar8)();
              bVar28 = in(0x2f);
              return (undefined *)(uint)bVar28;
            }
            goto code_r0x006c4db3;
          }
          bVar28 = 0;
          ppcVar20 = ppcVar20 + -1;
          ppcVar23 = (code **)((int)ppcVar23 + -1);
code_r0x006c4d37:
          *(undefined2 *)((int)ppcVar20 + -4) = in_CS;
          in_CS = 0x1c74;
          ppcVar21 = (code **)((int)ppcVar20 + -8);
          *(undefined4 *)((int)ppcVar20 + -8) = 0x6c4d40;
          func_0x11429e47();
          unaff_EBP = *ppcVar21;
          bVar29 = false;
          puVar12[0x71cf626e] = puVar12[0x71cf626e] & 0x45;
          *ppcVar21 = FUN_006c4d4f;
          uVar32 = func_0x40c63341();
          uVar18 = (undefined2)((uint6)uVar32 >> 0x20);
          ppcVar20 = (code **)&DAT_579d815d;
          if (extraout_ECX_00 != (code *)0x0) {
            unaff_ESI = (code **)((int)ppcVar23 + (uint)bVar28 * -2 + 1);
            out(*(undefined *)ppcVar23,uVar18);
            param_1 = extraout_ECX_00;
            goto LAB_006c4d57;
          }
          out(uVar18,(int)uVar32);
          if (bVar29) goto code_r0x006c4dda;
        }
        uVar17 = *ppcVar20;
        *(char *)((int)ppcVar23 + 0x242cb41) = *(char *)((int)ppcVar23 + 0x242cb41) + '\x01';
        *(code **)(unaff_EBP + 0x5a98642c) = ppcVar20[1];
        *(byte *)((int)ppcVar23 + -0x43a341bd) =
             *(byte *)((int)ppcVar23 + -0x43a341bd) & (byte)uVar17;
        ppcVar20 = (code **)*(undefined6 *)((int)unaff_EDI * 8 + 0x7166ef57);
        in(0x96);
code_r0x006c4dda:
        *(undefined2 *)ppcVar20 = in_CS;
        *(undefined4 *)((int)ppcVar20 + -4) = 0x6c4df2;
        fVar30 = (float10)func_0x6c61e371();
        in(0xf2);
        puVar12 = (undefined *)in(0x95);
        *(float *)(puVar12 + 0x58004ff3) = (float)fVar30;
        return puVar12;
      }
      do {
        uVar31 = CONCAT44(param_2,puVar13 + -1);
        pcVar8 = (code *)swi(4);
        if (SBORROW4((int)puVar13,1) == true) {
          uVar31 = (*pcVar8)();
          param_1 = extraout_ECX;
        }
        param_2 = (undefined *)((ulonglong)uVar31 >> 0x20);
        bVar27 = 9 < ((byte)uVar31 & 0xf) | bVar27;
        uVar15 = (undefined3)((ulonglong)uVar31 >> 8);
        bVar10 = (byte)uVar31 + bVar27 * -6;
        bVar10 = bVar10 + (0x9f < bVar10 | bVar26 | bVar27 * (bVar10 < 6)) * -0x60;
        pbVar1 = (byte *)(CONCAT31(uVar15,bVar10) + -0x5a7d0c95);
        bVar26 = CARRY1(bVar10,*pbVar1);
        bVar29 = SCARRY1(bVar10,*pbVar1);
        puVar13 = (undefined *)CONCAT31(uVar15,bVar10 + *pbVar1);
        unaff_EDI = puVar25;
        if (bVar29) goto code_r0x006c4d1a;
        if (!bVar29) {
          return puVar13;
        }
        if (!bVar29) {
          puVar9[-2] = puVar9[-2] - (int)ppcVar20;
          goto code_r0x006c4d37;
        }
      } while (bVar29);
    }
    puVar3 = (ushort *)(param_2 + -0xf);
    *puVar3 = *puVar3 + (ushort)bVar26 * (((ushort)ppcVar23 & 3) - (*puVar3 & 3));
    iVar14 = in(0x59);
    in_EAX = iVar14 + 1;
    unaff_ESI = ppcVar23;
  } while( true );
}

