005f5ac0 MOV EAX,dword ptr [ESP + 0x8]
005f5ac4 PUSH ESI
005f5ac5 MOV ESI,dword ptr [ESP + 0x8]
005f5ac9 PUSH EAX
005f5aca PUSH ESI
005f5acb CALL 0x005f59f0
005f5ad0 MOV EAX,dword ptr [ESP + 0x18]
005f5ad4 ADD ESP,0x8
005f5ad7 MOV ECX,dword ptr [EAX]
005f5ad9 MOV dword ptr [ESI + 0x8c],ECX
005f5adf MOV EDX,dword ptr [EAX + 0x4]
005f5ae2 MOV dword ptr [ESI + 0x90],EDX
005f5ae8 MOV EAX,dword ptr [EAX + 0x8]
005f5aeb MOV dword ptr [ESI + 0x94],EAX
005f5af1 POP ESI
005f5af2 RET
