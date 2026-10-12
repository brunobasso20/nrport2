/* NR2003.exe @ 00562e80 FUN_00562e80 */

void __fastcall FUN_00562e80(int param_1)

{
  int iVar1;
  undefined4 uVar2;
  undefined4 *puVar3;
  
  iVar1 = FUN_00574370(*(undefined4 *)(param_1 + 0x5b2));
  puVar3 = (undefined4 *)(param_1 + 0x58e);
  uVar2 = FUN_004233a0();
  *puVar3 = uVar2;
  *(undefined4 *)(param_1 + 0x592) = *(undefined4 *)(iVar1 + 0x90);
  *(undefined4 *)(param_1 + 0x596) = *(undefined4 *)(iVar1 + 0x94);
  iVar1 = FUN_00432cf0(puVar3);
  *(int *)(param_1 + 0x58a) = iVar1;
  *(undefined4 *)(param_1 + 0x582) = *(undefined4 *)(iVar1 + 0x1bc);
  *(undefined4 *)(param_1 + 0x586) = *(undefined4 *)(iVar1 + 0x1c0);
  FUN_0051a730(param_1,**(undefined4 **)(param_1 + 0x58a),(*(undefined4 **)(param_1 + 0x58a))[0x26])
  ;
  FUN_00550bc0(param_1,puVar3);
  *(undefined4 *)(param_1 + 0x120b) = 0;
  *(undefined4 *)(param_1 + 0x120f) = 0;
  *(undefined4 *)(param_1 + 0x1213) = 0;
  *(undefined4 *)(param_1 + 0x1217) = 0;
  iVar1 = 4;
  *(undefined4 *)(param_1 + 0x11fb) = 0;
  *(undefined4 *)(param_1 + 0x11ff) = 0;
  *(undefined4 *)(param_1 + 0x1203) = 0;
  *(undefined4 *)(param_1 + 0x1207) = 0;
  puVar3 = (undefined4 *)(param_1 + 0x122b);
  do {
    puVar3[-4] = 0x3f800000;
    *puVar3 = 0;
    puVar3 = puVar3 + 1;
    iVar1 = iVar1 + -1;
  } while (iVar1 != 0);
  return;
}

