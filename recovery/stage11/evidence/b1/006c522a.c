/* NR2003.exe @ 006c522a FUN_006c522a */

/* WARNING: Instruction at (ram,0x006c523f) overlaps instruction at (ram,0x006c523e)
    */
/* WARNING: Control flow encountered bad instruction data */
/* WARNING: Removing unreachable block (ram,0x006c525d) */
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_006c522a(int param_1,uint param_2)

{
  uint *puVar1;
  uint uVar2;
  float *unaff_EBX;
  int unaff_EBP;
  float10 in_ST0;
  float10 fVar3;
  float10 in_ST1;
  float10 in_ST2;
  float10 in_ST3;
  float10 in_ST4;
  float10 in_ST5;
  float10 in_ST6;
  int unaff_retaddr;
  
  uVar2 = _DAT_3ee573be & 0xfd9e267;
  *(int *)(uVar2 + 0xf99e06de) = *(int *)(uVar2 + 0xf99e06de) - (int)&stack0x00000004;
  fVar3 = (float10)*unaff_EBX;
  while( true ) {
    out((short)param_2,(char)uVar2);
    in((short)param_2);
    *(int *)(param_1 + -0x7c) = (int)ROUND(fVar3);
    uVar2 = in(0x31);
    if (param_1 != 1) break;
    uVar2 = in(0x96);
    param_2 = (uint)CONCAT11((char)(param_2 >> 8) + (char)((uint)unaff_EBX >> 8),(char)param_2);
    param_1 = -1;
    fVar3 = in_ST0;
    in_ST0 = in_ST1;
    in_ST1 = in_ST2;
    in_ST2 = in_ST3;
    in_ST3 = in_ST4;
    in_ST4 = in_ST5;
    in_ST5 = in_ST6;
  }
  puVar1 = (uint *)(unaff_EBP + 0x77 + unaff_retaddr);
  *puVar1 = *puVar1 ^ CONCAT31((int3)(uVar2 >> 8),((char)uVar2 + -4) - (uVar2 < 0x7fe0fe77));
                    /* WARNING: Bad instruction - Truncating control flow here */
  halt_baddata();
}

