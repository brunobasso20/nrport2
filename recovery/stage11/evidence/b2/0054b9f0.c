/* NR2003.exe @ 0054b9f0 FUN_0054b9f0 */

void __thiscall FUN_0054b9f0(int param_1_00,int param_1,undefined4 param_2)

{
  uint uVar1;
  byte bVar2;
  int iVar3;
  
  bVar2 = (char)param_1 * '\x02';
  uVar1 = *(uint *)(param_1_00 + 4);
  iVar3 = FUN_006c5018();
  *(uint *)(param_1_00 + 4) =
       (~(3 << (bVar2 & 0x1f)) << 7 | 0xffff807fU) & uVar1 | (iVar3 << (bVar2 & 0x1f) & 0xffU) << 7;
  *(undefined4 *)(param_1_00 + 0x3c + param_1 * 4) = param_2;
  return;
}

