/* NR2003.exe @ 004ed160 FUN_004ed160 */

void __fastcall FUN_004ed160(int *param_1)

{
  undefined4 *puVar1;
  int iVar2;
  
  puVar1 = (undefined4 *)*param_1;
  if ((puVar1 != (undefined4 *)0x0) && (iVar2 = puVar1[1], puVar1[1] = iVar2 + -1, iVar2 + -1 == 0))
  {
    (**(code **)*puVar1)(1);
  }
  return;
}

