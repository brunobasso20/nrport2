/* Ghidra pseudo-C; NR2003.exe @ 00561a80 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void recovered_00561a80(void)

{
  float fVar1;
  float fVar2;
  float fVar3;
  undefined4 uVar4;
  int iVar5;
  
  uVar4 = FUN_0055ab00();
  iVar5 = FUN_00562f70(uVar4);
  iVar5 = *(int *)(iVar5 + 0x5ae);
  if (iVar5 != 0) {
    fVar1 = DAT_00e0b840 * *(float *)(iVar5 + 0x24) +
            DAT_00e0b848 * *(float *)(iVar5 + 0x2c) + DAT_00e0b844 * *(float *)(iVar5 + 0x28);
    fVar2 = DAT_00e0b844 - fVar1 * *(float *)(iVar5 + 0x28);
    fVar3 = DAT_00e0b848 - fVar1 * *(float *)(iVar5 + 0x2c);
    *(float *)PTR_DAT_0074e094 = (DAT_00e0b840 - fVar1 * *(float *)(iVar5 + 0x24)) * _DAT_006ea44c;
    *(float *)PTR_DAT_0074e098 = fVar2 * _DAT_006ea44c;
    *(float *)PTR_DAT_0074e09c = fVar3 * _DAT_006ea44c;
    return;
  }
  *(float *)PTR_DAT_0074e094 = DAT_00e0b840 * _DAT_006ea44c;
  *(float *)PTR_DAT_0074e098 = DAT_00e0b844 * _DAT_006ea44c;
  *(float *)PTR_DAT_0074e09c = DAT_00e0b848 * _DAT_006ea44c;
  return;
}

