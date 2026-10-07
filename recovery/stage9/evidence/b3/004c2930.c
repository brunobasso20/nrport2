/* NR2003.exe @ 004c2930 FUN_004c2930 */

void __thiscall FUN_004c2930(int *param_1_00,int *param_1)

{
  int *piVar1;
  undefined4 uVar2;
  int iVar3;
  int **ppiVar4;
  
  piVar1 = param_1;
  uVar2 = (**(code **)(*param_1 + 0x78))(&DAT_00743310,&param_1);
  iVar3 = FUN_006c4ac9(uVar2);
  if (iVar3 == 1) {
    if (piVar1 == DAT_008d33b8) {
      ppiVar4 = (int **)(**(code **)(*param_1_00 + 0xc0))();
      if (*ppiVar4 != param_1) {
        ppiVar4 = (int **)(**(code **)(*param_1_00 + 0xc0))();
        *ppiVar4 = param_1;
        (**(code **)(*param_1_00 + 0xc0))();
        (**(code **)(*param_1_00 + 0x170))(99);
        return;
      }
    }
    else if (piVar1 == DAT_008d33bc) {
      ppiVar4 = (int **)(**(code **)(*param_1_00 + 200))();
      if (*ppiVar4 != param_1) {
        ppiVar4 = (int **)(**(code **)(*param_1_00 + 200))();
        *ppiVar4 = param_1;
        (**(code **)(*param_1_00 + 200))();
        (**(code **)(*param_1_00 + 0x174))(99);
        return;
      }
    }
    else if (piVar1 == DAT_008d33c0) {
      ppiVar4 = (int **)(**(code **)(*param_1_00 + 0xcc))();
      if (*ppiVar4 != param_1) {
        ppiVar4 = (int **)(**(code **)(*param_1_00 + 0xcc))();
        *ppiVar4 = param_1;
        (**(code **)(*param_1_00 + 0xcc))();
        (**(code **)(*param_1_00 + 0x178))(99);
        return;
      }
    }
    else if (piVar1 == DAT_008d33c4) {
      ppiVar4 = (int **)(**(code **)(*param_1_00 + 0xe0))();
      if (*ppiVar4 != param_1) {
        ppiVar4 = (int **)(**(code **)(*param_1_00 + 0xe0))();
        *ppiVar4 = param_1;
        (**(code **)(*param_1_00 + 0xe0))();
        (**(code **)(*param_1_00 + 0x188))(99);
        return;
      }
    }
    else if (piVar1 == DAT_008d33c8) {
      ppiVar4 = (int **)(**(code **)(*param_1_00 + 0xe4))();
      if (*ppiVar4 != param_1) {
        ppiVar4 = (int **)(**(code **)(*param_1_00 + 0xe4))();
        *ppiVar4 = param_1;
        (**(code **)(*param_1_00 + 0xe4))();
        (**(code **)(*param_1_00 + 0x18c))(99);
        return;
      }
    }
    else if (piVar1 == DAT_008d33cc) {
      ppiVar4 = (int **)(**(code **)(*param_1_00 + 0x128))();
      if (*ppiVar4 != param_1) {
        ppiVar4 = (int **)(**(code **)(*param_1_00 + 0x128))();
        *ppiVar4 = param_1;
        (**(code **)(*param_1_00 + 0x128))();
        (**(code **)(*param_1_00 + 0x1c8))(99);
        return;
      }
    }
    else if (piVar1 == DAT_008d33d0) {
      ppiVar4 = (int **)(**(code **)(*param_1_00 + 0x130))();
      if (*ppiVar4 != param_1) {
        ppiVar4 = (int **)(**(code **)(*param_1_00 + 0x130))();
        *ppiVar4 = param_1;
        (**(code **)(*param_1_00 + 0x130))();
        (**(code **)(*param_1_00 + 0x1d0))(99);
        return;
      }
    }
  }
  else {
    FUN_004c5f50(&DAT_008d3288);
  }
  return;
}

