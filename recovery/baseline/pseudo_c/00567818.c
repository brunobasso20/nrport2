/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00567818 */

undefined8 __fastcall
FUN_00567818(undefined4 param_1_00,undefined4 param_2_00,float *param_1,float *param_2,float param_3
            )

{
  float fVar1;
  float fVar2;
  undefined4 in_EAX;
  uint uVar3;
  uint uVar4;
  
  fVar1 = (param_3 - *param_2) * param_2[1];
  uVar4 = (uint)ROUND(fVar1);
  if ((int)uVar4 < 0) {
    fVar2 = 0.0;
    uVar4 = 0;
  }
  else if ((int)(uint)*(ushort *)(param_2 + 2) < (int)uVar4) {
    fVar2 = (float)*(short *)(param_2 + 2);
    uVar4 = (uint)*(ushort *)(param_2 + 2);
  }
  else {
    fVar2 = (float)(int)uVar4;
  }
  uVar3 = (uint)*(ushort *)((int)param_2 + 10);
  param_2 = (float *)((int)param_2 + uVar4 * uVar3 * 4 + 0xc);
  for (uVar4 = uVar3; (short)uVar4 != 0; uVar4 = (uint)(ushort)((short)uVar4 - 1)) {
    *param_1 = (param_2[uVar3] - *param_2) * (fVar1 - fVar2) + *param_2;
    param_2 = param_2 + 1;
    param_1 = param_1 + 1;
  }
  return CONCAT44(param_2_00,in_EAX);
}


