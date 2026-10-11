004f6a80 MOV EAX,dword ptr [ESP + 0x8]
004f6a84 PUSH EBX
004f6a85 MOV EBX,dword ptr [ESP + 0x10]
004f6a89 PUSH EBP
004f6a8a XOR EBP,EBP
004f6a8c PUSH ESI
004f6a8d LEA EDX,[EBX + EBX*0x2]
004f6a90 PUSH EDI
004f6a91 SHL EDX,0x2
004f6a94 SUB EAX,EDX
004f6a96 MOV dword ptr [ECX],0x4
004f6a9c CMP EAX,EBP
004f6a9e MOV dword ptr [ECX + 0x4],EBP
004f6aa1 MOV dword ptr [ECX + 0x8],EBP
004f6aa4 JLE 0x004f6b21
004f6aa6 MOV ESI,dword ptr [ESP + 0x14]
004f6aaa XOR EDI,EDI
004f6aac MOV dword ptr [ECX + 0x8],ESI
004f6aaf ADD ESI,EDX
004f6ab1 CMP EBX,EBP
004f6ab3 MOV dword ptr [ECX + 0x4],EBX
004f6ab6 JLE 0x004f6add
004f6ab8 XOR EDX,EDX
004f6aba MOV EBX,dword ptr [ECX + 0x8]
004f6abd INC EDI
004f6abe MOV dword ptr [EDX + EBX*0x1],0xffffffff
004f6ac5 MOV EBX,dword ptr [ECX + 0x8]
004f6ac8 MOV dword ptr [EBX + EDX*0x1 + 0x8],EBP
004f6acc MOV EBX,dword ptr [ECX + 0x8]
004f6acf MOV dword ptr [EBX + EDX*0x1 + 0x4],EBP
004f6ad3 MOV EBX,dword ptr [ECX + 0x4]
004f6ad6 ADD EDX,0xc
004f6ad9 CMP EDI,EBX
004f6adb JL 0x004f6aba
004f6add MOV EDI,dword ptr [ECX]
004f6adf CDQ
004f6ae0 IDIV EDI
004f6ae2 IMUL EAX,EDI
004f6ae5 ADD EAX,ESI
004f6ae7 XOR EDI,EDI
004f6ae9 CMP ESI,EAX
004f6aeb JNC 0x004f6b21
004f6aed MOV EBX,dword ptr [ECX + 0x8]
004f6af0 LEA EDX,[EDI + EDI*0x2]
004f6af3 SHL EDX,0x2
004f6af6 MOV EBX,dword ptr [EBX + EDX*0x1 + 0x8]
004f6afa MOV dword ptr [ESI],EBX
004f6afc MOV EBX,dword ptr [ECX + 0x8]
004f6aff MOV dword ptr [EBX + EDX*0x1 + 0x8],ESI
004f6b03 MOV EBX,dword ptr [ECX + 0x8]
004f6b06 LEA EDX,[EBX + EDX*0x1 + 0x4]
004f6b0a MOV EBX,dword ptr [EDX]
004f6b0c INC EBX
004f6b0d MOV dword ptr [EDX],EBX
004f6b0f MOV EDX,dword ptr [ECX]
004f6b11 ADD ESI,EDX
004f6b13 MOV EDX,dword ptr [ECX + 0x4]
004f6b16 INC EDI
004f6b17 CMP EDI,EDX
004f6b19 JNZ 0x004f6b1d
004f6b1b XOR EDI,EDI
004f6b1d CMP ESI,EAX
004f6b1f JC 0x004f6aed
004f6b21 POP EDI
004f6b22 POP ESI
004f6b23 POP EBP
004f6b24 POP EBX
004f6b25 RET 0xc
