/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00578140 */

void __thiscall
FUN_00578140(int param_1_00,int *param_1,int param_2,int *param_3,undefined4 param_5,int param_6)

{
  int iVar1;
  int *piVar2;
  int *piVar3;
  int iVar4;
  int *piVar5;
  int *piVar6;
  undefined4 *puVar7;
  undefined4 uStack_2c;
  undefined1 *local_28;
  undefined1 auStack_24 [4];
  undefined4 uStack_20;
  undefined4 *puStack_1c;
  
  piVar5 = param_3;
  iVar4 = param_2;
  piVar3 = param_1;
  piVar6 = param_1;
  do {
    if (piVar6 == piVar5) {
      return;
    }
    if ((short)piVar6[2] == 0) {
      if ((param_6 == 0) && (iVar1 = piVar6[1], *(int *)(iVar1 + 0xc) != 0)) {
        if (((*(char *)(iVar1 + 0x59) != '\0') || (*(char *)(iVar1 + 0x5a) != '\0')) &&
           ((*(char *)(*piVar6 + 0x59) != '\0' || (*(char *)(*piVar6 + 0x5a) != '\0')))) {
          if ((short)piVar6[2] == 0) {
            *(undefined2 *)(piVar6 + 2) = 1;
            *(int **)(param_1_00 + 0x6c1c + *(int *)(param_1_00 + 0x6c18) * 4) = piVar6;
            *(int *)(param_1_00 + 0x6c18) = *(int *)(param_1_00 + 0x6c18) + 1;
            puStack_1c = (undefined4 *)*piVar6;
            uStack_20 = 0x5781e6;
            FUN_00579a50();
            puStack_1c = (undefined4 *)piVar6[1];
            if (*(int *)((int)puStack_1c + 0xc) != 0) {
              uStack_20 = 0x5781f8;
              FUN_00579a50();
            }
          }
          puStack_1c = (undefined4 *)0x0;
          local_28 = auStack_24;
          uStack_2c = 0x578207;
          FUN_005799c0();
          uStack_2c = 0x57820e;
          FUN_005799f0();
          puVar7 = &uStack_2c;
          FUN_005799c0(&uStack_2c);
          FUN_005799d0(puVar7);
          FUN_00578140();
LAB_00578322:
          puStack_1c = (undefined4 *)0x0;
          local_28 = auStack_24;
          uStack_2c = 0x578331;
          FUN_005799c0();
          uStack_2c = 0x578338;
          FUN_00579a30();
          puVar7 = &uStack_2c;
          FUN_005799c0(&uStack_2c);
          FUN_00579a10(puVar7);
          FUN_00578140();
          piVar6 = piVar3;
        }
      }
      else {
        if ((short)piVar6[2] == 0) {
          puStack_1c = &param_1;
          *(undefined2 *)(piVar6 + 2) = 1;
          uStack_20 = 0x57824d;
          param_1 = piVar6;
          FUN_00579a90();
          puStack_1c = (undefined4 *)*param_1;
          uStack_20 = 0x57825b;
          FUN_00579a50();
          puStack_1c = (undefined4 *)param_1[1];
          piVar6 = piVar3;
          if (*(int *)((int)puStack_1c + 0xc) != 0) {
            uStack_20 = 0x578271;
            FUN_00579a50();
          }
        }
        param_1 = (int *)*piVar6;
        if ((*(char *)((int)param_1 + 0x59) == '\0') && (*(char *)((int)param_1 + 0x5a) == '\0')) {
          puStack_1c = (undefined4 *)(param_1_00 + 0x9930);
          *(undefined1 *)((int)param_1 + 0x59) = 1;
          uStack_20 = 0x57829c;
          FUN_005799a0();
          puStack_1c = &param_1;
          uStack_20 = 0x5782ac;
          FUN_00579a70();
        }
        puStack_1c = (undefined4 *)0x0;
        local_28 = auStack_24;
        uStack_2c = 0x5782bb;
        FUN_005799c0();
        uStack_2c = 0x5782c2;
        FUN_005799f0();
        puVar7 = &uStack_2c;
        FUN_005799c0(&uStack_2c);
        FUN_005799d0(puVar7);
        FUN_00578140();
        piVar2 = (int *)piVar3[1];
        piVar6 = piVar3;
        if (piVar2[3] != 0) {
          param_1 = piVar2;
          if ((*(char *)((int)piVar2 + 0x59) == '\0') && (*(char *)((int)piVar2 + 0x5a) == '\0')) {
            puStack_1c = (undefined4 *)(param_1_00 + 0x9930);
            *(undefined1 *)((int)piVar2 + 0x59) = 1;
            uStack_20 = 0x578312;
            FUN_005799a0();
            puStack_1c = &param_1;
            uStack_20 = 0x578322;
            FUN_00579a70();
          }
          goto LAB_00578322;
        }
      }
    }
    if (iVar4 == *piVar6) {
      piVar3 = *(int **)((int)piVar6 + 0x42);
      piVar6 = piVar3;
    }
    else if (iVar4 == piVar6[1]) {
      piVar3 = *(int **)((int)piVar6 + 0x4a);
      piVar6 = piVar3;
    }
  } while( true );
}


