/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00574020 */

void FUN_00574020(undefined4 *param_1)

{
  int iVar1;
  char cVar2;
  int iVar3;
  int iVar4;
  int iVar5;
  undefined4 *puVar6;
  int iVar7;
  undefined4 *puVar8;
  
  iVar7 = param_1[0x2a];
  iVar3 = FUN_0055a5a0();
  iVar4 = FUN_0055a5c0();
  iVar1 = iVar7 * 0xce;
  if (((&DAT_00c72730)[iVar7 * 0xce] == '\0') || (*(int *)(&DAT_00c727db + iVar1) != param_1[0x29]))
  {
    puVar6 = param_1;
    puVar8 = (undefined4 *)(&DAT_00c72737 + iVar1);
    for (iVar7 = 0x2b; iVar7 != 0; iVar7 = iVar7 + -1) {
      *puVar8 = *puVar6;
      puVar6 = puVar6 + 1;
      puVar8 = puVar8 + 1;
    }
    *(undefined2 *)puVar8 = *(undefined2 *)puVar6;
    *(undefined1 *)((int)puVar8 + 2) = *(undefined1 *)((int)puVar6 + 2);
    iVar7 = FUN_00562f70(param_1[0x2a]);
    *(undefined1 *)(iVar7 + 0x59b) = *(undefined1 *)(param_1 + 0x2b);
    if (1 < iVar3) {
      FUN_005631c0(param_1[0x2a]);
    }
    FUN_005aa3c0(param_1[0x2a]);
    (&DAT_00c72733)[iVar1] = param_1[0x25] != 0;
    (&DAT_00c72732)[iVar1] = 1;
    (&DAT_00c72734)[iVar1] = 0;
    (&DAT_00c72735)[iVar1] = 0;
    (&DAT_00c72730)[iVar1] = 1;
    (&DAT_00c72731)[iVar1] = 1;
    if (1 < iVar3) {
      puVar6 = (undefined4 *)FUN_00562f70(param_1[0x2a]);
      (**(code **)*puVar6)();
    }
    puVar6 = (undefined4 *)FUN_005aa360(param_1[0x2a]);
    (**(code **)*puVar6)();
    cVar2 = FUN_005c2cf0(DAT_00c08194);
    if (cVar2 == '\0') goto LAB_005742b9;
    iVar7 = FUN_005c2d40(DAT_00c08194);
    if (iVar7 != 2) goto LAB_005742b9;
    iVar7 = FUN_005c2d20(DAT_00c08194);
    if (iVar7 == 1) goto LAB_005742b9;
    iVar3 = FUN_00562f70(param_1[0x2a]);
    iVar7 = param_1[0x2a];
  }
  else {
    if (((*(int *)(&DAT_00c727c7 + iVar1) != param_1[0x24]) ||
        (*(int *)(&DAT_00c727cb + iVar1) != param_1[0x25])) ||
       (*(int *)(&DAT_00c727d3 + iVar1) != param_1[0x27])) {
      iVar7 = param_1[0x25];
      (&DAT_00c72732)[iVar1] = 1;
      (&DAT_00c72733)[iVar1] = iVar7 != 0;
      (&DAT_00c72734)[iVar1] = 0;
      (&DAT_00c72735)[iVar1] = 0;
    }
    puVar6 = param_1;
    puVar8 = (undefined4 *)(&DAT_00c72737 + iVar1);
    for (iVar7 = 0x2b; iVar7 != 0; iVar7 = iVar7 + -1) {
      *puVar8 = *puVar6;
      puVar6 = puVar6 + 1;
      puVar8 = puVar8 + 1;
    }
    *(undefined2 *)puVar8 = *(undefined2 *)puVar6;
    *(undefined1 *)((int)puVar8 + 2) = *(undefined1 *)((int)puVar6 + 2);
    iVar7 = FUN_00562f70(param_1[0x2a]);
    *(undefined1 *)(iVar7 + 0x59b) = *(undefined1 *)(param_1 + 0x2b);
    if (iVar3 < 2) goto LAB_005742b9;
    iVar7 = param_1[0x2a];
    iVar5 = FUN_0055ab00();
    if (((iVar7 == iVar5) && ((iVar3 == 4 || (iVar3 == 5)))) && (iVar4 == 3)) goto LAB_005742b9;
    puVar6 = (undefined4 *)FUN_00562f70(iVar7);
    (**(code **)*puVar6)();
    puVar6 = (undefined4 *)FUN_005aa360(param_1[0x2a]);
    (**(code **)*puVar6)();
    iVar7 = FUN_005c2d20(DAT_00c08194);
    if (iVar7 == 1) goto LAB_005742b9;
    iVar3 = FUN_00562f70(param_1[0x2a]);
    iVar7 = param_1[0x2a];
  }
  FUN_00433cb0(iVar7,iVar3 + 0x58e,&DAT_00c08874 + iVar7 * 0x32c);
LAB_005742b9:
  (&DAT_00c72736)[iVar1] = 0;
  DAT_00c74dd0 = 1;
  DAT_00c74e00 = 1;
  return;
}


