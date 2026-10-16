/* NR2003.exe @ 004e9200 recovered_004e9200 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall recovered_004e9200(int param_1,float *param_2,float param_3,char param_4)

{
  float fVar1;
  
  fVar1 = param_3 - _DAT_006e97d8;
  param_2[1] = fVar1 * *(float *)(param_1 + 0x845) * _DAT_006f3814 + *(float *)(param_1 + 0x831);
  if (param_4 == '\0') {
    *param_2 = param_3;
    return;
  }
  *param_2 = fVar1 * *(float *)(param_1 + 0x849) * _DAT_006f3814 + *(float *)(param_1 + 0x82d);
  return;
}

