/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0055d9c0 */

void FUN_0055d9c0(int param_1)

{
  int iVar1;
  undefined **ppuVar2;
  int iVar3;
  
  iVar3 = (&DAT_00c084ac)[param_1];
  if (param_1 < 2) {
    (**(code **)(PTR_PTR_0074fe48 + 0xc))
              (&DAT_00c08590,&DAT_00c08520 + param_1 * 4,
               *(int *)(*(int *)(iVar3 + 0x6d) + 0x6d) + 0x2d5);
    (**(code **)(PTR_PTR_0074fe48 + 0xc))
              (&DAT_00c084fc,&DAT_00c08224 + param_1 * 4,
               *(int *)(*(int *)(iVar3 + 0x6d) + 0x6d) + 0x2d5);
    (**(code **)PTR_PTR_0074fe48)(&DAT_00c084fc,&DAT_00c084fc,&DAT_00c0849c + param_1 * 4);
    (**(code **)(PTR_PTR_0074fe48 + 0xc))
              (&DAT_00c082ac,&DAT_00c085a4 + param_1 * 4,*(int *)(iVar3 + 0x6d) + 0x35d);
  }
  else {
    (**(code **)PTR_PTR_0074fe4c)(&DAT_00c084fc,&DAT_00c0849c + param_1 * 4);
    (**(code **)(PTR_PTR_0074fe48 + 0xc))(&DAT_00c08590,&DAT_00c08490,DAT_00c08254 + 0x2d5);
    (**(code **)(PTR_PTR_0074fe48 + 0xc))(&DAT_00c08340,&DAT_00c081f0,DAT_00c08254 + 0x35d);
    (**(code **)PTR_PTR_0074fe48)(&DAT_00c08590,&DAT_00c08590,&DAT_00c08340);
    (**(code **)PTR_PTR_0074fe48)(&DAT_00c08590,&DAT_00c08590,&DAT_00c08534);
  }
  (**(code **)(PTR_PTR_0074fe4c + 0x10))(&DAT_00c08690,&DAT_00c08590);
  (**(code **)(PTR_PTR_0074fe4c + 0x14))(&DAT_00c08694,&DAT_00c08590);
  (**(code **)(PTR_PTR_0074fe4c + 0x14))(&DAT_00c084f4,&DAT_00c084fc);
  (**(code **)(PTR_PTR_0074fe48 + 0xc))(&DAT_00c08694,&DAT_00c08694,&DAT_00c084f4);
  (**(code **)(PTR_PTR_0074fe4c + 0x10))(&DAT_00c08698,&DAT_00c084fc);
  iVar1 = iVar3 + 0x309;
  FUN_005b8370(&DAT_00c08654,iVar1,&DAT_00c08690);
  FUN_005b7e90(&DAT_00c085b0,&DAT_00c08654,&DAT_00c08628);
  FUN_005b7fa0(&DAT_00c085b0);
  FUN_005b7e90(&DAT_00c083c8,&DAT_00c08628,&DAT_00c085b0);
  FUN_005b7fa0(&DAT_00c083c8);
  FUN_005b7e30(&DAT_00c0833c,iVar3 + 0x32d,&DAT_00c08628);
  (**(code **)PTR_PTR_0074fe48)(&DAT_00c0833c,&DAT_00c0833c,&DAT_00c08568);
  FUN_005b7e30(&DAT_00c08258,&DAT_00c08654,&DAT_00c08628);
  (**(code **)(PTR_PTR_0074fe48 + 0xc))(&DAT_00c082b8,&DAT_00c08258,&PTR_DAT_0074e768 + param_1);
  (**(code **)(PTR_PTR_0074fe4c + 0x20))(&DAT_00c082b8,&DAT_00c082b8);
  FUN_005b7e30(&DAT_00c084f4,&DAT_00c08654,&DAT_00c083c8);
  ppuVar2 = &PTR_DAT_0074e758 + param_1;
  (**(code **)(PTR_PTR_0074fe48 + 0xc))(&DAT_00c08688,&DAT_00c084f4,ppuVar2);
  (**(code **)(PTR_PTR_0074fe48 + 0xc))(&DAT_00c08488,&DAT_00c084f4,&PTR_DAT_0074e778 + param_1);
  (**(code **)(PTR_PTR_0074fe48 + 0xc))(&DAT_00c08488,&DAT_00c084f4,&DAT_00c08488);
  (**(code **)PTR_PTR_0074fe48)(&DAT_00c085c0,&DAT_00c08688,&DAT_00c082b8);
  (**(code **)(PTR_PTR_0074fe48 + 8))(&DAT_00c08530,&DAT_00c0833c,&DAT_00c085c0);
  (**(code **)(PTR_PTR_0074fe4c + 0x1c))(&DAT_00c08530,&DAT_00c08530);
  (**(code **)PTR_PTR_0074fe48)(&DAT_00c085c0,&DAT_00c085c0,&DAT_00c08488);
  (**(code **)(PTR_PTR_0074fe48 + 8))(&DAT_00c0833c,&DAT_00c0833c,&DAT_00c085c0);
  (**(code **)(PTR_PTR_0074fe4c + 0x1c))(&DAT_00c0833c,&DAT_00c0833c);
  (**(code **)(PTR_PTR_0074fe48 + 8))(&DAT_00c0833c,&DAT_00c0833c,&DAT_00c08530);
  (**(code **)PTR_PTR_0074fe48)(&DAT_00c083ac,&DAT_00c0833c,&DAT_00c08488);
  (**(code **)PTR_PTR_0074fe48)(&DAT_00c083ac,&DAT_00c083ac,&DAT_00c082b8);
  (**(code **)(PTR_PTR_0074fe48 + 0xc))(&DAT_00c083ac,&DAT_00c083ac,&DAT_00c084f4);
  (**(code **)PTR_PTR_0074fe48)(&DAT_00c083ac,&DAT_00c083ac,ppuVar2);
  (**(code **)(PTR_PTR_0074fe4c + 4))(&DAT_00c0834c,&DAT_00c085c0);
  (**(code **)(PTR_PTR_0074fe48 + 8))(&DAT_00c0834c,&DAT_00c0834c,&DAT_00c0833c);
  FUN_005b7df0(&DAT_00c08670,&DAT_00c0834c,&DAT_00c08628);
  (**(code **)(PTR_PTR_0074fe48 + 0xc))(&DAT_00c0834c,&DAT_00c08258,ppuVar2);
  FUN_005b7df0(&DAT_00c08388,&DAT_00c0834c,&DAT_00c083c8);
  FUN_005b7d70(&DAT_00c08554,&DAT_00c08670,&DAT_00c08388);
  FUN_005b87c0(&DAT_00c08670,iVar1,&DAT_00c08554);
  FUN_005b7d70(&DAT_00c08554,&DAT_00c08554,iVar3 + 0x32d);
  FUN_005b7e90(&DAT_00c082a0,*(int *)(iVar3 + 0x6d) + 0x3d9,&DAT_00c08670);
  FUN_005b7d70(&DAT_00c082a0,&DAT_00c082a0,iVar3 + 0x3cd);
  FUN_005b8370(&DAT_00c082a0,iVar1,&DAT_00c082a0);
  FUN_005b7db0(&DAT_00c082a0,&DAT_00c082a0,&DAT_00c08304);
  (**(code **)(PTR_PTR_0074fe48 + 0xc))(&DAT_00c083a0,iVar3 + 0x395,&DAT_00c08290 + param_1 * 4);
  FUN_005b7e30(&DAT_00c08350,&DAT_00c082a0,&DAT_00c085b0);
  FUN_005b7e30(&DAT_00c08300,&DAT_00c082a0,&DAT_00c083c8);
  FUN_005b7e30(&DAT_00c085d8,&DAT_00c082a0,&DAT_00c08628);
  FUN_005b7db0(&DAT_00c08594,&DAT_00c08554,&DAT_00c08538);
  FUN_005b7e30(&DAT_00c08680,&DAT_00c08594,&DAT_00c085b0);
  (**(code **)(PTR_PTR_0074fe48 + 0xc))(&DAT_00c08638,&DAT_00c083a0,&PTR_DAT_0074fd9c);
  (**(code **)(PTR_PTR_0074fe48 + 8))(&DAT_00c08680,&DAT_00c08680,&DAT_00c08638);
  FUN_005b7e30(&DAT_00c084f8,&DAT_00c08594,&DAT_00c083c8);
  FUN_0057cbd0(&DAT_00c081e4);
  FUN_0057cbd0(&DAT_00c08684);
  FUN_0057cbd0(&DAT_00c083a4);
  FUN_0057cbd0(&DAT_00c082b4);
  FUN_0057cba0(&DAT_00c08350);
  FUN_0057cba0(&DAT_00c08300);
  FUN_0057cba0(&DAT_00c085d8);
  FUN_0057cba0(&DAT_00c083a0);
  FUN_0057cba0(&DAT_00c0833c);
  FUN_0057cba0(&DAT_00c08530);
  FUN_0057cba0(&DAT_00c08258);
  FUN_0057cba0(&DAT_00c08680);
  FUN_0057cba0(&DAT_00c084f8);
  FUN_0057cba0(&DAT_00c082ac);
  FUN_0057cc10((&PTR_LAB_0074df10)[param_1]);
  FUN_005b7df0(&DAT_00c085cc,&DAT_00c08684,&DAT_00c085b0);
  FUN_005b7df0(&DAT_00c08388,&DAT_00c083a4,&DAT_00c083c8);
  FUN_005b7d70(&DAT_00c085cc,&DAT_00c085cc,&DAT_00c08388);
  FUN_005b7df0(&DAT_00c08388,&DAT_00c082b4,&DAT_00c08628);
  FUN_005b7d70(&DAT_00c085cc,&DAT_00c085cc,&DAT_00c08388);
  FUN_005b87c0(&DAT_00c084e4,iVar1,&DAT_00c085cc);
  FUN_005b7df0(&DAT_00c08388,&DAT_00c081e4,&DAT_00c085b0);
  FUN_005b87c0(&DAT_00c08388,iVar1,&DAT_00c08388);
  (**(code **)PTR_PTR_0074fe48)(&DAT_00c084e8,&DAT_00c084e8,&DAT_00c0838c);
  (**(code **)PTR_PTR_0074fe48)(&DAT_00c084ec,&DAT_00c084ec,&DAT_00c08390);
  FUN_0057cbd0(&DAT_00c08608);
  FUN_0057cbd0(&DAT_00c0860c);
  FUN_0057cbd0(&DAT_00c08610);
  FUN_0057cba0(&DAT_00c084e4);
  FUN_0057cba0(&DAT_00c084e8);
  FUN_0057cba0(&DAT_00c084ec);
  FUN_0057cc10(&LAB_0055e160);
  FUN_005b7e90(&DAT_00c08614,&DAT_00c08670,&DAT_00c08608);
  (**(code **)PTR_PTR_0074fe48)(&DAT_00c08608,&DAT_00c08608,&DAT_00c08388);
  FUN_005b8040(iVar3 + 0x39d,iVar3 + 0x39d,&DAT_00c08608);
  if (param_1 < 2) {
    FUN_0057cba0(&DAT_00c083a4);
    FUN_0057cba0(&DAT_00c082b4);
    FUN_0057cba0(&DAT_00c0861c);
    FUN_0057cc10(&LAB_0055e180);
  }
  FUN_005b8370(&DAT_00c085cc,iVar1,&DAT_00c08608);
  return;
}


