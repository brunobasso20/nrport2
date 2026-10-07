/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00537010 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00537010(int param_1)

{
  undefined4 *puVar1;
  
  puVar1 = &DAT_00bdccd8 + param_1 * 0x10;
  if (*(char *)(&DAT_00bdccd8 + param_1 * 0x10) != '\0') {
    switch(param_1) {
    case 0:
      FUN_006c4b00(&DAT_00bddd40,puVar1,0x40);
      DAT_00bddd7f = 0;
      return;
    case 1:
      FUN_006c4b00(&DAT_00bdba58,puVar1,0x20);
      DAT_00bdba77 = 0;
      return;
    case 2:
      FUN_006c4ac9(puVar1,&DAT_0074c4f0,&DAT_00bdbd70);
      return;
    case 3:
      FUN_00536fa0(puVar1,&DAT_00bddf2c);
      return;
    case 4:
      FUN_00536fa0(puVar1,&DAT_00bdc4d0);
      return;
    case 5:
      FUN_006c4ac9(puVar1,&DAT_0074c4f4,&DAT_00bdbcf8);
      DAT_00bdbcf8 = _DAT_006f5370 * DAT_00bdbcf8;
      return;
    case 6:
      FUN_006c4ac9(puVar1,s__f__f_0074c4f8,&DAT_00bddf28,&DAT_00bddcd8);
      return;
    case 7:
      FUN_006c4ac9(puVar1,&DAT_0074c500,&DAT_00bde258);
      return;
    case 8:
      FUN_006c4ac9(puVar1,&DAT_0074c504,&DAT_00bde25c);
      return;
    case 9:
      FUN_006c4ac9(puVar1,&DAT_0074c508,&DAT_00bde260);
      return;
    case 10:
      FUN_006c4ac9(puVar1,&DAT_0074c50c,&param_1);
      if (-1 < param_1) {
        if (5 < param_1) {
          param_1 = 5;
        }
        DAT_00bdbd00 = param_1;
        return;
      }
      DAT_00bdbd00 = 0;
      return;
    case 0xb:
      FUN_006c4ac9(puVar1,&DAT_0074c510,&DAT_00bddde0);
      if (DAT_00bddde0 < -1) {
        DAT_00bddde0 = 0xffffffff;
        return;
      }
      if (1 < DAT_00bddde0) {
        DAT_00bddde0 = 1;
        return;
      }
      break;
    case 0xc:
      FUN_006c4b00(&DAT_00bde268,puVar1,0x40);
      DAT_00bde2a7 = 0;
      return;
    case 0xd:
      FUN_006c4b00(&DAT_00bdbd30,puVar1,0x40);
      DAT_00bdbd6f = 0;
      return;
    case 0xe:
      FUN_006c4b00(&DAT_00bdba18,puVar1,0x40);
      DAT_00bdba57 = 0;
      return;
    case 0xf:
      FUN_006c4b00(&DAT_00bdde68,puVar1,0x40);
      DAT_00bddea7 = 0;
      return;
    case 0x10:
      FUN_006c4b00(&DAT_00bdde28,puVar1,0x40);
      DAT_00bdde67 = 0;
      return;
    case 0x11:
      FUN_006c4b00(&DAT_00bddee8,puVar1,0x40);
      DAT_00bddf27 = 0;
      return;
    case 0x12:
      FUN_006c4b00(&DAT_00bddea8,puVar1,0x40);
      DAT_00bddee7 = 0;
      return;
    case 0x13:
      FUN_006c4b00(&DAT_00bddde8,puVar1,0x40);
      DAT_00bdde27 = 0;
      return;
    case 0x14:
      FUN_006c4ac9(puVar1,&DAT_0074c514,&DAT_00bde254);
      return;
    case 0x15:
      FUN_006c4ac9(puVar1,&DAT_0074c518,&DAT_00bdbcfc);
      return;
    case 0x16:
      FUN_006c4ac9(puVar1,&DAT_0074c51c,&DAT_00bddd90);
      return;
    case 0x17:
      FUN_006c4ac9(puVar1,&DAT_0074c520,&DAT_00bde2ac);
      if (DAT_00bde2ac < 1) {
        DAT_00bde2ac = 1;
        return;
      }
      if (0xc < DAT_00bde2ac) {
        DAT_00bde2ac = 0xc;
        return;
      }
      break;
    case 0x18:
      FUN_006c4ac9(puVar1,&DAT_0074c524,&DAT_00bdbd04);
      if (DAT_00bdbd04 < _DAT_006e981c) {
        DAT_00bdbd04 = 0.7;
        return;
      }
      if (_DAT_006ea62c < DAT_00bdbd04) {
        DAT_00bdbd04 = 3.0;
      }
    }
  }
  return;
}


