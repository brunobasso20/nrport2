0057d4e0 MOV EAX,dword ptr [ESP + 0x8]
0057d4e4 MOV EDX,dword ptr [ESP + 0x4]
0057d4e8 MOV ECX,dword ptr [EAX]
0057d4ea MOV EAX,dword ptr [EDX]
0057d4ec FLD float ptr [ECX]
0057d4ee FABS
0057d4f0 FSTP float ptr [EAX]
0057d4f2 RET
