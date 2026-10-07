/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00529b90 */

void FUN_00529b90(void)

{
  undefined4 uVar1;
  undefined *puVar2;
  undefined *puVar3;
  undefined4 *puVar4;
  int iVar5;
  undefined **ppuVar6;
  int *piVar7;
  undefined4 *puVar8;
  undefined4 local_50 [5];
  undefined4 local_3a [14];
  
  puVar8 = &DAT_00bd79e0;
  ppuVar6 = &PTR_s_SAFETY_0071e840;
  do {
    puVar4 = local_50;
    iVar5 = 2;
    do {
      puVar4[-3] = &PTR_FUN_006ed6e8;
      puVar4[-1] = 0;
      *puVar4 = 0;
      puVar4[1] = 0;
      *(undefined1 *)(puVar4 + 4) = 0;
      *(undefined1 *)((int)puVar4 + 0x11) = 0;
      *(undefined4 *)((int)puVar4 + 0x12) = 0;
      puVar4 = (undefined4 *)((int)puVar4 + 0x2e);
      iVar5 = iVar5 + -1;
    } while (iVar5 != 0);
    piVar7 = &DAT_0074bc14;
    puVar4 = local_3a;
    do {
      iVar5 = *piVar7;
      uVar1 = (&DAT_0074aa7c)[iVar5 * 6];
      puVar2 = (&PTR_s_yaw_accel_k1_0074aa78)[iVar5 * 6];
      puVar3 = *ppuVar6;
      *puVar8 = (&DAT_0074aa80)[iVar5 * 6];
      FUN_005cfcc6(0x48,puVar3,puVar2,uVar1,2,2);
      uVar1 = *puVar8;
      *puVar4 = puVar8;
      piVar7 = piVar7 + 1;
      puVar4[1] = uVar1;
      puVar4[2] = uVar1;
      puVar4 = (undefined4 *)((int)puVar4 + 0x2e);
      puVar8 = puVar8 + 1;
    } while ((int)piVar7 < 0x74bc1c);
    FUN_005cfd26(0x48,s_papy_ai_ini_0074bcc8);
    iVar5 = 2;
    do {
      FUN_005cfcc0();
      iVar5 = iVar5 + -1;
    } while (iVar5 != 0);
    iVar5 = 2;
    do {
      FUN_005cfcd2();
      iVar5 = iVar5 + -1;
    } while (iVar5 != 0);
    ppuVar6 = ppuVar6 + 1;
  } while ((int)ppuVar6 < 0x71e854);
  return;
}


