/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00520910 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 __thiscall FUN_00520910(int *param_1_00,int param_1,ushort *param_2)

{
  float fVar1;
  float10 fVar2;
  
  fVar1 = _DAT_006ea454;
  fVar2 = (float10)_DAT_006ea454;
  if ((int *)*param_1_00 != (int *)0x0) {
    if (param_2 == (ushort *)0x0) {
      param_2 = (ushort *)(**(code **)(*(int *)*param_1_00 + 4))();
      if (param_2 == (ushort *)0x0) {
        return (float10)fVar1;
      }
    }
    fVar2 = (float10)fVar1;
    switch(param_1) {
    case 0:
      return (float10)*(float *)(param_2 + 0xc);
    case 1:
      return (float10)*(float *)(param_2 + 0xe);
    case 2:
      return (float10)*(float *)(param_2 + 0x10);
    case 3:
      return (float10)*(float *)(param_2 + 0x12);
    case 4:
      return (float10)*(float *)(param_2 + 0x14);
    case 5:
      return (float10)*(float *)(param_2 + 10);
    case 6:
      return (float10)*(float *)(param_2 + 8);
    case 7:
      return (float10)*(float *)(param_2 + 0x1a);
    case 8:
      return (float10)*(float *)(param_2 + 0x18);
    case 9:
      return (float10)*(float *)(param_2 + 0x16);
    case 10:
      return (float10)*(float *)(param_2 + 0x1c);
    case 0xb:
      return (float10)*(float *)(param_2 + 0x2c);
    case 0xc:
      return (float10)*(float *)(param_2 + 0x30);
    case 0xd:
      return (float10)*(float *)(param_2 + 0x2e);
    case 0xe:
      return (float10)*(float *)(param_2 + 0x2a);
    case 0xf:
      return (float10)*(float *)(param_2 + 0x26);
    case 0x10:
      return (float10)*(float *)(param_2 + 0x28);
    case 0x11:
    case 0x12:
      if ((1 << ((char)param_1 - 0x11U & 0x1f) & *(uint *)(param_2 + 6) >> 0x1d & 3) != 0) {
        return (float10)_DAT_006e97d8;
      }
LAB_00520a3d:
      return (float10)_DAT_006ea454;
    case 0x13:
    case 0x14:
    case 0x15:
    case 0x16:
      return (float10)*(float *)(param_2 + param_1 * 2 + -8);
    case 0x17:
    case 0x18:
    case 0x19:
    case 0x1a:
      switch(((*param_2 & 0x3fc0) >> 6) >> (((char)param_1 + -0x17) * '\x02' & 0x1fU) & 3) {
      case 0:
        goto LAB_00520a3d;
      case 1:
        return (float10)_DAT_006ea674;
      case 2:
        return (float10)_DAT_006ea670;
      case 3:
        fVar2 = (float10)_DAT_006e97d8;
      }
    }
  }
  return fVar2;
}


