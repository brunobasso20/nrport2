0055e160 MOV EAX,dword ptr [ESP + 0x4]
0055e164 FLD float ptr [EAX + 0x10]
0055e167 FLD float ptr [EAX + 0x14]
0055e16a FLD float ptr [EAX + 0xc]
0055e16d MOV ECX,dword ptr [EAX]
0055e16f FSTP float ptr [ECX]
0055e171 MOV EDX,dword ptr [EAX + 0x4]
0055e174 FXCH
0055e176 FSTP float ptr [EDX]
0055e178 MOV EAX,dword ptr [EAX + 0x8]
0055e17b FSTP float ptr [EAX]
0055e17d RET
