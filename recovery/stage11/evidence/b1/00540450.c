/* NR2003.exe @ 00540450 FUN_00540450 */

undefined __thiscall FUN_00540450(int param_1_00,int param_1)

{
  int iVar1;
  
  if (*(char *)(param_1_00 + 0x452) == '\0') {
    return 0xff;
  }
  iVar1 = FUN_0055ab00();
  if (param_1 == iVar1) {
    return *(undefined *)(param_1_00 + 0x453);
  }
  return *(undefined *)(param_1 + 0x93d + param_1_00);
}

