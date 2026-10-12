/* NR2003.exe @ 005df260 FUN_005df260 */

void __thiscall FUN_005df260(int param_1_00,int param_1)

{
  FUN_005d8b90(param_1,param_1_00);
  if (*(int *)(param_1_00 + 0xc) != 0) {
    FUN_006c75a5(s__sBase_Texture__00754b80,param_1 + 4);
    (**(code **)(**(int **)(param_1_00 + 0xc) + 0xc))();
  }
  if (*(int *)(param_1_00 + 0x10) != 0) {
    FUN_006c75a5(s__sDetail_Texture__00754b94,param_1 + 4);
    (**(code **)(**(int **)(param_1_00 + 0x10) + 0xc))();
  }
  if (*(int *)(param_1_00 + 0x14) != 0) {
    FUN_006c75a5(s__sLight_Map__00754ba8,param_1 + 4);
    (**(code **)(**(int **)(param_1_00 + 0x14) + 0xc))();
  }
  if (*(int *)(param_1_00 + 0x18) != 0) {
    FUN_006c75a5(s__sBump_Map__00754bb8,param_1 + 4);
    (**(code **)(**(int **)(param_1_00 + 0x18) + 0xc))();
  }
  if (*(int *)(param_1_00 + 0x1c) != 0) {
    FUN_006c75a5(s__sEnvironment_Map__00754bc8,param_1 + 4);
    (**(code **)(**(int **)(param_1_00 + 0x1c) + 0xc))();
  }
  if (*(int *)(param_1_00 + 0x20) != 0) {
    FUN_006c75a5(s__sSpecular_Map__00754bdc,param_1 + 4);
    (**(code **)(**(int **)(param_1_00 + 0x20) + 0xc))();
  }
  if (*(int *)(param_1_00 + 0x24) != 0) {
    FUN_006c75a5(s__sMorph_Texture__00754bf0,param_1 + 4);
    (**(code **)(**(int **)(param_1_00 + 0x24) + 0xc))();
  }
  param_1 = param_1 + 4;
  FUN_006c75a5(s__sambient____f___f___f_00754c04,param_1,*(undefined4 *)(param_1_00 + 0x28),
               *(undefined4 *)(param_1_00 + 0x2c),*(undefined4 *)(param_1_00 + 0x30),
               *(undefined4 *)(param_1_00 + 0x34),*(undefined4 *)(param_1_00 + 0x38),
               *(undefined4 *)(param_1_00 + 0x3c));
  FUN_006c75a5(s__sdiffuse____f___f___f_00754c1c,param_1,*(undefined4 *)(param_1_00 + 0x40),
               *(undefined4 *)(param_1_00 + 0x44),*(undefined4 *)(param_1_00 + 0x48),
               *(undefined4 *)(param_1_00 + 0x4c),*(undefined4 *)(param_1_00 + 0x50),
               *(undefined4 *)(param_1_00 + 0x54));
  FUN_006c75a5(s__sspecular____f___f___f_00754c34,param_1,*(undefined4 *)(param_1_00 + 0x58),
               *(undefined4 *)(param_1_00 + 0x5c),*(undefined4 *)(param_1_00 + 0x60),
               *(undefined4 *)(param_1_00 + 100),*(undefined4 *)(param_1_00 + 0x68),
               *(undefined4 *)(param_1_00 + 0x6c));
  FUN_006c75a5(s__sshinyness____f_00754c50,param_1,*(undefined4 *)(param_1_00 + 0x70),
               *(undefined4 *)(param_1_00 + 0x74));
  FUN_006c75a5(s__sreflectivity____f_00754c64,param_1,*(undefined4 *)(param_1_00 + 0x78),
               *(undefined4 *)(param_1_00 + 0x7c));
  FUN_006c75a5(s__sopacity____f_00754c7c,param_1,*(undefined4 *)(param_1_00 + 0x80),
               *(undefined4 *)(param_1_00 + 0x84));
  FUN_006c75a5(s__senvmap_index____f_00754c8c,param_1,*(undefined4 *)(param_1_00 + 0x8c));
  FUN_006c75a5(s__sforced_bumpmap____d_00754ca4,param_1,*(undefined *)(param_1_00 + 0x9c));
  FUN_006c75a5(s__sEMBM_TexCoordScale____f_00754cbc,param_1,(double)*(float *)(param_1_00 + 0x90));
  FUN_006c75a5(s__sEMBM_NormalScale____f_00754cd8,param_1,(double)*(float *)(param_1_00 + 0x94));
  FUN_006c75a5(s__sEMBM_LuminosityScale____f_00754cf4,param_1,(double)*(float *)(param_1_00 + 0x98))
  ;
  FUN_005d8be0();
  return;
}

