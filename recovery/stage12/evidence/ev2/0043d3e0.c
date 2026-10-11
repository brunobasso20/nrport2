/* NR2003.exe @ 0043d3e0 FUN_0043d3e0 */

undefined4 FUN_0043d3e0(undefined4 *param_1)

{
  int iVar1;
  undefined4 *puVar2;
  char cVar3;
  
  puVar2 = param_1;
  cVar3 = FUN_005fbec0(&param_1,*param_1);
  if ((cVar3 == '\x01') && (iVar1 = puVar2[1], *(int *)((int)param_1 + 0x1ba) = iVar1, 0 < iVar1)) {
    FUN_00609e60();
  }
  return 1;
}

