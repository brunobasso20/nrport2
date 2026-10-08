/* NR2003.exe @ 0051a9c0 FUN_0051a9c0 */

void __fastcall FUN_0051a9c0(int param_1)

{
  byte bVar1;
  bool bVar2;
  int iVar3;
  uint uVar4;
  
  bVar1 = (byte)*(undefined4 *)(param_1 + 0x548);
  if ((bVar1 & 0x20) != 0x20) {
    if ((bVar1 & 2) == 2) {
      bVar2 = inBackground();
      if (bVar2) {
        iVar3 = thunk_FUN_0055a730();
      }
      else {
        bVar2 = inServer();
        if (!bVar2) {
          return;
        }
        iVar3 = FUN_00509b60(0xffffffff);
      }
      if (1 < iVar3) {
        if (*(int *)(param_1 + 0x54c) < 0) {
          rndUniform(0);
          iVar3 = FUN_006c5018();
          *(int *)(param_1 + 0x54c) = 0x5a - iVar3;
          return;
        }
        iVar3 = *(int *)(param_1 + 0x54c) + -1;
        *(int *)(param_1 + 0x54c) = iVar3;
        if (iVar3 < 0) {
          *(uint *)(param_1 + 0x548) = *(uint *)(param_1 + 0x548) | 0x20;
          *(undefined4 *)(param_1 + 0x550) = 0x3e800000;
          return;
        }
      }
    }
    else if (((1 << ((byte)(*(uint *)(param_1 + 0x548) >> 4) & 1) & *(uint *)(param_1 + 0x548) >> 2
              & 3) != 0) && (uVar4 = *(uint *)(param_1 + 0x548), ((byte)uVar4 & 0x10) < 0x20)) {
      uVar4 = ((uVar4 & 0xfffffff0) - 1 ^ uVar4) & 0x10 ^ uVar4;
      *(uint *)(param_1 + 0x548) = uVar4;
      *(uint *)(param_1 + 0x548) = uVar4 & 0xfffffffd ^ 2;
    }
  }
  return;
}

