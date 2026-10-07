/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 006c6df0 */

/* WARNING: Control flow encountered bad instruction data */
/* WARNING: Instruction at (ram,0x006c6d8e) overlaps instruction at (ram,0x006c6d8d)
    */

undefined8 __fastcall FUN_006c6df0(byte *param_1,undefined4 param_2)

{
  uint *puVar1;
  code cVar2;
  code *pcVar4;
  byte bVar5;
  char cVar6;
  byte bVar7;
  undefined4 in_EAX;
  code cVar9;
  undefined4 extraout_ECX;
  undefined4 uVar10;
  byte *extraout_ECX_00;
  byte *pbVar11;
  short sVar12;
  uint unaff_EBP;
  code *pcVar13;
  code *unaff_ESI;
  undefined2 in_CS;
  bool bVar14;
  bool bVar15;
  byte in_AF;
  byte in_TF;
  byte in_IF;
  byte in_NT;
  byte in_AC;
  byte in_VIF;
  byte in_VIP;
  byte in_ID;
  undefined8 uVar16;
  undefined2 uVar17;
  uint unaff_retaddr;
  code cVar3;
  byte bVar8;
  
  uVar16 = CONCAT44(param_2,in_EAX);
  do {
    uVar10 = CONCAT22((short)((ulonglong)uVar16 >> 0x10),
                      (ushort)(byte)((char)uVar16 + (char)((ulonglong)uVar16 >> 8) * -0x46));
    bVar15 = false;
    pbVar11 = param_1 + -1;
    if (pbVar11 == (byte *)0x0 || (char)((ulonglong)uVar16 >> 0x20) != (char)param_1) {
                    /* WARNING: Bad instruction - Truncating control flow here */
      halt_baddata();
    }
    while( true ) {
      bVar8 = (byte)uVar10;
      bVar5 = bVar8 + 0x92;
      bVar14 = bVar8 < 0x6e || bVar5 < bVar15;
      bVar7 = bVar5 - bVar15;
      *param_1 = bVar7;
      if (bVar7 == 0 || (SBORROW1(bVar8,'n') != SBORROW1(bVar5,bVar15)) != (char)bVar7 < '\0') {
        if (pbVar11 + *(int *)(unaff_EBP + 0x89d8d7f9) != (byte *)0x0) {
          param_1[1] = bVar7;
          param_1[2] = bVar7;
          return CONCAT44(unaff_retaddr,CONCAT31((int3)((uint)uVar10 >> 8),bVar7));
        }
        sVar12 = (short)unaff_retaddr + 1;
        in(sVar12);
        out(sVar12,&stack0x0000000c);
      }
      else {
        pcVar4 = unaff_ESI + 0x20;
        cVar2 = *pcVar4;
        cVar9 = SUB41(pbVar11,0);
        cVar3 = *pcVar4;
        bVar5 = (char)*pcVar4 - (char)cVar9;
        *pcVar4 = (code)(bVar5 - bVar14);
        in_AF = 9 < (bVar7 & 0xf) | in_AF;
        bVar15 = 0x99 < bVar7 || ((byte)cVar2 < (byte)cVar9 || bVar5 < bVar14);
        if (pbVar11 != (byte *)0x0) {
          if ((SBORROW1((char)cVar3,(char)cVar9) != SBORROW1(bVar5,bVar14)) !=
              (char)(bVar7 + in_AF * -6 + bVar15 * -0x60) < '\0') {
            if (pbVar11 == (byte *)0x1) {
                    /* WARNING: Bad instruction - Truncating control flow here */
              halt_baddata();
            }
                    /* WARNING: Bad instruction - Truncating control flow here */
            halt_baddata();
          }
          cVar6 = (char)(CONCAT11(bVar15,cVar9) >> 1);
          if ((int)unaff_ESI < -1) {
                    /* WARNING: Bad instruction - Truncating control flow here */
            halt_baddata();
          }
          param_1[CONCAT31((int3)((uint)pbVar11 >> 8),cVar6) * 2 + 0xb9e7d30] =
               param_1[CONCAT31((int3)((uint)pbVar11 >> 8),cVar6) * 2 + 0xb9e7d30] + cVar6;
          func_0xfcf6458c();
                    /* WARNING: Does not return */
          pcVar4 = (code *)invalidInstructionException();
          (*pcVar4)();
        }
      }
      uVar17 = (undefined2)((uint)unaff_ESI >> 0x10);
      unaff_EBP = CONCAT22(uVar17,in_CS);
      in_CS = 0x575c;
      func_0xf503e718();
      pcVar13 = unaff_ESI + -1;
      pbVar11 = (byte *)CONCAT31((int3)((uint)extraout_ECX >> 8),DAT_c8073dd3);
      pcVar4 = unaff_ESI + 3;
      out(*(undefined4 *)pcVar13,0x6dc7);
      puVar1 = (uint *)(param_1 + 0xa0b3fd);
      *puVar1 = *puVar1 >> 0x1e | *puVar1 << 2;
      bVar15 = (int)*puVar1 < 0;
      uVar10 = 0x7ff9fcfd;
      *(undefined2 *)(param_1 + 0x30) = in_CS;
      if ((int)unaff_ESI < 1) break;
      unaff_retaddr =
           (uint)(in_NT & 1) * 0x4000 | (uint)SBORROW4((int)unaff_ESI,1) * 0x800 |
           (uint)(in_IF & 1) * 0x200 | (uint)(in_TF & 1) * 0x100 | (uint)((int)pcVar13 < 0) * 0x80 |
           (uint)(pcVar13 == (code *)0x0) * 0x40 | (uint)(in_AF & 1) * 0x10 |
           (uint)((POPCOUNT((uint)pcVar13 & 0xff) & 1U) == 0) * 4 | (uint)bVar15 |
           (uint)(in_ID & 1) * 0x200000 | (uint)(in_VIP & 1) * 0x100000 |
           (uint)(in_VIF & 1) * 0x80000 | (uint)(in_AC & 1) * 0x40000;
      unaff_ESI[-0x1d1de560] = (code)((char)unaff_ESI[-0x1d1de560] + '\x01');
      param_1 = param_1 + 0x1d;
      unaff_ESI = unaff_ESI + 4;
      out(*pcVar4,0x6dc7);
    }
    unaff_EBP = unaff_EBP | (uint)pbVar11;
    if ((POPCOUNT(unaff_EBP & 0xff) & 1U) != 0) {
      return CONCAT44(0x6c6dc7,uRam3cfc89d7);
    }
    unaff_retaddr = CONCAT22(uVar17,in_CS);
    uVar16 = (*pcVar4)();
    param_1 = extraout_ECX_00;
    unaff_ESI = pcVar4;
  } while( true );
}


