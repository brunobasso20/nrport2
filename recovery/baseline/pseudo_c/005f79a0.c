/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005f79a0 */

/* void __cdecl bgRequestFGAction(void (__cdecl*)(void *,void *),void *,void *) */

void __cdecl bgRequestFGAction(_func_void_void_ptr_void_ptr *param_1,void *param_2,void *param_3)

{
  bool bVar1;
  
                    /* 0x1f79a0  238  ?bgRequestFGAction@@YAXP6AXPAX0@Z00@Z */
  bVar1 = inBackground();
  if (bVar1) {
    DAT_007559e0 = param_2;
    DAT_007559dc = param_3;
    DAT_007559d8 = param_1;
    if (param_1 != (_func_void_void_ptr_void_ptr *)0x0) {
      do {
        bgSleep();
      } while (DAT_007559d8 != (_func_void_void_ptr_void_ptr *)0x0);
      return;
    }
  }
  else {
    (*param_1)(param_2,param_3);
  }
  return;
}


