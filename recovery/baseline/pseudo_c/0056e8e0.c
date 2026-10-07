/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0056e8e0 */

uint __thiscall FUN_0056e8e0(uint *param_1_00,uint *param_1)

{
  uint uVar1;
  uint uVar2;
  uint uVar3;
  byte bVar4;
  uint uVar5;
  undefined3 uVar6;
  
  uVar5 = *param_1 ^ *param_1_00;
  if ((uVar5 & 0xffff) == 0) {
    uVar6 = (undefined3)(uVar5 >> 8);
    uVar5 = CONCAT31(uVar6,*(char *)((int)param_1_00 + 2));
    if ((*(char *)((int)param_1 + 2) == *(char *)((int)param_1_00 + 2)) &&
       (uVar5 = CONCAT31(uVar6,*(char *)((int)param_1_00 + 3)),
       *(char *)((int)param_1_00 + 3) == *(char *)((int)param_1 + 3))) {
      uVar1 = param_1_00[1];
      uVar2 = param_1[1];
      if ((((uVar1 ^ uVar2) & 0xfe00) == 0) &&
         ((bVar4 = *(byte *)((int)param_1_00 + 6) ^ *(byte *)((int)param_1 + 6),
          uVar5 = CONCAT31(uVar6,bVar4), (bVar4 & 0x7f) == 0 &&
          (((uVar1 ^ uVar2) & 0x3f800000) == 0)))) {
        uVar5 = param_1_00[2];
        uVar3 = param_1[2];
        if ((((((uVar5 ^ uVar3) & 0x7f) == 0) &&
             (((((((uVar1 ^ uVar2) & 0x1fc) == 0 && (((uVar5 ^ uVar3) & 0x800) == 0)) &&
                (((uVar1 ^ uVar2) & 1) == 0)) &&
               ((((uVar5 ^ uVar3) & 0x80000) == 0 && (((uVar5 ^ uVar3) & 0x20000000) == 0)))) &&
              ((((uVar5 ^ uVar3) & 0x100000) == 0 &&
               ((((uVar1 ^ uVar2) & 2) == 0 && (((uVar5 ^ uVar3) & 0x200000) == 0)))))))) &&
            (((uVar5 ^ uVar3) & 0x200) == 0)) &&
           ((((((uVar5 ^ uVar3) & 0x400) == 0 &&
              (((*(byte *)((int)param_1_00 + 10) ^ *(byte *)((int)param_1 + 10)) & 1) == 0)) &&
             (((uVar5 ^ uVar3) & 0x180) == 0)) &&
            ((((((uVar5 ^ uVar3) & 0x60000) == 0 && (((uVar5 ^ uVar3) & 0xc00000) == 0)) &&
              ((((uVar5 ^ uVar3) & 0xf000) == 0 &&
               ((uVar5 = uVar5 ^ uVar3, (uVar5 & 0x2000000) == 0 &&
                (uVar5 = param_1_00[4], uVar5 == param_1[4])))))) &&
             (uVar5 = param_1[5], param_1_00[5] == uVar5)))))) {
          return CONCAT31((int3)(uVar5 >> 8),1);
        }
      }
    }
  }
  return uVar5 & 0xffffff00;
}


