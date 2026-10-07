/* NR2003.exe @ 00425fc0 FUN_00425fc0 */

uint FUN_00425fc0(char *param_1)

{
  char cVar1;
  uint in_EAX;
  int iVar2;
  undefined4 unaff_ESI;
  
  if (param_1 != (char *)0x0) {
    cVar1 = *param_1;
    in_EAX = CONCAT31((int3)(in_EAX >> 8),cVar1);
    if (cVar1 != '\0') {
      in_EAX = FUN_006c4cd1((int)cVar1,unaff_ESI);
      if (in_EAX == 0) {
        iVar2 = -1;
        do {
          if (iVar2 == 0) break;
          iVar2 = iVar2 + -1;
          cVar1 = *param_1;
          param_1 = param_1 + 1;
        } while (cVar1 != '\0');
        in_EAX = FUN_006c4cd1();
        if (in_EAX == 0) {
          return 1;
        }
      }
    }
  }
  return in_EAX & 0xffffff00;
}

