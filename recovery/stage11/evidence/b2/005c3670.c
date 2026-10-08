/* NR2003.exe @ 005c3670 FUN_005c3670 */

void FUN_005c3670(ushort *param_1,int param_2)

{
  if (param_2 == 0) {
    *(byte *)param_1 = *(byte *)param_1 & 0xfe;
    return;
  }
  *param_1 = (byte)((char)param_2 * '\x02' - 1U ^ (byte)(*param_1 | 1)) & 0x3e ^ (*param_1 | 1);
  return;
}

