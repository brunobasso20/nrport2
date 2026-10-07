/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00558780 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 __thiscall FUN_00558780(int param_1_00,float param_1,float param_2,undefined4 param_3)

{
  float fVar1;
  int iVar2;
  float10 fVar3;
  
  FUN_00432cf0(param_1_00 + 0xef1);
  iVar2 = FUN_0056ed60(param_3);
  fVar1 = *(float *)(*(int *)(PTR_PTR_00734368 + iVar2 * 4) + 0x28);
  fVar3 = (float10)FUN_00579e80(0x13,1);
  return (float10)param_1 /
         -((((float10)param_2 / (float10)fVar1) * (float10)_DAT_006ed020 + (float10)_DAT_006ea4cc) *
          fVar3);
}


