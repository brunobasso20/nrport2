/* NR2003.exe @ 005588c0 FUN_005588c0 */

undefined4 __thiscall FUN_005588c0(int param_1,char *param_2)

{
  char cVar1;
  int iVar2;
  undefined4 uVar3;
  int iVar4;
  undefined4 *puVar5;
  undefined4 *puVar6;
  undefined4 uStack_214;
  int iStack_210;
  int local_20c;
  undefined auStack_208 [4];
  undefined2 uStack_204;
  undefined4 auStack_202 [64];
  undefined4 auStack_102 [64];
  
  if ((DAT_00c01520 & 1) == 0) {
    DAT_00c01520 = DAT_00c01520 | 1;
    DAT_00c0334c = DAT_006ed828 * 4 + 4;
  }
  iVar2 = FUN_005cfce4(&local_20c,DAT_00c0334c);
  if (iVar2 != 0) {
    iStack_210 = local_20c;
    if (local_20c != 0) {
      iVar2 = FUN_005cfdda(&uStack_214,param_2);
      if (iVar2 != 0) {
        uVar3 = FUN_00558830(1,0xe,local_20c,DAT_00c0334c);
        uStack_204 = FUN_005f7610(local_20c,uVar3,0xffff);
        puVar5 = (undefined4 *)(param_1 + 0x4f1);
        puVar6 = auStack_202;
        for (iVar2 = 0x40; iVar2 != 0; iVar2 = iVar2 + -1) {
          *puVar6 = *puVar5;
          puVar5 = puVar5 + 1;
          puVar6 = puVar6 + 1;
        }
        puVar5 = (undefined4 *)(param_1 + 0x5f1);
        puVar6 = auStack_102;
        for (iVar2 = 0x40; iVar2 != 0; iVar2 = iVar2 + -1) {
          *puVar6 = *puVar5;
          puVar5 = puVar5 + 1;
          puVar6 = puVar6 + 1;
        }
        iVar2 = FUN_005cfdd4(uStack_214,auStack_208,0x53544750,5);
        if (iVar2 != 0) {
          iVar4 = FUN_005cfe46(uStack_214,0x53544748,3,0x202,&uStack_204);
          iVar2 = iStack_210;
          if (iVar4 != 0) {
            iVar4 = FUN_005cfe46(uStack_214,0x53544744,0xe,uVar3,iStack_210);
            if (iVar4 != 0) {
              iVar4 = FUN_005cfe46(uStack_214,0x53544754,1,0x800,param_1 + 0x6f1);
              if (iVar4 != 0) {
                iVar4 = FUN_005cfdce(uStack_214,auStack_208);
                if (iVar4 != 0) {
                  iVar4 = FUN_005cfd08(uStack_214);
                  if (iVar4 != 0) {
                    param_1 = param_1 - (int)param_2;
                    do {
                      cVar1 = *param_2;
                      param_2[param_1 + 0x3ec] = cVar1;
                      param_2 = param_2 + 1;
                    } while (cVar1 != '\0');
                    FUN_005cfccc(iVar2);
                    return 1;
                  }
                }
              }
            }
          }
        }
        FUN_005cfd08(uStack_214);
        local_20c = iStack_210;
      }
      FUN_005cfdc8(param_2);
      FUN_005cfccc(local_20c);
    }
  }
  return 0;
}

