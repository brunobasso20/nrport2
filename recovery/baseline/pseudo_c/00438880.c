/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00438880 */

undefined4 __fastcall FUN_00438880(int param_1)

{
  undefined4 *puVar1;
  char cVar2;
  
  if (*(int *)(param_1 + 4) != 0) {
    puVar1 = (undefined4 *)(param_1 + 0x1d);
    cVar2 = FUN_005fbf30(puVar1,s_inpFileName_007263bc);
    if (cVar2 != '\0') {
      cVar2 = FUN_005fbce0((undefined4 *)(param_1 + 0x21),s_grpCClass_007263c8);
      if (((cVar2 != '\0') &&
          (cVar2 = FUN_005fc300(param_1 + 0x25,s_lstCClass_007263d4), cVar2 != '\0')) &&
         (cVar2 = FUN_005fc300(param_1 + 0x3d,s_lstChassis_007263e0), cVar2 != '\0')) {
        FUN_00438970();
        FUN_00438ad0();
        (**(code **)(**(int **)(param_1 + 0x21) + 0x4c))();
        (**(code **)(**(int **)(param_1 + 4) + 0x50))(*puVar1);
        return 1;
      }
    }
    *puVar1 = 0;
    *(undefined4 *)(param_1 + 0x21) = 0;
    *(undefined4 *)(param_1 + 0x25) = 0;
    *(undefined4 *)(param_1 + 0x3d) = 0;
  }
  return 0;
}


