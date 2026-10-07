/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005796e0 */

int __thiscall FUN_005796e0(int *param_1_00,int param_1,int param_2)

{
  int iVar1;
  int iVar2;
  int iVar3;
  
  iVar1 = param_2;
  iVar2 = param_1;
  iVar3 = 0;
  if ((param_2 != param_1_00[0x264f]) && (param_2 != 0)) {
    iVar3 = *(int *)(param_2 + 0xc);
    iVar3 = FUN_00517e9a(param_1,&param_1,*(undefined4 *)(iVar3 + 0xd4),
                         *(undefined4 *)(iVar3 + 0x40),*(undefined4 *)(iVar3 + 0xd8),0x40533333,
                         *(undefined4 *)(iVar3 + 0xec),&param_2,0,param_2);
  }
  iVar2 = (**(code **)(*param_1_00 + 0x1c))(iVar2 + iVar3 * 4,iVar1);
  return iVar2 + iVar3;
}


