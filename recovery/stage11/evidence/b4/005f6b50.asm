005f6b50 SUB ESP,0x24
005f6b53 MOV ECX,dword ptr [ESP + 0x30]
005f6b57 PUSH EBX
005f6b58 PUSH EBP
005f6b59 MOV EBP,dword ptr [ESP + 0x34]
005f6b5d PUSH ESI
005f6b5e PUSH EDI
005f6b5f MOV EDI,dword ptr [ESP + 0x38]
005f6b63 CMP EDI,EBP
005f6b65 JZ 0x005f6b6d
005f6b67 CMP EDI,ECX
005f6b69 MOV ESI,EDI
005f6b6b JNZ 0x005f6b71
005f6b6d LEA ESI,[ESP + 0x10]
005f6b71 MOV EBX,ESI
005f6b73 LEA EAX,[EBP + 0x4]
005f6b76 SUB EBX,EBP
005f6b78 MOV EDX,ESI
005f6b7a MOV EBP,0x3
005f6b7f FLD dword ptr [EAX + 0x4]
005f6b82 FMUL dword ptr [ECX + 0x18]
005f6b85 FLD dword ptr [EAX]
005f6b87 FMUL dword ptr [ECX + 0xc]
005f6b8a ADD EAX,0xc
005f6b8d ADD EDX,0xc
005f6b90 DEC EBP
005f6b91 FADDP
005f6b93 FLD dword ptr [EAX + -0x10]
005f6b96 FMUL dword ptr [ECX]
005f6b98 FADDP
005f6b9a FSTP dword ptr [EDX + -0xc]
005f6b9d FLD dword ptr [EAX + -0x8]
005f6ba0 FMUL dword ptr [ECX + 0x1c]
005f6ba3 FLD dword ptr [EAX + -0xc]
005f6ba6 FMUL dword ptr [ECX + 0x10]
005f6ba9 FADDP
005f6bab FLD dword ptr [EAX + -0x10]
005f6bae FMUL dword ptr [ECX + 0x4]
005f6bb1 FADDP
005f6bb3 FSTP dword ptr [EBX + EAX*0x1 + -0xc]
005f6bb7 FLD dword ptr [EAX + -0x8]
005f6bba FMUL dword ptr [ECX + 0x20]
005f6bbd FLD dword ptr [EAX + -0xc]
005f6bc0 FMUL dword ptr [ECX + 0x14]
005f6bc3 FADDP
005f6bc5 FLD dword ptr [EAX + -0x10]
005f6bc8 FMUL dword ptr [ECX + 0x8]
005f6bcb FADDP
005f6bcd FSTP dword ptr [EDX + -0x4]
005f6bd0 JNZ 0x005f6b7f
005f6bd2 CMP ESI,EDI
005f6bd4 JZ 0x005f6bdd
005f6bd6 MOV ECX,0x9
005f6bdb MOVSD.REP ES:EDI,ESI
005f6bdd POP EDI
005f6bde POP ESI
005f6bdf POP EBP
005f6be0 POP EBX
005f6be1 ADD ESP,0x24
005f6be4 RET
