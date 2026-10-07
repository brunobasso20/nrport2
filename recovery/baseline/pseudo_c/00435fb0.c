/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00435fb0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00435fb0(void)

{
  double dVar1;
  int iVar2;
  undefined4 uVar3;
  undefined2 *in_stack_00002004;
  int in_stack_00002008;
  undefined4 in_stack_0000200c;
  undefined4 in_stack_00002010;
  undefined4 in_stack_00002014;
  
  FUN_006c5af0();
  if (in_stack_00002008 < 0x20) {
    if (in_stack_00002004 != (undefined2 *)0x0) {
      *in_stack_00002004 = 0;
    }
  }
  else if (in_stack_00002004 != (undefined2 *)0x0) {
    iVar2 = FUN_004430c0();
    dVar1 = (double)CONCAT44(in_stack_00002010,in_stack_0000200c);
    if (iVar2 != 0) {
      uVar3 = 0x2922;
      if (dVar1 < _DAT_006e9808 == (dVar1 == _DAT_006e9808)) {
        uVar3 = 0x2923;
      }
      FUN_005f9730(uVar3,&stack0x00000000,0x1000);
      FUN_006c5990(in_stack_00002004,u____f__s_00725f94,in_stack_00002014,
                   (double)CONCAT44(in_stack_00002010,in_stack_0000200c) * _DAT_006ee750,
                   &stack0x00000000);
      return;
    }
    uVar3 = 0x2920;
    if (dVar1 < _DAT_006e9808 == (dVar1 == _DAT_006e9808)) {
      uVar3 = 0x2921;
    }
    FUN_005f9730(uVar3,&stack0x00000000,0x1000);
    FUN_006c5990(in_stack_00002004,u____f__s_00725fa4,in_stack_00002014,in_stack_0000200c,
                 in_stack_00002010,&stack0x00000000);
    return;
  }
  return;
}


