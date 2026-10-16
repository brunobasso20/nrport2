004ecc20 SUB ESP,0x14
004ecc23 PUSH EBP
004ecc24 PUSH ESI
004ecc25 MOV ESI,dword ptr [ESP + 0x20]
004ecc29 MOV EBP,ECX
004ecc2b PUSH ESI
004ecc2c MOV dword ptr [ESP + 0x14],EBP
004ecc30 CALL 0x004ea810
004ecc35 MOV EAX,dword ptr [ESP + 0x24]
004ecc39 MOV dword ptr [EBP],0x6f39b0   ; [006f39b0] f32=7.2375608332e-39 i32=5164896 f64=3.4273525382e-307
004ecc40 MOV dword ptr [EBP + 0x2c],EAX
004ecc43 MOV EAX,dword ptr [ESI + 0x1820]
004ecc49 TEST EAX,EAX
004ecc4b JLE 0x004ecd4f
004ecc51 ADD ESI,0x17a0
004ecc57 LEA ECX,[EBP + 0x610]
004ecc5d PUSH EBX
004ecc5e PUSH EDI
004ecc5f MOV dword ptr [ESP + 0x1c],ESI
004ecc63 MOV dword ptr [ESP + 0x14],ECX
004ecc67 MOV dword ptr [ESP + 0x20],EAX
004ecc6b MOV EAX,dword ptr [ESI]
004ecc6d MOV dword ptr [ESP + 0x28],EAX
004ecc71 CMP dword ptr [EAX + 0xa8],0x1
004ecc78 JNZ 0x004ecd28
004ecc7e MOV EDX,dword ptr [ESP + 0x2c]
004ecc82 MOV ECX,dword ptr [EAX + 0xb0]
004ecc88 CMP ECX,EDX
004ecc8a JNZ 0x004ecd28
004ecc90 MOV ECX,dword ptr [EAX + 0xa4]
004ecc96 XOR EDI,EDI
004ecc98 CMP ECX,EDI
004ecc9a JNZ 0x004ecd28
004ecca0 MOV ECX,dword ptr [EAX + 0xb4]
004ecca6 CMP ECX,EDI
004ecca8 JZ 0x004ecd28
004eccaa MOV EAX,dword ptr [ECX]
004eccac CALL dword ptr [EAX + 0x4]
004eccaf MOV ECX,dword ptr [ESP + 0x14]
004eccb3 MOV dword ptr [ESP + 0x10],EDI
004eccb7 LEA ESI,[EBP + 0x180]
004eccbd MOV dword ptr [ECX],EAX
004eccbf XOR EBX,EBX
004eccc1 MOV EDX,dword ptr [ESP + 0x10]
004eccc5 MOV EAX,dword ptr [ESP + 0x28]
004eccc9 PUSH EBX
004eccca PUSH EDX
004ecccb PUSH EAX
004ecccc MOV ECX,EBP
004eccce CALL 0x004ec250
004eccd3 MOV EBP,dword ptr [ESP + 0x18]
004eccd7 TEST AL,AL
004eccd9 JZ 0x004eccfa
004eccdb MOV ECX,dword ptr [ESI + 0xfffffef0]
004ecce1 MOV EDX,dword ptr [ESP + 0x28]
004ecce5 ADD ECX,EDI
004ecce7 MOV dword ptr [EBP + ECX*0x4 + 0x30],EDX
004ecceb MOV EAX,dword ptr [ESI + 0xfffffef0]
004eccf1 INC EAX
004eccf2 MOV dword ptr [ESI + 0xfffffef0],EAX
004eccf8 JMP 0x004ecd0e
004eccfa MOV EAX,dword ptr [ESI]
004eccfc MOV ECX,dword ptr [ESP + 0x28]
004ecd00 ADD EAX,EDI
004ecd02 MOV dword ptr [EBP + EAX*0x4 + 0x140],ECX
004ecd09 MOV EAX,dword ptr [ESI]
004ecd0b INC EAX
004ecd0c MOV dword ptr [ESI],EAX
004ecd0e INC EBX
004ecd0f ADD EDI,0x11
004ecd12 ADD ESI,0x44
004ecd15 CMP EBX,0x2
004ecd18 JL 0x004eccc1
004ecd1a MOV ECX,dword ptr [ESP + 0x10]
004ecd1e INC ECX
004ecd1f CMP EDI,0x44
004ecd22 MOV dword ptr [ESP + 0x10],ECX
004ecd26 JL 0x004eccbf
004ecd28 MOV EDX,dword ptr [ESP + 0x14]
004ecd2c MOV ESI,dword ptr [ESP + 0x1c]
004ecd30 MOV EAX,dword ptr [ESP + 0x20]
004ecd34 ADD EDX,0x4
004ecd37 ADD ESI,0x4
004ecd3a DEC EAX
004ecd3b MOV dword ptr [ESP + 0x14],EDX
004ecd3f MOV dword ptr [ESP + 0x1c],ESI
004ecd43 MOV dword ptr [ESP + 0x20],EAX
004ecd47 JNZ 0x004ecc6b
004ecd4d POP EDI
004ecd4e POP EBX
004ecd4f MOV EAX,EBP
004ecd51 POP ESI
004ecd52 POP EBP
004ecd53 ADD ESP,0x14
004ecd56 RET 0x8
