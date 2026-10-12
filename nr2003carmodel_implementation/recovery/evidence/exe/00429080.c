/* NR2003.exe @ 00429080 FUN_00429080 */

void FUN_00429080(undefined4 *param_1,int param_2,int param_3,int param_4,int param_5,int param_6,
                 int param_7)

{
  byte bVar1;
  uint3 uVar2;
  int iVar3;
  int iVar4;
  ushort *puVar5;
  ushort *puVar6;
  int3 iVar7;
  int local_14;
  
  iVar3 = param_7;
  if (0 < param_6) {
    iVar4 = param_3 - param_2 * param_5;
    puVar5 = (ushort *)(param_4 + 2);
    local_14 = param_6;
    do {
      if (0 < param_5) {
        param_7 = param_5;
        puVar6 = puVar5;
        do {
          bVar1 = *(byte *)((int)puVar6 + 1);
          if (bVar1 != 0) {
            if (bVar1 == 0xff) {
              *param_1 = CONCAT13(0xff,CONCAT12(*(undefined *)puVar6,puVar6[-1]));
            }
            else {
              uVar2 = (uint3)bVar1;
              iVar7 = 0xff - uVar2;
              param_3 = CONCAT13(*(byte *)((int)param_1 + 3) + bVar1,
                                 CONCAT12((char)((uint3)((uint3)*(byte *)((int)param_1 + 2) * iVar7)
                                                >> 8) +
                                          (char)((uint3)((*puVar6 & 0xff) * uVar2) >> 8),
                                          CONCAT11((char)((uint3)((uint3)*(byte *)((int)param_1 + 1)
                                                                 * iVar7) >> 8) +
                                                   (char)((uint3)((CONCAT11(*(undefined *)puVar6,
                                                                            *(undefined *)
                                                                             ((int)puVar6 + -1)) &
                                                                  0xff) * uVar2) >> 8),
                                                   (char)((uint3)((uint3)*(byte *)param_1 * iVar7)
                                                         >> 8) +
                                                   (char)((uint3)((puVar6[-1] & 0xff) * uVar2) >> 8)
                                                  )));
              *param_1 = param_3;
            }
          }
          puVar6 = puVar6 + 2;
          param_1 = param_1 + param_2;
          param_7 = param_7 + -1;
        } while (param_7 != 0);
      }
      param_1 = param_1 + iVar4;
      puVar5 = puVar5 + iVar3 * 2;
      local_14 = local_14 + -1;
    } while (local_14 != 0);
  }
  return;
}

