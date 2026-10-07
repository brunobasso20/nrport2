/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0052e8a0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0052e8a0(undefined4 param_1,int param_2,uint param_3,char param_4,float param_5)

{
  double dVar1;
  float local_4;
  
  local_4 = 0.0;
  if (param_2 == 2) {
    dVar1 = rndUniform(0);
    local_4 = (float)dVar1 * _DAT_006ea470 + _DAT_006ea4cc;
  }
  else if (param_2 == 4) {
    dVar1 = rndUniform(0);
    local_4 = ((float)dVar1 + _DAT_006e97d8) * _DAT_006ea44c;
  }
  switch(param_1) {
  case 1:
  case 2:
    if (param_3 == 0xffffffff) {
      param_3 = FUN_006c5bf8();
      param_3 = param_3 & 0x80000003;
      if ((int)param_3 < 0) {
        param_3 = (param_3 - 1 | 0xfffffffc) + 1;
      }
    }
    goto LAB_0052e944;
  case 3:
  case 6:
  case 7:
    if (param_2 == 8) {
      dVar1 = rndUniform(0);
      local_4 = (float)dVar1 * _DAT_006ea470 + _DAT_006ea4cc;
    }
    break;
  case 4:
  case 5:
    break;
  default:
    FUN_00502460();
  }
LAB_0052e944:
  if (param_4 != '\0') {
    local_4 = param_5;
  }
  FUN_0052e990(param_1,param_2,param_3,local_4);
  return;
}


