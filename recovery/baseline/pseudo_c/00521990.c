/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00521990 */

undefined4 __fastcall FUN_00521990(int param_1)

{
  int iVar1;
  int iVar2;
  float10 fVar3;
  
  if (*(char *)(param_1 + 100) != '\0') {
    iVar1 = *(int *)(param_1 + 0x65);
    iVar2 = FUN_004f5970(*(undefined4 *)(*(int *)(param_1 + 0x89) + 0x5b2));
    if (iVar1 == *(int *)(iVar2 + 0x1397)) {
      fVar3 = (float10)FUN_005361e0(iVar1);
      if (fVar3 == (float10)*(float *)(param_1 + 0x3c)) {
        fVar3 = (float10)FUN_005361f0(*(undefined4 *)(param_1 + 0x65));
        if (fVar3 == (float10)*(float *)(param_1 + 0x40)) {
          return 0;
        }
      }
    }
  }
  return 1;
}


