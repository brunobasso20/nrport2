/* NR2003.exe @ 00547e20 FUN_00547e20 */

undefined4 __thiscall FUN_00547e20(undefined4 *param_1_00,int param_1)

{
  float fVar1;
  float fVar2;
  undefined4 *puVar3;
  undefined4 *puVar4;
  
  puVar3 = (undefined4 *)*param_1_00;
  do {
    puVar4 = puVar3;
    if (puVar4 == (undefined4 *)0x0) {
      return param_1_00[5];
    }
    fVar1 = *(float *)(param_1 + param_1_00[3] * 4);
    fVar2 = (float)param_1_00[4];
    if (param_1_00[2] == 0) {
      if (fVar1 < fVar2) {
LAB_00547e44:
        puVar4 = (undefined4 *)param_1_00[1];
      }
    }
    else if (fVar1 < fVar2 == (NAN(fVar1) || NAN(fVar2))) goto LAB_00547e44;
    puVar3 = (undefined4 *)*puVar4;
    param_1_00 = puVar4;
  } while( true );
}

