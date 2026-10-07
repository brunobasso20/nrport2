/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b5cb0 */

void FUN_005b5cb0(undefined4 param_1)

{
  undefined4 uVar1;
  char cVar2;
  undefined4 local_8;
  undefined4 local_4;
  
  uVar1 = param_1;
  cVar2 = FUN_005c39b0(param_1);
  if (cVar2 == '\0') {
    cVar2 = FUN_005c3a60(uVar1,&local_8,&param_1);
    if (cVar2 == '\0') {
      return;
    }
    cVar2 = FUN_005b5d30(uVar1,local_8,param_1);
    if (cVar2 == '\0') {
      return;
    }
  }
  cVar2 = FUN_005c3ae0(uVar1,&local_8,&param_1,&local_4);
  if (cVar2 != '\0') {
    FUN_005b6190(uVar1,local_8,param_1,local_4);
  }
  return;
}


