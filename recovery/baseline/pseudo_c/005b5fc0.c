/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b5fc0 */

undefined4
FUN_005b5fc0(undefined1 *param_1,int param_2,char *param_3,undefined1 param_4,undefined4 param_5)

{
  char *pcVar1;
  char cVar2;
  undefined1 local_20 [32];
  
  if (param_2 < 0x11) {
    *param_1 = 0;
    return 0;
  }
  FUN_006c4f81(local_20,s___02x____s______ds_007522fc,param_2 + -0xf);
  cVar2 = *param_3;
  while (cVar2 == ' ') {
    pcVar1 = param_3 + 1;
    param_3 = param_3 + 1;
    cVar2 = *pcVar1;
  }
  FUN_006c4f81(param_1,local_20,param_4,param_3,param_5);
  return 1;
}


