/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0055ab90 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0055ab90(uint param_1,int param_2)

{
  byte bVar1;
  int iVar2;
  float *pfVar3;
  int iVar4;
  
  DAT_00c06d3e = DAT_00c06d3e + 1;
  iVar4 = 0;
  pfVar3 = (float *)&DAT_00c06d43;
  do {
    if ((iVar4 < (int)(param_1 >> 1)) && ((*(byte *)(param_2 + iVar4 * 2) & 1) != 0)) {
      *(undefined1 *)((int)pfVar3 + -1) = 1;
      bVar1 = *(byte *)(param_2 + 1 + iVar4 * 2);
      iVar2 = taskGetRate();
      *pfVar3 = ((float)(bVar1 & 0x7f) / (float)iVar2) * _DAT_006ea44c;
      pfVar3[1] = (float)(*(byte *)(param_2 + iVar4 * 2) >> 1) * _DAT_006ea4a4;
    }
    else {
      *(undefined1 *)((int)pfVar3 + -1) = 0;
      *pfVar3 = 0.0;
      pfVar3[1] = 0.0;
    }
    pfVar3 = (float *)((int)pfVar3 + 9);
    iVar4 = iVar4 + 1;
  } while ((int)pfVar3 < 0xc06ef3);
  return;
}


