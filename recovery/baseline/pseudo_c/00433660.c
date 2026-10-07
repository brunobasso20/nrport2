/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00433660 */

int * FUN_00433660(void)

{
  undefined4 *puVar1;
  int *piVar2;
  int iVar3;
  int *local_9c [10];
  int local_74 [13];
  undefined4 local_40;
  undefined4 local_34;
  undefined4 local_28;
  undefined4 local_1c;
  undefined4 local_10;
  undefined4 local_4;
  
  iVar3 = 0;
  while( true ) {
    puVar1 = (undefined4 *)FUN_00547e60(0x18);
    if (puVar1 == (undefined4 *)0x0) {
      puVar1 = (undefined4 *)0x0;
    }
    else {
      *puVar1 = 0;
      puVar1[1] = 0;
      puVar1[2] = 0xffffffff;
      puVar1[3] = 0xffffffff;
      puVar1[4] = 0;
      puVar1[5] = iVar3;
    }
    local_74[iVar3] = (int)puVar1;
    if (puVar1 == (undefined4 *)0x0) break;
    iVar3 = iVar3 + 1;
    if (10 < iVar3) {
      iVar3 = 0;
      while( true ) {
        piVar2 = (int *)FUN_00547e60(0x18);
        if (piVar2 == (int *)0x0) {
          piVar2 = (int *)0x0;
        }
        else {
          *piVar2 = 0;
          piVar2[1] = 0;
          piVar2[2] = -1;
          piVar2[3] = -1;
          piVar2[4] = 0;
          piVar2[5] = iVar3;
        }
        local_9c[iVar3] = piVar2;
        if (piVar2 == (int *)0x0) break;
        iVar3 = iVar3 + 1;
        if (9 < iVar3) {
          local_28 = 0x3f4ccccd;
          local_1c = 0xbfc00000;
          *local_9c[9] = (int)local_9c[2];
          local_9c[9][1] = (int)local_9c[8];
          local_9c[9][5] = -1;
          local_9c[9][2] = 0;
          local_4 = 0x3f000000;
          local_34 = 0x3e4ccccd;
          local_9c[9][3] = 0;
          local_10 = 0;
          local_40 = 0x3f400000;
          local_9c[9][4] = 0x3f4ccccd;
          *local_9c[8] = (int)local_9c[3];
          local_9c[8][1] = (int)local_9c[7];
          local_9c[8][5] = -1;
          local_9c[8][2] = 0;
          local_9c[8][3] = 0;
          local_9c[8][4] = -0x40400000;
          *local_9c[3] = local_74[10];
          local_9c[3][1] = (int)local_9c[4];
          local_9c[3][5] = 0xffffffff;
          local_9c[3][2] = 0;
          local_9c[3][3] = 2;
          local_9c[3][4] = 0x3f000000;
          *local_9c[4] = local_74[7];
          local_9c[4][1] = local_74[8];
          local_9c[4][5] = 0xffffffff;
          local_9c[4][2] = 0;
          local_9c[4][3] = 1;
          local_9c[4][4] = 0;
          *local_9c[2] = local_74[0];
          local_9c[2][1] = (int)local_9c[1];
          local_9c[2][5] = -1;
          local_9c[2][2] = 0;
          local_9c[2][3] = 1;
          local_9c[2][4] = 0x3f400000;
          *local_9c[1] = (int)local_9c[0];
          local_9c[1][1] = local_74[1];
          local_9c[1][5] = -1;
          local_9c[1][2] = 0;
          local_9c[1][3] = 1;
          local_9c[1][4] = -0x40c00000;
          *local_9c[0] = local_74[4];
          local_9c[0][1] = local_74[5];
          local_9c[0][5] = -1;
          local_9c[0][2] = 0;
          local_9c[0][3] = 2;
          local_9c[0][4] = 0x3e4ccccd;
          *local_9c[7] = local_74[2];
          local_9c[7][1] = (int)local_9c[6];
          local_9c[7][5] = 0xffffffff;
          local_9c[7][2] = 0;
          local_9c[7][3] = 1;
          local_9c[7][4] = 0x3f400000;
          local_9c[6][1] = local_74[3];
          *local_9c[6] = (int)local_9c[5];
          local_9c[6][5] = 0xffffffff;
          local_9c[6][2] = 0;
          local_9c[6][3] = 1;
          local_9c[6][4] = 0xbf400000;
          FUN_004347b0(local_74[9],local_74[6],0,2,0x3e4ccccd);
          return local_9c[9];
        }
      }
      FUN_00433970(local_9c,iVar3);
      FUN_00433970(local_74,0xb);
      return (int *)0x0;
    }
  }
  FUN_00433970(local_74,iVar3);
  return (int *)0x0;
}


