/* NR2003.exe @ 00536180 FUN_00536180 */

int __thiscall FUN_00536180(int param_1_00,int param_1,int *param_2)

{
  int iVar1;
  int iVar2;
  int *piVar3;
  int iVar4;
  undefined8 uVar5;
  
  if (param_1 != 0x7fffffff) {
    iVar4 = 0;
    *param_2 = param_1;
    iVar1 = FUN_00535c30();
    if (iVar1 <= param_1) {
      do {
        uVar5 = FUN_00535c30();
        piVar3 = (int *)((ulonglong)uVar5 >> 0x20);
        iVar2 = *piVar3 - (int)uVar5;
        iVar4 = iVar4 + 1;
        *piVar3 = iVar2;
        iVar1 = FUN_00535c30();
      } while (iVar1 <= iVar2);
    }
    return iVar4;
  }
  return *(int *)(param_1_00 + 8);
}

