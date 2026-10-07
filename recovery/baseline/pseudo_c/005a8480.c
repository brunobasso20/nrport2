/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005a8480 */

void FUN_005a8480(int param_1,int param_2)

{
  int iVar1;
  
  *(int *)(&DAT_00e0befc + param_2 * 4) = *(int *)(&DAT_00e0befc + param_2 * 4) + 1;
  *(int *)((int)&DAT_00e0bf0e + param_1 * 10) = param_2;
  (&DAT_00e0bf0d)[param_1 * 10] = 0;
  iVar1 = FUN_006c5018();
  if ((iVar1 <= DAT_00e0bf08) || ((DAT_00e0bef8 - iVar1) + 1 <= DAT_00e0bf04 + DAT_00e0bf00)) {
    (**(code **)(*DAT_00e0bef0 + 0xc))(iVar1 <= DAT_00e0bf08,DAT_00e0bf08,DAT_00e0bf00,DAT_00e0bf04)
    ;
    FUN_005a8520(0);
  }
  return;
}


