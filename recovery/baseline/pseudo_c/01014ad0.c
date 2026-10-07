/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 01014ad0 */

uint FUN_01014ad0(int param_1,uint param_2,int *param_3)

{
  uint local_8;
  
  *param_3 = 0;
  local_8 = param_2;
  while ((((local_8 = local_8 % 200, *(int *)(param_1 + local_8 * 8) != 0 ||
           (*(int *)(param_1 + 4 + local_8 * 8) != 0)) &&
          (*(uint *)(param_1 + local_8 * 8) != param_2)) && (*param_3 < 10))) {
    local_8 = local_8 + param_2 + *param_3;
    *param_3 = *param_3 + 1;
  }
  if (9 < *param_3) {
    local_8 = 0xffffffff;
  }
  return local_8;
}


