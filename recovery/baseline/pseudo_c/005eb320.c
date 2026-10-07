/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005eb320 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined1 * __thiscall
FUN_005eb320(undefined4 *param_1_00,undefined1 *param_1,int param_2,int param_3,int param_4,
            int param_5,char param_6)

{
  undefined1 uVar1;
  int iVar2;
  uint uVar3;
  int iVar4;
  int iVar5;
  float10 fVar6;
  undefined1 uVar7;
  undefined1 uVar8;
  float local_24;
  uint local_20;
  int local_1c;
  undefined1 local_10 [3];
  byte bStack_d;
  uint local_8;
  undefined4 uStack_4;
  
  iVar4 = 0;
  uVar3 = 0;
  local_24 = 0.0;
  local_1c = 0;
  local_20 = 0;
  if (DAT_00f6e888 == '\0') {
    do {
      fVar6 = (float10)FUN_006c5c40();
      (&DAT_00f6e480)[iVar4] = (float)fVar6;
      iVar4 = iVar4 + 1;
    } while (iVar4 < 0x100);
    DAT_00f6e888 = '\x01';
  }
  if (param_3 < param_5) {
    do {
      if (param_2 < param_4) {
        uVar3 = local_20 + (param_4 - param_2);
        iVar4 = param_2 * 3;
        iVar5 = param_2;
        do {
          switch(*param_1_00) {
          case 3:
            FUN_005d5390(local_10,iVar5,param_3);
            break;
          case 4:
            FUN_005d53f0(local_10,iVar5,param_3);
            break;
          case 5:
            FUN_004e8d70(local_10,iVar5,param_3);
            break;
          case 6:
            iVar2 = param_1_00[3] * param_3 + param_1_00[4];
            uVar1 = *(undefined1 *)(iVar2 + iVar4);
            iVar2 = iVar2 + iVar4;
            uVar8 = *(undefined1 *)(iVar2 + 2);
            uVar7 = *(undefined1 *)(iVar2 + 1);
            goto LAB_005eb485;
          case 7:
            FUN_005ed500(local_10,iVar5,param_3);
            break;
          case 8:
            uVar8 = *(undefined1 *)(param_1_00[3] * param_3 + param_1_00[4] + iVar5);
            uVar1 = uVar8;
            uVar7 = uVar8;
            goto LAB_005eb485;
          case 9:
            FUN_005d5490(local_10,iVar5,param_3);
            break;
          default:
            uVar8 = 0;
            uVar1 = 0;
            uVar7 = 0;
LAB_005eb485:
            FUN_00465b80(uVar1,uVar7,uVar8,0xff);
          }
          local_8 = (uint)bStack_d;
          uStack_4 = 0;
          local_1c = local_1c + local_8;
          iVar5 = iVar5 + 1;
          iVar4 = iVar4 + 3;
          local_24 = (float)local_8 * _DAT_006f3820 + local_24;
          local_20 = uVar3;
        } while (iVar5 < param_4);
      }
      param_3 = param_3 + 1;
    } while (param_3 < param_5);
    if (uVar3 != 0) {
      if (local_24 < _DAT_006f3fe8) {
        *param_1 = 0;
        param_1[1] = 0;
        param_1[2] = 0;
        param_1[3] = 0;
        return param_1;
      }
      uVar3 = (uint)((int)uVar3 / 2 + local_1c) / uVar3;
      FUN_006c5c40();
      FUN_006c5c40();
      FUN_006c5c40();
      if (param_6 != '\0') {
        uVar3 = -(uint)(0x7f < uVar3) & 0xff;
      }
      uVar1 = FUN_006c5018();
      *param_1 = uVar1;
      uVar1 = FUN_006c5018();
      param_1[1] = uVar1;
      uVar1 = FUN_006c5018();
      param_1[2] = uVar1;
      param_1[3] = (char)uVar3;
      return param_1;
    }
  }
  *param_1 = 0;
  param_1[1] = 0;
  param_1[2] = 0;
  param_1[3] = 0xff;
  return param_1;
}


