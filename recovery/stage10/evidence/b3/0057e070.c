/* NR2003.exe @ 0057e070 recovered_0057e070 */

void recovered_0057e070(void)

{
  int iVar1;
  
  func_0x005cfda4(0x74fe54,0x14000);
  func_0x0059d9d0();
  taskRegisterIntFunc((_func_void *)&UNK_005bea00);
  DAT_00d47db0 = 1;
  func_0x005952b0();
  func_0x0056bd60();
  iVar1 = func_0x0043e9f0();
  if (iVar1 != 0) {
    func_0x0057e0e0();
    func_0x0043eaa0();
  }
  taskRegisterIntFunc((_func_void *)0x0);
  func_0x0059dc30();
  FUN_005cfd80(0x74fe58,0x14000);
  return;
}

