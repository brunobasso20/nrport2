/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0056e000 */

void FUN_0056e000(void)

{
  int iVar1;
  int iVar2;
  undefined4 *puVar3;
  
  puVar3 = &DAT_00c5cb20;
  for (iVar2 = 0x200; iVar2 != 0; iVar2 = iVar2 + -1) {
    *puVar3 = 0;
    puVar3 = puVar3 + 1;
  }
  puVar3 = &DAT_00c5d510;
  for (iVar2 = 0xc0; iVar2 != 0; iVar2 = iVar2 + -1) {
    *puVar3 = 0;
    puVar3 = puVar3 + 1;
  }
  if (DAT_00c5f426 == '\0') {
    iVar2 = 0;
    do {
      FUN_006c4f81(&DAT_00c5d510 + iVar2 * 3,s_Race_d_0074f304,iVar2);
      iVar1 = iVar2 * 0x66;
      FUN_005cfcc6(0x14,s_Dedicated_Server_0074f330,&DAT_00c5d510 + iVar2 * 3,
                   s_Next_track_at_which_to_run_a_rac_0074f30c,2,
                   (-(uint)(iVar2 != 0) & 0xfffffffe) + 2);
      *(undefined4 **)((int)&DAT_00c5d8fa + iVar1) = &DAT_00c5cb20 + iVar2 * 8;
      FUN_006c4b00(&DAT_00c5d8fe + iVar1,&DAT_00c5cb20 + iVar2 * 8,0x20);
      FUN_006c4b00(&DAT_00c5d91e + iVar1,&DAT_00c5d8fe + iVar1,0x20);
      iVar2 = iVar2 + 1;
    } while (iVar2 < 0x40);
    DAT_00c5f426 = '\x01';
  }
  DAT_0074ee84 = 0xffffffff;
  return;
}


