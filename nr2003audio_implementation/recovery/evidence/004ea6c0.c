/* NR2003.exe @ 004ea6c0 recovered_004ea6c0 */

uint recovered_004ea6c0(uint param_1)

{
  *(undefined4 *)(param_1 + 4) = 0x3f800000;
  return param_1 & 0xffffff00;
}

