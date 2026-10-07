/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b8c40 */

void FUN_005b8c40(int param_1,float param_2,float param_3,float param_4)

{
  float fVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  float fVar6;
  float10 fVar7;
  
  fVar7 = (float10)fcos((float10)param_2);
  fVar1 = (float)fVar7;
  fVar7 = (float10)fsin((float10)param_2);
  fVar2 = (float)fVar7;
  fVar7 = (float10)fcos((float10)param_3);
  fVar3 = (float)fVar7;
  fVar7 = (float10)fsin((float10)param_3);
  fVar4 = (float)fVar7;
  fVar7 = (float10)fcos((float10)param_4);
  fVar5 = (float)fVar7;
  fVar7 = (float10)fsin((float10)param_4);
  fVar6 = (float)fVar7;
  FUN_0057ca60(param_1,fVar3 * fVar1);
  FUN_0057ca60(param_1 + 4,fVar6 * fVar4 * fVar1 - fVar5 * fVar2);
  FUN_0057ca60(param_1 + 8,fVar6 * fVar2 + fVar5 * fVar4 * fVar1);
  FUN_0057ca60(param_1 + 0xc,fVar3 * fVar2);
  FUN_0057ca60(param_1 + 0x10,fVar5 * fVar1 + fVar6 * fVar4 * fVar2);
  FUN_0057ca60(param_1 + 0x14,fVar5 * fVar4 * fVar2 - fVar6 * fVar1);
  FUN_0057ca60(param_1 + 0x18,-fVar4);
  FUN_0057ca60(param_1 + 0x1c,fVar6 * fVar3);
  FUN_0057ca60(param_1 + 0x20,fVar5 * fVar3);
  return;
}


