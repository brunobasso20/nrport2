/* NR2003.exe @ 00428a20 FUN_00428a20 */

void FUN_00428a20(undefined4 *param_1,undefined4 *param_2,int *param_3,int *param_4,int param_5,
                 undefined4 param_6)

{
  char cVar1;
  undefined4 uVar2;
  int iVar3;
  char *pcVar4;
  undefined4 *puVar5;
  undefined4 local_1ac [8];
  undefined4 local_18c;
  undefined4 local_188;
  undefined local_184;
  int local_d7;
  undefined4 local_d3;
  int local_cf;
  undefined4 local_93;
  undefined4 local_13;
  undefined4 local_f;
  int local_b;
  int local_7;
  undefined local_3;
  undefined local_2;
  
  *param_1 = 0;
  *param_2 = 0;
  *param_4 = 0;
  iVar3 = -1;
  pcVar4 = (char *)(param_5 + 0x70);
  do {
    if (iVar3 == 0) break;
    iVar3 = iVar3 + -1;
    cVar1 = *pcVar4;
    pcVar4 = pcVar4 + 1;
  } while (cVar1 != '\0');
  *param_3 = 0;
  if (iVar3 != -2) {
    local_18c = 0;
    local_188 = 0;
    local_184 = 0;
    local_cf = -1;
    local_d3 = 0;
    local_93 = 0;
    local_13 = 0;
    local_f = 0;
    local_b = 0;
    local_7 = 0;
    local_3 = 0;
    local_2 = 1;
    puVar5 = local_1ac;
    for (iVar3 = 8; iVar3 != 0; iVar3 = iVar3 + -1) {
      *puVar5 = 0;
      puVar5 = puVar5 + 1;
    }
    FUN_004fef00();
    iVar3 = FUN_0056c1e0();
    if (iVar3 != 0) {
      iVar3 = FUN_0055ab00();
      FUN_004fe280((char *)(param_5 + 0x70),0x32,0,*(int *)(param_5 + 0xa8) == iVar3);
      if (((local_d7 == *(int *)(param_5 + 0x94)) && (local_cf == *(int *)(param_5 + 0x9c))) &&
         (local_b != 0)) {
        iVar3 = FUN_004fee00();
        *param_3 = iVar3;
        if (local_7 == 0) {
          *param_4 = 0;
        }
        else {
          iVar3 = FUN_004fee80();
          *param_4 = iVar3;
        }
      }
    }
    FUN_004fe420(0x3f);
  }
  if (*(int *)(param_5 + 0x94) != 0) {
    if (*param_3 == 0) {
      iVar3 = FUN_00428be0(param_5,param_6);
      *param_3 = iVar3;
    }
    if (*param_4 == 0) {
      iVar3 = FUN_00429200(param_5,param_6);
      *param_4 = iVar3;
    }
  }
  uVar2 = FUN_004289b0(param_5,param_6);
  *param_1 = uVar2;
  uVar2 = FUN_004289e0(param_5,param_6);
  *param_2 = uVar2;
  return;
}

