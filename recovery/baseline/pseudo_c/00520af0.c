/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00520af0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_00520af0(int *param_1,int param_2,float param_3,float param_4)

{
  int iVar1;
  undefined4 uVar2;
  float10 fVar3;
  
  if (_DAT_006ea454 <= param_3) {
    if (_DAT_006ea4a0 < param_3) {
      param_3 = 2.0;
    }
  }
  else {
    param_3 = 0.0;
  }
  iVar1 = (int)param_4;
  if (*(char *)(*param_1 + 0x59b) == '\0') {
    iVar1 = (**(code **)(*(int *)*param_1 + 8))();
  }
  if (iVar1 != 0) {
    param_4 = 0.0;
    if (*(char *)(*param_1 + 0x59b) == '\0') {
      fVar3 = (float10)FUN_00520910(param_2,0);
      param_4 = (float)fVar3;
    }
    switch(param_2) {
    case 0:
      FUN_0054b6c0(2,param_3);
      break;
    case 1:
      FUN_0054b6c0(3,param_3);
      break;
    case 2:
      FUN_0054b6c0(4,param_3);
      break;
    case 3:
      FUN_0054b6c0(5,param_3);
      break;
    case 4:
      FUN_0054b6c0(6,param_3);
      break;
    case 5:
      FUN_0054b6c0(1,param_3);
      break;
    case 6:
      FUN_0054b6c0(0,param_3);
      break;
    case 7:
      FUN_0054b6c0(9,param_3);
      break;
    case 8:
      FUN_0054b6c0(8,param_3);
      break;
    case 9:
      FUN_0054b6c0(7,param_3);
      break;
    case 10:
      FUN_0054b6c0(10,param_3);
      break;
    case 0xb:
      FUN_0054b5a0(param_3);
      break;
    case 0xc:
      FUN_0054b840(param_3);
      break;
    case 0xd:
      FUN_0054b880(param_3);
      break;
    case 0xe:
      FUN_0054b800(param_3);
      break;
    case 0xf:
      FUN_0054b8c0(param_3);
      break;
    case 0x10:
      FUN_0054b900(param_3);
      break;
    case 0x11:
    case 0x12:
      if (param_3 <= _DAT_006ea454) {
        FUN_0054ba50(param_2 + -0x11,(uint)(uint3)(param_3 < _DAT_006ea454) << 8);
      }
      else {
        FUN_0054ba50(param_2 + -0x11,CONCAT31((uint3)(param_3 < _DAT_006ea454),1));
      }
      break;
    case 0x13:
    case 0x14:
    case 0x15:
    case 0x16:
      FUN_0054b9f0(param_2 + -0x13,param_3);
      break;
    case 0x17:
    case 0x18:
    case 0x19:
    case 0x1a:
      uVar2 = 3;
      if (_DAT_006f3fe8 <= param_3) {
        if (param_3 < _DAT_006ea44c == (param_3 == _DAT_006ea44c)) {
          if (param_3 < _DAT_006e97d8) {
            uVar2 = 2;
          }
        }
        else {
          uVar2 = 1;
        }
      }
      else {
        uVar2 = 0;
      }
      FUN_0054b9b0(param_2 + -0x17,uVar2);
    }
    if ((*(char *)(*param_1 + 0x59b) == '\0') &&
       (fVar3 = (float10)FUN_00520910(param_2,iVar1), fVar3 != (float10)param_4)) {
      (**(code **)(*(int *)*param_1 + 0xc))();
    }
  }
  return;
}


