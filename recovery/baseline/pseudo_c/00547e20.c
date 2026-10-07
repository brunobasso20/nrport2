/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00547e20 */

undefined4 __thiscall FUN_00547e20(undefined4 *param_1_00,int param_1)

{
  bool bVar1;
  undefined4 *puVar2;
  undefined4 *puVar3;
  
  puVar2 = (undefined4 *)*param_1_00;
  do {
    puVar3 = puVar2;
    if (puVar3 == (undefined4 *)0x0) {
      return param_1_00[5];
    }
    bVar1 = *(float *)(param_1 + param_1_00[3] * 4) < (float)param_1_00[4];
    if (param_1_00[2] == 0) {
      if (bVar1) {
LAB_00547e44:
        puVar3 = (undefined4 *)param_1_00[1];
      }
    }
    else if (!bVar1) goto LAB_00547e44;
    puVar2 = (undefined4 *)*puVar3;
    param_1_00 = puVar3;
  } while( true );
}


