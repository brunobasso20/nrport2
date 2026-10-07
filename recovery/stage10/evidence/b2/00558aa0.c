/* NR2003.exe @ 00558aa0 FUN_00558aa0 */

undefined4 __thiscall FUN_00558aa0(int param_1_00,undefined4 param_1)

{
  undefined4 uVar1;
  char cVar2;
  int iVar3;
  char *pcVar4;
  int iStack_c;
  int iStack_8;
  undefined auStack_4 [4];
  
  uVar1 = param_1;
  cVar2 = FUN_005cfefa(param_1);
  if (cVar2 != '\0') {
    iVar3 = FUN_005cfd0e(&param_1,uVar1);
    if (iVar3 != 0) {
      iVar3 = FUN_005cfe52(&iStack_c,&iStack_8,auStack_4,param_1);
      if (((iVar3 != 0) && (iStack_c == 0x53544750)) && (iStack_8 == 5)) {
        iVar3 = FUN_005cfe4c(param_1_00,&DAT_0074da78,3,param_1);
        if ((iVar3 != 0) && (*(short *)(param_1_00 + 0x4ed) == *(short *)(param_1_00 + 0x4ef))) {
          pcVar4 = &DAT_00c064c5;
          do {
            cVar2 = *pcVar4;
            pcVar4[param_1_00 + -0xc060d9] = cVar2;
            pcVar4 = pcVar4 + 1;
          } while (cVar2 != '\0');
          FUN_005cfd08(param_1);
          iVar3 = FUN_00558da0();
          if (iVar3 != 0) {
            FUN_00559820();
            return 1;
          }
        }
      }
      FUN_005cfd08(param_1);
    }
  }
  return 0;
}

