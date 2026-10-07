/* NR2003.exe @ 006c4b00 FUN_006c4b00 */

/* WARNING: Control flow encountered bad instruction data */
/* WARNING: Instruction at (ram,0x006c4dd8) overlaps instruction at (ram,0x006c4dd6)
    */
/* WARNING (jumptable): Unable to track spacebase fully for stack */
/* WARNING: Unable to track spacebase fully for stack */
/* WARNING: This function may have set the stack pointer */
/* WARNING: Removing unreachable block (ram,0x006c4f89) */
/* WARNING: Removing unreachable block (ram,0x006c4f8e) */
/* WARNING: Removing unreachable block (ram,0x006c4b17) */
/* WARNING: Removing unreachable block (ram,0x006c4ae9) */
/* WARNING: Removing unreachable block (ram,0x006c4af9) */
/* WARNING: Removing unreachable block (ram,0x006c4b23) */
/* WARNING: Removing unreachable block (ram,0x006c4b3c) */
/* WARNING: Removing unreachable block (ram,0x006c4b47) */
/* WARNING: Removing unreachable block (ram,0x006c4b6c) */
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
/* WARNING: Removing unreachable block (ram,0x006c4b95) */
/* WARNING: Removing unreachable block (ram,0x006c4bcc) */
/* WARNING: Removing unreachable block (ram,0x006c4be0) */
/* WARNING: Removing unreachable block (ram,0x006c4c1c) */
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined * __fastcall FUN_006c4b00(undefined4 param_1,undefined4 param_2,uint *param_3)

{
  byte *pbVar1;
  ushort *puVar2;
  byte bVar3;
  char cVar4;
  code *pcVar5;
  byte bVar6;
  byte bVar7;
  undefined4 in_EAX;
  char *pcVar8;
  uint uVar9;
  uint uVar10;
  undefined *puVar11;
  int3 iVar13;
  int iVar12;
  undefined3 uVar14;
  int extraout_ECX;
  int iVar15;
  int extraout_ECX_00;
  uint *puVar16;
  int extraout_ECX_01;
  undefined4 extraout_ECX_02;
  undefined4 extraout_ECX_03;
  undefined2 uVar17;
  undefined2 extraout_DX;
  undefined2 extraout_DX_00;
  int *piVar18;
  int iVar19;
  char cVar22;
  undefined4 unaff_EBX;
  undefined4 uVar20;
  undefined *puVar21;
  code **ppcVar23;
  code **ppcVar24;
  uint *puVar25;
  code **ppcVar26;
  uint *puVar27;
  int unaff_EBP;
  code *pcVar28;
  undefined *unaff_ESI;
  undefined4 *puVar29;
  code **ppcVar30;
  code **ppcVar31;
  ushort uVar32;
  undefined4 unaff_EDI;
  undefined4 *puVar33;
  undefined4 *puVar34;
  undefined2 in_ES;
  undefined2 in_CS;
  undefined2 in_DS;
  bool bVar35;
  bool bVar36;
  byte in_AF;
  bool bVar37;
  bool bVar38;
  float10 in_ST0;
  float10 extraout_ST0;
  float10 fVar39;
  undefined8 uVar40;
  
  puVar11 = unaff_ESI + 1;
  pcVar8 = (char *)CONCAT31((int3)((uint)in_EAX >> 8),*unaff_ESI);
  cVar22 = *pcVar8;
  *pcVar8 = *pcVar8 + '\x01';
  pcVar28 = (code *)swi(4);
  if (SCARRY1(cVar22,'\x01') == true) {
    uVar40 = (*pcVar28)();
    param_2 = (undefined4)((ulonglong)uVar40 >> 0x20);
    pcVar8 = (char *)uVar40;
    in_ST0 = extraout_ST0;
  }
  *(uint *)(pcVar8 + (int)puVar11 * 8) = *(uint *)(pcVar8 + (int)puVar11 * 8) & (uint)puVar11;
  *(undefined2 *)(param_3 + -1) = in_CS;
  fRamd7050eef = (float)in_ST0;
  bVar38 = true;
  param_3[-2] = (uint)pcVar8 ^ 0xc12fe3c6;
  param_3[-3] = 0xd7050eee;
  param_3[-4] = param_2;
  param_3[-5] = unaff_EBX;
  param_3[-6] = (uint)(param_3 + -1);
  param_3[-7] = unaff_EBP + 1;
  param_3[-8] = (uint)puVar11;
  param_3[-9] = unaff_EDI;
  out(0xf2,(uint)pcVar8 ^ 0xc12fe3c6);
  if (SCARRY4((int)puVar11,-0x657ba042) == SCARRY4((int)(unaff_ESI + -0x657ba041),0)) {
                    /* WARNING: Bad instruction - Truncating control flow here */
    halt_baddata();
  }
  puVar33 = (undefined4 *)param_3[-9];
  puVar29 = (undefined4 *)param_3[-8];
  pcVar28 = (code *)param_3[-7];
  uVar20 = param_3[-5];
  piVar18 = (int *)param_3[-4];
  uVar9 = param_3[-2];
  ppcVar24 = (code **)(param_3 + -1);
  puVar25 = param_3 + -1;
  ppcVar30 = (code **)(puVar29 + -1);
  out(*puVar29,(short)piVar18);
  if (-1 < (int)(unaff_ESI + -0x657ba041)) {
    in(0xf2);
    in(0x95);
                    /* WARNING: Bad instruction - Truncating control flow here */
    halt_baddata();
  }
  uVar10 = uVar9 + 0x74e19f9b;
  bVar6 = (byte)uVar10;
  if (uVar10 != 0 && -0x74e19f9c < (int)uVar9) {
    bVar35 = false;
    bVar37 = (int)(uVar10 & 0x88f7a331) < 0;
    bVar36 = (POPCOUNT(uVar10 & 0x31) & 1U) == 0;
    uRam719f88f7 = CONCAT22((short)(uVar10 >> 0x10),
                            CONCAT11(bVar37 << 7 | ((uVar10 & 0x88f7a331) == 0) << 6 | in_AF << 4 |
                                     bVar36 << 2,bVar6)) | 0x200;
    if (!bVar36) goto code_r0x006c4cfd;
  }
  else {
    *(code ***)(pcVar28 + -0x201077) = ppcVar30;
    pcVar28 = (code *)param_3[-1];
    bVar7 = 9 < (bVar6 & 0xf) | in_AF;
    bVar6 = bVar6 + bVar7 * '\x06';
    bVar38 = (bool)(0x90 < (bVar6 & 0xf0) | uVar9 < 0x8b1e6065 | bVar7 * (0xf9 < bVar6));
    puVar11 = (undefined *)CONCAT31((int3)(uVar10 >> 8),bVar6 + bVar38 * '`');
    iVar15 = CONCAT31((int3)((uint)uVar20 >> 8),0x48);
    if (!bVar38 && uVar10 != 0) {
      return puVar11;
    }
    piVar18 = (int *)0x5783845a;
    *(int *)((int)puVar29 + 0x3b) = (int)(*(int *)((int)puVar29 + 0x3b) + (int)puVar33);
    bVar38 = SCARRY4((int)ppcVar30,1);
    ppcVar30 = (code **)((int)puVar29 + -3);
    uVar9 = *param_3;
    ppcVar24 = (code **)(param_3 + 1);
    if (uVar9 == 1) {
      *param_3 = (uint)puVar11;
      do {
                    /* WARNING: Do nothing block with infinite loop */
      } while( true );
    }
    if (uVar9 == 1) goto LAB_006c4ce4;
    if (bVar38) goto LAB_006c4ce8;
    bVar38 = puVar11 != (undefined *)0xc2357cdd;
    if (uVar9 != 2 && bVar38) {
      *(undefined2 *)param_3 = in_CS;
      in_CS = 0x1c74;
      ppcVar23 = (code **)(param_3 + -1);
      param_3[-1] = 0x6c4c98;
      puVar11 = (undefined *)func_0x11429e47();
      pcVar28 = *ppcVar23;
      ppcVar24 = ppcVar23 + 1;
    }
    bVar38 = uVar9 == 2 || !bVar38;
    puVar33[-1] = puVar33[-1] & 0x479ae23b;
    *(int *)((int)ppcVar24 + iVar15 + 0x5d) =
         (int)((int)ppcVar30 +
              (uint)(((uint)puVar11 & 0x100) != 0) + *(int *)((int)ppcVar24 + iVar15 + 0x5d));
    pbVar1 = (byte *)(iVar15 + 0x2770866e);
    *pbVar1 = *pbVar1 & 0xc2;
    *(undefined *)((int)puVar33 + 0x517bfa71) = 0x48;
  }
  bVar35 = false;
  *ppcVar24 = (code *)0x6c4cb2;
  puVar11 = (undefined *)func_0xf14f1c31();
  iVar15 = extraout_ECX;
  if (bVar35) {
    puRam2770866e = puVar11;
    return puVar11;
  }
code_r0x006c4cb4:
  iVar13 = (int3)((uint)puVar11 >> 8);
  *(undefined4 *)((int)ppcVar24 + -4) = 0xffffffe2;
  iVar19 = (int)iVar13 >> 0x17;
  iVar15 = CONCAT31((int3)((uint)iVar15 >> 8),0x51);
  bVar6 = 0x81a479da < (CONCAT31(iVar13,(char)puVar11 + '\"') & 0xffffffa7);
  ppcVar31 = ppcVar30;
  puVar29 = puVar33;
  do {
    puVar2 = (ushort *)(iVar19 + -0xf);
    *puVar2 = *puVar2 + (ushort)bVar6 * (((ushort)ppcVar31 & 3) - (*puVar2 & 3));
    iVar12 = in(0x59);
    uVar40 = CONCAT44(iVar19,iVar12 + 1U);
    if (iVar15 == 0) {
LAB_006c4d57:
      puVar11 = (undefined *)((int)uVar40 + -1);
      *(uint *)((int)puVar29 + -0x1a) = *(uint *)((int)puVar29 + -0x1a) & (uint)puVar11;
      *(int *)(iVar15 + -0x2023dab4) = *(int *)(iVar15 + -0x2023dab4) + -1;
      out(*puVar11,(short)((ulonglong)uVar40 >> 0x20));
                    /* WARNING: Could not recover jumptable at 0x006c4d64. Too many branches */
                    /* WARNING: Treating indirect jump as call */
      puVar11 = (undefined *)(**ppcVar31)();
      return puVar11;
    }
    ppcVar30 = ppcVar31 + (uint)bVar38 * -2 + 1;
    out(*ppcVar31,(short)iVar19);
    puVar11 = (undefined *)(iVar12 + 1U ^ *(uint *)(iVar12 + 0x71 + (int)pcVar28 * 8));
    out(0x2c,(char)puVar11);
    _DAT_579d8159 = 0xffffffe2;
LAB_006c4ce4:
    piVar18 = (int *)((int)puVar11 >> 0x1f);
LAB_006c4ce8:
    *piVar18 = *piVar18 << 10;
    puVar25 = (uint *)&DAT_86615429;
    bVar37 = (_DAT_86615425 & 0x80) != 0;
    in_AF = (_DAT_86615425 & 0x10) != 0;
    bVar35 = (_DAT_86615425 & 1) != 0;
code_r0x006c4cfd:
    out(*(undefined *)ppcVar30,(short)piVar18);
    bVar38 = true;
    puVar33 = (undefined4 *)*puVar25;
    ppcVar30 = (code **)puVar25[1];
    pcVar28 = (code *)puVar25[2];
    puVar21 = (undefined *)puVar25[4];
    iVar19 = puVar25[5];
    iVar15 = puVar25[6];
    puVar11 = (undefined *)puVar25[7];
    ppcVar24 = (code **)(puVar25 + 7);
    puVar25[7] = iVar19;
    bVar7 = (byte)puVar21;
    if (!bVar37) break;
    puVar34 = puVar33 + -1;
    uVar17 = (undefined2)iVar19;
    uVar20 = in(uVar17);
    *puVar33 = uVar20;
    puVar27 = (uint *)((int)ppcVar30 + -0x7a);
    bVar6 = CARRY4(*puVar27,(uint)ppcVar30) ||
            CARRY4((uint)(undefined *)(*puVar27 + (int)ppcVar30),(uint)bVar35);
    *puVar27 = (uint)((undefined *)(*puVar27 + (int)ppcVar30) + bVar35);
    *(char *)(iVar19 + -7) = *(char *)(iVar19 + -7) + '\x01';
    puVar27 = puVar25 + 6;
    puVar25[6] = (uint)pcVar28;
    if (iVar15 != 0) {
      puVar29 = puVar33 + -2;
      uVar20 = in(uVar17);
      *puVar34 = uVar20;
      iVar15 = CONCAT22((short)((uint)iVar15 >> 0x10),
                        CONCAT11((byte)((uint)iVar15 >> 8) ^ *(byte *)(puVar29 + (int)puVar21 * 2),
                                 (char)iVar15));
      out(uVar17,puVar11);
      pbVar1 = puVar11 + 0x25cc844;
      bVar6 = CARRY1(*pbVar1,bVar7);
      bVar3 = *pbVar1;
      *pbVar1 = *pbVar1 + bVar7;
      if (SCARRY1(bVar3,bVar7)) {
        puVar27 = (uint *)puVar25[6];
        *(int *)((int)puVar27 + -4) = iVar15;
        *(undefined **)((int)ppcVar30 + 0x4b) = (undefined *)((int)puVar27 + -4);
        puVar16 = (uint *)((int)puVar33 + 0x122b603b);
        *puVar16 = *puVar16 | 0xffffffe3;
        if (iVar15 == 1) {
          puVar11 = puVar21 + 0x79;
          LOCK();
          *puVar21 = 0;
          UNLOCK();
          *(undefined **)(pcVar28 + 0x6c) = (undefined *)(*(int *)(pcVar28 + 0x6c) + (int)puVar29);
code_r0x006c4db3:
          *(uint *)(*(int *)((int)puVar27 + -4) + 0x50) =
               *(uint *)(*(int *)((int)puVar27 + -4) + 0x50) >> 0xb;
          return puVar11;
        }
        if ((int)*puVar16 < 1) {
          *(code ***)(pcVar28 + -0x200f9b) = ppcVar30;
          _DAT_0849366d = ppcVar30;
                    /* WARNING: Bad instruction - Truncating control flow here */
          halt_baddata();
        }
      }
      else {
        ppcVar30 = (code **)((int)ppcVar30 + 1);
        puVar27 = puVar25 + 5;
        *(undefined2 *)(puVar25 + 5) = in_DS;
code_r0x006c4d1a:
        uRam1e46af22 = SUB41(puVar11,0);
        *(undefined *)puVar29 = *(undefined *)ppcVar30;
        uVar9 = _DAT_6b78fd73;
        uVar32 = (ushort)(undefined *)((int)puVar29 + -1);
        puVar29 = (undefined4 *)
                  CONCAT22((short)((uint)(undefined *)((int)puVar29 + -1) >> 0x10),
                           uVar32 + (ushort)bVar6 * (((ushort)pcVar28 & 3) - (uVar32 & 3)));
        uVar20 = *puVar27;
        *puVar27 = iVar15;
        *(undefined2 *)((int *)puVar27 + -1) = in_ES;
        cVar22 = (char)((uint)uVar20 >> 8) + (char)iVar15;
        puVar21 = (undefined *)CONCAT22((short)((uint)uVar20 >> 0x10),CONCAT11(cVar22,(char)uVar20))
        ;
        puVar16 = (uint *)(iVar15 + -1);
        if ((puVar16 != (uint *)0x0 && cVar22 == '\0') && (puVar21 = puVar21 + 1, (int)puVar21 < 0))
        {
          puVar11 = (undefined *)(uVar9 | *puVar16);
          if (-1 < (int)puVar11) {
            cVar22 = '\0';
            if (puVar16 != (uint *)0x0) {
              ((int *)puVar27)[-1] = (int)puVar16;
              *(char *)(puVar29 + 1) = *(char *)(puVar29 + 1) + (char)((uint)puVar16 >> 8);
              uVar20 = in((short)iVar19);
              *puVar29 = uVar20;
              iVar15 = in(0xef);
              pbVar1 = (byte *)(iVar15 + 0x64edacf5);
              bVar6 = *pbVar1;
              bVar7 = (byte)((uint)iVar19 >> 8);
              *pbVar1 = *pbVar1 + bVar7;
              *(undefined **)(pcVar28 + -0x76) = (undefined *)((int)ppcVar30 + -2);
              *(int *)((int)puVar29 + -0x82) =
                   (int)((undefined *)((int)ppcVar30 + -2) +
                        (uint)CARRY1(bVar6,bVar7) + *(int *)((int)puVar29 + -0x82));
                    /* WARNING: Bad instruction - Truncating control flow here */
              halt_baddata();
            }
            *puVar27 = 0x6c4e9f;
            (*pcVar28)();
            pcVar5 = (code *)swi(4);
            uVar20 = extraout_ECX_02;
            uVar17 = extraout_DX;
            if (cVar22 == '\x01') {
              (*pcVar5)();
              uVar20 = extraout_ECX_03;
              uVar17 = extraout_DX_00;
            }
            puVar27[-1] = 0x8e5fbec0;
            pcVar5 = _DAT_c28ee074;
            puVar27[-2] = uVar20;
            uVar9 = puVar27[-2];
            bVar38 = (uVar9 & 0x400) != 0;
            out(*(undefined *)((int)ppcVar30 + -2),uVar17);
            if ((uVar9 & 0x40) == 0) {
              in(uVar17);
                    /* WARNING: Bad instruction - Truncating control flow here */
              halt_baddata();
            }
            uVar10 = (uint)((uVar9 & 1) != 0);
            bVar7 = ((char)pcVar5 + 'j') -
                    (pcVar28 < pcVar5 || (uint)((int)pcVar28 - (int)pcVar5) < uVar10);
            out(6,bVar7);
            bVar35 = 9 < (bVar7 & 0xf) || (uVar9 & 0x10) != 0;
            bVar7 = bVar7 + bVar35 * '\x06';
            bVar6 = bVar35 * (0xf9 < bVar7);
            bVar36 = 0x90 < (bVar7 & 0xf0);
            pcVar8 = (char *)(CONCAT31((int3)((uint)pcVar5 >> 8),bVar7 + (bVar36 | bVar6) * '`') +
                             (((int)pcVar28 - (int)pcVar5) - uVar10));
            cVar22 = *pcVar8;
            _DAT_1f68a8b0 = (undefined *)((int)ppcVar30 + (uint)bVar38 * -2 + -1);
            *pcVar8 = *pcVar8 + '\x01';
            cVar4 = *pcVar8;
            uVar20 = in(uVar17);
            *(undefined4 *)*puVar27 = uVar20;
            *puVar27 = (uint)((uVar9 & 0x4000) != 0) * 0x4000 | (uint)SCARRY1(cVar22,'\x01') * 0x800
                       | (uint)bVar38 * 0x400 | (uint)((uVar9 & 0x200) != 0) * 0x200 |
                       (uint)((uVar9 & 0x100) != 0) * 0x100 | (uint)(cVar4 < '\0') * 0x80 |
                       (uint)(cVar4 == '\0') * 0x40 | (uint)bVar35 * 0x10 |
                       (uint)((POPCOUNT(cVar4) & 1U) == 0) * 4 | (uint)(bVar36 | bVar6 & 1) |
                       (uint)((uVar9 & 0x200000) != 0) * 0x200000 |
                       (uint)((uVar9 & 0x40000) != 0) * 0x40000;
            pcVar28 = (code *)swi(0x16);
            (*pcVar28)();
            bVar6 = in(0x2f);
            return (undefined *)(uint)bVar6;
          }
          goto code_r0x006c4db3;
        }
        bVar38 = false;
        puVar27 = (uint *)((int *)puVar27 + -1);
        ppcVar30 = (code **)((int)ppcVar30 + -1);
code_r0x006c4d37:
        *(undefined2 *)((int)puVar27 + -4) = in_CS;
        in_CS = 0x1c74;
        ppcVar26 = (code **)((int)puVar27 + -8);
        *(undefined4 *)((int)puVar27 + -8) = 0x6c4d40;
        func_0x11429e47();
        pcVar28 = *ppcVar26;
        bVar35 = false;
        puVar21[0x71cf626e] = puVar21[0x71cf626e] & 0x45;
        *ppcVar26 = FUN_006c4d4f;
        uVar40 = func_0x40c63341();
        puVar27 = (uint *)&DAT_579d815d;
        uVar17 = (undefined2)((ulonglong)uVar40 >> 0x20);
        if (extraout_ECX_01 != 0) {
          ppcVar31 = (code **)((int)ppcVar30 + (uint)bVar38 * -2 + 1);
          out(*(undefined *)ppcVar30,uVar17);
          iVar15 = extraout_ECX_01;
          goto LAB_006c4d57;
        }
        out(uVar17,(int)uVar40);
        if (bVar35) goto code_r0x006c4dda;
      }
      uVar20 = *puVar27;
      *(char *)((int)ppcVar30 + 0x242cb41) = *(char *)((int)ppcVar30 + 0x242cb41) + '\x01';
      *(uint *)(pcVar28 + 0x5a98642c) = puVar27[1];
      *(byte *)((int)ppcVar30 + -0x43a341bd) = *(byte *)((int)ppcVar30 + -0x43a341bd) & (byte)uVar20
      ;
      puVar27 = (uint *)*(undefined6 *)((int)puVar29 * 8 + 0x7166ef57);
      in(0x96);
code_r0x006c4dda:
      *(undefined2 *)puVar27 = in_CS;
      *(undefined4 *)((int)puVar27 + -4) = 0x6c4df2;
      fVar39 = (float10)func_0x6c61e371();
      in(0xf2);
      puVar11 = (undefined *)in(0x95);
      *(float *)(puVar11 + 0x58004ff3) = (float)fVar39;
      return puVar11;
    }
    do {
      uVar40 = CONCAT44(iVar19,puVar11 + -1);
      pcVar5 = (code *)swi(4);
      if (SBORROW4((int)puVar11,1) == true) {
        uVar40 = (*pcVar5)();
        iVar15 = extraout_ECX_00;
      }
      iVar19 = (int)((ulonglong)uVar40 >> 0x20);
      in_AF = 9 < ((byte)uVar40 & 0xf) | in_AF;
      uVar14 = (undefined3)((ulonglong)uVar40 >> 8);
      bVar7 = (byte)uVar40 + in_AF * -6;
      bVar7 = bVar7 + (0x9f < bVar7 | bVar6 | in_AF * (bVar7 < 6)) * -0x60;
      pbVar1 = (byte *)(CONCAT31(uVar14,bVar7) + -0x5a7d0c95);
      bVar6 = CARRY1(bVar7,*pbVar1);
      bVar35 = SCARRY1(bVar7,*pbVar1);
      puVar11 = (undefined *)CONCAT31(uVar14,bVar7 + *pbVar1);
      puVar29 = puVar34;
      if (bVar35) goto code_r0x006c4d1a;
      if (!bVar35) {
        return puVar11;
      }
      if (!bVar35) {
        puVar33[-2] = puVar33[-2] - (int)puVar27;
        goto code_r0x006c4d37;
      }
      ppcVar31 = ppcVar30;
    } while (bVar35);
  } while( true );
  LOCK();
  puVar21[0x7e] = bVar7;
  UNLOCK();
  goto code_r0x006c4cb4;
}

