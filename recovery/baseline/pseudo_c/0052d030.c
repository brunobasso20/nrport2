/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0052d030 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_0052d030(int param_1)

{
  float *pfVar1;
  int iVar2;
  float fVar3;
  char cVar4;
  undefined4 uVar5;
  float10 fVar6;
  
  iVar2 = *(int *)(param_1 + 0x5ae);
  fVar3 = *(float *)(param_1 + 0x1872);
  pfVar1 = (float *)(param_1 + 0x1ab2);
  fVar6 = (float10)fpatan((float10)*(float *)(iVar2 + 0x38),(float10)*(float *)(iVar2 + 0x34));
  *(float *)(param_1 + 0x1a92) = (float)fVar6;
  FUN_0051e1c0(iVar2,*(undefined4 *)(param_1 + 0x18d2),param_1 + 0x186a,param_1 + 0x1886,
               param_1 + 0x18b6,param_1 + 0x18aa,(float *)(param_1 + 0x1872),param_1 + 0x188a,
               param_1 + 0x18ba,param_1 + 0x18ae,param_1 + 0x1aa6,pfVar1);
  *(float *)(param_1 + 0x1876) = *(float *)(param_1 + 0x1872) - fVar3;
  *(float *)(param_1 + 0x1a9e) =
       *pfVar1 * *(float *)(iVar2 + 0x58) +
       *(float *)(iVar2 + 100) * *(float *)(param_1 + 0x1ab6) +
       *(float *)(iVar2 + 0x70) * *(float *)(param_1 + 0x1aba);
  fVar6 = (float10)*(float *)(iVar2 + 0x5c) * (float10)*pfVar1 +
          (float10)*(float *)(iVar2 + 0x68) * (float10)*(float *)(param_1 + 0x1ab6) +
          (float10)*(float *)(iVar2 + 0x74) * (float10)*(float *)(param_1 + 0x1aba);
  *(float *)(param_1 + 0x1aa2) = (float)fVar6;
  fVar6 = (float10)fpatan((float10)*(float *)(param_1 + 0x1a9e),fVar6);
  *(float *)(param_1 + 0x18a6) = (float)fVar6;
  *(float *)(param_1 + 0x18f2) = ABS(*(float *)(param_1 + 0x1a9e)) * _DAT_006f51dc + _DAT_006ef678;
  uVar5 = FUN_00546840();
  cVar4 = FUN_0052be50(uVar5);
  if (cVar4 != '\0') {
    FUN_0052d160(param_1);
    FUN_0052b420();
  }
  FUN_00401a50();
  return;
}


