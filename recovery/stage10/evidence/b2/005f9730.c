/* NR2003.exe @ 005f9730 FUN_005f9730 */

undefined4 FUN_005f9730(void)

{
  char cVar1;
  undefined4 uVar2;
  int iVar3;
  uint uVar4;
  char *pcVar5;
  bool bVar6;
  int in_stack_00001104;
  undefined2 *in_stack_00001108;
  int in_stack_0000110c;
  
  FUN_006c5af0();
  if (in_stack_00001108 == (undefined2 *)0x0) {
    return 0;
  }
  if (in_stack_00001104 == 0) {
    *in_stack_00001108 = 0;
    return 1;
  }
  uVar2 = FUN_005f50c0(in_stack_00001104,&stack0x00000000,in_stack_0000110c);
  iVar3 = (*DAT_0103b4e0)(uVar2);
  bVar6 = iVar3 == 0;
  if (bVar6) {
    if (DAT_00f72795 == '\0') goto LAB_005f97fd;
    iVar3 = 0;
    do {
      cVar1 = (&DAT_00755dec)[iVar3];
      (&stack0xfffffff0)[iVar3] = cVar1;
      iVar3 = iVar3 + 1;
    } while (cVar1 != '\0');
    uVar4 = 0xffffffff;
    pcVar5 = &stack0xfffffff0;
    do {
      if (uVar4 == 0) break;
      uVar4 = uVar4 - 1;
      cVar1 = *pcVar5;
      pcVar5 = pcVar5 + 1;
    } while (cVar1 != '\0');
    iVar3 = ~uVar4 - 1;
    bVar6 = iVar3 == 0;
  }
  if (!bVar6 && -1 < iVar3) {
    uVar4 = 0xffffffff;
    pcVar5 = &stack0xfffffff0;
    do {
      if (uVar4 == 0) break;
      uVar4 = uVar4 - 1;
      cVar1 = *pcVar5;
      pcVar5 = pcVar5 + 1;
    } while (cVar1 != '\0');
    iVar3 = (*DAT_0103b4d4)(0,0,&stack0xfffffff0,~uVar4 - 1,in_stack_00001108,in_stack_0000110c + -1
                           );
    if (iVar3 != 0) {
      in_stack_00001108[iVar3] = 0;
      return 1;
    }
  }
LAB_005f97fd:
  *in_stack_00001108 = 0;
  return 0;
}

