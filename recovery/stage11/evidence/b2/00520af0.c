/* NR2003.exe @ 00520af0 FUN_00520af0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_00520af0(int **param_1_00,int param_1,float param_2,float param_3)

{
  uint3 uVar1;
  int iVar2;
  undefined4 uVar3;
  float10 fVar4;
  
  if (param_2 < _DAT_006ea454 == (NAN(param_2) || NAN(_DAT_006ea454))) {
    if (_DAT_006ea4a0 < param_2) {
      param_2 = 2.0;
    }
  }
  else {
    param_2 = 0.0;
  }
  iVar2 = (int)param_3;
  if (*(char *)((int)*param_1_00 + 0x59b) == '\0') {
    iVar2 = (**(code **)(**param_1_00 + 8))();
  }
  if (iVar2 != 0) {
    param_3 = 0.0;
    if (*(char *)((int)*param_1_00 + 0x59b) == '\0') {
      fVar4 = (float10)FUN_00520910(param_1,0);
      param_3 = (float)fVar4;
    }
    switch(param_1) {
    case 0:
      FUN_0054b6c0(2,param_2);
      break;
    case 1:
      FUN_0054b6c0(3,param_2);
      break;
    case 2:
      FUN_0054b6c0(4,param_2);
      break;
    case 3:
      FUN_0054b6c0(5,param_2);
      break;
    case 4:
      FUN_0054b6c0(6,param_2);
      break;
    case 5:
      FUN_0054b6c0(1,param_2);
      break;
    case 6:
      FUN_0054b6c0(0,param_2);
      break;
    case 7:
      FUN_0054b6c0(9,param_2);
      break;
    case 8:
      FUN_0054b6c0(8,param_2);
      break;
    case 9:
      FUN_0054b6c0(7,param_2);
      break;
    case 10:
      FUN_0054b6c0(10,param_2);
      break;
    case 0xb:
      FUN_0054b5a0(param_2);
      break;
    case 0xc:
      FUN_0054b840(param_2);
      break;
    case 0xd:
      FUN_0054b880(param_2);
      break;
    case 0xe:
      FUN_0054b800(param_2);
      break;
    case 0xf:
      FUN_0054b8c0(param_2);
      break;
    case 0x10:
      FUN_0054b900(param_2);
      break;
    case 0x11:
    case 0x12:
      uVar1 = (uint3)(byte)(param_2 < _DAT_006ea454 |
                           (byte)((ushort)((ushort)(param_2 == _DAT_006ea454) << 0xe) >> 8));
      if (param_2 <= _DAT_006ea454) {
        FUN_0054ba50(param_1 + -0x11,(uint)uVar1 << 8);
      }
      else {
        FUN_0054ba50(param_1 + -0x11,CONCAT31(uVar1,1));
      }
      break;
    case 0x13:
    case 0x14:
    case 0x15:
    case 0x16:
      FUN_0054b9f0(param_1 + -0x13,param_2);
      break;
    case 0x17:
    case 0x18:
    case 0x19:
    case 0x1a:
      uVar3 = 3;
      if (param_2 < _DAT_006f3fe8 == (NAN(param_2) || NAN(_DAT_006f3fe8))) {
        if (param_2 < _DAT_006ea44c == (param_2 == _DAT_006ea44c)) {
          if (param_2 < _DAT_006e97d8 != (NAN(param_2) || NAN(_DAT_006e97d8))) {
            uVar3 = 2;
          }
        }
        else {
          uVar3 = 1;
        }
      }
      else {
        uVar3 = 0;
      }
      FUN_0054b9b0(param_1 + -0x17,uVar3);
    }
    if ((*(char *)((int)*param_1_00 + 0x59b) == '\0') &&
       (fVar4 = (float10)FUN_00520910(param_1,iVar2),
       (NAN(fVar4) || NAN((float10)param_3)) == (fVar4 == (float10)param_3))) {
      (**(code **)(**param_1_00 + 0xc))();
    }
  }
  return;
}

