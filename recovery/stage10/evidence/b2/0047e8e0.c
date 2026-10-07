/* NR2003.exe @ 0047e8e0 FUN_0047e8e0 */

void FUN_0047e8e0(int *param_1,char param_2)

{
  char cVar1;
  
  cVar1 = FUN_005fbe20(&param_1,param_1);
  if (cVar1 == '\x01') {
    (**(code **)(*param_1 + 0x2c))(param_2 == '\0');
  }
  return;
}

