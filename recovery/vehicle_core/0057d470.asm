0057d470 MOV EAX,dword ptr [ESP + 0x8]
0057d474 MOV EDX,dword ptr [ESP + 0x4]
0057d478 MOV ECX,dword ptr [EAX]
0057d47a MOV EAX,dword ptr [EDX]
0057d47c FLD float ptr [ECX]
0057d47e FCOS
0057d480 FSTP float ptr [EAX]
0057d482 RET
